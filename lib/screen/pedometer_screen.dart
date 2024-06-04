import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

class PedometerPage extends StatefulWidget {
  @override
  _PedometerPageState createState() => _PedometerPageState();
}

class _PedometerPageState extends State<PedometerPage> {
  FirebaseDatabase _realtime = FirebaseDatabase.instance;
  DateTime now = DateTime.now();
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';
  int _seconds = 0;
  bool _isRunning = false;
  late Timer _timer;
  int goal = 0;

  void _startTimer() {
    _isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    _isRunning = false;
    _timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    getGoal();
  }

  Future<void> getGoal() async {
    String date = DateFormat("yyyyMMdd").format(now);
    DataSnapshot ref = await _realtime.ref("steps/${date}/memberGoal/goal").get();
    int data = ref.value as int;
    print(data);
    setState(() {
      goal = data;
    });
  }

  void onStepCount (StepCount event) async{
    setState(() {
      _steps = event.steps.toString();
    });
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMdd').format(now);
    String timeString = DateFormat('HHmmss').format(now);
    await _realtime.ref().child("steps").child(formattedDate).child(timeString).set({
      "step": _steps,
      "time": timeString,
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _status = event.status;
    });
    walkStatus();
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  void walkStatus() {
    print(_status);
    if (_status == 'walking' && !_isRunning) {
      _startTimer();
    } else if (_status != 'walking' && _isRunning) {
      _stopTimer();
    }
  }

  String formatTime(int seconds) {
    if (seconds < 60) {
      return '$seconds 초';
    } else if (seconds < 3600) {
      int minutes = seconds ~/ 60;
      int remainingSeconds = seconds % 60;
      return '$minutes 분 $remainingSeconds 초';
    } else {
      int hours = seconds ~/ 3600;
      int remainingMinutes = (seconds % 3600) ~/ 60;
      return '$hours 시간 $remainingMinutes 분';
    }
  }

  double percent(){
    var percent = double.parse(_steps)/goal;
    if(percent > 1){
      return 1.0;
    }else{
      return percent;
    }
  }

  @override
  Widget build(BuildContext context) {
    double steps = double.tryParse(_steps) ?? 0;
    int caloriesBurned = (steps * 0.03).round(); // Convert to int to remove decimal points

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("만보기"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularPercentIndicator(
                radius: 120.0,
                lineWidth: 13.0,
                animation: true,
                percent: percent(),
                center: Text(
                  _steps,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 40.0),
                ),
                progressColor: Colors.yellow,
                circularStrokeCap: CircularStrokeCap.round,
              ),
              Text('목표: ${goal}'),
              const Divider(
                height: 100,
                thickness: 0,
                color: Colors.white,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "시간\n${formatTime(_seconds)}",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "칼로리 소모\n$caloriesBurned",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: Column(
                      children: [
                        Text(
                          "거리\n???",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
