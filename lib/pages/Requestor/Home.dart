import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloodbank/pages/Requestor/constant.dart';
import 'package:bloodbank/pages/Requestor/widgets/bottom_nav_bar.dart';
import 'package:bloodbank/pages/Requestor/widgets/search_bar.dart';

class RequestorHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.center,
            colors: [
              Colors.grey[600],
              Colors.grey[400],
            ],
          ),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              height: size.height * .40,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/Requestor/icons/meditation_bg.jpg"),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Text(
                        "Welcome",
                        style: Theme.of(context)
                            .textTheme
                            .display1
                            .copyWith(fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Name of Organization",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: size.width * .6, // it just take 60% of total width
                        child: Text(
                          "Live happier and healthier by saving someone's life, by donating blood.\nSo don't waste time,Let's plan for a blood donation camp.",
                        ),
                      ),
                      SizedBox(
                        width: size.width * .5, // it just take the 50% width
                        child: SearchBar(),
                      ),
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: <Widget>[
                          SeassionCard(
                            seassionNum: "Plan for Blood\nDonation Camp",
                            press: () {},
                          ),
                          SeassionCard(
                            seassionNum: "Advisory For\nDonating Blood ",
                            press: () {},
                          ),
                          SeassionCard(
                            seassionNum: "Details Of Staff",
                            press: () {},
                          ),
                          SeassionCard(
                            seassionNum: "Blood Records",
                            press: () {},
                          ),
                          SeassionCard(
                            seassionNum: "Add Events Or\n Other Details ",
                            press: () {},
                          ),
                          SeassionCard(
                            seassionNum: "About Your\nOrganization",
                            press: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
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
                      SizedBox(height: 20),
                      Text(
                        "Individuals under certain conditions are deemed ineligible to donate blood",
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontWeight: FontWeight.bold),
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SeassionCard extends StatelessWidget {
  final String seassionNum;
  final Function press;
  const SeassionCard({
    Key key,
    this.seassionNum,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Container(
          width: constraint.maxWidth / 2 -
              10, // constraint.maxWidth provide us the available with for this widget
          // padding: EdgeInsets.all(16),
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
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: press,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 10),
                    Text(
                      "$seassionNum",
                      style: Theme.of(context).textTheme.subtitle,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}