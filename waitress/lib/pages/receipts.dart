import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
class Receipts extends StatefulWidget {
  const Receipts({super.key});

  @override
  State<Receipts> createState() => _ReceiptsState();
}

class _ReceiptsState extends State<Receipts> {
  List _receipts =[
        {
        "image":"burger.png",
        "title":"Veg. Burger",
        "id": "qrqrr-1-09-24",
        "price":"3,400",
        "currency":"NGN",
          "vendor":"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR5byPlsGyh30_VLehwLo-sUSngyiq1MjLZxQ&s",
      },
    {
        "image":"shawarma.png",
        "title":"shawarma",
        "id": "qrqrr-1-09-24",
        "price":"3,000",
        "currency":"NGN",
      "vendor":"https://play-lh.googleusercontent.com/1Tv6SA365yIkYQ99zK1dFYMiYP9tWm6Lccm9yx7xG_jdjsB9qTIzEeVexYiNWGdtcv6f",
      },{
        "image":"kebab.png",
        "title":"beef kebab",
        "id": "qrqrr-1-09-24",
        "price":"5,670",
        "currency":"NGN",
      "vendor":"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR5byPlsGyh30_VLehwLo-sUSngyiq1MjLZxQ&s",
      }

  ];
  @override
  Widget build(BuildContext context) {
    double widthx = MediaQuery.sizeOf(context).width;
    double heightx = MediaQuery.sizeOf(context).height;
    return Container(
      height: heightx,
      width: widthx,
      margin: EdgeInsets.only(left:10,right: 10),
      child: ListView.builder(
          itemCount: _receipts.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context,index){
            return
              Column(
                children: [
                  Container(
                      height: heightx * 0.1,
                      width: widthx,
                      decoration: BoxDecoration(
                          color:Color.fromARGB(255, 243,239,236),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                      ),
                    child: Stack(
                      children: [
                        Align(
                            alignment:Alignment.centerRight,
                            child:Container(
                              height: heightx * 0.1,
                              width: widthx *0.7,
                              padding: EdgeInsets.only(left:10,right: 10),
                              alignment: Alignment.center,
                              // color: Colors.blue,
                              child: AutoSizeText(
                                textAlign: TextAlign.start,
                                "${_receipts[index]["title"]}",
                                style: TextStyle(fontSize: 50,fontWeight: FontWeight.w900,color:Color.fromARGB(255, 200,200,200)),
                                minFontSize: 5,
                                maxFontSize: 50,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          )
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: heightx * 0.1,
                            width: widthx *0.5,
                            child:Image.asset("assets/img/${_receipts[index]["image"]}",fit:BoxFit.fitWidth)
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child:Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image:DecorationImage(image: NetworkImage(
                                "${_receipts[index]["vendor"]}"
                              ),fit:BoxFit.cover)
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                  Container(
                      height: heightx * 0.05,
                      width: widthx,
                      decoration: BoxDecoration(
                        color:Color.fromARGB(255, 30, 30, 30),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15))
                      ),
                    child: Row(
                      children:[
                        SizedBox(width: 10,),
                        AutoSizeText(
                          textAlign: TextAlign.start,
                          "${_receipts[index]["id"]}",
                          style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color:Color.fromARGB(255, 200,200,200)),
                          minFontSize: 5,
                          maxFontSize: 15,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        AutoSizeText(
                          textAlign: TextAlign.start,
                          "${_receipts[index]["currency"]}${_receipts[index]["price"]}",
                          style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color:Color.fromARGB(255, 200,200,200)),
                          minFontSize: 5,
                          maxFontSize: 15,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(width: 10,),
                      ]
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )

                ],
              );
          }),
    );
  }
}
