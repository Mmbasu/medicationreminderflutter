import 'package:flutter/material.dart';
import 'package:medi_health1/Screens/Dashboard/firstpage/calenderpage.dart';
import 'package:medi_health1/Screens/settings/settings.dart';
import 'package:medi_health1/icons.dart';

import '../../notification_services.dart';
import '../../sharedprefferences.dart';
import '../addmedication/addmedication.dart';
import '../../addmedpage.dart';
import 'firstpage/firstdashboard.dart';
import 'secondpage/seconddashboard.dart';
import 'thirdpage/thirddashboard.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, Object? data}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final Preferences _prefs = Preferences();

  var loggedinUser = " ";

  late var greetings = "Hello";
  //
  // int pageIndex = 0;
  //
  // final pages = [
  //   CalenderPage(),
  //   Page2(),
  //   Page3(),
  //   AddMedPage(),
  // ];

  int pageIndexes = 0;

  final page = [
    CalenderPage(),
    Page2(),
    Page3(),
    AddMedPage(),
  ];

  var notifyHelper;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {

    _prefs.getStringValuesSF("firstname").then((firstname) => {
      setState(() => {
        //print(firstname),
        loggedinUser = firstname!,
      })
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Image.network("https://medihealth2.000webhostapp.com/userprofilepictures/griffin.jpg"),

            // onPressed: () {
            //   print('Click leading');
            // },
          //),
        ),
        automaticallyImplyLeading: false,
        title:  Text( "Hello "+ loggedinUser),
        titleTextStyle: TextStyle(color: Colors.black,
          //fontWeight: FontWeight.w600,
          fontSize: 20),
        backgroundColor: Color(0xFF94C3DD),

        actions: [
          PopupMenuButton<int>(
              color: Color(0xFF94C3DD),
              onSelected: (result){
                if(result==0){
                  notifyHelper.displayNotification(
                      title: "Medihealth",
                      body:"Welcome"
                  );
                 //notifyHelper.scheduledNotification();

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MySettings()));
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(Icons.settings),
                      //const SizedBox(width: 8),
                      Text('Settings'),
                    ],
                  ),
                ),
              ],
            ),
        ],

      ),
      body: page[pageIndexes],
      bottomNavigationBar: buildMyNavBar(context),
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Color(0xFF94C3DD),
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                pageIndexes = 0;
              });
            },
            icon: pageIndexes == 0
                ? const Icon(
                    Icons.home_filled,
                    color: Colors.black,
                    size: 35,
                  )
                : const Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                    size: 35,
                  ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                pageIndexes = 1;
              });
            },
            icon: pageIndexes == 1
                ? const Icon(
                    MyFlutterApp.pill_svgrepo_com__3_,
                    color: Colors.black,
                    size: 35,
                  )
                : const Icon(
                    MyFlutterApp.pill_svgrepo_com__2_,
                    color: Colors.white,
                    size: 35,
                  ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                pageIndexes = 2;
              });
            },
            icon: pageIndexes == 2
                ? const Icon(
                    Icons.more,
                    color: Colors.black,
                    size: 35,
                  )
                : const Icon(
                    Icons.more_outlined,
                    color: Colors.white,
                    size: 35,
                  ),
          ),
        ],
      ),
    );
  }


}


