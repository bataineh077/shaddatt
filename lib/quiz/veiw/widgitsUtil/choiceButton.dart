import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shaddatt/quiz/viewModel/quizController.dart';

class ChoiceButton extends GetWidget<QuizController> {

  String keyQ;


  ChoiceButton({this.keyQ});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      child: MaterialButton(
        onPressed: () {

       //   checkanswer(keyQ);

          } ,
        child: Text(
          "${controller.quizDataList.value[1][controller.indexQuestionRandom.value.toString()][keyQ]}",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Alike",
            fontSize: 16.0,
          ),
          maxLines: 2,
          textDirection: TextDirection.rtl,
        ),
        color: controller.btncolor[keyQ],
        splashColor: Colors.indigo[700],
        highlightColor: Colors.indigo[700],
        minWidth: 125.0,
        height: 45.0,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }
}
