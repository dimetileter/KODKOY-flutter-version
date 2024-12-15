import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kodkoy/LoginPage.dart';

class SigninPage extends StatelessWidget {
   SigninPage({super.key});
   final FirebaseAuth _auth = FirebaseAuth.instance;
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   final TextEditingController passwordController = TextEditingController();
   final TextEditingController emailController = TextEditingController();

   Future<void> registerUser(BuildContext context, String email, String password) async {
     try {
       // Authentication ile kullanıcıyı oluştur
       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
         email: email,
         password: password,
       );

       // Kullanıcı UUID'sini al
       String userId = userCredential.user!.uid;

       // Firestore'da "Users" koleksiyonuna veri ekle
       await _firestore.collection("Users").doc(userId).set({
         'user_uuid': userId,
         'useremail': email,
       });

       Fluttertoast.showToast(msg: "Hesap oluşturuldu! Giriş yapın");
       Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
     } catch (e) {
       Fluttertoast.showToast(msg: e.toString());
     }
   }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(28, 32, 23, 1.0),
      body: Stack(
        children: [
          const SizedBox(
            width: 265,
            child: Text("01000010  01110101  00100000  01100010  01101001  01110010  00100000  "
                "01110011  01100001  01110110  01100001  01110011  01011111  00100000  01110101  "
                "01101110  01110101  01110100  01110101  01101101  01100001  00100000  01101011  "
                "01100001  01101100  01101101  01100001  00100000  01101101  01100101  01110011  "
                "01100101  01101100  01100101  01110011  01101001  00101110  00100000  01000001  "
                "01110011  01101100  01100001  00100000  01110110  01100001  01111010  01100111  "
                "01100101  11100111  01101101  01100101  00101110  00100000  00110000  01101110  "
                "01110100  01101001  01101011  01100001  01101101  00110001  01101110  00100000  "
                "01100001  01101100  00110001  01101110  01100001  01100011  01100001  01101011  "
                "00100000  01100001  01101110  01100011  01100001  01101011  00100000  01111010  "
                "01100001  01101101  01100001  01101110  00100000  01110110  01100001  01110010  "
                "00101110  00100000  01001000  01100101  01100100  01100101  01100110  01101100  "
                "01100101  01110010  01100101  00100000  01100111  01101001  01100100  01100101  "
                "01101110  00100000  01111001  01101111  01101100  00100000  01110100  01100001  "
                "01011111  01101100  00110001  00100000  01101111  01101100  01110011  01100001  "
                "01100100  01100001  00100000  01100001  01110011  01101100  01100001  00100000  "
                "01110000  01100101  01110011  00100000  01100101  01110100  01101101  01100101  "
                "00101110  00100000  01010101  01101110  01110101  01110100  01101101  01100001  "
                "00100000  01100010  01110101  00100000  01100010  01101001  01110010  00100000  "
                "01101000  01100001  01111001  01100001  01110100  01110100  01100001  00100000  "
                "01101011  01100001  01101100  01101101  01100001  00100000  01101101  01100101  "
                "01110011  01100101  01101100  01100101  01110011  01101001  00100000  01110110  "
                "01100101  00100000  01110011  01100001  01101110  01100001  00100000  01111001  "
                "01100001  01110000  00110001  01101100  01100001  01101110  01101100  01100001  "
                "01110010  00100000  11110110  01100100  01100101  01110100  01101001  01101100  "
                "01100101  01100011  01100101  01101011  00101110  00100000  01000101  00011111  "
                "01100101  01110010  00100000  01011111  01101001  01101101  01100100  01101001  "
                "00100000  01110110  01100001  01111010  01100111  01100101  11100111  01100101  "
                "01110010  01110011  01100101  01101110  00100000  01101111  01101110  01101100  "
                "01100001  01110010  00100000  01101011  01100001  01111010  01100001  01101110  "
                "00110001  01110010  00101110  00101110  00101110",
              style: TextStyle(fontSize: 11, color: Color.fromRGBO(182, 176, 34, 0.25), fontFamily: "FiraCode-Light"),
            ),
          ),
          Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const SizedBox(height: 111),

                // Uygulama imsi
                const Text("KODKOY", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Color.fromRGBO(186, 219, 215, 1.0),
                    fontFamily: "montserrat",
                    shadows: [
                      Shadow(
                        offset: Offset(6, 6),
                        blurRadius: 3,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),

                // haesap oluştur yazısı yap yazısı
                const Text('Hesap Oluştur', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color.fromRGBO(186, 219, 215, 1.0),
                    fontFamily: "FiraCode-Regular"
                  ),
                ),

                const SizedBox(height: 280),

                // Eposta giriş
                SizedBox(
                  width: 350,
                  height: 50,
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress, // E-posta tipi giriş
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromRGBO(75, 84, 93, 0.45), // Arka plan rengi
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30), // Köşeleri 30 birim yuvarlat
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(186, 219, 215, 0.5), // Kenar rengi
                          width: 1, // Kenar kalınlığı
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(186, 219, 215, 0.5),
                          width: 1,
                        ),
                      ),
                      labelText: "E-posta",
                      labelStyle: const TextStyle(
                        fontFamily: "FiraCode-Regular",
                        color: Color.fromRGBO(186, 219, 215, 1.0),
                      ),
                    ),
                    style: const TextStyle(
                      color: Color.fromRGBO(186, 219, 215, 1.0), // Metin rengi
                    ),
                    textAlignVertical: TextAlignVertical.center, // Giriş metnini dikeyde ortalar
                  ),
                ),

                const SizedBox(height: 16),

                // Şifre giriş
                SizedBox(
                  width: 350,
                  height: 50,
                  child: TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword, // E-posta tipi giriş
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromRGBO(75, 84, 93, 0.45), // Arka plan rengi
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30), // Köşeleri 30 birim yuvarlat
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(186, 219, 215, 0.5), // Kenar rengi
                          width: 1, // Kenar kalınlığı
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(186, 219, 215, 0.5),
                          width: 1,
                        ),
                      ),
                      labelText: "Şifre",
                      labelStyle: const TextStyle(
                        fontFamily: "FiraCode-Regular",
                        color: Color.fromRGBO(186, 219, 215, 1.0),
                      ),
                    ),
                    style: const TextStyle(
                      color: Color.fromRGBO(186, 219, 215, 1.0), // Metin rengi
                    ),
                    textAlignVertical: TextAlignVertical.center, // Giriş metnini dikeyde ortalar
                  ),
                ),

                const SizedBox(height: 48),

                // Kayıt ol butonu
                SizedBox(
                  height: 43,
                  width: 150,
                  child: ElevatedButton(
                      // Tıklama kısımları
                      onPressed: () {
                        String password = passwordController.text.trim();
                        String email = emailController.text.trim();

                        if (password.isNotEmpty && password.isNotEmpty) {
                          // Firebase kayıt fonksiyonunu çağır
                          registerUser(context, email, password);

                        }
                        else {
                          Fluttertoast.showToast(msg: "Kullanıcı bilgileri boş bırakılamaz");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          side: const BorderSide(color: Color.fromRGBO(186, 219, 215, 1.0), width: 1),
                          backgroundColor: const Color.fromRGBO(75, 84, 93, 0.45),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          )
                      ),
                      child: const Text("Hesap Oluştur", style: TextStyle( color: Color.fromRGBO(186, 219, 215, 1.0),
                      fontFamily: "FiraCode-Semibold"),)
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

