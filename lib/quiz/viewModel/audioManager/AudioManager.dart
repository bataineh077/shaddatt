import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class AudioManager{


  static final assetsAudioPlayer = AssetsAudioPlayer();
  static final assetsCorrect = AssetsAudioPlayer();
  static final assetsFalse = AssetsAudioPlayer();


 static playSong()async{
    try {
      await assetsAudioPlayer.open(
        Audio.network("https://cdn.indiesound.com/tracks/386300671_47006409_1959926117.mp3"),
      ).whenComplete(() =>  assetsAudioPlayer.play());
    } catch (t) {
      //mp3 unreachable
      print(t);
    }
  }


static  playCorrect()async{
    try {
      await assetsCorrect.open(
        Audio.network("https://dm0qx8t0i9gc9.cloudfront.net/previews/audio/BsTwCwBHBjzwub4i4/audioblocks-game-success-ding-correct-answer-achievement-award_SF4WMa-8APU_NWM.mp3"),
      ).whenComplete(() =>  assetsCorrect.play());
    } catch (t) {
      //mp3 unreachable
    }
  }

 static playFalse()async{
    try {
      await assetsFalse.open(
        Audio.network("https://dm0qx8t0i9gc9.cloudfront.net/previews/audio/BsTwCwBHBjzwub4i4/audioblocks-fail-error-mistake-out-of-time-sound-error-mistake-out-of-time-sound_SYoWmAb8CwI_NWM.mp3"),
      ).whenComplete(() =>  assetsFalse.play());
    } catch (t) {
      //mp3 unreachable
    }
  }

}