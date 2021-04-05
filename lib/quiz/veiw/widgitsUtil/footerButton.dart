
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shaddatt/quiz/viewModel/quizController.dart';

class FooterButton extends GetWidget<QuizController> {

  VoidCallback voidCallback;
  Color color;
  String title;

  FooterButton({@required this.color,@required this.voidCallback, @required this.title});

  @override
  Widget build(BuildContext context) {
    return  Flexible(
      child: GestureDetector(
        onTap: ()=>voidCallback(),
        child: Container(
          height: MediaQuery.of(context).size.height/10,
          width: double.infinity,
          color: color,
          child: Center(
            child: Text(this.title,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),),
          ),
        ),
      ),
    );
  }
}
