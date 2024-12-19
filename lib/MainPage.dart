import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kodkoy/FeedPage.dart';
import 'package:kodkoy/LoginPage.dart';
import 'package:kodkoy/MessagePage.dart';
import 'package:kodkoy/ProfilePage.dart';
import 'package:kodkoy/SharePage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key });

  @override
  State<MainPage> createState() => _MainPageState();
}


class _MainPageState extends State<MainPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
        userName = "@null";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Tab sayısı
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: const Color.fromRGBO(23, 32, 27, 1.0),
          automaticallyImplyLeading: false,
          title: const Text("KODKOY",
            style: TextStyle(
              color: Color.fromRGBO(186, 219, 215, 1.0),
              fontSize: 36,
              fontFamily: "montserrat",
              letterSpacing: 1.0,
            ),
          ),


          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                  children : [

                    // Çıkış butonu butonu
                    IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                          _auth.signOut();
                        },
                        style: IconButton.styleFrom(
                          side: const BorderSide(color: Color.fromRGBO(186, 219, 215, 1.0), width: 1),
                          backgroundColor: const Color.fromRGBO(75, 84, 93, 0.45),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                        ),
                        icon: const Icon(Icons.exit_to_app, size: 20, color: Colors.white,)
                    ),

                    const SizedBox(width: 10),

                    // Mesajlar butonu
                    IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const MessagePage() ));
                        },
                        style: IconButton.styleFrom(
                          side: const BorderSide(color: Color.fromRGBO(186, 219, 215, 1.0), width: 1),
                          backgroundColor: const Color.fromRGBO(75, 84, 93, 0.45),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                        ),
                        icon: const Icon(Icons.mail_outline, size: 20, color: Colors.white,)
                    ),

                    const SizedBox(width: 10),

                    // Paylaşım butonu
                    IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SharePage(userName: userName!) ));
                      },
                      style: IconButton.styleFrom(
                        side: const BorderSide(color: Color.fromRGBO(186, 219, 215, 1.0), width: 1),
                        backgroundColor: const Color.fromRGBO(75, 84, 93, 0.45),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))
                        ),
                      ),
                      icon: const Icon(Icons.add, size: 20, color: Colors.white,)
                  ),

                    const SizedBox(width: 10),
                ]
              ),
            )
          ],




          bottom: const TabBar(
            indicatorColor: Colors.white, // Alt çizgi rengi
            indicatorWeight: 2, // Alt çizgi kalınlığı
            labelColor: Colors.white, // Aktif sekme rengi
            unselectedLabelColor: Colors.grey, // Pasif sekme rengi
            tabs: [
              Tab(icon: Icon(Icons.home), text: "Anasayfa"),
              Tab(icon: Icon(Icons.account_circle), text: "Profil"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const FeedPage(),
            ProfilePage(userName: userName!, userUuid: "0",),
          ],
        ),
      ),
    );
  }
}
