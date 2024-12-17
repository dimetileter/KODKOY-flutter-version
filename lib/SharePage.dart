import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class SharePage extends StatefulWidget {
  String userName;
  SharePage({super.key, required this.userName});

  @override
  State<StatefulWidget> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? _selectedImage; // Seçilen resmi tutacak
  final TextEditingController commentController = TextEditingController();
  String _comment = "";

  @override
  void initState() {
    super.initState();

    commentController.addListener(() {
      setState(() {
        _comment = commentController.text.trim();
      });
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path); // Seçilen resmi kayded
        });
      }
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<void> _uploadFeed() async {
    if (_selectedImage == null || _comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Resim ve yorum eklenmeli.")),
      );
      return;
    }

    try {
      // Resmi Base64 string'e çevir
      final bytes = await _selectedImage!.readAsBytes();
      final base64Image = base64Encode(bytes);
      FirebaseFirestore fireStore = FirebaseFirestore.instance;

      // Kullanıcı UUID'sini al
      final userId = _auth.currentUser?.uid;

      // Firestore'a rastgele uuid ile kaydet
      String uuid = const Uuid().v4();
      await fireStore.collection('Feeds').doc(uuid).set({
        'image': base64Image,
        'comment': _comment,
        'timestamp': FieldValue.serverTimestamp(),
        'userName': widget.userName,
        'userUuid': userId
      });

      // Kaydedilen gönderinin referansını kullanıcıya kaydet
      await FirebaseFirestore.instance.collection('Users').doc(userId).set({
        'postRef': FieldValue.arrayUnion([uuid]) // Mevcut diziye yeni UUID eklenir
      }, SetOptions(merge: true)); // Mevcut belgeyi bozmadan güncelle

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Paylaşım başarıyla yüklendi!")),
      );

      setState(() {
        _selectedImage = null;
        commentController.clear(); // Yorum kutusunu temizler
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(23, 32, 27, 1.0),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "KODKOY",
          style: TextStyle(
            color: Color.fromRGBO(186, 219, 215, 1.0),
            fontSize: 36,
            fontFamily: "montserrat",
            letterSpacing: 1.0,
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(23, 32, 27, 1.0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.only(left: 34),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(widget.userName,
                    style: const TextStyle(
                      fontFamily: "FiraCode-Regular",
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ), // Buraya firebase ile alınan kullanıcı adı koyulacak

            const SizedBox(height: 20),

            // Resim kutusu
            Container(
              width: 353,
              height: 197,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12),
                image: _selectedImage != null
                    ? DecorationImage(
                  image: FileImage(_selectedImage!),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: _selectedImage == null
                  ? const Center(
                child: Text(
                  "Resim seçilmedi",
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : null,
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: 348,
              height: 140,
              child: TextField(
                controller: commentController,
                maxLines: 20,
                style: const TextStyle(
                    fontFamily: "FiraCode-Light",
                    color: Color.fromRGBO(255, 255, 255, 1.0)),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white, // Kenarlık rengi
                        width: 1.0, // Kenarlık kalınlığı
                      )),
                  hintText: "Yorumunuzu ekleyin",
                  hintStyle: TextStyle(color: Colors.grey),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey, // Odaklanıldığında kenarlık rengi
                      width: 2.5, // Odaklanıldığında kenarlık kalınlığı
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey, // Varsayılan kenarlık rengi
                      width: 1.0, // Varsayılan kenarlık kalınlığı
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 18),
                child: IconButton(
                  onPressed: () {
                    _pickImage();
                  },
                  icon: const Icon(
                    Icons.image_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 250),

            Padding(
              padding: const EdgeInsets.only(left: 34, right: 34),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Herkesle paylaş butonu
                  ElevatedButton(
                    onPressed: () {
                      _uploadFeed();
                    },
                    style: ElevatedButton.styleFrom(
                        side: const BorderSide(
                            color: Color.fromRGBO(186, 219, 215, 1.0), width: 1),
                        backgroundColor:
                        const Color.fromRGBO(75, 84, 93, 0.45),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(8)))),
                    child: const Text("Herkesle Paylaş",
                        style: TextStyle(
                            color: Color.fromRGBO(186, 219, 215, 1.0),
                            fontFamily: "FiraCode-Semibold")),
                  ),

                  const SizedBox(width: 24),

                  // Takipçilere olarak gönder
                  SizedBox(
                    width: 38,
                    child: IconButton(
                      onPressed: () {
                        // Takipçilere gönderme işlemi
                      },
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(color: Color.fromRGBO(186, 219, 215, 1.0), width: 1),
                        backgroundColor: const Color.fromRGBO(75, 84, 93, 0.45),
                        shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))
                      )
                    ),
                      icon: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
