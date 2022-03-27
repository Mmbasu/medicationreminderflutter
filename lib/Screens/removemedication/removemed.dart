import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medi_health1/Screens/Dashboard/secondpage/seconddashboard.dart';
import 'package:http/http.dart' as http;

import '../../mywidget.dart';
import '../../sharedprefferences.dart';


class removemed extends StatefulWidget {
   const removemed({Key? key}) : super(key: key);

   @override
   State<removemed> createState() => _removemedState();
 }

 class _removemedState extends State<removemed> {

   late var loggedinUser;
   final Preferences _prefs = Preferences();

   TextEditingController medicationNameController = TextEditingController();
   late ScaffoldMessengerState scaffoldMessenger;


   @override
   Widget build(BuildContext context) {
     _prefs.getStringValuesSF("firstname").then((firstname) => {
       setState(() => {
         //print(firstname),
         loggedinUser = firstname,
       })
     });

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
                             "Remove Medication",
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
                             // decoration: BoxDecoration(
                             //     border: Border(
                             //         bottom: BorderSide(color: Colors.black))),
                             child: TextField(
                               controller: medicationNameController,
                               decoration: InputDecoration(
                                 border: InputBorder.none,
                                 hintText: "Medication Name",
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
                       onPressed: removeMedFunction,
                       //defining the shape
                       color: Color(0xFF94C3DD),
                       shape: RoundedRectangleBorder(
                           side: BorderSide(color: Colors.black),
                           borderRadius: BorderRadius.circular(20)),
                       child: Text(
                         "Remove Med",
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

   void removeMedFunction() {
     if (medicationNameController.text.isEmpty) {
       scaffoldMessenger.showSnackBar(
         mySnackBar("Provide Medication Name"),
       );
       return;
     }
     else {
       print(medicationNameController.text);
       removingMed(medicationNameController.text);

     }
   }

   removingMed(String medicationname) async {
     DialogBuilder(context).showLoadingIndicator(
         "Please wait as we Remove your Medication", "Removing");
     Map data = {'medicationname': medicationname};
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
           scaffoldMessenger.showSnackBar(
             mySnackBar("Medication Removed Successfully"),
           );
           Navigator.push(
               context,
               MaterialPageRoute(
                   builder: (context) => Page2()));
         } else {
           scaffoldMessenger.showSnackBar(
             mySnackBar("Medication does not Exist"),
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
