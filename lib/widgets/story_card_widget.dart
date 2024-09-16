import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class StoryPlayerWidget extends StatefulWidget {
  final double height;
  final AudioPlayer audioPlayer;
  final String storyText;
  final Uint8List audioBytes;
  const StoryPlayerWidget(
      {super.key,
      required this.height,
      required this.storyText,
      required this.audioBytes,
      required this.audioPlayer});

  @override
  State<StoryPlayerWidget> createState() => _StoryPlayerWidgetState();
}

class _StoryPlayerWidgetState extends State<StoryPlayerWidget> {
  late List<Map<String, dynamic>> lyricsWithTiming;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  // Function to generate timestamps for given lyrics
  List<Map<String, dynamic>> generateTimestamps(
      List<String> lyrics, double wps) {
    List<Map<String, dynamic>> timestamps = [];
    double totalDuration = 0.0; // Total duration in seconds

    for (String line in lyrics) {
      // Calculate duration for this line
      int wordCount =
          line.split(RegExp(r'\s+')).length; // Count words in the line
      double lineDuration = wordCount / wps;

      // Add timestamp for this line
      timestamps.add({
        'text': line,
        'startTime': totalDuration,
        'endTime': totalDuration + lineDuration,
      });

      // Update total duration
      totalDuration += lineDuration;
    }

    return timestamps;
  }

  // Function to convert a block of text into structured lyrics with timestamps using regex
  List<Map<String, dynamic>> textToLyrics(String text, double wps) {
    // Regex pattern to split text by punctuation or line breaks
    RegExp pattern = RegExp(
        r'(?<=[.!?])\s+|\n+'); // Split on punctuation followed by spaces or new lines

    // Split the text into lines or phrases
    List<String> lines =
        text.split(pattern).where((line) => line.trim().isNotEmpty).toList();

    // Generate timestamps for the lyrics
    return generateTimestamps(lines, wps);
  }

  @override
  void initState() {
    super.initState();
    lyricsWithTiming = textToLyrics(widget.storyText, 2.5);
    widget.audioPlayer.setSourceBytes(widget.audioBytes);
    widget.audioPlayer.onPlayerComplete.listen((data) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _currentPosition = Duration.zero;
        });
      }
    });
    widget.audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        _totalDuration = newDuration;
        setState(() {});
      }
    });

    widget.audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        _currentPosition = newPosition;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    widget.audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        LyricsWidget(
          currenPos: _currentPosition,
          lyrics: lyricsWithTiming,
          height: widget.height,
        ),
        SizedBox(
          height: size.height * 0.05,
        ),
        MainAudioPlayer(
            onBtnClick: () {
              if (_isPlaying) {
                widget.audioPlayer.pause();
                setState(() {
                  _isPlaying = false;
                });
              } else {
                widget.audioPlayer.resume();
                setState(() {
                  _isPlaying = true;
                });
              }
            },
            height: widget.height,
            playerIcon: _isPlaying ? Icons.pause : Icons.play_arrow,
            startTime:
                _formatDuration(Duration(seconds: _currentPosition.inSeconds)),
            endTime:
                _formatDuration(Duration(seconds: _totalDuration.inSeconds)),
            currval: _currentPosition.inSeconds.toDouble(),
            totalVal: _totalDuration.inSeconds.toDouble(),
            onSliderChangeCallBack: (value) {
              widget.audioPlayer.seek(Duration(seconds: value.toInt()));
            }),
      ],
    );
  }
}

class LyricsWidget extends StatefulWidget {
  final Duration currenPos;
  final List<Map<String, dynamic>> lyrics;
  final double height;
  const LyricsWidget(
      {super.key,
      required this.height,
      required this.lyrics,
      required this.currenPos});

  @override
  State<LyricsWidget> createState() => _LyricsWidgetState();
}

class _LyricsWidgetState extends State<LyricsWidget> {
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant LyricsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateCurrentLine();
  }

  void _updateCurrentLine() {
    for (int i = 0; i < widget.lyrics.length; i++) {
      if (widget.currenPos.inSeconds >= widget.lyrics[i]['startTime'] &&
          widget.currenPos.inSeconds < widget.lyrics[i]['endTime']) {
        setState(() {
          _currentIndex = i;
        });

        // Scroll to the current line smoothly if needed
        WidgetsBinding.instance.addPostFrameCallback((_) {
          double targetScrollOffset = _currentIndex * 50;
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(
              targetScrollOffset,
            );
          }
        });

        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width > 700 ? size.width * 0.6 : size.width * 0.9,
      height: widget.height * 2,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(offset: Offset(0, 4), spreadRadius: 0, blurRadius: 8)
          ]),
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.lyrics.map((line) {
            final isHighlighted = widget.lyrics.indexOf(line) == _currentIndex;
            return Container(
              height: 50,
              padding: const EdgeInsets.symmetric(vertical: 2),
              alignment: Alignment.center,
              child: Text(
                line["text"],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight:
                      isHighlighted ? FontWeight.bold : FontWeight.normal,
                  color: isHighlighted ? Colors.blue : Colors.black,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class MainAudioPlayer extends StatelessWidget {
  final double height;
  final IconData playerIcon;
  final String startTime, endTime;
  final double currval, totalVal;
  final void Function(double) onSliderChangeCallBack;
  final VoidCallback onBtnClick;

  const MainAudioPlayer(
      {super.key,
      required this.startTime,
      required this.endTime,
      required this.currval,
      required this.totalVal,
      required this.onBtnClick,
      required this.playerIcon,
      required this.height,
      required this.onSliderChangeCallBack});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width > 700 ? size.width * 0.6 : size.width * 0.9,
      height: height,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(offset: Offset(0, 4), spreadRadius: 0, blurRadius: 8)
          ]),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          IconButton(
            style: IconButton.styleFrom(
                backgroundColor: const Color.fromRGBO(149, 39, 237, 1)),
            onPressed: onBtnClick,
            icon: Icon(
              playerIcon,
              color: Colors.white,
            ),
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(startTime), Text(endTime)],
                ),
              ),
              Slider(
                  value: currval,
                  min: 0,
                  max: totalVal,
                  onChanged: onSliderChangeCallBack),
            ],
          ))
        ],
      ),
    );
  }
}
