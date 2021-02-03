import 'package:flutter/material.dart';

class Rules extends StatefulWidget {
  @override
  _RulesState createState() => _RulesState();
}

class _RulesState extends State<Rules> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('قواعد اللعبة'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),

      body: Container(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/index3.jpeg'),
                      fit: BoxFit.cover
                  )
              ),
            ),
            ListView.separated(
              separatorBuilder:(context , index)=> Divider(),
              itemCount: rules.length,
              itemBuilder: (context , index){
                return   RaisedButton(onPressed: (){},
                  color: Colors.white70,
                  child: Text('${rules[index]['name']}',
                    style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,
                    color: Colors.black87),
                  textDirection: TextDirection.rtl,),
                );
              },



            ),
          ],
        ),
      ),
    );
  }
}


var rules = [
  {
  'name':'يتكون التطبيق من مستوى واحد يوجد فيه 700 سؤال , كل 100 سؤال ب 44 شدة'
  },
  {
    'name':'لن تستطيع ربح الشدات حتى تجمع 340 شدة , اي انهاء المرحلة كاملة ومن ثم بإمكانك سحبهم بدفعة واحدة'
  },
  {
    'name':'اذا تخطى عداد الخطأ 100 خطأ يتم تنقيص 250 من المجموع و 150 من الشدات'
  },
  {
    'name':'انتبه للوقت ! في كل مرة ينتهي الوقت يزيد عداد الخطأ مرة واحدة'
  },

  {
    'name':'اذا واجهت صعوبة في الاسئلة كل ما عليك فعله هو زيادة العملات لكشف الاجابة'
  },
];