import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emergency Sound Detector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SoundDetectorScreen(),
    );
  }
}

class SoundDetectorScreen extends StatefulWidget {
  @override
  _SoundDetectorScreenState createState() => _SoundDetectorScreenState();
}

class _SoundDetectorScreenState extends State<SoundDetectorScreen> {
  static const EventChannel _eventChannel =
      EventChannel('com.example/emergency_sound_event');

  StreamSubscription? _eventSubscription;

  @override
  void initState() {
    super.initState();
    _eventSubscription = _eventChannel.receiveBroadcastStream().listen(
      (event) {
        if (event == 'emergency_sound_detected') {
          _handleEmergencySoundDetected();
        }
      },
      onError: (error) {
        print('Error listening to sound events: $error');
      },
    );
  }

  void _handleEmergencySoundDetected() async {
    print('Emergency sound detected!');
    Vibration.vibrate(duration: 2000);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Emergency Sound Detected'),
        content: Text('Please take necessary action!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Sound Detector'),
      ),
      body: Center(
        child: Text(
          'Listening for Emergency Sounds...',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
