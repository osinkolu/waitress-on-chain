import "package:flutter/material.dart";
import 'package:auto_size_text/auto_size_text.dart';
import 'receipts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  double _progress =35;
  final PageController _pageController = PageController(viewportFraction: 1.0);
  @override
  Widget build(BuildContext context) {
    double widthx = MediaQuery.sizeOf(context).width;
    double heightx = MediaQuery.sizeOf(context).height;
    List<Widget> _sections =[
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Container(
                height:heightx*0.2,
                width:widthx*0.7,
                child: Image.asset("assets/img/empty_tray.png",fit:BoxFit.contain)
            ),
            SizedBox(
                height:5
            ),
            Container(
                height: heightx*0.07,
                width: widthx*0.6,
                alignment:Alignment.center,
                decoration: BoxDecoration(
                ),
                child:AutoSizeText(
                  textAlign: TextAlign.center,
                  "Your plate looks like this...",
                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color:Color.fromARGB(200, 255,255,255)),
                  minFontSize: 5,
                  maxFontSize: 15,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
            )
          ]
      ),
      Column(
        children: [
          Container(
              height: 20,
              width: widthx,
              margin: EdgeInsets.only(left:10,right: 10),
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                textAlign: TextAlign.start,
                "previous orders",
                style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900,color:Color.fromARGB(255, 255,255,255)),
                minFontSize: 5,
                maxFontSize: 20,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
          ),
          Expanded(
            child: Receipts(),
          )
        ],
      )
    ];
    return Container(
      width: widthx,
      height: heightx,
      padding: EdgeInsets.only(left:0,right: 0,top: 10,bottom: 0),
      child: Column(
        children: [
          Container(
            width:50,
            height: 10,
            alignment: Alignment.center,
            child: SmoothPageIndicator(
                controller: _pageController,
                count:  _sections.length,
                effect:  ExpandingDotsEffect(
                    dotHeight :7,
                    dotWidth :7,
                    activeDotColor: Color.fromARGB(255, 255, 255, 255),
                    dotColor: Color.fromARGB(100, 255, 255, 255)
                ),
                onDotClicked: (index){
                }
            )
          ),
          Spacer(),
          Container(
            width: widthx,
            height: heightx * 0.32,
            // color: Colors.green,
            child: PageView.builder(
              itemCount: _sections.length,
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context,index){
                return _sections[index];
              }
            )
          ),
        ],
      ),
    );
  }
}
