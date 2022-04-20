import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {

  Color color;
  VoidCallback voidCallback;
  String title;

  HomeButton({this.voidCallback,this.color,this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RaisedButton(textColor: Colors.white,
            onPressed: ()=> voidCallback(),
            color: color,
            child: Text(title,style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25
            ),),
          ),
        ),
      ],
    );
  }
}
