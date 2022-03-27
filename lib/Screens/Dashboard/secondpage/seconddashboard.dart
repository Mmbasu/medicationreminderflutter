import 'package:flutter/material.dart';
import 'package:medi_health1/Screens/removemedication/removemed.dart';

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => removemed()));
        },
        icon: Icon(Icons.remove),
        backgroundColor: Color(0xFF94C3DD),
        label: Text("Remove Med"),
      ),
    );
  }
}