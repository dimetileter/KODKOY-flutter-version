import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    String cuUuid = _auth.currentUser!.uid; // Şu anki kullanıcının UUID'si
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('Users')
          .doc(cuUuid)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .get();

      final List<Map<String, dynamic>> messages = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        // Mesajın resmini çevir
        String? localImagePath;
        if (data['image'] != null) {
          final bytes = base64Decode(data['image']);
          final tempDir = Directory.systemTemp;
          final imageFile =
          File('${tempDir.path}/message_image_${doc.id}.png');
          imageFile.writeAsBytesSync(bytes);
          localImagePath = imageFile.path;
        }

        return {
          'comment': data['comment'],
          'senderEmail': data['senderEmail'],
          'timestamp': data['timestamp']?.toDate(),
          'imagePath': localImagePath,
        };
      }).toList();

      setState(() {
        _messages = messages;
        _isLoading = false;
      });
    } catch (e) {
      print("Hata: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return '--.--.--';
    return DateFormat('dd.MM.yyyy HH:mm').format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(23, 32, 27, 1.0),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromRGBO(23, 32, 27, 1.0),
        title: const Text(
          "Mesajlar",
          style: TextStyle(
            color: Color.fromRGBO(186, 219, 215, 1.0),
            fontSize: 36,
            fontFamily: "montserrat",
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.white),
      )
          : _messages.isEmpty
          ? const Center(
        child: Text(
          "Hiç mesajınız yok.",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final post = _messages[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        post['senderEmail'] ?? 'Bilinmeyen Kullanıcı',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      // Tarih ve saat metni
                      Text(
                        _formatTimestamp(post['timestamp']),
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                        ),
                      ),

                    ],
                  ),
                ),


                const SizedBox(height: 8),

                if (post['imagePath'] != null)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.file(
                      File(post['imagePath']!),
                      width: double.infinity, // Görüntünün genişliği
                      height: 250, // Görüntünün yüksekliği
                      fit: BoxFit.cover, // Görüntünün kutuya sığması için ayar
                    ),
                  )
                else
                  const Icon(Icons.broken_image, size: 200, color: Colors.grey),
                const SizedBox(height: 8),
                Text(
                  post['comment'] ?? '',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
