import 'dart:convert';

import 'package:flutter/material.dart';
import '../../mywidget.dart';
import '../../sharedprefferences.dart';
import '../Dashboard/dashboard.dart';
import '../Dashboard/firstpage/firstdashboard.dart';
import '../login/login.dart';
import '../signup/mytextfield.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;

class Page4 extends StatefulWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  late var loggedinUser;

  final Preferences _prefs = Preferences();

  TextEditingController medicationNameController = TextEditingController();
  TextEditingController frequencyController = TextEditingController();
  TextEditingController timesController = TextEditingController();

  late ScaffoldMessengerState scaffoldMessenger;

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Everyday"),value: "Everyday"),
      DropdownMenuItem(child: Text("Selected Days"),value: "Selected Days"),
      DropdownMenuItem(child: Text("Birth Control Cycle"),value: "Birth Control Cycle"),
    ];
    return menuItems;
  }

  String selectedValue = "Everyday";


    @override
  Widget build(BuildContext context) {

      _prefs.getStringValuesSF("firstname").then((firstname) => {
        setState(() => {
          //print(firstname),
          loggedinUser = firstname,
        })
      });

      scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(left: 5),
            child: Image.network("https://medihealth2.000webhostapp.com/userprofilepictures/griffin.jpg"),
          ),
          automaticallyImplyLeading: false,
          title: Text(loggedinUser),
          titleTextStyle: TextStyle(color: Colors.black,
              //fontWeight: FontWeight.w600,
              fontSize: 20),
          backgroundColor: Color(0xFF94C3DD),

          actions: [
            PopupMenuButton<int>(
              color: Color(0xFF94C3DD),
              itemBuilder: (context) =>
              [
                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.settings),
                      const SizedBox(width: 8),
                      Text('Settings'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      body: SingleChildScrollView(
    child: Container(

    width: double.infinity,
      height: MediaQuery.of(context).size.height,

      child: Column(
        children: <Widget>[
          Container(
            height: 200,
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: Container(
                    margin: EdgeInsets.only(top: 100),
                    child: Center(
                      child: Text(
                        "Add Medication",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xFF94C3DD),
                            blurRadius: 20.0,
                            offset: Offset(0, 10)),
                      ]),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.black))),
                        child: TextField(
                          controller: medicationNameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Medication Name",
                            hintStyle: TextStyle(color: Colors.grey[400]),

                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.black))),
                        child: TextField(
                          controller: frequencyController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Frequency",
                            hintStyle: TextStyle(color: Colors.grey[400]),

                          ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            controller: timesController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Times taken",
                              hintStyle: TextStyle(color: Colors.grey[400]),

                            ),
                          ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
      MaterialButton(
        minWidth: double.infinity,
        height: 60,
        onPressed: addMedFunction,
        //defining the shape
        color: Color(0xFF94C3DD),
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(20)),
        child: Text(
          "Add Med",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 18),
        ),
      ),
              ],
            ),
          ),
        ],
      ),
    ),
    ),
    );
  }

  void addMedFunction() {
    if (medicationNameController.text.isEmpty) {
      scaffoldMessenger.showSnackBar(
        mySnackBar("Provide Medication Name"),
      );
      return;
    }else if (frequencyController.text.isEmpty) {
      scaffoldMessenger.showSnackBar(
        mySnackBar("Provide Frequency"),
      );
      return;
    }else if (timesController.text.isEmpty) {
      scaffoldMessenger.showSnackBar(
        mySnackBar("Provide No of times taken"),
      );
      return;
    }
    else {
      print(medicationNameController.text);
      print(frequencyController.text);
      print(timesController.text);
      addMed(medicationNameController.text, frequencyController.text, timesController.text);

    }
  }
  addMed(String medicationname, String frequency, String timestaken) async {
    DialogBuilder(context).showLoadingIndicator(
        "Please wait as we Add your Medication", "Adding");
    Map data = {'medicationname': medicationname, 'frequency': frequency, 'timestaken': timestaken};
    var jsonResponse;
    var response = await http.post(
        Uri.parse("https://medihealth2.000webhostapp.com/addmed.php"),
        body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          DialogBuilder(context).hideOpenDialog();
        });
        int isRegistered = jsonResponse['code'];
        if (isRegistered == 1) {
          scaffoldMessenger.showSnackBar(
            mySnackBar("Medication Added Successfully"),
          );
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen()));
        } else {
          scaffoldMessenger.showSnackBar(
            mySnackBar("Medication is already Added"),
          );
        }
      }
    } else {
      setState(() {
        DialogBuilder(context).hideOpenDialog();
      });
    }
  }

}