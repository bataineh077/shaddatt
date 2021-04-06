import 'package:connectivity_alert_widget/connectivity_alert_widget.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shaddatt/quiz/veiw/quizScreen.dart';
import 'package:shaddatt/quiz/veiw/quizpage.dart';
import 'package:shaddatt/home/rules.dart';
import 'package:shaddatt/quiz/viewModel/quizController.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../quiz/veiw/quizpage.dart';

class homepage extends StatefulWidget {
  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {


//
//  Widget customcard(String langname, String image, String des){
//    return Padding(
//      padding: EdgeInsets.symmetric(
//        vertical: 20.0,
//        horizontal: 30.0,
//      ),
//      child: InkWell(
//        onTap: (){
//          Navigator.of(context).pushReplacement(MaterialPageRoute(
//            // in changelog 1 we will pass the langname name to ther other widget class
//            // this name will be used to open a particular JSON file
//            // for a particular language
//            builder: (context) => getjson(),
//          ));
//        },
//        child: Material(
//          color: Colors.indigoAccent,
//          elevation: 10.0,
//          borderRadius: BorderRadius.circular(25.0),
//          child: Container(
//            child: Column(
//              children: <Widget>[
//                Padding(
//                  padding: EdgeInsets.symmetric(
//                    vertical: 10.0,
//                  ),
//                  child: Material(
//                    elevation: 5.0,
//                    borderRadius: BorderRadius.circular(100.0),
//                    child: Container(
//                      // changing from 200 to 150 as to look better
//                      height: 150.0,
//                      width: 150.0,
//                      child: ClipOval(
//                        child: Image(
//                          fit: BoxFit.cover,
//                          image: AssetImage(
//                            image,
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//                Center(
//                  child: Text(
//                    langname,
//                    style: TextStyle(
//                      fontSize: 20.0,
//                      color: Colors.white,
//                      fontFamily: "Quando",
//                      fontWeight: FontWeight.w700,
//                    ),
//                  ),
//                ),
//                Container(
//                  padding: EdgeInsets.all(20.0),
//                  child: Text(
//                    des,
//                    style: TextStyle(
//                      fontSize: 18.0,
//                      color: Colors.white,
//                      fontFamily: "Alike"
//                    ),
//                    maxLines: 5,
//                    textAlign: TextAlign.justify,
//                  ),
//
//                ),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  int _coins = 0;

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,

      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }



  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-2814422544312075~1911331018');
   // _bannerAd = createBannerAd()..load()..show();
    // TODO: implement initState
    super.initState();
  }

  var controller = Get.put(QuizController());

  @override
  void dispose() {
    _bannerAd?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown, DeviceOrientation.portraitUp
    ]);
    return ConnectivityAlertWidget(
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
      ),
      //  offlineBanner:
        onlineWidget:

            Scaffold(

            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/index3.jpeg'),
                          fit: BoxFit.cover
                      )
                  ),
                ),
                Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[


                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: RaisedButton(textColor: Colors.white,
                              onPressed: (){
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => QuizScreen(),
                                ));
                              },
                              color: Colors.red,
                              child: Text('إبدأ',style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25
                              ),),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 25),
                      child: Row(
                        children: [
                          Expanded(
                            child: RaisedButton(textColor: Colors.white,
                              onPressed: (){
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Rules(),
                                ));
                              },
                              color: Colors.indigo,
                              child: Text('إقرأ أولا',style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25
                              ),),
                            ),
                          ),
                        ],
                      ),
                    ),


                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.black45,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(splashColor: Colors.red,
                          onTap: ()async{
                            const url = 'fb://page/101231191757698';
                            if (await canLaunch(url)) {
                              await launch(url, forceSafariVC: false, forceWebView: false,);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Image.asset('images/facebook.png',
                            height: MediaQuery.of(context).size.height/15,),
                        ),

                        InkWell(
                          onTap: ()async{
                            const url = 'https://www.instagram.com/free_shaddat/';
                            if (await canLaunch(url)) {
                              await launch(
                                url,
                                universalLinksOnly: true,
                              );
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Image.asset('images/instagram.png',
                            height: MediaQuery.of(context).size.height/15,),
                        ),

                        InkWell(
                          onTap: ()async{
                            const url = 'mailto:mnsayarba@gmail.com?subject=News&body=New%20plugin';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Image.asset('images/gmail.png',
                            height: MediaQuery.of(context).size.height/15,),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),

          )


    );
  }
}