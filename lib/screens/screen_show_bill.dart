import 'dart:convert';

import 'package:flutter/material.dart';

class ScreenBillImage extends StatelessWidget {
  final String image;
  const ScreenBillImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final convertedImage = const Base64Decoder().convert(image);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
              colors: [Color(0xFF6DD5ED), Color(0xFF2193B0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 600,
              decoration: BoxDecoration(
                  image: DecorationImage(image: MemoryImage(convertedImage))),
            ),
          ],
        )),
      ),
    );
  }
}
