import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kodkoy/ProfilePage.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Feed> feeds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFeeds();
  }

  Future<void> _fetchFeeds() async {
    try {
      // Firestore'dan tüm verileri çekiyoruz.
      final snapshot = await FirebaseFirestore.instance.collection('Feeds').get();

      // Tüm dökümanları dönüyoruz ve listeye ekliyoruz.
      final data = snapshot.docs.map((doc) => Feed.fromMap(doc.data())).toList();

      setState(() {
        feeds = data; // Listeyi güncelliyoruz.
        isLoading = false; // Yüklenme durumunu kaldırıyoruz.
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(23, 32, 27, 1.0),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : ListView.builder(
        itemCount: feeds.length, // Listedeki öğe sayısını alıyoruz.
        itemBuilder: (context, index) {
          final feed = feeds[index]; // Şu anki öğeyi alıyoruz.
          return GestureDetector(
            onTap: () {
              // ProfilePage'e yönlendirme
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    userName: feed.userName,
                    userUuid: feed.userUuid,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Card(
                color: Colors.white, // card rengi beyaz
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kullanıcı Adı
                      Text(
                        feed.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Resim
                      Container(
                        width: double.infinity,
                        height: 197,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: MemoryImage(base64Decode(feed.imageUrl)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Açıklama
                      Text(
                        feed.comment,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
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

class Feed {
  final String userName;
  final String imageUrl;
  final String comment;
  final String userUuid;

  Feed({required this.userName, required this.imageUrl, required this.comment, required this.userUuid});

  factory Feed.fromMap(Map<String, dynamic> map) {
    return Feed(
      userName: map['userName'] ?? '',
      imageUrl: map['image'] ?? '',
      comment: map['comment'] ?? '',
      userUuid: map['userUuid'] ?? '',
    );
  }
}
