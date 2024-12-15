import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FadePage extends StatefulWidget {
  const FadePage({super.key});

  @override
  State<FadePage> createState() => _FadePageState();
}

class _FadePageState extends State<FadePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromRGBO(23, 32, 27, 1.0)
    );
  }
}
