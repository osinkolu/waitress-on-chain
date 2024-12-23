import "package:flutter/material.dart";
import 'vendors.dart';
import 'activity.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shef/connectionParams.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double mascot_scale = 1.0;
  bool showSplash = true;
  bool _activateUserInput = true;
  bool _openedNewChat = false;
  bool _showShefActivity = false;
  List<Map> _cart = [];

  final PageController _menuListController = PageController(viewportFraction: 1.0);
  final TextEditingController _userInputController = TextEditingController();
  late ScrollController _scrollController;
  var _currentMenu = {};
  List<Map> _conversations = [
    {
      "type":"gap",
      "author":"user",
      "content":"",
    },
    // {
    //   "type":"menu_list",
    //   "author":"shef",
    //   "content":"this is some data about the menu",
    //   "data":[
    //     {
    //       'restaurant_name': 'chicken republic',
    //       'restaurant_logo': 'https://upload.wikimedia.org/wikipedia/en/thumb/e/e9/Chicken_Republic_Logo.svg/1200px-Chicken_Republic_Logo.svg.png',
    //       'restaurant_id': 'demp-id-xvt',
    //       'restaurant_proximity': 0.6888978412337678,
    //       'menu_name': 'Jollof Rice & Chicken',
    //       'menu_price': 4500,
    //       'menu_id': 'menu-id-afang',
    //       'menu_image': 'https://firebasestorage.googleapis.com/v0/b/checkoutmerchant-8cc2f.appspot.com/o/jollof_rice.png?alt=media&token=02b77324-9863-4cdf-a2e5-ed7ad296f958'
    //     },{
    //       'restaurant_name': 'chicken republic',
    //       'restaurant_logo': 'https://upload.wikimedia.org/wikipedia/en/thumb/e/e9/Chicken_Republic_Logo.svg/1200px-Chicken_Republic_Logo.svg.png',
    //       'restaurant_id': 'demp-id-xvt',
    //       'restaurant_proximity': 0.6888978412337678,
    //       'menu_name': 'Pancake and berries',
    //       'menu_price': 1500,
    //       'menu_id': 'menu-id-afang',
    //       'menu_image': 'https://firebasestorage.googleapis.com/v0/b/checkoutmerchant-8cc2f.appspot.com/o/plate2.png?alt=media&token=9ca610e4-aea5-48a1-9dc4-5177a3a4388c'
    //     },{
    //       'restaurant_name': 'chicken republic',
    //       'restaurant_logo': 'https://upload.wikimedia.org/wikipedia/en/thumb/e/e9/Chicken_Republic_Logo.svg/1200px-Chicken_Republic_Logo.svg.png',
    //       'restaurant_id': 'demp-id-xvt',
    //       'restaurant_proximity': 0.6888978412337678,
    //       'menu_name': 'Toasted potatoes',
    //       'menu_price': 2600,
    //       'menu_id': 'menu-id-afang',
    //       'menu_image': 'https://firebasestorage.googleapis.com/v0/b/checkoutmerchant-8cc2f.appspot.com/o/plate3.png?alt=media&token=77eaf3ed-9d1b-4268-a04b-2341100d3b0d'
    //     },
    //   ]
    // },
    {
      "type":"input",
      "author":"user",
      "content":"",
    }
  ];
  Future<void> _updateConversations(Map convo) async{

    for (var conversation in _conversations) {
      if (conversation['type'] != 'text') {
        conversation['collapse'] = true;
      }
    }

    if (convo["author"] == "shef"){
      setState(() {
        _activateUserInput = true;
        _conversations.insert(_conversations.length-1,convo);
      });
    }else{
      setState(() {
        _activateUserInput = false;
        _conversations.insert(_conversations.length-1,convo);
      });
    }
    print("convo updated");
  }
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, // Scroll to the maximum extent
      duration: Duration(milliseconds: 500), // Animation duration
      curve: Curves.easeInOut, // Animation curve
    );
  }

  Future<Map<String, dynamic>> makePostRequest(String url, Map<String, dynamic> payload) async {
    try {
      String jsonPayload = jsonEncode(payload);
      final response = await http.post(
        Uri.parse(ipAddr + url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonPayload,
      ).timeout(const Duration(seconds: 30000));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to make POST request: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during POST request: $e');
    }
  }
  void askShef(String userInput) async{
    String url = "/generate";
    Map<String, dynamic> payload = {
      "prompt" : userInput,
      "message_history": []
    };
    try {
      Map<String, dynamic> response = await makePostRequest(url, payload);

      final regex = RegExp(r'data\s*=\s*(\[.*\])', dotAll: true);
      final match = regex.firstMatch(response["response"]);
      final cleanedResponse = response["response"].replaceAll(regex, '').trim();
      final cleanedResponse1 = cleanedResponse.replaceAll("```json", '').trim();
      final cleanedResponse2 = cleanedResponse1.replaceAll("```", '').trim();
      if (match != null) {
        String jsonString = match.group(1)!;
        List<dynamic> pizzaList = jsonDecode(jsonString);
        await _updateConversations(
            {
              "content": cleanedResponse2,
              "type": "menu_list",
              "author": "shef",
              "collapse":false,
              "data": pizzaList
            }
        );
      } else {
        await _updateConversations(
            {"type": "text",
              "author": "shef",
              "content": response["response"]}
        );
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  String formatNumberWithCommas(String number) {
    final NumberFormat formatter = NumberFormat.decimalPattern();
    return formatter.format(double.parse(number));
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double widthx = MediaQuery.sizeOf(context).width;
    double heightx = MediaQuery.sizeOf(context).height;
    return  Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          child:Stack(
              children:[
                Container(
                    height: heightx,
                    width: widthx,
                    color:Color.fromARGB(255, 255, 255, 255),
                    child:Column(
                      children: [
                        showSplash?Spacer():
                        Expanded(
                            child:
                            InkWell(
                                onTap:(){
                                  _scrollToBottom();
                                },
                                child:ListView.builder(
                                      controller: _scrollController,
                                      itemCount: _conversations.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return
                                          _conversations[index]["type"] == "gap"?
                                          Container(
                                            height:heightx*0.8,
                                          )
                                              :
                                          _conversations[index]["type"] == "text"?
                                          Align(
                                            alignment: _conversations[index]["author"] == "shef" ?Alignment.centerLeft:Alignment.centerRight,
                                            child: Container(
                                                width: widthx*0.7,
                                                margin:EdgeInsets.only(left:_conversations[index]["author"] == "shef" ? 20:0,right:_conversations[index]["author"] == "shef" ? 0:20,bottom:20),
                                                child: AutoSizeText(
                                                  textAlign:_conversations[index]["author"] == "shef" ? TextAlign.start:TextAlign.end,
                                                  _conversations[index]["content"],
                                                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color:_conversations[index]["author"] == "shef" ? Color.fromARGB(255, 0, 0, 0):Color.fromARGB(255, 150, 150, 150)),
                                                  minFontSize: 5,
                                                  maxFontSize: 20,
                                                  maxLines: 100,
                                                  overflow: TextOverflow.ellipsis,
                                                )
                                            ),
                                          ):
                                          _conversations[index]["type"] == "menu_list"?
                                              Align(
                                                alignment: _conversations[index]["author"] == "shef" ?Alignment.centerLeft:Alignment.centerRight,
                                                child:Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children:[
                                                    Container(
                                                        width: widthx*0.7,
                                                        margin:EdgeInsets.only(left:_conversations[index]["author"] == "shef" ? 20:0,right:_conversations[index]["author"] == "shef" ? 0:20),
                                                        child: AutoSizeText(
                                                          textAlign:_conversations[index]["author"] == "shef" ? TextAlign.start:TextAlign.end,
                                                          _conversations[index]["content"],
                                                          style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color:_conversations[index]["author"] == "shef" ? Color.fromARGB(255, 0, 0, 0):Color.fromARGB(255, 150, 150, 150)),
                                                          minFontSize: 5,
                                                          maxFontSize: 20,
                                                          maxLines: 100,
                                                          overflow: TextOverflow.ellipsis,
                                                        )
                                                    ),
                                                    _conversations[index]["collapse"]?
                                                        Container(
                                                          width:widthx,
                                                          height:heightx *0.1,
                                                          alignment: Alignment.center,
                                                          margin:EdgeInsets.only(bottom:20),
                                                          child:Container(
                                                            width:widthx*0.45,
                                                            height:heightx *0.06,
                                                            padding: EdgeInsets.all(5),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(heightx *0.03),
                                                              color: Color.fromARGB(255, 10,10,10),
                                                              border: Border.all(width:2,color:Color.fromARGB(255, 200,200,200))
                                                            ),
                                                            child:Row(
                                                              children:[
                                                                CircleAvatar(
                                                                  radius:20,
                                                                  backgroundColor:Color.fromARGB(255, 50,50,50),
                                                                  backgroundImage: AssetImage("assets/img/sheficon.png"),
                                                                ),
                                                                SizedBox(width:5),
                                                                Column(
                                                                  children:[
                                                                    Container(
                                                                      height: heightx*0.022,
                                                                      width: widthx*0.25,
                                                                      child:AutoSizeText(
                                                                        textAlign: TextAlign.start,
                                                                        "Activity",
                                                                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900,color:Color.fromARGB(255, 200,200,200)),
                                                                        minFontSize: 5,
                                                                        maxFontSize: 20,
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      height: heightx*0.017,
                                                                      width: widthx*0.25,
                                                                      child:AutoSizeText(
                                                                        textAlign: TextAlign.start,
                                                                        "this menu is closed...",
                                                                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color:Color.fromARGB(255, 200,200,200)),
                                                                        minFontSize: 5,
                                                                        maxFontSize: 20,
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  ]
                                                                )
                                                              ]
                                                            )
                                                          )
                                                        )
                                                    :_conversations[index]["data"].length==0?Container():Container(
                                                      height:heightx*0.4,
                                                      width: widthx,
                                                      margin:EdgeInsets.only(bottom:20),
                                                      child:Column(
                                                        children:[
                                                          Container(
                                                            height:(heightx*0.4)-10,
                                                            width: widthx,
                                                            child:Stack(
                                                              children:[
                                                                Container(
                                                                  height:(heightx*0.4)-10,
                                                                  width: widthx,
                                                                  child:Column(
                                                                    children:[
                                                                      Align(
                                                                        alignment:Alignment.centerRight,
                                                                        child:Container(
                                                                            height:heightx*0.2,
                                                                            width: widthx*0.6,
                                                                          margin:EdgeInsets.only(right:15),
                                                                          child:
                                                                          AutoSizeText(
                                                                            textAlign: TextAlign.start,
                                                                            "${_currentMenu["name"]??_conversations[index]["data"][0]["name"]}",
                                                                            style: TextStyle(fontSize: 50,fontWeight: FontWeight.w900,color:Color.fromARGB(255, 100,100,100),fontFamily:"poppins_bold2"),
                                                                            minFontSize: 5,
                                                                            maxFontSize: 50,
                                                                            maxLines: 3,
                                                                            overflow: TextOverflow.ellipsis,
                                                                          )
                                                                        ),
                                                                      ),
                                                                      Align(
                                                                        alignment:Alignment.centerRight,
                                                                        child:Container(
                                                                          height:heightx*0.07,
                                                                          width: widthx*0.4,
                                                                          margin:EdgeInsets.only(right:15),
                                                                          child:Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                                            children:[
                                                                              Row(
                                                                                children:[
                                                                                  Expanded(
                                                                                      child:AutoSizeText(
                                                                                        textAlign: TextAlign.end,
                                                                                        "served by:",
                                                                                        style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color:Color.fromARGB(255, 150,150,150)),
                                                                                        minFontSize: 5,
                                                                                        maxFontSize: 12,
                                                                                        maxLines: 1,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                      )
                                                                                  ),
                                                                                  SizedBox(width: 5),
                                                                                  CircleAvatar(
                                                                                    backgroundColor:Colors.red,
                                                                                    radius:heightx*0.015 ,
                                                                                    backgroundImage: NetworkImage("https://e7.pngegg.com/pngimages/264/277/png-clipart-domino-s-pizza-enterprises-logo-resturant-angle-rectangle.png"),
                                                                                  )
                                                                                ]
                                                                              ),
                                                                              SizedBox(height:5),
                                                                              Expanded(
                                                                                child:AutoSizeText(
                                                                                  textAlign: TextAlign.end,
                                                                                  "Domino's",
                                                                                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color:Color.fromARGB(255, 100,100,100)),
                                                                                  minFontSize: 5,
                                                                                  maxFontSize: 15,
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                )
                                                                              )
                                                                            ]
                                                                          )
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:Container(
                                                                          margin:EdgeInsets.only(left:20,right:20),
                                                                          child:Row(
                                                                            children:[
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children:[
                                                                                  Spacer(),
                                                                                  Container(
                                                                                    height:heightx*0.02,
                                                                                    width:widthx*0.3,
                                                                                    child:AutoSizeText(
                                                                                      textAlign: TextAlign.start,
                                                                                      "PRICE:",
                                                                                      style: TextStyle(fontSize: 15,fontWeight: FontWeight.w900,color:Color.fromARGB(255, 80,80,80)),
                                                                                      minFontSize: 5,
                                                                                      maxFontSize: 15,
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                    )
                                                                                  ),
                                                                                  Row(
                                                                                    children:[
                                                                                      Container(
                                                                                          height:heightx*0.05,
                                                                                          width:widthx*0.3,
                                                                                          child:AutoSizeText(
                                                                                            textAlign: TextAlign.end,
                                                                                            "${formatNumberWithCommas((_currentMenu["price"])??_conversations[index]["data"][0]["price"])}",
                                                                                            style: TextStyle(fontSize: 50,fontWeight: FontWeight.w900,color:Color.fromARGB(255, 50,50,50),fontFamily:"poppins_bold2"),
                                                                                            minFontSize: 5,
                                                                                            maxFontSize: 50,
                                                                                            maxLines: 1,
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                          )
                                                                                      ),
                                                                                      Container(
                                                                                          height:heightx*0.05,
                                                                                          width:widthx*0.1,
                                                                                          child:AutoSizeText(
                                                                                            textAlign: TextAlign.start,
                                                                                            "ETH",
                                                                                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900,color:Color.fromARGB(255, 150,150,150),fontFamily:"poppins_bold2"),
                                                                                            minFontSize: 5,
                                                                                            maxFontSize: 20,
                                                                                            maxLines: 1,
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                          )
                                                                                      )
                                                                                    ]
                                                                                  ),
                                                                                  
                                                                                  Spacer()
                                                                                ]
                                                                              ),Spacer(),
                                                                              Container(
                                                                                height: heightx * 0.05,
                                                                                width: widthx*0.2,
                                                                                padding:EdgeInsets.all(10),
                                                                                decoration: BoxDecoration(
                                                                                    color:Color.fromARGB(255, 248, 32, 79),
                                                                                    borderRadius: BorderRadius.circular(15),
                                                                                  border:Border.all(width:3,color:Color.fromARGB(150, 255,255,255))
                                                                                ),
                                                                                child:Row(
                                                                                  children:[
                                                                                    Expanded(
                                                                                      child:AutoSizeText(
                                                                                        textAlign: TextAlign.start,
                                                                                        "Add",
                                                                                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.w900,color:Color.fromARGB(255, 255,255,255)),
                                                                                        minFontSize: 5,
                                                                                        maxFontSize: 15,
                                                                                        maxLines: 1,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                      ),
                                                                                    ),
                                                                                    Icon(Icons.shopping_bag_rounded,color:Color.fromARGB(255, 255,255,255))
                                                                                  ]
                                                                                )
                                                                              )
                                                                            ]
                                                                          )
                                                                        )
                                                                      )
                                                                    ]
                                                                  )
                                                                ),
                                                                Container(
                                                                  height:(heightx*0.4)-10,
                                                                  width: widthx,
                                                                  child:PageView.builder(
                                                                    itemCount: _conversations[index]["data"].length,
                                                                    scrollDirection: Axis.horizontal,
                                                                      controller: _menuListController,
                                                                    physics: BouncingScrollPhysics(),
                                                                    onPageChanged: (val){
                                                                      setState(() {
                                                                        _currentMenu = _conversations[index]["data"][val];
                                                                      });
                                                                    },
                                                                    itemBuilder: (context,menuIndex){
                                                                      return SizedBox(
                                                                          height:(heightx*0.4)-10,
                                                                          width: widthx,
                                                                        child:Align(
                                                                          alignment: Alignment.topLeft,
                                                                          child:Container(
                                                                              height:heightx*0.25,
                                                                              width: widthx*0.5,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(5),
                                                                                image: DecorationImage(image: NetworkImage("${_conversations[index]["data"][menuIndex]["image"]}"),fit:BoxFit.contain)
                                                                              ),
                                                                          )
                                                                        )
                                                                      );
                                                                    }
                                                                  )
                                                                )
                                                              ]
                                                            )
                                                          ),
                                                          Container(
                                                            height:10,
                                                            width: widthx,
                                                            alignment: Alignment.center,
                                                            child: SmoothPageIndicator(
                                                                controller: _menuListController,
                                                                count:  _conversations[index]["data"].length,
                                                                effect:  ExpandingDotsEffect(
                                                                    dotHeight :7,
                                                                    dotWidth :7,
                                                                    activeDotColor: Color.fromARGB(255, 248, 32, 79),
                                                                    dotColor: Color.fromARGB(100, 248, 32, 79)
                                                                ),
                                                                onDotClicked: (index){
                                                                }
                                                            )
                                                          )
                                                        ]
                                                      )
                                                    )
                                                  ]
                                                )
                                              )
                                          :Align(
                                              alignment: Alignment.centerRight,
                                              child:Container(
                                                width:widthx*0.7,
                                                // height: heightx*0.1,
                                                // color: Colors.green,
                                                margin:EdgeInsets.only(right: 20),
                                                child: TextField(
                                                  textAlign: TextAlign.end,
                                                  onChanged: (val){
                                                    if (_showShefActivity){
                                                      setState(() {
                                                        _showShefActivity = false;
                                                      });
                                                    }
                                                  },
                                                  autofocus:true,
                                                  enabled: _activateUserInput,
                                                  controller: _userInputController,
                                                  maxLines: 1,
                                                  decoration: InputDecoration(
                                                    hintText: "...",
                                                    hintStyle: TextStyle(fontSize: 40,fontWeight: FontWeight.w500,color:Color.fromARGB(255, 150, 150, 150)),
                                                    border: InputBorder.none,
                                                  ),
                                                  cursorColor: Color.fromARGB(255, 248, 32, 79),
                                                  cursorWidth: 3,
                                                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color:Color.fromARGB(255, 150, 150, 150)),
                                                ),
                                              )
                                          );
                                      }
                                  ),
                            )
                        ),
                        Visibility(
                          visible: showSplash,
                            child:Container(
                              height: heightx*0.07,
                              width: widthx,
                              alignment:Alignment.center,
                              child:AutoSizeText(
                                textAlign: TextAlign.center,
                                "Hello Friend!",
                                style: TextStyle(fontSize: 40,fontWeight: FontWeight.w900,color:Color.fromARGB(255, 10,10,10)),
                                minFontSize: 5,
                                maxFontSize: 40,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                        )),
                        Visibility(
                            visible: showSplash,
                            child:Container(
                              height: heightx*0.07,
                              width: widthx,
                              padding: EdgeInsets.only(left:20,right:20),
                              alignment:Alignment.center,
                              child:AutoSizeText(
                                textAlign: TextAlign.center,
                                "I'm an AI Agent. I take pizza orders \nand help make the payments for it on \nthe blockchain.",
                                style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color:Color.fromARGB(255, 100,100,100)),
                                minFontSize: 5,
                                maxFontSize: 20,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              )
                        )
                        ),
                        SizedBox(
                          height:showSplash?heightx*0.08:5
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            showSplash?Container():SizedBox(
                            width: (heightx*0.3)*mascot_scale,
                          ),
                          InkWell(
                              onTap: (){
                                if (!_openedNewChat ){
                                  setState(() {
                                    mascot_scale = !showSplash?1:0.2;
                                    showSplash = !showSplash;
                                    _openedNewChat = true;
                                  });
                                  _updateConversations({
                                    "type":"text",
                                    "author":"shef",
                                    "content":"what type of pizza do you want? fr..",
                                  });
                                }else{
                                  setState(() {
                                    _showShefActivity = !_showShefActivity;
                                    _activateUserInput = false;
                                    _activateUserInput = true;
                                  });
                                }
                              },
                              child:AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.bounceInOut,
                                height: (heightx*0.3)*mascot_scale,
                                width:widthx*0.6*mascot_scale,
                                alignment: Alignment.bottomCenter,
                                child: Image.asset("assets/img/shef_mascot.gif",fit: BoxFit.contain,),
                              )
                          ),
                          showSplash?Container():InkWell(
                            onTap: () async{
                              if (_userInputController.text.isNotEmpty){
                                await _updateConversations({
                                  "type":"text",
                                  "author":"user",
                                  "content":_userInputController.text,
                                });
                                askShef(_userInputController.text);
                                _userInputController.clear();
                              }
                            },
                            child:Container(
                              height:(heightx*0.3)*mascot_scale,
                              width:(heightx*0.3)*mascot_scale,
                              child: Icon(Icons.arrow_upward_rounded,color:Color.fromARGB(255, 150, 150, 150),size: (heightx*0.2)*mascot_scale)
                            )
                          )

                        ],),
                        AnimatedContainer(
                          duration: Duration(milliseconds:500),
                          curve: Curves.fastOutSlowIn,
                          width: widthx,
                          height:!_showShefActivity?3:heightx*0.35,
                          color: Color.fromARGB(255, 248, 32, 79),
                          child:Activity()
                        )
                      ],
                    )
                  ),
                Container(
                  height: heightx,
                  width: widthx,
                  child:Vendors()
                ),
              ]
          )
      ),
    );
  }
}
