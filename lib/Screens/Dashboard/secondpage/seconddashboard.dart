import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medi_health1/Constants.dart';
import 'package:medi_health1/Screens/removemedication/removemed.dart';
import 'package:http/http.dart' as http;

import '../../../controllers/medicationcontroller.dart';
import '../../../icons.dart';
import '../../../models/medication.dart';
import '../../../tasktile.dart';


Future <List<Data>> fetchData() async {
  final response =await http.post(
    Uri.parse("https://medihealth2.000webhostapp.com/getMeds.php"),);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => new Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Data {
  final String note;
  final String title;
  final String date;
  final String repeat;

  Data({required this.note, required this.title, required this.date, required this.repeat});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      note: json['note'],
      title: json['title'],
      date: json['date'],
      repeat:json['repeat']
    );
  }
}



class Page2 extends StatefulWidget {

  const Page2({Key? key}) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final _taskController = Get.put(TaskController());

  late Future <List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){},
        icon: Icon(Icons.remove),
        backgroundColor: Color(0xFF94C3DD),
        label: Text("Remove Med"),
      ),

      body: SafeArea(
        child: ListTileTheme(
          contentPadding: EdgeInsets.all(15),
          iconColor: Colors.black54,
          textColor: Colors.black54,
          style: ListTileStyle.list,
          dense: false,
          child: FutureBuilder <List<Data>>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Data>? data = snapshot.data;
                return
                  ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => Card(
                      color: Color(0xFF94C3DD),
                      shape: RoundedRectangleBorder(
                          //side: BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 1,
                      margin: EdgeInsets.all(20.0),
                      child: ListTile(
                        leading: Icon(MyFlutterApp.pill_svgrepo_com__3_),
                        title: Text("${snapshot.data![index].title}", style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              //color: Colors.black
                          ),
                        ),),
                        subtitle: Text("${snapshot.data![index].repeat}", style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              //color: Colors.black
                          ),),),
                        trailing: Text("${snapshot.data![index].note}", style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              //color: Colors.black
                          ),),
                      ),
              ),),
                  );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }


}
