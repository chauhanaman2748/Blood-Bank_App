import 'package:flutter/material.dart';

double iconSize = 30;


DonorList donorList = DonorList(cars: [
  Donor(companyName: "Welcome", imgList: [
    "D1.jpg",
    "D2.jpg",
    "D3.jpg",
    "D4.jpg",
    "D5.jpg",
  ], services: [
    {Icon(Icons.assignment, size: iconSize): "Your\nDonations"},
    {Icon(Icons.airline_seat_individual_suite, size: iconSize): "Need For\nBlood"},
    {Icon(Icons.pin_drop, size: iconSize): "Nearest\nCamps"},
    {Icon(Icons.shutter_speed, size: iconSize): "Your\nAppointments"},
  ], donorDetails: [
    {
      Icon(Icons.person, size: iconSize): {"Name": "Aman Chauhan"}
    },
    {
      Icon(Icons.av_timer, size: iconSize): {"Age": "20 yrs"}
    },
    {
      Icon(Icons.invert_colors, size: iconSize): {"Blood Group": "O+"}
    },
    {
      Icon(Icons.account_balance_wallet, size: iconSize): {
        "Mob No.": "8700230416"
      }
    },
    {
      Icon(Icons.assignment_late, size: iconSize): {"": "Other Info"}
    },
  ], advantages: [
    {
      Icon(Icons.assignment, size: iconSize):"1. Giving blood can reveal potential health problems"
    },
    {
      Icon(Icons.assignment, size: iconSize):"2. Giving blood can reduce harmful iron stores"
    },
    {
      Icon(Icons.assignment, size: iconSize):"3. Giving blood may lower your risk of suffering a heart attack"
    },
    {
      Icon(Icons.assignment, size: iconSize):"4. Giving blood may reduce your risk of developing cancer"
    },
    {
      Icon(Icons.assignment, size: iconSize):"5. Giving blood can help your liver stay healthy"
    },
    {
      Icon(Icons.assignment, size: iconSize):"6. Giving blood can help your mental state"
    },

  ]),

]);

class DonorList {
  List<Donor> cars;


  DonorList({
    @required this.cars,
  });
}

class Donor {
  String companyName;
  List<String> imgList;
  List<Map<Icon, String>> services;
  List<Map<Icon, String>> advantages;
  List<Map<Icon, Map<String, String>>> donorDetails;


  Donor({
    @required this.companyName,
    @required this.imgList,
    @required this.services,
    @required this.advantages,
    @required this.donorDetails,
  });
}

