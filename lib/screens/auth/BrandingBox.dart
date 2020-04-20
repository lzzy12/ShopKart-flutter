import 'package:flutter/material.dart';

class BrandingBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        width: size.width,
        margin: EdgeInsets.only(
            top: size.height / 8,
            left: size.width / 8,
            right: size.width / 8,
            bottom: 50),
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 24),
        child: Center(
          child: Text(
            'ShopKart',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 36),
          ),
        ),
//        transform: Matrix4.rotationZ(- 8 * pi / 180)..translate(-25.0),
      ),
    );
  }
}
