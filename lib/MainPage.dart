import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kodkoy/FadePage.dart';
import 'package:kodkoy/ProfilePage.dart';
import 'package:kodkoy/SharePage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
            Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(23),
              child : IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SharePage() ));
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
            const FadePage(),
            ProfilePage(),
          ],
        ),
      ),
    );
  }
}
