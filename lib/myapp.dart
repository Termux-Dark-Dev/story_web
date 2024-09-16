import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyweb/bloc/home_bloc.dart';
import 'package:storyweb/screens/home_screen/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: const MaterialApp(
        title: "Story Web",
          debugShowCheckedModeBanner: false, home: HomeScreen()),
    );
  }
}
