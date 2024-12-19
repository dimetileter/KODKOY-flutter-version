import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kodkoy/MainPage.dart';
import 'package:kodkoy/SigninPage.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  Future<void> loginUser(BuildContext context, String email, String password) async {
    try {
      // Firebase ile giriş işlemi
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      String? displayName = _auth.currentUser?.displayName.toString() ?? "Kullanıcı";
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainPage() ));

    } catch (e) {
      // Hata mesajı
      Fluttertoast.showToast(msg: "Giriş başarısız");
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(13, 36, 30, 1.0),
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
              style: TextStyle(fontSize: 11, color: Color.fromRGBO(34, 155, 182, 0.25), fontFamily: "FiraCode-Light"),
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
                style: TextStyle(fontSize: 64, fontFamily: "montserrat", fontWeight: FontWeight.bold, color: Color.fromRGBO(186, 219, 215, 1.0),
                  shadows: [
                    Shadow(
                      offset: Offset(6, 6),
                      blurRadius: 3,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),

              // Giriş yap yazısı
              const Text('Giriş Yap', textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Color.fromRGBO(186, 219, 215, 1.0), fontFamily: "FiraCode-Regular"
                ),
              ),

              const SizedBox(height: 250),

              Container(
                width: 345,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Uygulamada yeni misin?", style: TextStyle(
                      fontSize: 12,
                      color: Color.fromRGBO(186, 215, 219, 1.0),
                      fontFamily: "FiraCode-Regular"
                    ),
                    ),
                    SizedBox(
                      width: 85,
                      height: 25,
                      // Kayıt ol butonu
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => SigninPage(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                            },
                        style: ElevatedButton.styleFrom(
                            side: const BorderSide(color: Color.fromRGBO(186, 219, 215, 1.0), width: 1),
                            backgroundColor: const Color.fromRGBO(75, 84, 93, 0.45),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4))
                            )
                        ),
                          child: const Text("Kayıt ol",
                              style: TextStyle(
                                  color: Color.fromRGBO(186, 219, 215, 1.0),
                                  fontSize: 10,
                                fontFamily: "FiraCode-Semibold"
                              )),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10,),

              // eposta giriş
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
                      fontFamily: "FiraCode-regular",
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
                      color: Color.fromRGBO(186, 219, 215, 1.0),
                    ),
                  ),
                  style: const TextStyle(
                      fontFamily: "FiraCode-regular",
                    color: Color.fromRGBO(186, 219, 215, 1.0), // Metin rengi
                  ),
                  textAlignVertical: TextAlignVertical.center, // Giriş metnini dikeyde ortalar
                ),
              ),

              const SizedBox(height: 48),

              // Giriş butonu
              SizedBox(
                height: 43,
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();

                    if(email.isNotEmpty && password.isNotEmpty) {
                      loginUser(context, email, password);
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
                  child: const Text("Giriş Yap", style: TextStyle( color: Color.fromRGBO(186, 219, 215, 1.0), fontFamily: "FiraCode-Semibold"))
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
