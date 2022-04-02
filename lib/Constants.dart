import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//colors
const maincolor = const Color(0xFF0E243C);
const backgroundColor = Colors.white;

//Color(0xFF2E8BC0)

const primaryColor = Color(0xFF94C3DD);
const pinkColor = Color(0xFFEF7C8E);
const orangeColor= Color(0xFFFBAA60);



TextStyle get subHeadingStyle{
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
        color: Colors.grey
    )
  );
}

TextStyle get HeadingStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold
      )
  );
}


TextStyle get titleStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold
      )
  );
}

TextStyle get subTitleStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey
      )
  );
}



//strings
