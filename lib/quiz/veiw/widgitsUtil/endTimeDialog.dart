import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shaddatt/quiz/viewModel/quizController.dart';


class Dialogs{

 static void endTimeDialog(){


    showDialog(barrierDismissible: false,
        context: Get.context,
        builder: (context) => AlertDialog(

          title: Text(
            "انتهى الوقت",
          ),
          content: Image.asset('images/alarm.png'),
          actions: <Widget>[
            FlatButton(
              onPressed: () async{
                Get.back();


                  Get.find<QuizController>().endTime();
              },
              child: Text(
                'السؤال التالي',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            )
          ],
        ));
  }

  static  willBackDialog(){

     showDialog(
        context: Get.context,
        builder: (context) => AlertDialog(
          title: Text(
            "تنبيه",
          ),
          content: Text("لا يمكنك الرجوع الى القائمة الرئيسية"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Ok',
              ),
            )
          ],
        ));
  }
}