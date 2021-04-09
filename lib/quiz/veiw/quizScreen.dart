import 'package:connectivity_alert_widget/connectivity_alert_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shaddatt/quiz/veiw/widgitsUtil/backGroundImage.dart';
import 'package:shaddatt/quiz/veiw/widgitsUtil/choiceButton.dart';
import 'package:shaddatt/quiz/veiw/widgitsUtil/endTimeDialog.dart';
import 'package:shaddatt/quiz/veiw/widgitsUtil/headerComponent.dart';
import 'package:shaddatt/quiz/veiw/widgitsUtil/offLineWidget.dart';
import 'package:shaddatt/quiz/veiw/widgitsUtil/questionArea.dart';
import 'package:shaddatt/quiz/veiw/widgitsUtil/timerRow.dart';
import 'package:shaddatt/quiz/viewModel/quizController.dart';

import 'widgitsUtil/footerButton.dart';


class QuizScreen extends StatelessWidget {

  AnimationController animateController;
  AnimationController animateController2;
  AnimationController animateController3;
  AnimationController animateController4;

  var controller = Get.put(QuizController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: ()=>Dialogs.willBackDialog(),


        child: GetX<QuizController>(
          init: QuizController(),
          builder: (_) {
            return Padding(
              padding: const EdgeInsets.only(top: 50),
    child: ConnectivityAlertWidget(
    onConnectivityResult: (connectivity)=>print(connectivity),
            offlineWidget: OfflineWidget(),
            onlineWidget:
            Scaffold(
              body: SafeArea(
                child: Stack(
                  children: [

                    BackGroundImage(),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

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
                                    number: _.score.value ,
                                    iconColor: Colors.green,colors: Colors.green,
                                  ),

                                  HeaderComponents(image: 'images/hiclipart.com(2).png',
                                    animateController: animateController2,
                                    number: _.falseAwnser.value ,
                                    iconColor: Colors.red,
                                  ),

                                  HeaderComponents(image: 'images/shaddat.png',
                                    animateController: animateController3,
                                    number: _.shaddat.value ,
                                    iconColor: Colors.purple,
                                  ),


                                  HeaderComponents(image: 'images/hiclipart.com(3).png',
                                    animateController: animateController4,
                                    number: _.coins.value ,
                                    iconColor: Colors.yellow,
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),


                        Expanded(flex: 2,child: QuestionArea()),

                        Expanded(
                          flex: 4,
                          child: AbsorbPointer(
                            absorbing: _.disableAnswer.value,
                            child: Container(
                              child: ListView(
                                //  mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ChoiceButton(keyQ: 'a',),
                                  ChoiceButton(keyQ: 'b',),
                                  ChoiceButton(keyQ: 'c',),
                                  ChoiceButton(keyQ: 'd',),

                                ],
                              ),
                            ),
                          ),
                        ),




                        TimerRow(),


                      Expanded(
                          child:Row(
                            children: [
                              FooterButton(title: "شاهد اعلان للحصول على عملتين",voidCallback: (){

                                controller.watchRewardAD();

                              },color: Colors.indigo,),
                              FooterButton(color: Colors.orange.withOpacity(0.9),
                                  voidCallback: (){
                                    controller.resolveQuestion();
                                  },
                                  title: "إكتشف الاجابة"),
                              
                              Visibility(
                                visible: controller.isVisible.value,
                                child: FooterButton(color: Colors.deepOrangeAccent.withOpacity(0.9),
                                  voidCallback: (){

                                  },
                                  title:'طالب بالشدات'),)
                            ],
                          ) )
                      ],
                    )

                  ],
                ),
              ),
            )
    )
            );
          }
        ),
      );

  }
}
