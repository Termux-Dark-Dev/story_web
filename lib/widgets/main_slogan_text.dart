import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:storyweb/utils/string_const.dart';

class SloganText extends StatelessWidget {
  final double fontSize;
  const SloganText({super.key,required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
        textAlign: TextAlign.center,
        TextSpan(
            text: StringConsts.narrativeTitle,
            style: GoogleFonts.lexend(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(0, 29, 81, 1)),
            children: [
              TextSpan(
                  text: StringConsts.narrativeTitle2,
                  style: GoogleFonts.lexend(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromRGBO(109, 47, 231, 1))),
              TextSpan(
                  text: ",",
                  style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold)),
              TextSpan(
                text: StringConsts.narrativeTitle3,
                style: GoogleFonts.lexend(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(21, 171, 255, 1)),
              ),
              TextSpan(
                  text: ",",
                  style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold)),
              TextSpan(
                text: StringConsts.narrativeTitle4,
                style: GoogleFonts.lexend(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(18, 81, 188, 1)),
              )
            ]));
  }
}
