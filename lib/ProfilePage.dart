import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userName;

  @override
  void initState() {
    super.initState();
    // Kullanıcının emailini al
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email != null) {
      String email = currentUser!.email!;
      setState(() {
        userName = email.split('@')[0]; // @ önceki kısım
      });
    }
    else {
      setState(() {
        userName = "Bilinmeyen Kullanıcı";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(23, 32, 27, 1.0),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const SizedBox(height: 36),

            ClipOval(
              child: Image.network(
                "https://via.placeholder.com/150",
                width: 120, // Görüntünün genişliği
                height: 120, // Görüntünün yüksekliği
                fit: BoxFit.cover, // Görüntünün kutuya sığması için ayar
              ),
            ),

            const SizedBox(height: 20),

            // Alınan kullanıcı adını buraya koy
            Text(userName ?? "Yükleniyor", style: const TextStyle(
              fontFamily: "FiraCode-Regular",
              color: Colors.white
              ),
            ),

            const SizedBox(height: 20),


            // Buraya mesajlar kısmı gelecek


          ],
        ),
      ),
    );
  }
}
