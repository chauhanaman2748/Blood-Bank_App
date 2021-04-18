import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:bloodbank/pages/Donor/Request.dart';
import 'package:bloodbank/pages/Requestor/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bloodbank/pages/Donor/bloc/state_bloc.dart';
import 'package:bloodbank/pages/Donor/bloc/state_provider.dart';
import 'package:bloodbank/pages/Donor/model/donor.dart';
import 'package:bloodbank/pages/login/Login.dart';
import 'package:bloodbank/pages/Requestor/constant.dart';

import 'BloodCamps.dart';
import 'BloodRequests.dart';
import 'GetData.dart';

class DonorHome extends StatefulWidget{

  final String user;
  final LinkedHashMap userDetails;

  DonorHome({this.user, this.userDetails});

  @override
  _DonorHome createState() => new _DonorHome();
}

var currentDonor = donorList.cars[0];

class _DonorHome extends State<DonorHome> {


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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RequestorHome()));
              },
            ),
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: LayoutStarts(widget.user, widget.userDetails),
    );
  }
}
//    print(widget.userDetails['Name']);

class LayoutStarts extends StatelessWidget {

  LayoutStarts(this.user, this.userDetails);
  final String user;
  final LinkedHashMap userDetails;
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        DonorDetailsAnimation(user, userDetails),
        CustomBottomSheet(user, userDetails),
      ],
    );
  }
}

class DonorDetailsAnimation extends StatefulWidget {

  DonorDetailsAnimation(this.user, this.userDetails);
  final String user;
  final LinkedHashMap userDetails;

  @override
  _DonorDetailsAnimationState createState() => _DonorDetailsAnimationState();
}

class _DonorDetailsAnimationState extends State<DonorDetailsAnimation>
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
              child: DonorDetails(widget.user, widget.userDetails),
            ),
          );
        });
  }
}

class DonorDetails extends StatelessWidget {

  DonorDetails(this.user, this.userDetails);
  final String user;
  final LinkedHashMap userDetails;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 30),
                child: _donorTitle(userDetails['Name']),
              ),
              Container(
                width: double.infinity,
                child: DonorCarousel(),
              ),
              userDetails['Donor'] == 'false' ?
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                padding: EdgeInsets.all(10),
                height: 340,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 17),
                      blurRadius: 23,
                      spreadRadius: -13,
                      color: kShadowColor,
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Image.asset(
                          "assets/Requestor/icons/donating.jpg",
                          width: 100,
                          height: 100,
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "What if you\nneed blood",
                                style: Theme.of(context)
                                    .textTheme
                                    .title
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "1. Request for blood",
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                        Text("One way you can proceed is by requesting for blood to the donors through our app.\n"),
                        Text(
                          "2. Contact to particular donor",
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                        Text("From the available list, you can search for a donor and can directly contact with him.\n"),
                        Text(
                          "3. Hospitals",
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                        Text("If you need blood urgently, you can search for the nearby hospitals and go with that.\n"),
                      ],
                    ),
                  ],
                ))
                    :
                  Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  padding: EdgeInsets.all(10),
                  height: 530,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 17),
                        blurRadius: 23,
                        spreadRadius: -13,
                        color: kShadowColor,
                      ),
                    ],
                  ),
                  child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Image.asset(
                          "assets/Requestor/icons/donating.jpg",
                          width: 100,
                          height: 100,
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Criteria to\ndonate blood",
                                style: Theme.of(context)
                                    .textTheme
                                    .title
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "1. Overall health",
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                        Text("The donor must be fit and healthy, and should not be suffering from transmittable diseases.\n"),
                        Text(
                          "2. Age and weight",
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                        Text("The donor must be 18–65 years old and should weigh a minimum of 50  kg.\n"),
                        Text(
                          "3. Pulse rate",
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                        Text("Between 50 and 100 without irregularities.\n"),
                        Text(
                          "4. Hemoglobin level",
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                        Text("A minimum of 12.5 g/dL.\n"),
                        Text(
                          "5. Blood pressure",
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                        Text(" Diastolic: 50–100 mm Hg, Systolic: 100–180 mm Hg.\n"),
                        Text(
                          "6. Body temperature",
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                        Text("Should be normal, with an oral temperature not exceeding 37.5 °C.\n"),
                        Text(
                          "7. Duration For Donation",
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                        Text("The time period between successive blood donations should be more than 3 months.")
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                "Individuals under certain conditions are deemed ineligible to donate blood",
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                padding: EdgeInsets.all(10),
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 17),
                      blurRadius: 23,
                      spreadRadius: -13,
                      color: kShadowColor,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("1. A person who has been tested HIV positive.\n\n2. Individuals suffering from ailments like cardiac arrest, hypertension, blood pressure, cancer, epilepsy, kidney ailments and diabetes.A person who has undergone ear/body piercing or tattoo in the past 6 months.\n\n3. Individuals who have undergone immunization in the past 1 month.\n\n4. Individuals treated for rabies or received Hepatitis B vaccine in the past 6 months.\n\n5. A person who has consumed alcohol in the past 24 hours.\n\n6. Women who are pregnant or breastfeeding.\n\n7. Individuals who have undergone major dental procedures or general surgeries in the past 1 month.\n\n8. Women who have had miscarriage in the past 6 months.\n\n9. Individuals who have had fits, tuberculosis, asthma and allergic disorders in the past",
                      style: Theme.of(context).textTheme.subtitle,),
                  ],
                ),
              ),
              SizedBox(height: 35),
            ],
          )),
    );
  }

  _donorTitle(user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
              style: TextStyle(color: Colors.white, fontSize: 38),
              children: [
                TextSpan(text: currentDonor.companyName),
              ]),
        ),
        SizedBox(height: 10),
        RichText(
          text: TextSpan(
              style: TextStyle(color: Colors.white, fontSize: 38),
              children: [
                TextSpan(text: user),
              ]),
        ),
        SizedBox(height: 10),
        RichText(
          text: TextSpan(style: TextStyle(fontSize: 16), children: [
            TextSpan(
              text: userDetails['Donor'] == 'false' ? "Blood Donation is one of the Divine Karma not everyone is able to do. Many are in need of blood but could not get blood on time. The problem is not insufficient number of donors, but finding a willing donor at the required time. Thus we help you by building a network of people who can help each other during an emergency." : "Your blood can give a life to someone.\nYour blood donation can give a precious\nsmile to someone's face. Don't let fools\nor mosquitoes suck your blood, put it to \ngood use. Donate blood and save a life.",
              style: TextStyle(color: Colors.grey),
            )
          ]),
        ),
        SizedBox(height: 25),
      ],
    );
  }
}

class DonorCarousel extends StatefulWidget {
  @override
  _DonorCarouselState createState() => _DonorCarouselState();
}

class _DonorCarouselState extends State<DonorCarousel> {
  static final List<String> imgList = currentDonor.imgList;

  final List<Widget> child = _map<Widget>(imgList, (index, String assetName) {
    return Container(
        child: Image.asset("assets/Donor/$assetName", fit: BoxFit.fitWidth));
  }).toList();

  static List<T> _map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          CarouselSlider(
            height:  350,
            viewportFraction: 1.0,
            items: child,
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
          ),
          Container(
            margin: EdgeInsets.only(left: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _map<Widget>(imgList, (index, assetName) {
                return Container(
                  width: 50,
                  height: 2,
                  decoration: BoxDecoration(
                      color: _current == index
                          ? Colors.grey[100]
                          : Colors.grey[600]),
                );
              }),
            ),
          )
        ],
      ),
    );
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