import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shaddatt/quiz/viewModel/audioManager/AudioManager.dart';
import 'package:shaddatt/quiz/viewModel/quizController.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import 'endTimeDialog.dart';

class TimerRow extends GetWidget<QuizController> {

  Icon icon = Icon(Icons.volume_up,color: Colors.white,size: 30,);


  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        IconButton(
            icon: icon,
            onPressed: (){
             AudioManager.assetsAudioPlayer.playOrPause();
             }

        ),

        Container(
          alignment: Alignment.bottomCenter,
          child: Center(

            child: Countdown(
              controller: controller.timecontroller,
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

                Dialogs.endTimeDialog();
              },
            ),

          ),
        ),

        Container(child: Text('    '),)
      ],
    );
  }
}
