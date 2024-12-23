import "package:flutter/material.dart";
import 'package:avatar_stack/avatar_stack.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Vendors extends StatefulWidget {
  const Vendors({super.key});

  @override
  State<Vendors> createState() => _VendorsState();
}

class _VendorsState extends State<Vendors> {
  bool _openVendorDetails = false;
  final PageController _pageController = PageController(viewportFraction: 1.0);

  List<Map> vendorDetails =[
    {
      "name": "ChowDeck",
      "logo": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR5byPlsGyh30_VLehwLo-sUSngyiq1MjLZxQ&s",
    },
    {
      "name": "HeyFood",
      "logo": "https://play-lh.googleusercontent.com/1Tv6SA365yIkYQ99zK1dFYMiYP9tWm6Lccm9yx7xG_jdjsB9qTIzEeVexYiNWGdtcv6f",
    },
    {
      "name": "Glovo",
      "logo": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQrgMNlJePg5BOsRK5mULJzWskdbAu-cAXsyeStRxqpmzPoqNFvanRUYRkGs3sIRPcHgKo&usqp=CAU",
    },
  ];

  @override
  Widget build(BuildContext context) {
    double widthx = MediaQuery.sizeOf(context).width;
    double heightx = MediaQuery.sizeOf(context).height;
    return Container(
      height: heightx,
      width: widthx,
      child: SafeArea(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _openVendorDetails = !_openVendorDetails;
                });
              },
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: CurvedAnimation(parent: animation, curve: Curves.bounceInOut),
                    child: child,
                  );
                },
                child: _openVendorDetails
                    ? Container(
                        key: ValueKey(1), // Unique key to differentiate widgets
                        height: heightx * 0.17,
                        width: widthx * 0.7,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 30, 30, 30),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child:Column(
                          children:[
                            Container(
                              height: heightx * 0.02,
                              width: widthx * 0.7,
                              child: AutoSizeText(
                                textAlign: TextAlign.start,
                                "Ethereum wallet",
                                style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color:Color.fromARGB(255, 200,200,200)),
                                minFontSize: 5,
                                maxFontSize: 20,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(child: Container(
                                height: heightx * 0.06,
                                width: widthx * 0.7,
                                child: Row(
                                  children: [
                                    Container(
                                      height: heightx * 0.06,
                                      width: heightx * 0.06,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          image: DecorationImage(image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNUvhKD4fcvAc1XpKRuy7h4kyrLG5q5-vMtg&s"),fit:BoxFit.cover)
                                      ),
                                    ),
                                    SizedBox(
                                        width:10
                                    ),
                                    Expanded(
                                        child:AutoSizeText(
                                          textAlign: TextAlign.start,
                                          "0.000 ETH",
                                          style: TextStyle(fontSize: 30,fontWeight: FontWeight.w900,color:Color.fromARGB(255, 255,255,255)),
                                          minFontSize: 5,
                                          maxFontSize: 30,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                    )
                                  ],
                                )
                            )
                            ),
                            Container(
                              height: heightx * 0.05,
                              width: widthx * 0.7,
                              child: Row(
                                children: [
                                  Expanded(
                                      child:AutoSizeText(
                                        textAlign: TextAlign.center,
                                        "Fund Wallet",
                                        style: TextStyle(fontSize: 13,fontWeight: FontWeight.w900,color:Color.fromARGB(200, 255,255,255)),
                                        minFontSize: 5,
                                        maxFontSize: 13,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                  ),
                                  Icon(Icons.add,color:Color.fromARGB(200, 255, 255, 255))
                                ],
                              ),
                            ),
                          ]
                        )

                      )
                    : Container(
                    height: heightx*0.04,
                    width: widthx*0.25,
                    alignment:Alignment.center,
                    key: ValueKey(2),
                    padding: EdgeInsets.only(left:5,right:5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:Color.fromARGB(255, 30, 30, 30),
                      border: Border.all(width: 2,color:Color.fromARGB(100, 255, 255, 255))
                    ),child:Row(
                    children:[
                      // Icon(Icons.cryp,color:Color.fromARGB(200, 255, 255, 255),size:25),
                      Container(
                        // height: heightx * 0.02,
                        width: widthx * 0.05,
                        child: AutoSizeText(
                          textAlign: TextAlign.start,
                          "Bal:",
                          style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900,color:Color.fromARGB(255, 255,255,255)),
                          minFontSize: 5,
                          maxFontSize: 20,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                          child:AutoSizeText(
                            textAlign: TextAlign.center,
                            "0.000 ETH",
                            style: TextStyle(fontSize: 13,fontWeight: FontWeight.w900,color:Color.fromARGB(250, 255,255,255)),
                            minFontSize: 5,
                            maxFontSize: 13,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                      ),
                    ]
                )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
