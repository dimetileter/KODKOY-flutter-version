import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kodkoy/FollowsPage.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key, required this.userName, required this.userUuid});
  String userName;
  String userUuid;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _posts = [];
  File? _selectedImage; // Seçilen resmi tutacak
  bool _isLoading = true;
  bool _isOtherUser = false;
  bool isIconChanged = false;

  @override
  void initState() {
    super.initState();

    if(widget.userUuid == "0"){
      _fetchMyPosts();
      _fetchProfilePicture(_auth.currentUser!.uid);
    }
    else {
      _fetchUserPost(widget.userUuid);
      _fetchProfilePicture(widget.userUuid);
      _isOtherUser = true;
    }
  }

  Future<void> _fetchUserPost(userUuid) async {
    try {
      // Diğer kullanıcının verisini al
      final userDoc = await _firestore.collection('Users').doc(userUuid).get();
      final postRefs = List<String>.from(userDoc.data()?['postRef'] ?? []);

      // Refeeransları çek

      final List<Map<String, dynamic>> posts = [];
      for(String ref in postRefs) {
        final feedDoc = await _firestore.collection('Feeds').doc(ref).get();
        if(feedDoc.exists) {
          posts.add(feedDoc.data()!);
        }
      }

      setState(() {
        _posts = posts; // referansları listeye ekle
        _isLoading = false; // yüklemeyi durdur
      });

    }
    catch(e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    }
  }

  Future<void> _fetchMyPosts() async {
    try {
      // Kullanıcının auth UID'sini al
      final userId = _auth.currentUser!.uid;

      // Kullanıcının post referanslarını listesini al
      final userDoc = await _firestore.collection('Users').doc(userId).get();
      final postRefs = List<String>.from(userDoc.data()?['postRef'] ?? []);

      // Her bir gönderi uuidsi için koleksiyondan veri çek
      final List<Map<String, dynamic>> posts = [];
      for (String ref in postRefs) {
        final feedDoc = await _firestore.collection('Feeds').doc(ref).get();
        if (feedDoc.exists) {
          posts.add(feedDoc.data()!);
        }
      }


      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    }
  }

  Future<void> _fetchProfilePicture(userUuid) async {
    try {
      // Kullanıcının Firestore'daki verilerini al
      final userDoc = await _firestore.collection('Users').doc(userUuid).get();

      // Firestore'dan profil resmini çek
      final base64Image = userDoc.data()?['profilePicture'] as String?;

      if (base64Image != null) {
        // Base64 formatındaki resmi byte'a çevir ve File nesnesine ata
        final bytes = base64Decode(base64Image);
        final tempDir = Directory.systemTemp;
        final imageFile = File('${tempDir.path}/profile_picture_$userUuid.png');
        await imageFile.writeAsBytes(bytes);

        setState(() {
          _selectedImage = imageFile;
        });
      } else {
        setState(() {
          _selectedImage = null;
        });
      }
    } catch (e) {
      setState(() {
        _selectedImage = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profil resmi yüklenirken hata: $e")),
      );
    }
  }



  // Kullanıcı uuid'sini kaydet.
  Future<void> _followUser()async {
    final myID = _auth.currentUser!.uid;
    await _firestore.collection('Users').doc(myID).set({
      'followsRef': FieldValue.arrayUnion([widget.userUuid]) // Kullanıcının uuid'sini ekle
    }, SetOptions(merge: true));
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path); // Seçilen resmi kayded
        });

        // Firebase'e göndermek için bit formatına çevir
        final bytes = await _selectedImage!.readAsBytes();
        final base64image = base64Encode(bytes);
        final currentUserUuid = _auth.currentUser!.uid;

        await _firestore.collection('Users').doc(currentUserUuid).set({
          'profilePicture': base64image
        }, SetOptions(merge: true));

        _selectedImage = null;

      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(23, 32, 27, 1.0),
      body: Column(
        children: [
          // Profil ve kullanıcı adı kısmı
          Container(
            padding: const EdgeInsets.symmetric(vertical: 36),
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _selectedImage == null
                          ? const NetworkImage("https://via.placeholder.com/150")
                          : FileImage(_selectedImage!) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),


                const SizedBox(height: 20),

                // Alınan kullanıcı adını buraya koy
                Text(widget.userName, style: const TextStyle(
                    fontFamily: "FiraCode-Regular",
                    color: Colors.white
                ),
                ),

                const SizedBox(height: 20),

                // Takip edilen kullanıcılar ve profil resmi butonu
                !_isOtherUser // başka kullanıcıysa butonu gösterme
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const FollowsPage(image:"", comment: "")));
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Takipler", style: TextStyle(color: Colors.black,)),
                          SizedBox(width: 8),
                          Icon(Icons.bookmark_add, color: Colors.black,),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Resim seçme ayarı
                    IconButton(
                      onPressed: () {
                        _pickImage();
                      },
                      style: IconButton.styleFrom(
                        //backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white)
                      ),
                      icon: const Icon(Icons.settings, color: Colors.white),
                    )

                  ],

                ) :


                const SizedBox(height: 10),

                // Takip et butonu
                _isOtherUser // başka birisinin profili ise butonu gizler
                    ? ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _followUser();
                      isIconChanged = !isIconChanged; // Durumu değiştir
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isIconChanged ? "Takip Edildi" : "Takip Et",
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        isIconChanged ? Icons.check : Icons.person_add,
                        color: Colors.black,
                      ),
                    ],
                  ),
                )
                    : const SizedBox(), // _isOtherUser false ise, buton görünmez
              ],
            ),
          ),

          // Gönderiler kısmı
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(23, 32, 27, 1.0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),


              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : _posts.isEmpty
                  ? const Center(
                child: Text(
                  "Hiç gönderi bulunamadı",
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : ListView.builder(
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  final post = _posts[index];
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
                        Text(
                          post['userName'] ?? 'Bilinmeyen Kullanıcı',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 8),

                        if (post['image'] != null)
                          Image.memory(
                            base64Decode(post['image']),
                            width: double.infinity, // Görüntünün genişliği
                            height: 197, // Görüntünün yüksekliği
                            fit: BoxFit.cover, // Görüntünün kutuya sığması için ayar
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
            ),
          ),
        ],
      ),
    );
  }
}
