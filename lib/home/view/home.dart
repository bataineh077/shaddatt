import 'package:connectivity_alert_widget/connectivity_alert_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shaddatt/home/view/rules.dart';
import 'package:shaddatt/home/view/widgets/bottomBarHome.dart';
import 'package:shaddatt/home/view/widgets/homeButton.dart';
import 'package:shaddatt/quiz/veiw/quizScreen.dart';
import 'package:shaddatt/quiz/viewModel/quizController.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return Scaffold(
        body:
        ConnectivityAlertWidget(

      offlineWidget: Material(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/noconn.png',
                height: MediaQuery.of(context).size.height / 2.5,
                width: MediaQuery.of(context).size.width / 1.2,
              ),
              Text(
                'لا يوجد اتصال',
                style: TextStyle(fontSize: 25, color: Colors.grey),
              )
            ],
          ),
        ),
      ),

          onlineWidget: GetX<QuizController>(
              init: QuizController(),
              builder: (controller) {
                if (controller.isLoading.value)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                else
                  return  controller.connectionStatus.value == ConnectivityResult.none?
                  Material(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/noconn.png',
                            height: MediaQuery.of(context).size.height / 2.5,
                            width: MediaQuery.of(context).size.width / 1.2,
                          ),
                          Text(
                            'لا يوجد اتصال',
                            style: TextStyle(fontSize: 25, color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                  )
                      : Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('images/index3.jpeg'),
                                fit: BoxFit.cover)),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: HomeButton(
                                color: Colors.red,
                                title: 'إبدأ',
                                voidCallback: () => Get.to(() => QuizScreen()),
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 25),
                            child: HomeButton(
                              color: Colors.indigo,
                              title: 'إقرأ أولا',
                              voidCallback: () => Get.to(
                                    () => Rules(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: BottomBarHome()),
                    ],
                  );
              }),
    )


    );
  }
}
