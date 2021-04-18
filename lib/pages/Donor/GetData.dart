import 'dart:collection';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import 'package:bloodbank/pages/Requestor/Home.dart';
import 'package:bloodbank/pages/login/Login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'BloodCamps.dart';
import 'BloodRequests.dart';
import 'Home.dart';
import 'Request.dart';
import 'bloc/state_bloc.dart';
import 'bloc/state_provider.dart';
import 'model/donor.dart';

class GetData extends StatefulWidget{

  final String user;
  final String varPage;
  final LinkedHashMap userDetails;
  GetData({this.user, this.varPage, this.userDetails});

  @override
  _GetData createState() => new _GetData();
}

var currentDonor = donorList.cars[0];

class _GetData extends State<GetData>{


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
        DonationDetailsAnimation(user, varPage, userDetails),
        CustomBottomSheet(user, userDetails),
      ],
    );
  }
}

class DonationDetailsAnimation extends StatefulWidget {

  DonationDetailsAnimation(this.user, this.varPage, this.userDetails);
  final String user, varPage;
  final LinkedHashMap userDetails;

  @override
  _DonationDetailsAnimation createState() => _DonationDetailsAnimation();
}

class _DonationDetailsAnimation extends State<DonationDetailsAnimation>
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

  var getVal;

  @override
  void initState() {
    super.initState();
    setState(() {
      getVal = "Donations";
    });
  }

  @override
  Widget build(BuildContext context) {

    return ListView(
      children: <Widget>[
        Column(
              children: <Widget>[
                widget.varPage == 'Donor'
                    ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          getVal = "Donations";
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.redAccent, width: 5),
                            color: Colors.greenAccent,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                          child: Text(
                            'Your\nBlood Donations',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "Poppins-Bold",
                                color: Colors.black,
                                fontSize: ScreenUtil.getInstance().setSp(30)
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          getVal = "Requests";
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.redAccent, width: 5),
                            color: Colors.lightBlueAccent,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                          child: Text(
                            'Your\nBlood Requests',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "Poppins-Bold",
                                color: Colors.black,
                                fontSize: ScreenUtil.getInstance().setSp(30)
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                    :
                Text(
                  'Your Blood Requests',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: "Poppins-Bold",
                      color: Colors.white
                  ),
                ),
                SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                widget.varPage == 'Donor' && getVal == 'Donations' ? Container() :
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white
                    ),
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 2),
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.green[900]
                            ),
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.done,
                              size: 20,
                              color: Colors.white,
                            )
                        ),
                        Text(
                          'Accepted Requests',
                          style: TextStyle(
                              fontFamily: "Poppins-Bold",
                              fontSize: 15
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 2),
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.red
                            ),
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.clear,
                              size: 20,
                              color: Colors.white,
                            )
                        ),
                        Text(
                          'Pending Requests',
                          style: TextStyle(
                              fontFamily: "Poppins-Bold",
                              fontSize: 15
                          ),
                        )
                      ],
                    )
                ),
                SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                widget.varPage == 'Donor' && getVal == 'Donations'
                    ?
                FutureBuilder(
                    future: getData(),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? snapshot.data.length == 0
                            ? Column(
                              children: <Widget>[
                                SizedBox(height: ScreenUtil.getInstance().setHeight(200)),
                                Center(child: Text('This List Is Empty', style: TextStyle(color: Colors.white, fontFamily: "Poppins-Bold", fontSize: 20),),),
                                SizedBox(height: ScreenUtil.getInstance().setHeight(20)),
                                Center(child: Text('Start Your First Donation !', style: TextStyle(color: Colors.yellow, fontFamily: "Poppins-Bold", fontSize: 20),),),
                                SizedBox(height: ScreenUtil.getInstance().setHeight(20)),
                                Center(child: Text('Find Out The Blood Requests ?', style: TextStyle(color: Colors.greenAccent, fontFamily: "Poppins-Bold", fontSize: 20),),),
                                SizedBox(height: ScreenUtil.getInstance().setHeight(20)),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> BloodRequests(user: widget.user, varPage: 'Requests', userDetails: widget.userDetails,)));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.white),
                                      color: Colors.redAccent
                                    ),
                                    child: Text(
                                        'Check Here',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "Poppins-Bold"
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                            : new DonationList(list: snapshot.data)
                          : new Center (child: new CircularProgressIndicator(),);
                    },
                )
                    :
                FutureBuilder(
                  future: getData(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? snapshot.data.length == 0
                        ? Column(
                      children: <Widget>[
                        SizedBox(height: ScreenUtil.getInstance().setHeight(200)),
                        Center(child: Text('Congratulations', style: TextStyle(color: Colors.white, fontFamily: "Poppins-Bold", fontSize: 20),),),
                        SizedBox(height: ScreenUtil.getInstance().setHeight(20)),
                        Center(child: Text("You Don't Have Any Pending Requests", style: TextStyle(color: Colors.yellow, fontFamily: "Poppins-Bold", fontSize: 20),),),
                        SizedBox(height: ScreenUtil.getInstance().setHeight(50)),
                        Center(child: Text('Request For Blood ?', style: TextStyle(color: Colors.greenAccent, fontFamily: "Poppins-Bold", fontSize: 20),),),
                        SizedBox(height: ScreenUtil.getInstance().setHeight(20)),
                        GestureDetector(
                          onTap: () {
                            LinkedHashMap mp = {'reqId': ''} as LinkedHashMap;
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Request(user: widget.user, userDetails: widget.userDetails, singleDonor: mp)));
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white),
                                color: Colors.redAccent
                            ),
                            child: Text(
                              'Click Here',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Poppins-Bold"
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                        : new RequestList(list: snapshot.data)
                        : new Center (child: new CircularProgressIndicator(),);
                  },
                ),
                SizedBox(height: ScreenUtil.getInstance().setHeight(250)),
              ],
        ),
      ],
    );
  }

  void _showSnackBar(String msg) {
    final snackBar = SnackBar(content: Text(msg),);
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Future getData() async {
    var fetchDataOf;
    if(widget.varPage == 'Donor' && getVal == 'Donations') {
      fetchDataOf = 'Donations';
    } else {
      fetchDataOf = 'Requests';
    }
    var url = "https://us-central1-blood-bank-280211.cloudfunctions.net/getData";
    var res = await http.post(url, body: {
      'val' : widget.user,
      'getData' : fetchDataOf.toString()
    });
    var data = jsonDecode(res.body);
    return data;
  }
}

class DonationList extends StatelessWidget {

  final List list;
  DonationList({this.list});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(bottom: 1),
                      decoration: BoxDecoration(
                          color: Colors.orangeAccent,
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
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white
                              ),
                              padding: EdgeInsets.all(5),
                              child: Text(
                                list[i]['Req_BG'],
                                style: TextStyle(
                                  fontSize: 50,
                                  color: Colors.red,
                                  fontFamily: "Poppins-Medium",
                                ),
                              ),
                            ),
                            SizedBox(width: 20,),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text:
                                              'Donated To: ',
                                              style: TextStyle(
                                                  fontFamily: "Poppins-Medium",
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: ScreenUtil.getInstance().setSp(37))
                                          ),
                                          TextSpan(
                                              text:
                                              'abc',
                                              //list[i]['Name'],
                                              style: TextStyle(
                                                  fontFamily: "Poppins-Medium",
                                                  color: Colors.black,
                                                  fontSize: ScreenUtil.getInstance()
                                                      .setSp(30))
                                          ),
                                        ]
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text:
                                              'Units Of Blood: ',
                                              style: TextStyle(
                                                  fontFamily: "Poppins-Medium",
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: ScreenUtil.getInstance().setSp(37))
                                          ),
                                          TextSpan(
                                              text:
                                              list[i]['Blood_Units'],
                                              style: TextStyle(
                                                  fontFamily: "Poppins-Medium",
                                                  color: Colors.black,
                                                  fontSize: ScreenUtil.getInstance()
                                                      .setSp(30))
                                          ),
                                        ]
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text:
                                              'Donated On: ',
                                              style: TextStyle(
                                                  fontFamily: "Poppins-Medium",
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: ScreenUtil.getInstance().setSp(37))
                                          ),
                                          TextSpan(
                                              text: ' ' + list[i]['Date'],
                                              style: TextStyle(
                                                  fontFamily: "Poppins-Medium",
                                                  color: Colors.black,
                                                  fontSize: ScreenUtil.getInstance()
                                                      .setSp(30))
                                          ),
                                        ]
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                ],
          );
        }
    );
  }
}

class RequestList extends StatelessWidget {

  final List list;
  RequestList({this.list});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () {},
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(bottom: 1),
                    decoration: BoxDecoration(
                        color: Colors.orangeAccent,
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
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black, width: 2),
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white
                                ),
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  list[i]['Req_BG'],
                                  style: TextStyle(
                                    fontSize: 50,
                                    color: Colors.red,
                                    fontFamily: "Poppins-Medium",
                                  ),
                                ),
                              ),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        RichText(
                                          text: TextSpan(
                                              children: [
                                                WidgetSpan(
                                                    child: Icon(Icons.invert_colors,
                                                      size: ScreenUtil.getInstance()
                                                          .setSp(50),)
                                                ),
                                                TextSpan(
                                                    text:
                                                    list[i]['Blood_Units'] == '1'
                                                        ? ' ' + list[i]['Blood_Units'] + ' Unit Of Blood'
                                                        : ' ' + list[i]['Blood_Units'] + ' Units Of Blood',
                                                    style: TextStyle(
                                                        fontFamily: "Poppins-Medium",
                                                        color: Colors.black,
                                                        fontSize: ScreenUtil.getInstance()
                                                            .setSp(30))
                                                ),
                                              ]
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                              children: [
                                                WidgetSpan(
                                                    child: Icon(Icons.calendar_today,
                                                      size: ScreenUtil.getInstance()
                                                          .setSp(50),)
                                                ),
                                                TextSpan(
                                                    text: ' ' + list[i]['Date'],
                                                    style: TextStyle(
                                                        fontFamily: "Poppins-Medium",
                                                        color: Colors.black,
                                                        fontSize: ScreenUtil.getInstance()
                                                            .setSp(30))
                                                ),
                                              ]
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                              children: [
                                                WidgetSpan(
                                                    child: Icon(Icons.person,
                                                      size: ScreenUtil.getInstance().setSp(50),)
                                                ),
                                                TextSpan(
                                                    text: list[i]['RequestedTo'] != '' ? ' ' + list[i]['RequestedTo'] : 'To all donors',
                                                    style: TextStyle(
                                                        fontFamily: "Poppins-Medium",
                                                        color: Colors.black,
                                                        fontSize: ScreenUtil.getInstance()
                                                            .setSp(30))
                                                ),
                                              ]
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(20),
                                      color: list[i]['isAccepted'] == 'true' ? Colors.green[900] : Colors.red
                                  ),
                                  padding: EdgeInsets.all(5),
                                  child: Icon(
                                    list[i]['isAccepted'] == 'true' ? Icons.done : Icons.clear,
                                    size: 30,
                                    color: Colors.white,
                                  )
                              ),
                            ],
                          ),
                          list[i]['isAccepted'] != 'true'
                              ? Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                        "* Not Accepted Yet",
                                        style: TextStyle(fontFamily: "Poppins-Bold", fontSize: ScreenUtil.getInstance().setSp(30)),
                                      ),
                                  ), 
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        deleteReq(context, list[i]['reqId']);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all(color: Colors.redAccent, width: 5),
                                            color: Colors.yellowAccent,
                                          ),
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            'Delete Request',
                                            style: TextStyle(
                                                fontFamily: "Poppins-Bold",
                                                color: Colors.black,
                                                fontSize: ScreenUtil.getInstance().setSp(30)
                                            ),
                                          )
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                              :
                          RichText(
                            text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Accepted By ',
                                      style: TextStyle(
                                          fontFamily: "Poppins-Medium",
                                          color: Colors.black,
                                          fontSize: ScreenUtil.getInstance().setSp(30))
                                  ),
                                  TextSpan(
                                      text: ' ' + list[i]['AcceptedBy'],
                                      style: TextStyle(
                                          fontFamily: "Poppins-Bold",
                                          color: Colors.blue[900],
                                          fontSize: ScreenUtil.getInstance().setSp(35))
                                  ),
                                  TextSpan(
                                      text: ' On ',
                                      style: TextStyle(
                                          fontFamily: "Poppins-Medium",
                                          color: Colors.black,
                                          fontSize: ScreenUtil.getInstance().setSp(30))
                                  ),
                                  TextSpan(
                                      text: ' ' + list[i]['AcceptedOn'],
                                      style: TextStyle(
                                          fontFamily: "Poppins-Bold",
                                          color: Colors.blue[900],
                                          fontSize: ScreenUtil.getInstance().setSp(35))
                                  ),
                                ]
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
              ],
            ),
          );
        }
    );
  }

  Future deleteReq(BuildContext context, reqId) async {
    var url = "https://us-central1-blood-bank-280211.cloudfunctions.net/handleRequests";
    var res = await http.post(url, body: {
      'action' : 'delete',
      'reqId' : reqId
    });
    var data = jsonDecode(res.body);
    if(data['status'] == 'deleted') {
      var msg = 'Your request has been successfully deleted';
      _showSnackBar(msg, context);
    }
    else {
      _showSnackBar(data['status'], context);
    }
  }

  void _showSnackBar(String msg, BuildContext context) {
    final snackBar = SnackBar(content: Text(msg, style: TextStyle(fontSize: 20),));
    Scaffold.of(context).showSnackBar(snackBar);
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
        print(data['status']);
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