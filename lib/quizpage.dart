import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:connectivity_alert_widget/connectivity_alert_widget.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shaddatt/audioManager/AudioManager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import 'widgitsUtil/headerComponent.dart';


class getjson extends StatelessWidget {
  // accept the langname as a parameter

//  String assettoload;
//
//  // a function
//  // sets the asset to a particular JSON file
//  // and opens the JSON
//  setasset() {
//      assettoload = "assets/python.json";
//  }




  @override
  Widget build(BuildContext context) {
    // this function is called before the build so that
    // the string assettoload is avialable to the DefaultAssetBuilder
  //  setasset();
    // and now we return the FutureBuilder to load and decode JSON
    return FutureBuilder(
      future:
          DefaultAssetBundle.of(context).loadString('assets/java.json', cache: true),
      builder: (context, snapshot) {
        List mydata = json.decode(snapshot.data.toString());

        if (mydata == null) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator()
            ),
          );
        } else {
          return quizpage(mydata: mydata);
        }
      },
    );
  }
}

class quizpage extends StatefulWidget  {
  final List mydata;

  quizpage({Key key, @required this.mydata}) : super(key: key);
  @override
  _quizpageState createState() => _quizpageState(mydata);
}

class _quizpageState extends State<quizpage> {



  final List mydata;
  _quizpageState(this.mydata);

  int score =0,falseAwnser=0,shaddat=0,coins=0;

  TextEditingController userPubgID = TextEditingController();

  GlobalKey<_quizpageState> _myKey = GlobalKey();

  checkFirstTime()async{
    final prefs = await SharedPreferences.getInstance();

    if(!prefs.containsKey('first')) {
      prefs.setBool('first', true);

      prefs.setInt('score', 0);
      prefs.setInt('shaddat', 0);
      prefs.setInt('coins', 0);
      prefs.setInt('false', 0);

      score = prefs.getInt('score');
      falseAwnser = prefs.getInt('false');
      shaddat = prefs.getInt('shaddat');
      coins = prefs.getInt('coins');
    }
    else{

      score = prefs.getInt('score');
       falseAwnser = prefs.getInt('false');
      shaddat = prefs.getInt('shaddat');
      coins = prefs.getInt('coins');
    }


  }


  Color colortoshow = Colors.indigoAccent;
  Color right = Colors.green;
  Color wrong = Colors.red;
  int i = 1;
  bool disableAnswer = false;
  // extra varibale to iterate
  int j = 1;
  int timer = 15;
  var random_array;

  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['pubg', 'games' , 'arcade' , 'quiz' 'jordan' , 'الاردن','ببجي'],
    // contentUrl: 'https://flutter.io',
    // birthday: DateTime.now(),
    childDirected: false,
    designedForFamilies: false,
    gender: MobileAdGender.male, // or MobileAdGender.female, MobileAdGender.unknown
    // testDevices: <String>['120AD3FA0F076D56C99E317E1EF7D9C1',], // Android emulators are considered test devices
  );

  AnimationController animateController;
  AnimationController animateController2;
  AnimationController animateController3;
  AnimationController animateController4;
  bool _loaded = false;

  final CountdownController timecontroller = CountdownController();


  Map<String, Color> btncolor = {
    "a": Colors.indigoAccent,
    "b": Colors.indigoAccent,
    "c": Colors.indigoAccent,
    "d": Colors.indigoAccent,
  };

 // bool canceltimer = false;

  bool isAds = true;


  // code inserted for choosing questions randomly
  // to create the array elements randomly use the dart:math module
  // -----     CODE TO GENERATE ARRAY RANDOMLY

  genRandomArray(){
    var rand = new Random();
    var distinctIds = [];

      for (; ;) {
      distinctIds.add(rand.nextInt(mydata[0].length));
        random_array = distinctIds.toSet().toList();
        if(random_array.length < mydata[0].length){
          continue;
        }else{
          break;
        }
      }
      print(random_array);
  }
  //
  // listener(AppLovinAdListener event , bool interstitial)async{
  //   if(event == AppLovinAdListener.adReceived) AppLovin.showInterstitial(interstitial: interstitial);
  //   if(event == AppLovinAdListener.videoPlaybackBegan) {
  //     timecontroller.pause();
  //     AudioManager.assetsAudioPlayer.pause();
  //   }
  //
  //     if(event == AppLovinAdListener.videoPlaybackEnded) {
  //       AudioManager.assetsAudioPlayer.play();
  //       timecontroller.resume();
  //     }
  //   var  prefs = await SharedPreferences.getInstance();
  //
  //   if(event == AppLovinAdListener.userRewardRejected){
  //
  //     AudioManager.assetsAudioPlayer.pause();
  //
  //   }
  //
  //   if(event == AppLovinAdListener.userRewardVerified){
  //     setState(() {
  //       coins += 700;
  //       prefs.setInt('coins', prefs.getInt('coins')+700);
  //       AudioManager.assetsAudioPlayer.pause();
  //     });
  //
  //
  //   }
  //   else print(event);
  // }
  //

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

  InterstitialAd _interstitialAd;

  InterstitialAd createInterstitialAd() {

    return InterstitialAd(
      adUnitId:
     'ca-app-pub-2814422544312075/9539031839',
     //InterstitialAd.testAdUnitId,
       targetingInfo: targetingInfo,
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
              timecontroller.resume();

        }
        if(event.toString() == 'MobileAdEvent.failedToLoad'){

          // AppLovin.requestInterstitial(
          //         (AppLovinAdListener event) => listener(event,true),
          //     interstitial: true);
          Fluttertoast.showToast(msg: '${event}');
           timecontroller.resume();
        // setState(() {disableAnswer = true; timecontroller.pause();});
         //TODO:
         // return  showDialog(barrierDismissible: false,
         //     context: context,
         //     builder: (context) => WillPopScope(
         //       key: _key,
         //       onWillPop: () {
         //         return showDialog(
         //             context: context,
         //             builder: (context) => AlertDialog(
         //               title: Text(
         //                 "تنبيه",
         //               ),
         //               content: Text("تأكد من تشغيل الانترنت وادخل للتطبيق مرة اخرى"),
         //               actions: <Widget>[
         //                 FlatButton(
         //                   onPressed: () {
         //                     Navigator.of(context).pop();
         //                   },
         //                   child: Text(
         //                     'Ok',
         //                   ),
         //                 )
         //               ],
         //             ));
         //       },
         //       child: AlertDialog(
         //
         //         title: Text(
         //           "تنبيه",textAlign: TextAlign.center,
         //           style: TextStyle(
         //             fontSize: 25
         //           ),
         //         ),
         //         content: SizedBox(
         //           height:MediaQuery.of(context).size.height ,
         //           width: MediaQuery.of(context).size.width,
         //         child: Center(
         //           child: Text(
         //             "هناك مشكلة في تشغيل الاعلانات \n"
         //                 "تأكد من تشغيل الانترنت",textAlign: TextAlign.center,
         //             style: TextStyle(
         //                 fontSize: 25,fontWeight: FontWeight.bold
         //             ),
         //           ),
         //         ),
         //         ),
         //
         //       ),
         //     ));
        }

      },
    );
  }






  @override
  void initState() {

    AudioManager.playSong();


    var rand = new Random();
         i = rand.nextInt(mydata[0].length);

    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-2814422544312075~1911331018');

    myBanner
      ..load()
      ..show(
        anchorType: AnchorType.top,
        anchorOffset: kToolbarHeight -25,
      );

    RewardedVideoAd.instance
        .load(
      adUnitId:
      'ca-app-pub-2814422544312075/4895932406'
     // RewardedVideoAd.testAdUnitId,
    )
        .catchError((e) => print("error in loading 1st time"))
        .then((v) => setState(() => _loaded = v));

    // ad listener
    RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event, {String rewardType, int rewardAmount})async {
      if (event == RewardedVideoAdEvent.closed) {
        RewardedVideoAd.instance
            .load(adUnitId:
        'ca-app-pub-2814422544312075/4895932406',
       // RewardedVideoAd.testAdUnitId,
      targetingInfo: targetingInfo  )
            .catchError((e) {
              print('nice');
              print("error in loading again");
            })
            .then((v) => setState(() => _loaded = v));
      }
            var  prefs = await SharedPreferences.getInstance();

      if (event == RewardedVideoAdEvent.rewarded) {
        setState(() {
          coins += 2;
          prefs.setInt('coins', prefs.getInt('coins')+2);


        });
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

    // createInterstitialAd()..load()..show().whenComplete(() => );
    genRandomArray();
    checkFirstTime();
    super.initState();



  }


@override
  void dispose() {
  _interstitialAd?.dispose();
  RewardedVideoAd.instance.listener = null;
  myBanner?.dispose();
 // players.pause();
  super.dispose();
  }



  // overriding the setstate function to be called only if mounted
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }

  }



  void nextQuestion() {
    print('next Q');
    setState(() {
      print(j);
      if (j < mydata[0].length) {
        i = random_array[j];
        print('random arr :${random_array[j]}');
        j++;
      } else {

      j=0;
        genRandomArray();
      print('End');
      }

      btncolor["a"] = Colors.indigoAccent;
      btncolor["b"] = Colors.indigoAccent;
      btncolor["c"] = Colors.indigoAccent;
      btncolor["d"] = Colors.indigoAccent;
      disableAnswer = false;
    });

    timecontroller.restart();
  }

  int correctTime = 0;
  int inCorrectTime = 0;

  void checkReward(bool t)async{

    final prefs = await SharedPreferences.getInstance();

if(t){
    setState(() {
      prefs.setInt('score', prefs.getInt('score')+1);
      score =prefs.getInt('score');

      AudioManager.playCorrect();


     // animateController.reset();
    //  animateController3.reset();
    //  animateController4.reset();


      if(score ==100 || score ==200 || score ==300 || score ==400 || score ==500
          || score ==600 || score ==700 || score ==800 ||score ==900|| score==1000)
      {
        prefs.setInt('shaddat', prefs.getInt('shaddat')+44);
        shaddat =prefs.getInt('shaddat');
      }
    });}

else if(!t){

  setState(() {
    prefs.setInt('false', prefs.getInt('false')+1);
    falseAwnser = prefs.getInt('false');

    AudioManager.playFalse();

   // animateController2.reset();
   // animateController3.reset();
   // animateController4.reset();


    if(coins > 0){
      coins -= 1;
      prefs.setInt('coins', prefs.getInt('coins')-1);}
    else if(coins <=0){

      prefs.setInt('coins', 0);
      coins = prefs.getInt('coins');
    }

    if(prefs.getInt('false') >= 100){
  print('aaaa');
             prefs.setInt('false', 0);
             falseAwnser = prefs.getInt('false');

      if(score <= 250){
        prefs.setInt('score', 0);
        score =prefs.getInt('score');


        if(shaddat<=44){
          prefs.setInt('shaddat', 0);
          shaddat =prefs.getInt('shaddat');
        }


      }else if(score >= 250){
        prefs.setInt('score', prefs.getInt('score')-250);
        score =prefs.getInt('score');

        prefs.setInt('shaddat', prefs.getInt('shaddat')-110);
        shaddat =prefs.getInt('shaddat');
      }

    }
  });

}

  }

  void checkanswer(String k ){
 print('K = ${k}');
    // in the previous version this was
    // mydata[2]["1"] == mydata[1]["1"][k]
    // which i forgot to change
    // so nake sure that this is now corrected
    if (mydata[2][i.toString()] == mydata[1][i.toString()][k]) {
      // just a print sattement to check the correct working
      // debugPrint(mydata[2][i.toString()] + " is equal to " + mydata[1][i.toString()][k]);
      // marks = marks + 1;
     checkReward(true);

     // changing the color variable to be green
     colortoshow = right;
     if(correctTime <1 && isAds){
       correctTime ++;
       Timer(Duration(seconds: 1), nextQuestion);
     }else if(correctTime==1 && isAds){

       correctTime = 0;
       _interstitialAd?.dispose();

       timecontroller.pause();
       _interstitialAd = createInterstitialAd()..load()..show();
     }
     else if(!isAds){
       Timer(Duration(seconds: 1), nextQuestion);
     }

    } else {
      checkReward(false);

      // just a print sattement to check the correct working
      // debugPrint(mydata[2]["1"] + " is equal to " + mydata[1]["1"][k]);
      colortoshow = wrong;
      if( isAds && inCorrectTime <1){
        inCorrectTime++;
        Timer(Duration(seconds: 1), nextQuestion);



    }else if(inCorrectTime==1 && isAds){
        _interstitialAd?.dispose();

        timecontroller.pause();
        _interstitialAd = createInterstitialAd()..load()..show();

        inCorrectTime = 0;
      }
    }
    setState(() {
      // applying the changed color to the particular button that was selected
      btncolor[k] = colortoshow;
     timecontroller.pause();
      disableAnswer = true;

    });

    // nextquestion();
    // changed timer duration to 1 second

  }

  Widget choicebutton(String k) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      child: MaterialButton(
        onPressed: () {
          isAds =true;
          checkanswer(k);} ,
        child: Text(
          "${mydata[1][i.toString()][k]}",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Alike",
            fontSize: 16.0,
          ),
          maxLines: 2,
          textDirection: TextDirection.rtl,
        ),
        color: btncolor[k],
        splashColor: Colors.indigo[700],
        highlightColor: Colors.indigo[700],
        minWidth: 125.0,
        height: 45.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }



  bool _isVisible ;

  void showRewardButton() {

    if(shaddat <340){
      _isVisible = false;
    }
if(shaddat >=340){
    setState(() {

      _isVisible = !_isVisible;

    });

}

  }



  @override
  Widget build(BuildContext context) {


    showRewardButton();
     Icon icon = Icon(Icons.volume_up,color: Colors.white,size: 30,);


    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return WillPopScope(
      key: _myKey,
      onWillPop: () {
        return showDialog(
            context: context,
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
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: ConnectivityAlertWidget(
            onConnectivityResult: (connectivity)=>print(connectivity),

          offlineWidget: Material(
          child: Container(
          height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    color: Colors.white,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Image.asset('images/noconn.png',
    height: MediaQuery.of(context).size.height/2.5,
    width: MediaQuery.of(context).size.width/1.2, ),
    Text('لا يوجد اتصال',style: TextStyle(fontSize: 25,color: Colors.grey),)
    ],
    ),
    ),
    ) ,
    onlineWidget:
          Scaffold(
             // appBar: AppBar(title: myBanner..load()..show()),
            body: SafeArea(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                        'images/im2.jpeg'
                      ))
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex:1,
                        child: Container(
                         // height: MediaQuery.of(context).size.height/10,
                           color: Colors.indigo,
                          child: Center(
                            child: Row(

                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [


                                HeaderComponents(image: 'images/hiclipart.com(1).png',
                                  animateController: animateController,
                                  number: score ,
                                iconColor: Colors.green,colors: Colors.green,
                                ),

                                HeaderComponents(image: 'images/hiclipart.com(2).png',
                                animateController: animateController2,
                                number: falseAwnser ,
                                  iconColor: Colors.red,
                                ),

                                HeaderComponents(image: 'images/shaddat.png',
                                  animateController: animateController3,
                                  number: shaddat ,
                                  iconColor: Colors.purple,
                                ),


                                HeaderComponents(image: 'images/hiclipart.com(3).png',
                                  animateController: animateController4,
                                  number: coins ,
                                  iconColor: Colors.yellow,
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),


                      Expanded(
                        flex: 2,
                        child: Container(
                          color: Colors.black26,
                          padding: EdgeInsets.all(14.0),
                          alignment: Alignment.center,
                          child: Text(
                            "${mydata[0][i.toString()]}",
                            style: TextStyle(
                              fontSize: 19.0,
                              //fontFamily: "Quando",
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 4,
                          child: AbsorbPointer(
                            absorbing: disableAnswer,
                              child: Container(
                              child: ListView(
                              //  mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  choicebutton('a'),
                                  choicebutton('b'),
                                  choicebutton('c'),
                                  choicebutton('d'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          IconButton(
                            icon: icon,
                            onPressed: (){
                              setState(() {  AudioManager.assetsAudioPlayer.playOrPause();
                              });}

                          ),

                          Container(
                            alignment: Alignment.bottomCenter,
                            child: Center(

                              child: Countdown(
                                controller: timecontroller,
                                seconds: 15,
                                build: (_, double time) => Text(
                                  "${time.toString()}",
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70
                                  ),
                                ),
                                interval: Duration(milliseconds: 100),
                                onFinished: () {

                                  showDialog(barrierDismissible: false,
                                      context: context,
                                      builder: (context) => AlertDialog(

                                        title: Text(
                                          "انتهى الوقت",
                                        ),
                                        content: Image.asset('images/alarm.png'),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () async{
                                              Navigator.of(context).pop();
                                              var  prefs = await SharedPreferences.getInstance();


                                              setState(() {
                                                prefs.setInt('false', prefs.getInt('false')+1);
                                                falseAwnser =prefs.getInt('false');

                                                if(falseAwnser > 100){
                                                  if(score <= 250){
                                                    prefs.setInt('score', 0);
                                                    score =prefs.getInt('score');

                                                    prefs.setInt('false', 0);
                                                    falseAwnser =prefs.getInt('false');
                                                  }else if(score >250){
                                                    prefs.setInt('score', prefs.getInt('score')-250);
                                                    score =prefs.getInt('score');
                                                    prefs.setInt('false', 0);
                                                    falseAwnser =prefs.getInt('false');
                                                  }

                                                }
                                              });
                                              nextQuestion();
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
                                },
                              ),

                            ),
                          ),

                          Container(child: Text('    '),)
                        ],
                      ),


                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Flexible(
                              child: GestureDetector(
                                onTap: ()async{

                                  timecontroller.pause();
                                  await RewardedVideoAd.instance.show().catchError((e) {
                                    print('nice');
                                    print("error in showing ad: ${e.toString()}");
                                    // AppLovin.requestInterstitial(
                                    //       (AppLovinAdListener event) =>listener(event,false),
                                    //   interstitial: false,);
                                  });
                                  setState(() => _loaded = false);


                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height/10,
                                  width: double.infinity,
                                  color: Colors.indigo,
                                  child: Center(
                                    child: Text("شاهد اعلان للحصول على عملتين",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      ),),
                                  ),
                                ),
                              ),
                            ),

                            Flexible(
                              child: GestureDetector(
                                onTap: ()async{

                                  final prefs = await SharedPreferences.getInstance();
                                  if(coins >= 3) {

                                    setState(() {
                                      coins -= 3;
                                      prefs.setInt('coins', prefs.getInt('coins') - 3);
                                      isAds = false;
                                      List choice = ["a","b","c","d"];

                                      for(int aa=0; aa<choice.length;aa++){
                                        if (mydata[2][i.toString()] == mydata[1][i.toString()][choice[aa]]){

                                          checkanswer(choice[aa]);

                                        }
                                      }
                                    });



                                  }
                                  else{
                                    Fluttertoast.showToast(msg: 'لا يوجد لديك عملات كافية',);
                                  }


                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height/10,
                                  width:  double.infinity,
                                  color: Colors.orange.withOpacity(0.9),
                                  child: Center(
                                    child: Text("إكتشف الاجابة",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      ),),
                                  ),
                                ),
                              ),
                            ),

                            Visibility(
                              visible: _isVisible,
                              child: Flexible(
                                child: GestureDetector(
                                  onTap: (){
                                    timecontroller.pause();
                                    showDialog(barrierDismissible: false,
                                        context: context,
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
                                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                                    setState(() {
                                                      prefs.setInt('shaddat', prefs.getInt('shaddat')-340);
                                                      shaddat = shaddat-340;
                                                      shaddat =prefs.getInt('shaddat');
                                                    });
                                                    userPubgID.clear();

                                                    timecontroller.resume();
                                                    Navigator.pop(context);

                                                    setState(() { showRewardButton();});
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


                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height/10,
                                    width: double.infinity,
                                    color: Colors.deepOrangeAccent,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset('images/shaddat.png',
                                          height:MediaQuery.of(context).size.height/17.5 ,
                                          width: MediaQuery.of(context).size.height/17.5,),
                                        Text("طالب بالشدات",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold
                                          ),),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),


                    ],
                  ),
                ],
              ),
            ),

           // bottomNavigationBar:


          )
        ),
      ),
    );

  }

}
