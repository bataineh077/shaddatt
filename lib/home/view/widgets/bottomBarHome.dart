import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomBarHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
