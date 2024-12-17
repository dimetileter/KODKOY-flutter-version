import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(23, 32, 27, 1.0),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromRGBO(23, 32, 27, 1.0),
        title: const Text("Mesajlar",
          style: TextStyle(
            color: Color.fromRGBO(186, 219, 215, 1.0),
            fontSize: 36,
            fontFamily: "montserrat",
            letterSpacing: 1.0,
        ),
        )
      ),
      body: const Column(
        children: [

        ],
      ),
    );
  }
}
