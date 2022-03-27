import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medi_health1/Constants.dart';
import 'Constants.dart';


class MyInputField extends StatelessWidget {

  final String title;
  final String hint;
  final TextEditingController? inputfieldcontroller;
  final Widget? widget;
  const MyInputField({Key? key, required this.title, required this.hint, this.inputfieldcontroller, this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            height: 52,
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.only(left: 14),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width:1.0,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  readOnly: widget==null?false:true,
                  autofocus: false,
                  controller: inputfieldcontroller,
                  style: subTitleStyle,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: subTitleStyle,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: context.theme.backgroundColor,
                        width: 0,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: context.theme.backgroundColor,
                        width: 0,
                      ),
                    ),
                  ),
                )
                ),
                widget==null?Container():Container(child: widget)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
