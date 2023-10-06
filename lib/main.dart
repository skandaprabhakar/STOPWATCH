import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stopwatch App',
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 60, 29, 115),
      ),
      home: StopwatchPage(),
    );
  }
}

class StopwatchPage extends StatefulWidget {
  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  bool _isRunning = false;
  List<String> _laps = [];
  int _milliseconds = 0;
  late Timer _timer;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startStopwatch() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
      setState(() {
        _milliseconds += 100;
      });
    });
  }

  void _stopStopwatch() {
    _timer.cancel();
  }

  void _resetStopwatch() {
    setState(() {
      _milliseconds = 0;
      _laps.clear();
    });
  }

  void _recordLap() {
    setState(() {
      _laps.insert(0, formatTime(_milliseconds));
    });
  }

  String formatTime(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr:$hundredsStr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        title: Text(
          'STOPWATCH',
          style: TextStyle(letterSpacing: 10, fontWeight: FontWeight.w900),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              formatTime(_milliseconds),
              style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_isRunning) {
                        _stopStopwatch();
                      } else {
                        _startStopwatch();
                      }
                      _isRunning = !_isRunning;
                    });
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
                  child: Text(_isRunning ? 'Stop' : 'Start',
                      style: TextStyle(fontSize: 20)),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_isRunning) {
                      _recordLap();
                    } else {
                      _resetStopwatch();
                    }
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
                  child: Text(_isRunning ? 'Lap' : 'Reset',
                      style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _laps.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Lap ${index + 1}',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    subtitle: Text(_laps[index],
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
