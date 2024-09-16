import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:storyweb/utils/string_const.dart';

class AppDescTextWidget extends StatelessWidget {
  const AppDescTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: size.width>700? size.width*0.6:size.width*0.8),
      child: SelectableText(
        StringConsts.desc,
        textAlign: TextAlign.center,
        style: GoogleFonts.lexend(
          color: const Color.fromRGBO(86, 93, 109, 1),
          fontSize: size.width>700? size.width*0.01:size.width*0.03,
        ),
      ),
    );
  }
}
