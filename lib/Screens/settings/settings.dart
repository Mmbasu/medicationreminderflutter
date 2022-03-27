import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medi_health1/Screens/login/login.dart';

import '../../mywidget.dart';
import '../../sharedprefferences.dart';


class MySettings extends StatefulWidget {
  const MySettings({Key? key}) : super(key: key);

  @override
  State<MySettings> createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
  final Preferences _prefs = Preferences();

  String loginUser = " ";
  @override
  late ScaffoldMessengerState scaffoldMessenger;

  Widget build(BuildContext context) {

    _prefs.getStringValuesSF("firstname").then((firstname) => {
      setState(() => {
        //print(firstname),
        loginUser = firstname!
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
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.fingerprint,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.red,
                    ),
                    title: 'Privacy',
                    subtitle: "Lock the App to improve your privacy",
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.dark_mode_rounded,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.red,
                    ),
                    title: 'Dark mode',
                    subtitle: "Automatic",
                    trailing: Switch.adaptive(
                      value: false,
                      onChanged: (value) {},
                    ),
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
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => firstLoginPage()));
                      scaffoldMessenger.showSnackBar(
                        mySnackBar("Logged Out Successfully"),
                      );
                    },
                    icons: Icons.exit_to_app_rounded,
                    title: "Sign Out",
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: CupertinoIcons.repeat,
                    title: "Change email",
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: CupertinoIcons.delete_solid,
                    title: "Delete account",
                    titleStyle: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}