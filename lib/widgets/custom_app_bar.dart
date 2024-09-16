import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:storyweb/utils/string_const.dart';

class CustomAppBar extends StatelessWidget {
  final Size size;
  const CustomAppBar({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
      color: Colors.white,
      padding: const EdgeInsets.only(left: 24),
      child: Row(
        mainAxisAlignment: size.width > 700
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/logo.png",
            fit: BoxFit.contain,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            StringConsts.appName,
            style: GoogleFonts.lexend(fontSize: 28,fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
