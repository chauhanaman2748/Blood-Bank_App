import 'dart:collection';
import 'dart:convert';
import 'package:bloodbank/pages/Donor/GetData.dart';
import 'package:http/http.dart' as http;

import 'package:bloodbank/pages/Requestor/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bloodbank/pages/Donor/bloc/state_bloc.dart';
import 'package:bloodbank/pages/Donor/bloc/state_provider.dart';
import 'package:bloodbank/pages/Donor/model/donor.dart';
import 'package:bloodbank/pages/login/Login.dart';
import 'package:bloodbank/pages/Requestor/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'BloodRequests.dart';
import 'Home.dart';
import 'Request.dart';

class BloodCamps extends StatefulWidget{

  final String user, varPage;
  final LinkedHashMap userDetails;
  BloodCamps({this.user, this.varPage, this.userDetails});

  @override
  _BloodCamps createState() => new _BloodCamps();
}

var currentDonor = donorList.cars[0];

class _BloodCamps extends State<BloodCamps>{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: EdgeInsets.only(left: 25),
          //child:
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 25),
            child: IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>RequestorHome()));
              },
            ),
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: LayoutStarts(widget.user, widget.varPage, widget.userDetails),
    );
  }

}

class LayoutStarts extends StatelessWidget {

  LayoutStarts(this.user, this.varPage, this.userDetails);
  final String user, varPage;
  final LinkedHashMap userDetails;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        RequestFormAnimation(user, varPage, userDetails),
        CustomBottomSheet(user, userDetails),
      ],
    );
  }
}

class RequestFormAnimation extends StatefulWidget {

  RequestFormAnimation(this.user, this.varPage, this.userDetails);
  final String user, varPage;
  final LinkedHashMap userDetails;

  @override
  _RequestFormAnimationState createState() => _RequestFormAnimationState();
}

class _RequestFormAnimationState extends State<RequestFormAnimation>
    with TickerProviderStateMixin {
  AnimationController fadeController;
  AnimationController scaleController;

  Animation fadeAnimation;
  Animation scaleAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fadeController =
        AnimationController(duration: Duration(milliseconds: 180), vsync: this);

    scaleController =
        AnimationController(duration: Duration(milliseconds: 350), vsync: this);

    fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(fadeController);
    scaleAnimation = Tween(begin: 0.8, end: 1.0).animate(CurvedAnimation(
      parent: scaleController,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    ));
  }

  forward() {
    scaleController.forward();
    fadeController.forward();
  }

  reverse() {
    scaleController.reverse();
    fadeController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        initialData: StateProvider().isAnimating,
        stream: stateBloc.animationStatus,
        builder: (context, snapshot) {
          snapshot.data ? forward() : reverse();

          return ScaleTransition(
            scale: scaleAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: InputForm(widget.user, widget.varPage, widget.userDetails),
            ),
          );
        });
  }
}

class InputForm extends StatefulWidget {

  InputForm(this.user, this.varPage, this.userDetails);
  final String user, varPage;
  final LinkedHashMap userDetails;

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {

  var list = [1, 2, 3, 4, 5, 6, 7];

  var isCampForm;

  var key = GlobalKey<FormState>();
  TextEditingController controllerName = new TextEditingController();
  TextEditingController controllerVenue = new TextEditingController();
  TextEditingController controllerDate = new TextEditingController();
  TextEditingController controllerDuration = new TextEditingController();
  TextEditingController controllerMessage = new TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      isCampForm = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              widget.varPage != 'Donor' ? Container() :
              Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isCampForm = !isCampForm;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.redAccent, width: 5),
                        color: Colors.yellowAccent,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                                child: Icon(Icons.local_hospital, size: ScreenUtil.getInstance().setSp(50),)
                            ),
                            TextSpan(
                              text: isCampForm ? ' Show Blood Camps/Vans' : ' Organise A Blood Camp',
                              style: TextStyle(
                                  fontFamily: "Poppins-Bold",
                                  color: Colors.black,
                                  fontSize: ScreenUtil.getInstance().setSp(30)
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              isCampForm
                  ?
              Form(
                key: key,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: new Container(
                            child: Text(
                              'Blood Camp Form',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: "Poppins-Bold",
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                        new Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(bottom: 1),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(0.0, 15.0),
                                    blurRadius: 15.0),
                                BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(0.0, -10.0),
                                    blurRadius: 10.0),
                              ]),
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: ScreenUtil.getInstance().setHeight(30),
                                ),
                                Text("Organisation Name",
                                    style: TextStyle(
                                        fontFamily: "Poppins-Medium",
                                        fontSize: ScreenUtil.getInstance().setSp(26))),
                                TextFormField(
                                  controller: controllerName,
                                  // ignore: missing_return
                                  validator: (val) {
                                    if(val.isEmpty) {
                                      return 'Please Enter The Organisation Name';
                                    }
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Enter The Organisation Name",
                                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                                ),
                                SizedBox(
                                  height: ScreenUtil.getInstance().setHeight(30),
                                ),
                                Text("Venue",
                                    style: TextStyle(
                                        fontFamily: "Poppins-Medium",
                                        fontSize: ScreenUtil.getInstance().setSp(26))),
                                TextFormField(
                                  controller: controllerVenue,
                                  // ignore: missing_return
                                  validator: (val) {
                                    if(val.isEmpty) {
                                      return 'Please Provide Venue Details';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Venue Details",
                                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),),
                                ),
                                SizedBox(
                                  height: ScreenUtil.getInstance().setHeight(30),
                                ),
                                Text("Date",
                                    style: TextStyle(
                                        fontFamily: "Poppins-Medium",
                                        fontSize: ScreenUtil.getInstance().setSp(26))),
                                TextFormField(
                                  controller: controllerDate,
                                  // ignore: missing_return
                                  validator: (val) {
                                    if(val.isEmpty) {
                                      return 'Please Enter The Day Of Organisation';
                                    }
                                  },
                                  keyboardType: TextInputType.datetime,
                                  decoration: InputDecoration(
                                    hintText: "Date Of Organisation",
                                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),),
                                ),
                                SizedBox(
                                  height: ScreenUtil.getInstance().setHeight(30),
                                ),
                                Text("Duration",
                                    style: TextStyle(
                                        fontFamily: "Poppins-Medium",
                                        fontSize: ScreenUtil.getInstance().setSp(26))),
                                TextFormField(
                                  controller: controllerDuration,
                                  // ignore: missing_return
                                  validator: (val) {
                                    if(val.isEmpty) {
                                      return 'Please Provide The Time Period';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Time Period Eg. 1 Day",
                                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),),
                                ),
                                SizedBox(
                                  height: ScreenUtil.getInstance().setHeight(35),
                                ),
                                Text("Other Message",
                                    style: TextStyle(
                                        fontFamily: "Poppins-Medium",
                                        fontSize: ScreenUtil.getInstance().setSp(26))),
                                TextFormField(
                                  controller: controllerMessage,
                                  // ignore: missing_return
                                  decoration: InputDecoration(
                                    hintText: "Say Something About The Camp",
                                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),),
                                ),
                                SizedBox(
                                  height: ScreenUtil.getInstance().setHeight(35),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                width: ScreenUtil.getInstance().setWidth(330),
                                height: ScreenUtil.getInstance().setHeight(100),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Color(0xFF17ead9),
                                      Color(0xFF6078ea)
                                    ]),
                                    borderRadius: BorderRadius.circular(6.0),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0xFF6078ea).withOpacity(.3),
                                          offset: Offset(0.0, 8.0),
                                          blurRadius: 8.0)
                                    ]),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: (){
                                          if(key.currentState.validate()) {
                                            submit();
                                          }
                                        },
                                        child: Text("SUBMIT",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Poppins-Bold",
                                                fontSize: 18,
                                                letterSpacing: 1.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                  ),
                ),
              )
                  :
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: new Container(
                      child: Text(
                        'Nearest Blood Camps\nand Vans',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            fontFamily: "Poppins-Bold",
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                  new ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 6,
                      itemBuilder: (context, i) {
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(bottom: 1),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(0.0, 15.0),
                                          blurRadius: 15.0),
                                      BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(0.0, -10.0),
                                          blurRadius: 10.0),
                                    ]),
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: ScreenUtil.getInstance().setHeight(30),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                            text: 'CAMP ',
                                            style: TextStyle(
                                                fontFamily: "Poppins-Medium",
                                                color: Colors.black,
                                                fontSize: ScreenUtil.getInstance().setSp(30)),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: list[i].toString(),
                                                style: TextStyle(
                                                    fontFamily: "Poppins-Medium",
                                                    color: Colors.red,
                                                    fontSize: ScreenUtil.getInstance().setSp(35)),
                                              ),
                                            ]
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                            text: 'Address: ',
                                            style: TextStyle(
                                                fontFamily: "Poppins-Medium",
                                                color: Colors.black,
                                                fontSize: ScreenUtil.getInstance().setSp(30)),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: 'some address...',
                                                style: TextStyle(
                                                    fontFamily: "Poppins-Medium",
                                                    color: Colors.red,
                                                    fontSize: ScreenUtil.getInstance().setSp(35)),
                                              ),
                                            ]
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20,)
                          ],
                        );
                      }
                  )
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 190,)
      ],

    );
  }

  void _showSnackBar(String msg) {
    final snackBar = SnackBar(content: Text(msg, style: TextStyle(fontSize: 20),),);
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Future submit() async {
    var url = "https://us-central1-blood-bank-280211.cloudfunctions.net/user";
    var res = await http.post(url, body: {
      'org' : controllerName.text,
      'venue' : controllerVenue.text,
      'date' : controllerDate.text,
      'duration' : controllerDuration.text,
      'message' : controllerMessage.text,
      'username' :  widget.user,
    });
    var data = jsonDecode(res.body);
    if(data['status'] == 'success') {
      var msg = 'Your camp organisation form has been submitted successfully';
      _showSnackBar(msg);
      setState(() {
        isCampForm = !isCampForm;
      });
    }
    else {
      _showSnackBar(data['status']);
    }
  }

}


class CustomBottomSheet extends StatefulWidget {

  CustomBottomSheet(this.user, this.userDetails);
  final String user;
  final LinkedHashMap userDetails;

  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet>
    with SingleTickerProviderStateMixin {
  double sheetTop = 620;
  double minSheetTop = 30;

  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    animation = Tween<double>(begin: sheetTop, end: minSheetTop)
        .animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    ))
      ..addListener(() {
        setState(() {});
      });
  }

  forwardAnimation() {
    controller.forward();
    stateBloc.toggleAnimation();
  }

  reverseAnimation() {
    controller.reverse();
    stateBloc.toggleAnimation();
  }

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: animation.value,
      left: 0,
      child: GestureDetector(
        onTap: () {
          controller.isCompleted ? reverseAnimation() : forwardAnimation();
        },
        onVerticalDragEnd: (DragEndDetails dragEndDetails) {
          //upward drag
          if (dragEndDetails.primaryVelocity < 0.0) {
            forwardAnimation();
            controller.forward();
          } else if (dragEndDetails.primaryVelocity > 0.0) {
            //downward drag
            reverseAnimation();
          } else {
            return;
          }
        },
        child: SheetContainer(widget.user, widget.userDetails),
      ),
    );
  }
}

class SheetContainer extends StatelessWidget {

  SheetContainer(this.user, this.userDetails);
  final String user;
  final LinkedHashMap userDetails;

  @override
  Widget build(BuildContext context) {
    double sheetItemHeight = 110;
    return Container(
      padding: EdgeInsets.only(top: 25),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          color: Colors.redAccent
      ),
      child: Column(
        children: <Widget>[
          drawerHandle(),
          Expanded(
            flex: 1,
            child: ListView(
              children: <Widget>[
                services(sheetItemHeight, context),
                donorDetails(sheetItemHeight, context, userDetails),
                userDetails['Donor'] != 'true' ? Container() :
                advantages(sheetItemHeight),
                SizedBox(height: 20),
                userDetails['Donor'] == 'true' ? Container() :
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton.icon(
                        textColor: Colors.white,
                        color: Colors.black,
                        elevation: 5,
                        splashColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(color: Colors.black)
                        ),
                        label: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text("Become A Donor", style: TextStyle(fontSize: 20),),
                        ),
                        icon: Icon(Icons.add_location),
                        onPressed: () {
                          update(context);
                        },
                      ),
                    ]
                ),
                SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton.icon(
                        textColor: Colors.white,
                        color: Colors.black,
                        elevation: 5,
                        splashColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(color: Colors.black)
                        ),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text("Delete Account"),
                        ),
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          delete(context);
                        },
                      ),
                      SizedBox(width: 20,),
                      RaisedButton.icon(
                        textColor: Colors.white,
                        color: Colors.black,
                        elevation: 5,
                        splashColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(color: Colors.black)
                        ),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text("Logout"),
                        ),
                        icon: Icon(Icons.https),
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
                        },
                      ),
                    ]
                ),
                SizedBox(height: 220),
              ],
            ),
          )
        ],
      ),
    );
  }

  drawerHandle() {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      height: 3,
      width: 65,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Color(0xffd9dbdb)),
    );
  }

  donorDetails(double sheetItemHeight, BuildContext context, LinkedHashMap userDetails) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Donor Details",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            height: sheetItemHeight,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 20),
                  width: sheetItemHeight,
                  height: sheetItemHeight,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.person, size: 30, color: Colors.black,),
                      Text(
                        'Name',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        userDetails['Name'].toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20),
                  width: sheetItemHeight,
                  height: sheetItemHeight,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.av_timer, size: 30, color: Colors.black,),
                      Text(
                        'Age',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        userDetails['Age'].toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20),
                  width: sheetItemHeight,
                  height: sheetItemHeight,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.invert_colors, size: 30, color: Colors.black,),
                      Text(
                        'Blood Group',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        userDetails['Blood_Group'].toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20),
                  width: sheetItemHeight,
                  height: sheetItemHeight,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.phone_in_talk, size: 30, color: Colors.black,),
                      Text(
                        'Mob No.',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        userDetails['Mobile'].toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => print('clicked4'),
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    width: sheetItemHeight,
                    height: sheetItemHeight,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.assignment_late, size: 30, color: Colors.black,),
                        Text(
                          'Other Info',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  advantages(double sheetItemHeight) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Advantages Of Blood Donation",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            height: sheetItemHeight,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: currentDonor.advantages.length,
              itemBuilder: (context, index) {
                return ListItem(
                  sheetItemHeight: sheetItemHeight,
                  mapVal: currentDonor.advantages[index],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  services(double sheetItemHeight, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Our Services",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 15),
              height: sheetItemHeight,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      userDetails['Donor'] == 'true'
                          ? Navigator.push(context, MaterialPageRoute(builder: (context)=>GetData(user: user, varPage: 'Donor', userDetails: userDetails,)))
                          : Navigator.push(context, MaterialPageRoute(builder: (context)=>GetData(user: user, varPage: 'Requests', userDetails: userDetails,)));
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      width: sheetItemHeight,
                      height: sheetItemHeight,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.lightGreenAccent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.assessment, size: 30, color: Colors.black,),
                          Text(
                            userDetails['Donor'] == 'true' ? 'Donations\n& Requests' : 'Your\nRequests',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      LinkedHashMap mp = {'reqId': ''} as LinkedHashMap;
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Request(user: user, userDetails: userDetails, singleDonor: mp,)));
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      width: sheetItemHeight,
                      height: sheetItemHeight,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.lightGreenAccent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.airline_seat_individual_suite, size: 30, color: Colors.black,),
                          Text(
                            'Need For\nBlood',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      var page;
                      userDetails['Donor'] == 'true' ? page = 'Requests' : page = 'NotDonor';
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> BloodRequests(user: user, varPage: page, userDetails: userDetails,)));
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      width: sheetItemHeight,
                      height: sheetItemHeight,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.lightGreenAccent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.add_circle, size: 30, color: Colors.black,),
                          Text(
                            'Donate\nblood',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      var page;
                      userDetails['Donor'] == 'true' ? page = 'Donor' : page = 'NotDonor';
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> BloodCamps(user: user, varPage: page, userDetails: userDetails,)));
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      width: sheetItemHeight,
                      height: sheetItemHeight,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.lightGreenAccent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.pin_drop, size: 30, color: Colors.black,),
                          Text(
                            'Blood Camps\nand Vans',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => print('clicked4'),
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      width: sheetItemHeight,
                      height: sheetItemHeight,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.lightGreenAccent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.local_hospital, size: 30, color: Colors.black,),
                          Text(
                            'Blood Banks\n& Hospitals',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
          )
        ],
      ),
    );
  }

  Future delete(BuildContext context) async {
    var url = "https://us-central1-blood-bank-280211.cloudfunctions.net/signUp";
    var res = await http.get(url+'?val='+user+'&action=delete');
    var data = jsonDecode(res.body);
    if(data['status'] == 'deleted') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    }
    else {
      final snackBar = SnackBar(content: Text(data['status']),);
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future update(BuildContext context) async {
    print('clicked');
    var url = "https://us-central1-blood-bank-280211.cloudfunctions.net/signUp";
    var res = await http.get(url+'?val='+user+'&action=update');
    var data = jsonDecode(res.body);
    if(data['status'] == 'updated') {
      var response = await http.get(url+'?val='+user+'&action=get');
      var data = jsonDecode(response.body);
      if(data['status'] == 'success') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DonorHome(user: user, userDetails: data['result'],)));
      }
      else {
        final snackBar = SnackBar(content: Text(data['status']),);
        Scaffold.of(context).showSnackBar(snackBar);
      }
    }
    else {
      final snackBar = SnackBar(content: Text(data['status']),);
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

}

class ListItem extends StatelessWidget {
  final double sheetItemHeight;
  final Map mapVal;

  ListItem({this.sheetItemHeight, this.mapVal});

  @override
  Widget build(BuildContext context) {
    var innerMap;
    bool isMap;

    if (mapVal.values.elementAt(0) is Map) {
      innerMap = mapVal.values.elementAt(0);
      isMap = true;
    } else {
      innerMap = mapVal;
      isMap = false;
    }

    return Container(
      margin: EdgeInsets.only(right: 20),
      width: sheetItemHeight,
      height: sheetItemHeight,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          mapVal.keys.elementAt(0),
          isMap
              ? Text(innerMap.keys.elementAt(0),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black, letterSpacing: 1.2, fontSize: 11))
              : Container(),
          Text(
            innerMap.values.elementAt(0),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }
}