import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FollowsPage extends StatefulWidget {
  final String image;
  final String comment;
  const FollowsPage({super.key, required this.image, required this.comment});

  @override
  State<FollowsPage> createState() => _FollowsPageState();
}

class _FollowsPageState extends State<FollowsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _follows = []; // Liste görünümü için
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserFollows();
  }

  Future<void> _fetchUserFollows() async {
    String cuUuid = _auth.currentUser!.uid; // Şu anki kullanıcının UUID'si
    try {
      // Kullanıcının followsRef listesini alıyoruz
      final userDoc = await _firestore.collection('Users').doc(cuUuid).get();
      final followsRef = List<String>.from(userDoc.data()?['followsRef'] ?? []);

      final List<Map<String, dynamic>> follows = [];
      for (String ref in followsRef) {
        final followsDoc = await _firestore.collection('Users').doc(ref).get();
        if (followsDoc.exists) {
          final String? base64Image = followsDoc.data()?['profilePicture'] as String?;
          String? localImagePath;

          if (base64Image != null && base64Image.isNotEmpty) {
            // Base64'ten byte array'e dönüştür
            final bytes = base64Decode(base64Image);

            // Byte array'i geçici bir dosyaya yaz
            final tempDir = Directory.systemTemp;
            final imageFile = File('${tempDir.path}/profile_picture_$ref.png');
            await imageFile.writeAsBytes(bytes);

            localImagePath = imageFile.path;
          }

          follows.add({
            'useremail': followsDoc.data()?['useremail'] ?? '',
            'profilePicturePath': localImagePath, // Yerel dosya yolu
            'userUuid': ref,
          });
        }
      }

      setState(() {
        _follows = follows;
        _isLoading = false;
      });
    } catch (e) {
      print("Hata: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendMessage(String recipientUuid) async {
    try {
      await _firestore
          .collection('Users')
          .doc(recipientUuid)
          .collection('messages')
          .add({
        'image': widget.image,
        'comment': widget.comment,
        'timestamp': FieldValue.serverTimestamp(),
        'senderEmail': _auth.currentUser!.email,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mesaj başarıyla gönderildi!")),
      );
    } catch (e) {
      print("Mesaj gönderme hatası: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mesaj gönderilemedi!")),
      );
    }
  }

  void _unfollowUser(String userUuid) async {
    String cuUuid = _auth.currentUser!.uid;

    try {
      // Kullanıcının dokümanını al
      DocumentReference userDoc = _firestore.collection('Users').doc(cuUuid);

      // followsRef listesini güncelle
      await userDoc.update({
        'followsRef': FieldValue.arrayRemove([userUuid])
      });

      // Listeyi güncelleştitr
      setState(() {
        _follows.removeWhere((user) => user['userUuid'] == userUuid);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kullanıcı takipten çıkarıldı.")),
      );
    } catch (e) {
      print("Hata: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kullanıcı takipten çıkarılamadı.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(23, 32, 27, 1.0),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromRGBO(23, 32, 27, 1.0),
        title: const Text(
          "Takip Edilen Kişiler",
          style: TextStyle(
            color: Color.fromRGBO(186, 219, 215, 1.0),
            fontSize: 24,
            fontFamily: "montserrat",
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.white),
      )
          : ListView.builder(
        itemCount: _follows.length,
        itemBuilder: (context, index) {
          final user = _follows[index];
          final userName =
          user['useremail'].split('@')[0]; // @ işaretinden önceki kısmı al

          return Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                onTap: () => _sendMessage(user['userUuid']), // Kullanıcıya mesaj gönder
                leading: CircleAvatar(
                  backgroundImage: user['profilePicturePath'] != null
                      ? FileImage(File(user['profilePicturePath']))
                      : const AssetImage("assets/default_profile.png")
                  as ImageProvider,
                  radius: 25,
                ),
                title: Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.black, // Yazı rengini siyah yap
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: ElevatedButton.icon(
                  onPressed: () => _unfollowUser(user['userUuid']),
                  icon: const Icon(Icons.person_remove, color: Colors.red),
                  label: const Text(
                    "Takipten Çıkar",
                    style: TextStyle(color: Colors.red),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.grey, width: 0.5),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
