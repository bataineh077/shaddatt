import 'package:asset_cache/asset_cache.dart';
import 'package:connectivity_alert_widget/connectivity_alert_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shaddatt/home/view/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  JsonAssets.instance.basePath = 'assets/';
  await GetStorage.init();
  FirebaseAdMob.instance
      .initialize(appId: 'ca-app-pub-2814422544312075~1911331018');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    
    return  GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "من سيربح الشدات",
          theme: ThemeData(
            fontFamily: 'Raleway',
            primarySwatch: Colors.indigo,
          ),
          home: Homepage(),

        );
  }
}
