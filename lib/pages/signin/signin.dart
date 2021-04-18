import 'dart:convert';
import 'package:bloodbank/pages/Donor/Home.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bloodbank/pages/signin/widgets/FormCard.dart';
import 'package:bloodbank/pages/login/Login.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  final String title = "DropDown Demo";
  @override
  _SignUp createState() => new _SignUp();
}

class Blood {
  int id;
  String name;

  Blood(this.id, this.name);

  static List<Blood> getCompanies() {
    return <Blood>[
      Blood(1, 'O+'),
      Blood(2, 'O-'),
      Blood(3, 'A+'),
      Blood(4, 'A-'),
      Blood(5, 'B+'),
      Blood(6, 'B-'),
      Blood(7, 'AB+'),
      Blood(8, 'AB-'),
    ];
  }
}

class _SignUp extends State<SignUp> {

  List<Blood> _companies = Blood.getCompanies();
  List<DropdownMenuItem<Blood>> _dropdownMenuItems;
  Blood _selectedCompany;

  List<DropdownMenuItem<Blood>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Blood>> items = List();
    for (Blood company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Blood selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
    });
  }

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

  TextEditingController controllerName = new TextEditingController();
  TextEditingController controllerUsername = new TextEditingController();
  TextEditingController controllerPassword = new TextEditingController();
  TextEditingController controllerAddress = new TextEditingController();
  TextEditingController controllerMobile = new TextEditingController();
  TextEditingController controllerAge = new TextEditingController();

  var date = new List<int>.generate(31, (i) => i+1);
  var month = new List<int>.generate(12, (i) => i+1);
  var year = [1980,1981,1982,1983,1984,1985,1986,1987,1988,1989,1990];

  var dateSelected;
  var monthSelected;
  var yearSelected;

  @override
  void initState() {
    super.initState();

    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
    dateSelected = date[0];
    monthSelected = month[0];
    yearSelected = year[0];
  }

  @override
  Widget build(BuildContext context) {

    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: Stack(
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
          Form(
            key: key,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(80),
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
                              Text("SignUp",
                                  style: TextStyle(
                                      fontSize: ScreenUtil.getInstance().setSp(45),
                                      fontFamily: "Poppins-Bold",
                                      letterSpacing: .6)),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(30),
                              ),
                              Text("Name",
                                  style: TextStyle(
                                      fontFamily: "Poppins-Medium",
                                      fontSize: ScreenUtil.getInstance().setSp(26))),
                              TextFormField(
                                controller: controllerName,
                                // ignore: missing_return
                                validator: (val) {
                                  if(val.isEmpty) {
                                    return 'Please Enter Your Name';
                                  }
                                },
                                decoration: InputDecoration(
                                    hintText: "Enter Your Name",
                                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
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
                                              hintText: "Username",
                                              hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: ScreenUtil.getInstance().setHeight(30),
                                        ),
                                        Text("Enter Phone Number",
                                            style: TextStyle(
                                                fontFamily: "Poppins-Medium",
                                                fontSize: ScreenUtil.getInstance().setSp(26))),
                                        TextFormField(
                                          controller: controllerMobile,
                                          // ignore: missing_return
                                          validator: (val) {
                                            if(val.isEmpty) {
                                              return 'Please Enter Your Mobile Number';
                                            }
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: "Mobile Number",
                                            hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(30),
                              ),
                              Text("Password",
                                  style: TextStyle(
                                      fontFamily: "Poppins-Medium",
                                      fontSize: ScreenUtil.getInstance().setSp(26))),
                              TextFormField(
                                controller: controllerPassword,
                                // ignore: missing_return
                                validator: (val) {
                                  if(val.isEmpty) {
                                    return 'Please Enter The Password';
                                  }
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                              ),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(30),
                              ),
                              Text("Address",
                                  style: TextStyle(
                                      fontFamily: "Poppins-Medium",
                                      fontSize: ScreenUtil.getInstance().setSp(26))),
                              TextFormField(
                                controller: controllerAddress,
                                // ignore: missing_return
                                validator: (val) {
                                  if(val.isEmpty) {
                                    return 'Please Enter Your Address';
                                  }
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: "Address",
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: ScreenUtil.getInstance().setHeight(30),
                                        ),
                                        Text("Enter Age",
                                            style: TextStyle(
                                                fontFamily: "Poppins-Medium",
                                                fontSize: ScreenUtil.getInstance().setSp(26))),
                                        TextFormField(
                                          controller: controllerAge,
                                          // ignore: missing_return
                                          validator: (val) {
                                            if(val.isEmpty) {
                                              return 'Please Enter Your Age';
                                            }
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: "Age",
                                            hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),),
                                        ),

/*
                                        Row(
                                          children: <Widget>[
                                            DropdownButton<int> (
                                              items: date.map((int dropDownStringItem) {
                                                return DropdownMenuItem<int> (
                                                  value: dropDownStringItem,
                                                  child: Text(
                                                    dropDownStringItem.toString(),
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (int newValueSelected) {
                                                setState(() {
                                                  dateSelected = newValueSelected;
                                                });
                                              },
                                              value: dateSelected,
                                            ),
                                            DropdownButton<int> (
                                              items: month.map((int dropDownStringItem) {
                                                return DropdownMenuItem<int> (
                                                  value: dropDownStringItem,
                                                  child: Text(
                                                    dropDownStringItem.toString(),
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (int newValueSelected) {
                                                setState(() {
                                                  monthSelected = newValueSelected;
                                                });
                                              },
                                              value: monthSelected,
                                            ),
                                            DropdownButton<int> (
                                              items: year.map((int dropDownStringItem) {
                                                return DropdownMenuItem<int> (
                                                  value: dropDownStringItem,
                                                  child: Text(
                                                    dropDownStringItem.toString(),
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (int newValueSelected) {
                                                setState(() {
                                                  yearSelected = newValueSelected;
                                                });
                                              },
                                              value: yearSelected,
                                            ),
                                          ],
                                        ),
*/
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: ScreenUtil.getInstance().setHeight(30),
                                        ),
                                        Text("Choose Blood Group",
                                            style: TextStyle(
                                                fontFamily: "Poppins-Medium",
                                                fontSize: ScreenUtil.getInstance().setSp(26))),
                                        DropdownButton(
                                          value: _selectedCompany,
                                          items: _dropdownMenuItems,
                                          onChanged: onChangeDropdownItem,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
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
                            Text("Be A Donor",
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
                                            signUp();
                                          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
                                        }
                                      },
                                      child: Text("SIGNUP",
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
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future signUp() async {
    var _dob = yearSelected.toString()+'/'+monthSelected.toString()+'/'+dateSelected.toString();

    var url = "https://us-central1-blood-bank-280211.cloudfunctions.net/signUp";
    var res = await http.post(url, body: {
      'name' : controllerName.text,
      'username' : controllerUsername.text,
      'mobile' : controllerMobile.text,
      'password' : controllerPassword.text,
      'address' : controllerAddress.text,
      'blood_group' : _selectedCompany.name,
      'age' : controllerAge.text,
      'donor' : _isSelected.toString()
    });
    var data = jsonDecode(res.body);

    if(data['status'] == 'success') {
      var response = await http.get(url+'?val='+controllerUsername.text+'&action=get');
      var data = jsonDecode(response.body);
      if(data['status'] == 'success') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DonorHome(user: controllerUsername.text, userDetails: data['result'],)));
      }
      else {
        print(data['status']);
      }
    }
/*
    var data = jsonDecode(res.body);
    print(data);
    if(data['status'] == 'success') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DonorHome()));
    }
    else {
      print(data);
    }
*/
  }

}