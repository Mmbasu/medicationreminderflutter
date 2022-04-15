import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Constants.dart';
import '../../inputfield.dart';
import '../../mywidget.dart';
import '../../sharedprefferences.dart';
import '../settings/settings.dart';

class removemed extends StatefulWidget {
  const removemed({Key? key}) : super(key: key);

  @override
  State<removemed> createState() => _removemedState();
}

class _removemedState extends State<removemed> {
  final Preferences _prefs = Preferences();

  String loggedinUseremailAddress = " ";

  var loggedinUser = " ";

  String _selectedRepeat = "None";
  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
    "Monthly",
  ];

  int _selectedColor = 0;
  late ScaffoldMessengerState scaffoldMessenger;

  TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {


    _prefs.getStringValuesSF("emailAddress").then((emailAddress) => {
          setState(() => {
                loggedinUseremailAddress = emailAddress!,
              })
        });

    _prefs.getStringValuesSF("firstname").then((firstname) => {
      setState(() => {
        loggedinUser = firstname!,

      })
    });


    scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text("Hello " + loggedinUser),
        titleTextStyle: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w600,
            fontSize: 20),
        backgroundColor: Color(0xFF94C3DD),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MySettings()));
                });
              },
              icon: Icon(
                Icons.settings,
                color: Colors.white,
                size: 35,
              )),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 30),
          Text(
            "Remove Medication",
            style: HeadingStyle,
          ),
          SizedBox(height: 20),
          MyInputField(
            title: "Medication",
            hint: "Enter your medication name",
            inputfieldcontroller: _titleController,
          ),
          SizedBox(
            height: 60,
          ),
          Row(
            children: [
              SizedBox(width: 210),
              FloatingActionButton.extended(
                onPressed: _validateTextData,
                backgroundColor: Color(0xFF94C3DD),
                label: Text("Remove Med",
                style: TextStyle(
                  color: Colors.black54,
                ),
                ),
              ),
            ],
          ),
        ])),
      ),
    );
  }


  _validateTextData() {
    print(_titleController.text);
    print(loggedinUseremailAddress);

    if(_titleController.text.isEmpty){

      scaffoldMessenger.showSnackBar(
        mySnackBar("Enter Medication Name"),
      );
    }else{
      deleteMed(loggedinUseremailAddress, _titleController.text);
    }

  }

  deleteMed(email, title) async {
    DialogBuilder(context).showLoadingIndicator(
        "Please wait as we delete your Medication", "Deleting");
    Map data = {
      'email': email,
      'title': title,
    };
    var jsonResponse;
    var response = await http.post(
        Uri.parse("https://medihealth2.000webhostapp.com/removemed.php"),
        body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          DialogBuilder(context).hideOpenDialog();
        });
        int isRegistered = jsonResponse['code'];
        if (isRegistered == 1) {
          //correct password
          //move to dashboard
          scaffoldMessenger.showSnackBar(
            mySnackBar("Medication deleted"),
          );
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => firstLoginPage()));
        } else {
          scaffoldMessenger.showSnackBar(
            mySnackBar("Failed to delete"),
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
