import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shaddatt/quiz/viewModel/quizController.dart';

class QuestionArea extends GetWidget<QuizController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      padding: EdgeInsets.all(14.0),
      alignment: Alignment.center,
      child: Text(
        "${controller.quizDataList[0][controller.indexQuestionRandom.value.toString()]}",
        style: TextStyle(
            fontSize: 19.0,
            //fontFamily: "Quando",
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
        textDirection: TextDirection.rtl,
      ),
    );
  }
}
