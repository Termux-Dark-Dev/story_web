import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:storyweb/bloc/home_bloc.dart';
import 'package:storyweb/utils/string_const.dart';
import 'package:storyweb/widgets/app_desc_text.dart';
import 'package:storyweb/widgets/custom_app_bar.dart';
import 'package:storyweb/widgets/main_slogan_text.dart';
import 'package:storyweb/widgets/story_card_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(size.width, 60),
              child: CustomAppBar(
                size: Size(size.width, 60),
              ),
            ),
            body: const FlexibleHomeScreen()));
  }
}

class FlexibleHomeScreen extends StatelessWidget {
  const FlexibleHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: size.height - 60,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SloganText(
                fontSize:
                    size.width > 700 ? size.width * 0.04 : size.width * 0.06,
              ),
              SizedBox(
                height:
                    size.width > 700 ? size.height * 0.01 : size.height * 0.03,
              ),
              const AppDescTextWidget(),
              SizedBox(
                height: size.height * 0.1,
              ),
              const MiddleBody(),
              SizedBox(
                height: size.height * 0.1,
              ),
              // generate button
              const LowerBtn(),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MiddleBody extends StatelessWidget {
  const MiddleBody({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder(
      bloc: context.read<HomeBloc>(),
      builder: (context, state) {
        if (state is HomeInitialState) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width * 0.6),
            child: TextField(
                controller: state.textEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: "Write your story idea here",
                  hintStyle: GoogleFonts.lexend(
                    color: const Color.fromRGBO(86, 93, 109, 1),
                    fontSize: size.width > 700
                        ? size.width * 0.01
                        : size.width * 0.03,
                  ),
                  errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(189, 193, 202, 1))),
                  enabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(189, 193, 202, 1))),
                )),
          );
        } else if (state is HomeSuccessState) {
          return StoryPlayerWidget(
              storyText: state.storyText,
              audioPlayer: state.audioPlayer,
              audioBytes: state.audioBytes,
              height: size.width>700? size.height * 0.12:size.height*0.14);
        } else if (state is HomeErrorState) {
          return const Center(
            child: Text("Something Occured"),
          );
        } else {
          return const Center(
              child: SizedBox(
            height: 40,
            width: 40,
            child: CircularProgressIndicator(),
          ));
        }
      },
    );
  }
}

class LowerBtn extends StatelessWidget {
  const LowerBtn({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder(
        bloc: context.read<HomeBloc>(),
        builder: (context, state) {
          if (state is HomeInitialState) {
            return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    backgroundColor: const Color.fromRGBO(109, 49, 237, 1)),
                onPressed: () {
                  context.read<HomeBloc>().add(GenerateButtonClickedEvent(
                      text: state.textEditingController.text));
                },
                child: Text(
                  StringConsts.generate,
                  style: GoogleFonts.lexend(color: Colors.white),
                ));
          } else if (state is HomeErrorState) {
            return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    backgroundColor: const Color.fromRGBO(109, 49, 237, 1)),
                onPressed: () {
                  context
                      .read<HomeBloc>()
                      .add(GenerateButtonClickedEvent(text: state.text));
                },
                child: Text(
                  "Retry",
                  style: GoogleFonts.lexend(color: Colors.white),
                ));
          } else if (state is HomeSuccessState) {
            return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    backgroundColor: const Color.fromRGBO(109, 49, 237, 1)),
                onPressed: () {
                  context.read<HomeBloc>().add(RegenerateButtonClickedEvent());
                },
                child: Text(
                  StringConsts.regenerate,
                  style: GoogleFonts.lexend(color: Colors.white),
                ));
          } else {
            // loading State
            return ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth:
                      size.width > 700 ? size.width * 0.15 : size.width * 0.6),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      backgroundColor: const Color.fromRGBO(109, 49, 237, 1)),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Generating",
                        style: GoogleFonts.lexend(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    ],
                  )),
            );
          }
        });
  }
}
