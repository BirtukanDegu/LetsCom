import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import './sound_to_text.dart';

enum SpeechMode {
  STT,
  TTS,
}

class TextToSpeechScreen extends StatefulWidget {
  final SpeechMode mode;

  const TextToSpeechScreen({Key? key, required this.mode}) : super(key: key);

  @override
  _TextToSpeechScreenState createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  late FlutterTts flutterTts;
  late TextEditingController _textEditingController;
  double _volume = 0.5;
  double _pitch = 1.0;
  double _rate = 0.8;
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    _textEditingController = TextEditingController();
    initTts();
  }

  Future<void> initTts() async {
    await flutterTts.setLanguage('am-ET');
    await flutterTts.setPitch(_pitch);
    await flutterTts.setSpeechRate(_rate);
    await flutterTts.setVolume(_volume);
  }

  Future<void> speak() async {
    String text = _textEditingController.text;
    if (text.isNotEmpty) {
      await flutterTts.speak(text);
    }
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }

  @override
  void dispose() {
    flutterTts.stop();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.mode == SpeechMode.STT ? 'Speech to Text' : 'Text to Speech';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    labelText: 'Enter text',
                  ),
                ),
                SizedBox(height: 16.0),
                _buildSlider(
                  value: _volume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  onChanged: (newValue) {
                    setState(() {
                      _volume = newValue;
                      flutterTts.setVolume(_volume);
                    });
                  },
                  label: 'Volume',
                ),
                _buildSlider(
                  value: _pitch,
                  min: 0.5,
                  max: 2.0,
                  divisions: 15,
                  onChanged: (newValue) {
                    setState(() {
                      _pitch = newValue;
                      flutterTts.setPitch(_pitch);
                    });
                  },
                  label: 'Pitch',
                ),
                _buildSlider(
                  value: _rate,
                  min: 0.5,
                  max: 1.5,
                  divisions: 10,
                  onChanged: (newValue) {
                    setState(() {
                      _rate = newValue;
                      flutterTts.setSpeechRate(_rate);
                    });
                  },
                  label: 'Rate',
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: speak,
                      child: Text('Speak'),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff304a6e), // Set the button color to 0xff304a6e
                      ),
                    ),
                    SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: stop,
                      child: Text(
                        'Stop',
                        style: TextStyle(
                          color: Color(0xff304a6e), // Set the text color to 0xff304a6e
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xffe9ebf0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 16.0,
            bottom: 16.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _isMenuOpen = !_isMenuOpen;
                    });
                  },
                  child: Icon(Icons.menu),
                  tooltip: 'Services',
                ),
                SizedBox(height: 16.0),
                AnimatedOpacity(
                  opacity: _isMenuOpen ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: ServicesMenu(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
          label: value.toStringAsFixed(2),
        ),
      ],
    );
  }
}
