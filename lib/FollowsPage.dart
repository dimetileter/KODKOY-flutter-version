import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FollowsPage extends StatefulWidget {
  const FollowsPage({super.key});

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

      // Her bir UUID için Users koleksiyonundan kullanıcı bilgilerini çekiyoruz
      final List<Map<String, dynamic>> follows = [];
      for (String ref in followsRef) {
        final followsDoc = await _firestore.collection('Users').doc(ref).get();
        if (followsDoc.exists) {
          follows.add({
            'useremail': followsDoc.data()?['useremail'] ?? '',
            'profilePicture': followsDoc.data()?['profilePicture'] ?? '',
            'userUuid': ref, // Kullanıcının UUID'si
          });
        }
      }

      setState(() {
        _follows = follows; // Listeyi güncelliyoruz
        _isLoading = false; // Yüklenme durumunu kaldırıyoruz
      });
    } catch (e) {
      print("Hata: $e");
      setState(() {
        _isLoading = false; // Bir hata durumunda yüklenme durumu kaldırılıyor
      });
    }
  }

  void _unfollowUser(String userUuid) {
    // Kullanıcıyı takipten çıkarma mantığı
    setState(() {
      _follows.removeWhere((user) => user['userUuid'] == userUuid);
    });
    print("$userUuid takipten çıkarıldı!"); //testten sonra silinecek
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

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: user['profilePicture'].isNotEmpty
                  ? NetworkImage(user['profilePicture'])
                  : const AssetImage("assets/default_profile.png")
              as ImageProvider,
              radius: 25,
            ),
            title: Text(
              userName,
              style: const TextStyle(
                color: Colors.white,
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
          );
        },
      ),
    );
  }
}
