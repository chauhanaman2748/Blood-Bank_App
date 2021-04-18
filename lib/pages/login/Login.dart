import 'dart:collection';
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bloodbank/pages/login/Widgets/FormCard.dart';
import 'package:bloodbank/pages/login/Widgets/SocialIcons.dart';
import 'CustomIcons.dart';
import 'package:bloodbank/pages/signin/signin.dart';
import 'package:bloodbank/pages/Donor/Home.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => new _Login();
}

class _Login extends State<Login> {
  bool _isSelected = false;


  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }


  Widget radioButton(bool isSelected) => Container(
    width: 16.0,
    height: 16.0,
    padding: EdgeInsets.all(2.0),
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 2.0, color: Colors.black)),
    child: isSelected
        ? Container(
      width: double.infinity,
      height: double.infinity,
      decoration:
      BoxDecoration(shape: BoxShape.circle, color: Colors.black),
    )
        : Container(),
  );

  Widget horizontalLine() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      width: ScreenUtil.getInstance().setWidth(120),
      height: 1.0,
      color: Colors.black26.withOpacity(.2),
    ),
  );

  var key = GlobalKey<FormState>();
  TextEditingController controllerUsername = new TextEditingController();
  TextEditingController controllerPassword = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.black));
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: Builder(
        builder: (context) =>
        Form(
          key: key,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Image.asset("assets/login/donate-blood.jpg"),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Expanded(child: Image.asset("assets/login/image_02.png"))
                ],
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("LOGO",
                              style: TextStyle(
                                  fontFamily: "Poppins-Bold",
                                  fontSize: ScreenUtil.getInstance().setSp(46),
                                  letterSpacing: .6,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil.getInstance().setHeight(180),
                      ),
                      new Container(
                        width: double.infinity,
//      height: ScreenUtil.getInstance().setHeight(500),
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
                              Text("Login",
                                  style: TextStyle(
                                      fontSize: ScreenUtil.getInstance().setSp(45),
                                      fontFamily: "Poppins-Bold",
                                      letterSpacing: .6)),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(30),
                              ),
                              Text("Username",
                                  style: TextStyle(
                                      fontFamily: "Poppins-Medium",
                                      fontSize: ScreenUtil.getInstance().setSp(26))),
                              TextFormField(
                                controller: controllerUsername,
                                // ignore: missing_return
                                validator: (val) {
                                  if(val.isEmpty) {
                                    return 'Please Enter Your Username';
                                  }
                                },
                                decoration: InputDecoration(
                                    hintText: "username",
                                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                              ),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(30),
                              ),
                              Text("PassWord",
                                  style: TextStyle(
                                      fontFamily: "Poppins-Medium",
                                      fontSize: ScreenUtil.getInstance().setSp(26))),
                              TextFormField(
                                controller: controllerPassword,
                                // ignore: missing_return
                                validator: (val) {
                                  if(val.isEmpty) {
                                    return 'Please Enter Your Password';
                                  }
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                              ),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(35),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontFamily: "Poppins-Medium",
                                        fontSize: ScreenUtil.getInstance().setSp(28)),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 12.0,
                              ),
                              GestureDetector(
                                onTap: _radio,
                                child: radioButton(_isSelected),
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Text("Remember me",
                                  style: TextStyle(
                                      fontSize: 12, fontFamily: "Poppins-Medium"))
                            ],
                          ),
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
                                          userLogin(context);
                                        }
                                      },
                                      child: Text("SIGNIN",
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
                          )
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil.getInstance().setHeight(40),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          horizontalLine(),
                          Text("Social Login",
                              style: TextStyle(
                                  fontSize: 16.0, fontFamily: "Poppins-Medium")),
                          horizontalLine()
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil.getInstance().setHeight(40),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SocialIcon(
                            colors: [
                              Color(0xFF102397),
                              Color(0xFF187adf),
                              Color(0xFF00eaf8),
                            ],
                            iconData: CustomIcons.facebook,
                            onPressed: () {},
                          ),
                          SocialIcon(
                            colors: [
                              Color(0xFFff4f38),
                              Color(0xFFff355d),
                            ],
                            iconData: CustomIcons.googlePlus,
                            onPressed: () {},
                          ),
                          SocialIcon(
                            colors: [
                              Color(0xFF17ead9),
                              Color(0xFF6078ea),
                            ],
                            iconData: CustomIcons.twitter,
                            onPressed: () {},
                          ),
                          SocialIcon(
                            colors: [
                              Color(0xFF00c6fb),
                              Color(0xFF005bea),
                            ],
                            iconData: CustomIcons.linkedin,
                            onPressed: () {},
                          )
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil.getInstance().setHeight(30),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "New User? ",
                            style: TextStyle(fontFamily: "Poppins-Medium"),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
                            },
                            child: Text("SignUp",
                                style: TextStyle(
                                    color: Color(0xFF5d74e3),
                                    fontFamily: "Poppins-Bold")),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future userLogin(context) async {
    var url = "https://us-central1-blood-bank-280211.cloudfunctions.net/userLogin";
    var response = await http.post(url, body: {
      'username' : controllerUsername.text,
      'password' : controllerPassword.text
    });
    var data = jsonDecode(response.body);

    if(data['status'] == 'success') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DonorHome(user: controllerUsername.text, userDetails: data['result'],)));
    }
    else {
      _showSnackBar(data['status'], context);
    }
  }

  void _showSnackBar(String msg, context) {
    final snackBar = SnackBar(content: Text(msg, style: TextStyle(fontSize: 20),),);
    Scaffold.of(context).showSnackBar(snackBar);
  }

}