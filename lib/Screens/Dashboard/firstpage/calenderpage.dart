import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:medi_health1/addmedpage.dart';
import 'package:medi_health1/controllers/medicationcontroller.dart';

import '../../../Constants.dart';
import '../../../models/medication.dart';
import '../../../notification_services.dart';
import '../../../tasktile.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage({Key? key}) : super(key: key);

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());

  var notifyHelper;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    //notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.yMMMMd().format(DateTime.now()),
                        style: subHeadingStyle,
                      ),
                      Text(
                        "Today",
                        style: HeadingStyle,
                      ),
                    ],
                  ),
                ),

                GestureDetector(
                    child: Text(
                      "Add Med",
                      style:
                      TextStyle(color: Color(0xFF94C3DD), fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  onTap: () async{
                      await Get.to(()=> AddMedPage());
                      _taskController.getTasks();
                      // notifyHelper.scheduledNotification();

                  },
                ),
              ],
            ),
          ),
          Container (
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Expanded(
                    child: DatePicker(DateTime.now(),
                        height: 100,
                        width: 80,
                        initialSelectedDate: DateTime.now(),
                        selectionColor: Color(0xFF94C3DD),
                        selectedTextColor: Colors.white,
                        dateTextStyle: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        dayTextStyle: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize:16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        monthTextStyle: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      onDateChange: (date){
                      setState(() {
                        _selectedDate=date;
                      });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks(){
    return Expanded(
      child:Obx((){
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index){
              Task task = _taskController.taskList[index];
              //print(task.toJson());
              if(task.repeating=='Daily') {
                DateTime date = DateFormat.jm().parse(task.startTime.toString());
                var myTime = DateFormat("HH:mm").format(date);
                notifyHelper.scheduledNotification(
                  int.parse(myTime.toString().split(":")[0]),
                  int.parse(myTime.toString().split(":")[1]),
                  task

                );


                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: (){
                                  _showBottomSheet(context, task);
                                },
                                child: TaskTile(task)
                            )
                          ],
                        ),
                      ),
                    ));

              }
              if (task.date==DateFormat.yMd().format(_selectedDate)){
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: (){
                                  _showBottomSheet(context, task);
                                },
                                child: TaskTile(task)
                            )
                          ],
                        ),
                      ),
                    ));
              }
              else{
                return Container();
              }

            });
      }),
    );
  }

  _showBottomSheet(BuildContext context, Task task){
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted==1?
        MediaQuery.of(context).size.height*0.24:
        MediaQuery.of(context).size.height*0.32,
          color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300]
                ),
            ),
            Spacer(),
            task.isCompleted==1?
                Container():
                _botomSheetButton(
                    label: "Medication Taken",
                    onTap: (){
                      _taskController.markTaskCompleted(task.id!);
                      Get.back();
                    },
                    clr: primaryColor,
                  context: context,
                ),

            _botomSheetButton(
              label: "Delete Medication",
              onTap: (){
                _taskController.delete(task);
                Get.back();
              },
              clr: Colors.red[300]!,
              context: context,
            ),
            SizedBox(
              height: 20,
            ),
            _botomSheetButton(
              label: "Close",
              onTap: (){
                Get.back();
              },
              clr: Colors.red[300]!,
              isClose:true,
              context: context,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),

      ),
    );
  }

  _botomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
})
  {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose==true?Colors.grey[300]!:clr
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose==true?Colors.transparent:clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose?titleStyle:titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );

  }

}
