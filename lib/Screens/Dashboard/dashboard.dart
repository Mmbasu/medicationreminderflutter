import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:medi_health1/Screens/Dashboard/firstpage/calenderpage.dart';
import 'package:medi_health1/Screens/settings/settings.dart';
import 'package:medi_health1/icons.dart';

import '../../controllers/medicationcontroller.dart';
import '../../models/medication.dart';
import '../../notification_services.dart';
import '../../sharedprefferences.dart';
import '../../tasktile.dart';
import '../addmedication/addmedication.dart';
import '../../addmedpage.dart';
import 'firstpage/firstdashboard.dart';
import 'secondpage/seconddashboard.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, Object? data}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _taskController = Get.put(TaskController());

  final Preferences _prefs = Preferences();

  String loggedinUser = " ";

  String greetings = "Hello";
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
    AddMedPage(),
    // MySettings(),
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
        // leading: Padding(
        //   padding: EdgeInsets.only(left: 5),
        //   child: CircleAvatar(
        //     backgroundImage: NetworkImage("https://medihealth2.000webhostapp.com/userprofilepicturefdres/griffin.jpg"),
        //   )
        //
        //     // onPressed: () {
        //     //   print('Click leading');
        //     // },
        //   //),
        // ),
        automaticallyImplyLeading: false,
        title:  Text( "Hello "+ loggedinUser),
        titleTextStyle: TextStyle(color: Colors.black54,
          fontWeight: FontWeight.w600,
          fontSize: 20),
        backgroundColor: Color(0xFF94C3DD),


        actions: [
          IconButton(
            onPressed: () {
              setState(() {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => MySettings()));
              });
            },
            icon: Icon(
              Icons.settings,
              color: Colors.white,
              size: 35,
            )
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
          TextButton.icon(
            onPressed: () {
              setState(() {
                pageIndexes = 0;
              });
            },
            icon: pageIndexes == 0
                ? const Icon(
                    Icons.home_filled,
                    color: Colors.black54,
                    size: 35,
                  )
                : const Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                    size: 35,
                  ), label: Text(
            "Home",
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          ),
          TextButton.icon(
            onPressed: () {
              setState(() {

                pageIndexes = 1;
              });
            },
            icon: pageIndexes == 1
                ? const Icon(
                    MyFlutterApp.pill_svgrepo_com__3_,
                    color: Colors.black54,
                    size: 35,
                  )
                : const Icon(
                    MyFlutterApp.pill_svgrepo_com__2_,
                    color: Colors.white,
                    size: 35,
                  ), label: Text(
            "Meds",
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          ),
        ],
      ),
    );
  }


}


