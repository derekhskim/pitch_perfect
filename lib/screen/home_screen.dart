import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';

import 'dart:typed_data';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Has the tuner started?
  ///
  /// Default is always false which means it has not started yet
  ///
  /// It shows an image file when in false status
  bool _hasPitchDetectingStarted = false;

  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);
  final pitchupDart = PitchHandler(InstrumentType.guitar);

  var note = '';
  var status = 'Press the Image!';

  final String iOSTestUnitId = 'ca-app-pub-3940256099942544/2934735716';
  final String androidTestUnitId = 'ca-app-pub-3940256099942544/6300978111';

  getPermission() async {
    var status = await Permission.microphone.status;
    if (status.isGranted) {
      print('Approved');
    } else if (status.isDenied) {
      print('Refused');
      Permission.microphone.request();
    }
  }

  BannerAd? banner;

  @override
  void initState() {
    super.initState();
    getPermission();

    banner = BannerAd(
      listener: BannerAdListener(),
      size: AdSize.banner,
      adUnitId: Platform.isIOS ? 'ca-app-pub-1461016926202144/6836157814' : 'ca-app-pub-1461016926202144/7774653201',
      request: AdRequest(),
    )..load();
  }

  // Start Button - Capturing Audio Begins
  Future<void> _startCapture() async {
    await _audioRecorder.start(
        listener, onError, // Error will appear when audio sample cannot be obtained
        sampleRate: 44100,
        bufferSize: 3000);

    setState(() {
      note = '';
      status = 'Please Sing!';
      _hasPitchDetectingStarted = true;
    });
  }

  // Stop Button - Stops Audio Capturing
  Future<void> _stopCapture() async {
    await _audioRecorder.stop();

    setState(() {
      note = '';
      status = 'Press Start!';
      _hasPitchDetectingStarted = false;
    });
  }

  void listener(dynamic obj) {
    // Calling Audio Samples In
    var buffer = Float64List.fromList(obj.cast<double>());
    final List<double> audioSample = buffer.toList();

    // pitch_detector_dart library allows translating from audio sample to actual pitch
    final result = pitchDetectorDart.getPitch(audioSample);

    // When pitch has been found - it shows which note it is
    if (result.pitched) {
      // pitchupDart library allows finding note using comparison from guitar
      final handledPitchResult = pitchupDart.handlePitch(result.pitch);

      // Updating state to show the result of the note
      setState(() {
        note = handledPitchResult.note;
        status = '';
      });
    }
  }

  void onError(Object e) {
    print(e);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 25,
      fontWeight: FontWeight.bold,
    );

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pitch Perfect'), // Title
          backgroundColor: const Color(0xFF2A3A7C),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: getBoxDecoration(), // Background Gradiation Widget Add
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      note,
                      style: textStyle.copyWith(
                          fontSize:
                              70), // This was added to show notes in the middle.
                    ),
                    SingleChildScrollView(
                      child: Visibility(
                        visible:
                            !_hasPitchDetectingStarted,
                        child: _Logo(
                          onTap: _startCapture,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        status,
                        style: textStyle.copyWith(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 70),
                    SingleChildScrollView(
                      child: Visibility(
                        visible:
                            _hasPitchDetectingStarted,
                        child: SizedBox(
                          child: FloatingActionButton(
                              onPressed: _stopCapture, child: const Text('Stop')),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: banner == null
                    ? Container()
                    : AdWidget(
                  ad: banner!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration getBoxDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF2A3A7C),
          Color(0xFF000118),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final VoidCallback onTap;

  const _Logo({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        'assets/image/Sing.png',
        height: 450,
        width: 300,
      ),
    );
  }
}
