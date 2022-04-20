import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_count_down/timer_controller.dart';

import 'audioManager/AudioManager.dart';


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


  RxMap<String, Color> btncolor = {
    "a": Colors.indigo,
    "b": Colors.indigo,
    "c": Colors.indigo,
    "d": Colors.indigo,
  }.obs;



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
    
    SharedPreferences prefs = await SharedPreferences.getInstance();


    if(!box.hasData('first')) {
      box.write('first', true);

      if( prefs.containsKey('first') ){
        prefs.setBool('first', true);

        updateCoinsValue(prefs.getInt('coins'));
        updateFalseAwnserValue(prefs.getInt('false'));
        updateScoreValue(prefs.getInt('score'));
        updateShaddatValue(prefs.getInt('shaddat'));

      }else{

        updateCoinsValue(0);
        updateFalseAwnserValue(0);
        updateScoreValue(0);
        updateShaddatValue(0);

      }



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


    timecontroller.restart();
  }


  resetBtnColor(){

    btncolor.value["a"] = Colors.indigo;
    btncolor.value["b"] = Colors.indigo;
    btncolor.value["c"] = Colors.indigo;
    btncolor.value["d"] = Colors.indigo;
  }

  int correctTime = 0;
  int inCorrectTime = 0;

  void checkReward(bool t)async{



    if(t){

        box.write('score', box.read('score')+1);
       // score =prefs.getInt('score');
       checkFirstTime();
        AudioManager.playCorrect();

      var scoreInside = box.read('score');

        if(scoreInside == 100 || scoreInside ==200
            || scoreInside ==300 || scoreInside ==400 || scoreInside ==500
            || scoreInside ==600 || scoreInside ==700
            || scoreInside ==800 ||scoreInside ==900|| scoreInside==1000)
        {
          box.write('shaddat', box.read('shaddat')+44);
          checkFirstTime();

          // shaddat =prefs.getInt('shaddat');
        }
     }

    else if(!t){

        box.write('falseAwnser', box.read('falseAwnser')+1);
       // falseAwnser = prefs.getInt('falseAwnser');
        checkFirstTime();

        AudioManager.playFalse();




        if(box.read('coins') > 0){

          box.write('coins', box.read('coins')-1);
          checkFirstTime();
        }
        else if(box.read('coins') <=0){

          box.write('coins', 0);
          checkFirstTime();

          // coins = box.read('coins');
        }

        if(box.read('falseAwnser') >= 100){
          print('aaaa');
          box.write('falseAwnser', 0);
         // falseAwnser = prefs.getInt('falseAwnser');
          checkFirstTime();

          if(box.read('score') <= 250){
            box.write('score', 0);
           // score =prefs.getInt('score');
            checkFirstTime();


            if(box.read('shaddat')<=44){
              box.write('shaddat', 0);
              checkFirstTime();

              //  shaddat =prefs.getInt('shaddat');
            }


          }else if(box.read('score') >= 250){
            box.write('score', box.read('score')-250);
           // score =prefs.getInt('score');
            checkFirstTime();

            box.write('shaddat', box.read('shaddat')-110);
           // shaddat =prefs.getInt('shaddat');
            checkFirstTime();

          }

        }


    }

  }

  Rx<Color> colortoshow = Colors.indigo.obs;
  Color right = Colors.green;
  Color wrong = Colors.red;

  void checkanswer(String k ){
    print('K = ${k}');

    if (quizDataList.value[2][indexQuestionRandom.toString()] == quizDataList[1][indexQuestionRandom.toString()][k]) {

      checkReward(true);

      // changing the color variable to be green
      colortoshow.value = right;

      if(correctTime <4 && isAds){
        correctTime ++;
        Timer(Duration(seconds: 1), nextQuestion);
      }else if(correctTime==4 && isAds){

        correctTime = 0;
        interstitialAd?.dispose();

        timecontroller.pause();
        interstitialAd = createInterstitialAd()..load()..show();
      }
      else if(!isAds){
        Timer(Duration(seconds: 1), nextQuestion);
      }

    } else {
      checkReward(false);

      // just a print sattement to check the correct working
      // debugPrint(mydata[2]["1"] + " is equal to " + mydata[1]["1"][k]);
      colortoshow.value = wrong;
      if( isAds && inCorrectTime <4){
        inCorrectTime++;
        Timer(Duration(seconds: 1), nextQuestion);



      }else if(inCorrectTime==4 && isAds){

        inCorrectTime = 0;
        interstitialAd?.dispose();

        timecontroller.pause();
        interstitialAd = createInterstitialAd()..load()..show();


      }
    }

      // applying the changed color to the particular button that was selected
      btncolor[k] = colortoshow.value;
      timecontroller.pause();
      disableAnswer.value = true;
    showRewardButton();


    // nextquestion();
    // changed timer duration to 1 second

  }



  BannerAd myBanner = BannerAd(
    // Replace the testAdUnitId with an ad unit id from the AdMob dash.
    // https://developers.google.com/admob/android/test-ads
    // https://developers.google.com/admob/ios/test-ads
    adUnitId:
    // BannerAd.testAdUnitId,
    'ca-app-pub-2814422544312075/2043685194',
    size: AdSize.banner,
    //  targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("BannerAd event is $event");
    },
  );

  InterstitialAd interstitialAd;

  InterstitialAd createInterstitialAd() {

    return InterstitialAd(
      adUnitId:
      'ca-app-pub-2814422544312075/9539031839',
     // InterstitialAd.testAdUnitId,
    //  targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        // print("InterstitialAd event $event");
        // print('the Adddd = ${MobileAdEvent.opened.toString()}')  ;
        if(event.toString() == 'MobileAdEvent.opened'){
          Timer(Duration(seconds: 1),(){
            timecontroller.pause();
            print('the Adddd = ${event.toString()}')  ;

          });

        }
        if(event.toString() == 'MobileAdEvent.closed'){
          // Fluttertoast.showToast(msg: '${event}');
          print('the Adddd = ${event.toString()}')  ;
          Timer(Duration(seconds: 1),(){
            timecontroller.pause();
            nextQuestion();

          } );
          timecontroller.restart();

        }
        if(event.toString() == 'MobileAdEvent.failedToLoad'){

          Fluttertoast.showToast(msg: '${event}');
          timecontroller.resume();
          nextQuestion();
        }

      },
    );
  }

  RxBool isLoading = false.obs;

  Rx<ConnectivityResult> connectionStatus = ConnectivityResult.none.obs;
  final Connectivity _connectivity = Connectivity();
   StreamSubscription<ConnectivityResult> _connectivitySubscription;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
     ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.


    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    connectionStatus.value = result;
  }
  @override
  void onInit() {
    // TODO: implement onInit

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);


    try{


      isLoading(true);

      getQuizData().whenComplete(() {
        if(quizDataList.isNotEmpty) {
          genRandomArray();
          indexQuestionRandom.value = rand.nextInt(quizDataList[0].length);
        }
      }).whenComplete(() =>  isLoading(false));

      checkFirstTime();


      myBanner
        ..load()
        ..show(
          anchorType: AnchorType.top,
          anchorOffset: kToolbarHeight -25,
        );


      initAdReward();
      createInterstitialAd();
    }catch(e){

    }
    finally{
     // isLoading(false);

      AudioManager.playSong();

    }

    super.onInit();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    interstitialAd?.dispose();
    RewardedVideoAd.instance.listener = null;
    myBanner?.dispose();
    super.dispose();
  }

  RxBool loaded = false.obs;

  void initAdReward(){


    RewardedVideoAd.instance
        .load(
        adUnitId:
        'ca-app-pub-2814422544312075/4895932406'
      // RewardedVideoAd.testAdUnitId,
    )
        .catchError((e) => print("error in loading 1st time"))
        .then((v) =>  loaded.value = v);

    // ad listener
    RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event, {String rewardType, int rewardAmount})async {
      if (event == RewardedVideoAdEvent.closed) {
        RewardedVideoAd.instance
            .load(adUnitId:
        'ca-app-pub-2814422544312075/4895932406',
           //  RewardedVideoAd.testAdUnitId,
           // targetingInfo: targetingInfo
        )
            .catchError((e) {
          print('nice');
          print("error in loading again");
        })
            .then((v) =>loaded.value = v);
      }


      if (event == RewardedVideoAdEvent.rewarded) {


          box.write('coins', box.read('coins') + 2);
          checkFirstTime();

      }
      if(event == RewardedVideoAdEvent.closed){
        timecontroller.resume();
      }

      if(event == RewardedVideoAdEvent.failedToLoad){
        // disableAnswer = true;
        //  AppLovin.requestInterstitial(
        //          (AppLovinAdListener event) => listener(event,false),
        //      interstitial: false);
      }
    };


  }

  void resolveQuestion(){

    if(box.read('coins') >= 3) {



        box.write('coins', box.read('coins') - 3);

        checkFirstTime();

       // isAds = false;
        correctTime = 0;
        List choice = ["a","b","c","d"];

        for(int aa=0; aa<choice.length;aa++){
          if (quizDataList[2][indexQuestionRandom.toString()] == quizDataList[1][indexQuestionRandom.toString()][choice[aa]]){

            checkanswer(choice[aa]);

          }
        }




    }
    else{
      Fluttertoast.showToast(msg: 'لا يوجد لديك عملات كافية',);
    }

  }

  void watchRewardAD()async{

    timecontroller.pause();
    await RewardedVideoAd.instance.show().catchError((e) {
      print('nice');
      print("error in showing ad: ${e.toString()}");
      // AppLovin.requestInterstitial(
      //       (AppLovinAdListener event) =>listener(event,false),
      //   interstitial: false,);
    });
    loaded.value = false;

  }


  RxBool isVisible = false.obs ;

  void showRewardButton() {

    if(box.read('shaddat') < 340){
      isVisible.value = false;
    }
    if(box.read('shaddat') >=340){

        isVisible.value = true;



    }

  }


  withDrawShaddat(){

    timecontroller.pause();
    showDialog(barrierDismissible: false,
        context: Get.context,
        builder: (context) => AlertDialog(

          title: Text(
            "مبروك !! "
                "\n"
                " سيتم شحن 340 شدة على ID "
                "\n"
                "وقت التسليم حتى 48 ساعة ",textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          content: SizedBox(
            height:MediaQuery.of(context).size.height/6 ,
            width: double.infinity,
            child: Column(
              children: [
                TextField(
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  controller: userPubgID,
                  decoration: InputDecoration(
                    labelText: 'ID',
                    alignLabelWithHint: true,
                    hintText: 'ادخل ID هنا',
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.lightGreen,
              onPressed: ()async {

                if(userPubgID.text.length ==10){
                  print('${userPubgID.text.length}');
                  FirebaseDatabase().reference().child('Shaddat')
                      .push().set({
                    "ID": userPubgID.text,
                    "date":DateTime.now().toIso8601String(),

                  }).then((v) async{
                    print('done');

                    updateShaddatValue(box.read('shaddat') - 340);
                    updateFalseAwnserValue(0);
                    updateScoreValue(0);

                    userPubgID.clear();

                    timecontroller.resume();
                    Navigator.pop(context);

                    showRewardButton();
                  });
                }
                else{
                  Fluttertoast.showToast(msg: 'الرقم خاطئ');
                }

              },
              child: Text(
                'ارسال',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15
                  ,color: Colors.white),
              ),
            ),

            FlatButton(
              color: Colors.redAccent,
              onPressed: () async{
                timecontroller.resume();
                Navigator.pop(context);
              },
              child: Text(
                'الغاء',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
              ),
            ),
          ],
        ));

  }



}