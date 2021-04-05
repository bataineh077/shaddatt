import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timer_count_down/timer_controller.dart';


class QuizController extends GetxController{

  final box = GetStorage();
  final rand = new Random();

  RxInt indexQuestionOrdered = 0.obs;
  RxInt indexQuestionRandom = 0.obs;
  bool isAds = true;


  TextEditingController userPubgID = TextEditingController();
  final CountdownController timecontroller = CountdownController();


  RxList quizDataList = [].obs;
  List   randomIntList = [];


  RxInt score =0.obs;
  RxInt falseAwnser=0.obs;
  RxInt shaddat=0.obs;
  RxInt coins=0.obs;


  Map<String, Color> btncolor = {
    "a": Colors.indigoAccent,
    "b": Colors.indigoAccent,
    "c": Colors.indigoAccent,
    "d": Colors.indigoAccent,
  };


  updateScoreValue(value)=>box.write('score', value);
  updateFalseAwnserValue(value)=>box.write('falseAwnser', value);
  updateShaddatValue(value)=>box.write('shaddat', value);
  updateCoinsValue(value)=>box.write('coins', value);


  void endTime(){

    updateFalseAwnserValue(box.read('falseAwnser')+1);
    checkFirstTime();
      falseAwnser.value = box.read('falseAwnser');

      if(falseAwnser.value > 100){
        if(score.value <= 250){
          box.write('score', 0);
         // score = prefs.getInt('score');

          box.write('falseAwnser', 0);

          checkFirstTime();
         // falseAwnser =prefs.getInt('falseAwnser');
        }else if(score.value >250){
          box.write('score', box.read('score')-250);
         // score =prefs.getInt('score');
          box.write('falseAwnser', 0);
          checkFirstTime();
         // falseAwnser =prefs.getInt('falseAwnser');
        }

      }

    nextQuestion();

  }


  Future getQuizData()async{


      String data = await DefaultAssetBundle.of(Get.context).loadString('assets/java.json', cache: true);

     final List jsonResult = json.decode(data);

      quizDataList.assignAll(jsonResult);

      print(quizDataList.value);

  }


  checkFirstTime()async{

    if(!box.hasData('first')) {
      box.write('first', true);

      updateCoinsValue(0);
      updateFalseAwnserValue(0);
      updateScoreValue(0);
      updateShaddatValue(0);

    }
    else{

      score.value =  box.read('score');
      falseAwnser.value = box.read('falseAwnser');
      shaddat.value = box.read('shaddat');
      coins.value = box.read('coins');
    }


  }


  RxBool disableAnswer = false.obs;

  genRandomArray(){
    var rand = new Random();
    var distinctIds = [];

    for (; ;) {
      distinctIds.add(rand.nextInt(quizDataList[0].length));
      randomIntList = distinctIds.toSet().toList();
      if(randomIntList.length < quizDataList[0].length){
        continue;
      }else{
        break;
      }
    }

  }


  void nextQuestion() {


      if (indexQuestionOrdered.value < quizDataList[0].length) {
        indexQuestionRandom.value = randomIntList[indexQuestionOrdered.value];
        indexQuestionOrdered.value++;
      } else {

        indexQuestionOrdered.value=0;
        genRandomArray();
        print('End');
      }

      resetBtnColor();
      disableAnswer.value = false;


  //  timecontroller.restart();
  }


  resetBtnColor(){

    btncolor["a"] = Colors.indigoAccent;
    btncolor["b"] = Colors.indigoAccent;
    btncolor["c"] = Colors.indigoAccent;
    btncolor["d"] = Colors.indigoAccent;
  }



  @override
  void onInit() {
    // TODO: implement onInit

    getQuizData().whenComplete(() {
      if(quizDataList.isNotEmpty) {
        genRandomArray();
        indexQuestionRandom.value = rand.nextInt(quizDataList[0].length);
      }
    });

    checkFirstTime();
    super.onInit();
  }

}