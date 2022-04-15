import 'dart:convert';

import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:medi_health1/Screens/login/login.dart';
import 'package:medi_health1/changepassword.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants.dart';
import '../../mywidget.dart';
import '../../sharedprefferences.dart';
import 'package:http/http.dart'as http;


class MySettings extends StatefulWidget {
  const MySettings({Key? key}) : super(key: key);

  @override
  State<MySettings> createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
  final Preferences _prefs = Preferences();

  String loginUser = " ";
  String logoutUser = " ";
  @override
  late ScaffoldMessengerState scaffoldMessenger;

  Widget build(BuildContext context) {

    _prefs.getStringValuesSF("firstname").then((firstname) => {
      setState(() => {
        //print(firstname),
        loginUser = firstname!,
      })
    });

    _prefs.getStringValuesSF("emailAddress").then((emailAddress) => {
      setState(() => {
        //print(emailAddress),
        logoutUser = emailAddress!,
      })
    });


    scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
        backgroundColor: Colors.white.withOpacity(.94),
        appBar: AppBar(
          title: Text(
            "Settings",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              // user card
              SimpleUserCard(
                userName: loginUser,
                userProfilePic: NetworkImage("https://medihealth2.000webhostapp.com/userprofilepictures/griffin.jpg"),
              ),
              SettingsGroup(
                items: [
                  // SettingsItem(
                  //   onTap: () {},
                  //   icons: Icons.fingerprint,
                  //   iconStyle: IconStyle(
                  //     iconsColor: Colors.white,
                  //     withBackground: true,
                  //     backgroundColor:Color(0xFF94C3DD) ,
                  //   ),
                  //   title: 'Privacy',
                  //   subtitle: "Lock the App to improve your privacy",
                  // ),
                  SettingsItem(
                    onTap: (){
                      _showBottomSheet(context);
                    },
                    icons: Icons.help,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Color(0xFF94C3DD),
                    ),
                    title: 'Help & Support',
                    subtitle: "Need Help",
                  ),
                  SettingsItem(
                    onTap: () {
                      Share.share("https://play.google.com/store/apps/details?id=com.instructivetech.testapp");
                    },
                    icons: Icons.share_sharp,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor:Color(0xFF94C3DD) ,
                    ),
                    title: 'Share',
                    subtitle: "Spread the word",
                  ),
                ],
              ),
              SettingsGroup(
                items: [
                  SettingsItem(
                    onTap: () {
                      showAboutDialog(
                          context: context,
                        applicationIcon: FlutterLogo(),
                        applicationName: "About Medi-health",
                        applicationVersion: "0.0.1",
                        applicationLegalese: "Developed by IntolerableMouse",
                        children: <Widget>[
                          Text(
                            "Medi-health, the Kenyan Medicines and Medical Devices Safety Authority, is the medical regulatory body run by the Kenyan Ministry of Health, administering the Medicines Act 1981 and Medicines Regulations 1984. Medi-health employs approximately 60 staff members in two offices"
                          ),
                        ]
                      );
                    },
                    icons: Icons.info_rounded,
                    iconStyle: IconStyle(
                      backgroundColor: Colors.purple,
                    ),
                    title: 'About',
                    subtitle: "Learn more about the App",
                  ),
                ],
              ),
              // You can add a settings title
              SettingsGroup(
                settingsGroupTitle: "Account",
                items: [
                  SettingsItem(
                    onTap: () async {
                      removeValues();

                      await Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => firstLoginPage()));

                      scaffoldMessenger.showSnackBar(
                        mySnackBar("Logged Out Successfully"),
                      );
                    },
                    icons: Icons.exit_to_app_outlined,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor:Color(0xFF94C3DD) ,
                    ),
                    title: 'Log Out',

                  ),

                  SettingsItem(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => changePassword()));
                    },
                    icons: Icons.change_circle_outlined,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor:Color(0xFF94C3DD) ,
                    ),
                    title: 'Change Password',

                  ),
                  SettingsItem(
                    onTap: () {
                      _bottomSheet(context);
                    },
                    icons: Icons.delete_outlined,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor:Colors.red ,
                    ),
                    title: 'Delete Account',
                    // titleStyle: TextStyle(
                    //   color: Colors.red,
                    //   fontWeight: FontWeight.bold,
                    // ),

                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
  _showBottomSheet(context){
    showModalBottomSheet(context: context, builder: (BuildContext c){
      return Container(
        height: MediaQuery.of(context).size.height*0.32,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Contact us", style: HeadingStyle,),
            ),

            Divider(
              height: 2.0,
            ),

            ListTile(
              leading: Image.asset("assets/email.png",
              height: 40.0,
              ),
              title: Text("medihealth@health.com",
              style: TextStyle(
                fontSize: 14,
              ),
              ),
            ),

            Divider(
              height: 2.0,
            ),

            ListTile(
              leading: Image.asset("assets/twitter.png",
                height: 40.0,
              ),
              title: Text("@mediHealth",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),

            Divider(
              height: 2.0,
            ),

            ListTile(
              leading: Image.asset("assets/phone.png",
                height: 40.0,
              ),
              title: Text("+254712345678",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),

          ],
        ),
      );
    });
  }

  _bottomSheet(BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        elevation: 5,
        context: ctx,
        builder: (ctx) => Padding(
          padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text("This Action cannot be undone!!!! Would you like to continue",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),

              Divider(
                height: 2.0,
              ),
              const SizedBox(
                height: 15,
              ),
              _botomButton(label: "Delete Account", onTap: (){
                deleteAccount(logoutUser);
              }, clr: Colors.red[300]!, context: context),
              _botomButton(label: "Go Back", onTap: (){
                Get.back();
              }, clr: primaryColor, context: context)

            ],
          ),
        ));
  }
  _botomButton({
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

  deleteAccount(String email) async {
    DialogBuilder(context).showLoadingIndicator(
        "We are deleting your account", "Deleting");
    Map data = {'email': email};
    var jsonResponse;
    var response = await http.post(
        Uri.parse("https://medihealth2.000webhostapp.com/deleteaccount.php"),
        body: data);
    //use shared preferences to store username
    //in the shared preferences we can store the name
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
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => firstLoginPage()));
        } else {
          //wrongpassword use SnackBar to Show
          scaffoldMessenger.showSnackBar(
            mySnackBar("Wrong Credentials"),
          );
        }
      }
    } else {
      setState(() {
        DialogBuilder(context).hideOpenDialog();
      });
    }
  }


  removeValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(loginUser);
    prefs.remove(logoutUser);
    print("Removed Shared Preferences");

  }


}