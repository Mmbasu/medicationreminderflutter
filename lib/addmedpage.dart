import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:medi_health1/Screens/Dashboard/firstpage/calenderpage.dart';
import 'package:medi_health1/inputfield.dart';

import 'Constants.dart';
import 'controllers/medicationcontroller.dart';
import 'models/medication.dart';
import 'mywidget.dart';



class AddMedPage extends StatefulWidget {
  const AddMedPage({Key? key}) : super(key: key);

  @override
  State<AddMedPage> createState() => _AddMedPageState();
}

class _AddMedPageState extends State<AddMedPage> {
  final TaskController _taskController = Get.put(TaskController());

  TextEditingController _titleController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];

  String _selectedRepeat = "None";
  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
    "Monthly",
  ];

  int _selectedColor = 0;
  late ScaffoldMessengerState scaffoldMessenger;


  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.only(left: 5),
            child: Image.network("https://medihealth2.000webhostapp.com/userprofilepictures/griffin.jpg"),

          ),
          automaticallyImplyLeading: false,
          title:  Text( "Hello "),
          titleTextStyle: TextStyle(color: Colors.black,
              //fontWeight: FontWeight.w600,
              fontSize: 20),
          backgroundColor: Color(0xFF94C3DD),

        ),

      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add Medication",
              style: HeadingStyle,
              ),
              MyInputField(title: "Title", hint: "Enter your title", inputfieldcontroller: _titleController,),
              MyInputField(title: "Note", hint: "Enter your Note", inputfieldcontroller: _noteController,),
              MyInputField(title: "Date", hint: DateFormat.yMd().format(_selectedDate),
              widget: IconButton(
                icon: Icon(Icons.calendar_today_outlined,
                color:Colors.grey ,
                ),
                onPressed: () {
                  getDateFromUser();
                },
              ),
              ),

              Row(
                children: [
                  Expanded(
                      child: MyInputField(
                        title: "Start Time",
                        hint: _startTime,
                        widget: IconButton(
                          onPressed: (){
                            getTimeFromUser(isStartTime: true);
                          },
                          icon: Icon(Icons.access_time_rounded),
                          color: Colors.grey,
                        ),
                      )
                  ),

                  SizedBox(width: 12,),
                  Expanded(
                      child: MyInputField(
                        title: "End Time",
                        hint: _endTime,
                        widget: IconButton(
                          onPressed: (){
                            getTimeFromUser(isStartTime: false);
                          },
                          icon: Icon(Icons.access_time_rounded),
                          color: Colors.grey,
                        ),
                      )
                  ),
                ],
              ),

              MyInputField(title: "Remind", hint: "$_selectedRemind minutes early",
                  widget: DropdownButton(
                    icon:Icon(Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(height: 0,),
                    items: remindList.map<DropdownMenuItem<String>>((int value){
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString()),
                      );
                    }
                    ).toList(),
                    onChanged: (String? newvalue) {
                      setState(() {
                        _selectedRemind = int.parse(newvalue!);
                      });
                    },
              ),
              ),

              MyInputField(title: "Repeat", hint: "$_selectedRepeat",
                widget: DropdownButton(
                  icon:Icon(Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0,),
                  items: repeatList.map<DropdownMenuItem<String>>((String? value){
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value!, style: TextStyle(color: Colors.grey)),
                    );
                  }
                  ).toList(),
                  onChanged: (String? newvalue) {
                    setState(() {
                      _selectedRepeat = newvalue!;
                    });
                  },
                ),
              ),
              SizedBox(height: 18,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Color",
                      style: titleStyle,
                      ),
                      SizedBox(height: 8,),

                      Wrap(
                        children: List<Widget>.generate(
                            3,
                                (int index) {
                              return GestureDetector(
                                onTap: (){
                                  setState(() {
                                    _selectedColor= index;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: CircleAvatar(
                                    radius: 14,
                                      backgroundColor: index==0?primaryColor:index==1?pinkColor:orangeColor,
                                  child: _selectedColor==index?Icon(Icons.done,
                                    color: Colors.white,
                                    size: 16,
                                  ):Container(),
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                  FloatingActionButton.extended(
                    onPressed: () {
                      _validateTextData();
                    },
                    backgroundColor: Color(0xFF94C3DD),
                    label: Text("Create Med"),
                  ),

                ],
              )

            ],
          ),
        ),

      ),
    );
  }

  _validateTextData(){
    print(_noteController.text);
    print(_titleController.text);
    if(_titleController.text.isNotEmpty&&_noteController.text.isNotEmpty){
      _addMedToDb();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CalenderPage()));
    }else if(_titleController.text.isEmpty || _noteController.text.isEmpty){
      scaffoldMessenger.showSnackBar(
        mySnackBar("Provide Title and Note"),
      );
    }

  }

  getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2121)
    );

    if(_pickerDate!=null){
      setState(() {
        _selectedDate = _pickerDate;
      });
    }else{
      print("Its null or sth");
    }
}

getTimeFromUser({required bool isStartTime}) async {
var pickedTime = await _showTimePicker();
String _formatedTime = pickedTime.format(context);

if(pickedTime==null){

  print("Time Cancelled");

}else if(isStartTime==true){

setState(() {
  _startTime= _formatedTime;
});

}else if(isStartTime==false){

setState(() {
  _endTime=_formatedTime;
});
  
}
}

_showTimePicker(){
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          //_startTime --> 10:30 AM
            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
        ),
    );
}

_addMedToDb() async {
    int value = await _taskController.addTask(
      task:Task(
        note: _noteController.text,
        title: _titleController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColor,
        isCompleted:0,
      )
    );
    print("My id is "+"$value");
}

}
