import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';


class HeaderComponents extends StatefulWidget {


  String image ; int number; AnimationController animateController;
  Color iconColor , colors;
  HeaderComponents({ this.image, this.number,this.animateController ,this.iconColor,this.colors});

  @override
  _HeaderComponentsState createState() => _HeaderComponentsState();
}

class _HeaderComponentsState extends State<HeaderComponents> {
  @override
  Widget build(BuildContext context) {
    return Row(

      children: [
        Image.asset(widget.image,height: 25,
          width: 25,
          color: widget.colors,
        ),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: widget.iconColor,width: 2),
              borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          child: Text('${widget.number}',
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
        ),

        ZoomOut(from: 15,
          manualTrigger: true,
          controller: ( controller ) => widget.animateController = controller,
          child: Text('${widget.number}',
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: widget.iconColor),),
        )
      ],
    );
  }
}


