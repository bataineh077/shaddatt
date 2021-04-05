import 'package:flutter/material.dart';

class BackGroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                  'images/im2.jpeg'
              ))
      ),
    );
  }
}
