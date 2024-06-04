import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import '../model/step.dart';
import '../widget/barchart.dart';

List<DateTime> getDatesOfCurrentWeek() {
  DateTime now = DateTime.now();

  DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

  List<DateTime> datesOfWeek = [];
  for (int i = 0; i < 7; i++) {
    datesOfWeek.add(startOfWeek.add(Duration(days: i)));
  }
  return datesOfWeek;
}

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _State();
}

class _State extends State<AnalysisScreen> {
  FirebaseDatabase _realtime = FirebaseDatabase.instance;
  late Future<List<StepModel>> listFuture;
  late Future<List> goalFuture;

  @override
  void initState() {
    super.initState();
    listFuture = fetch();
    // goalFuture = getGoal();
  }

  Future<List> getGoal() async {
    var date = getDatesOfCurrentWeek();
    List goalList = [];
    for (var i in date) {
      String formattedDate = DateFormat("yyyyMMdd").format(i);
      DataSnapshot snapshot =
      await _realtime.ref("steps/$formattedDate/memberGoal/goal").get();
      if (snapshot.value != null && snapshot.value != null) {
        int data = snapshot.value as int;
        print(data);
        goalList.add(data);
      } else {
        goalList.add("0");
      }
    }
    return goalList;
  }

  Future<List<StepModel>> fetch() async {
    List<StepModel> list = [];
    var date = getDatesOfCurrentWeek();
    for (var i in date) {
      String formattedDate = DateFormat("yyyyMMdd").format(i);
      DataSnapshot snapshot =
      await _realtime.ref("steps/$formattedDate").get();
      if (snapshot.value != null) {
        dynamic data = snapshot.value;

        String maxKey = data.keys.reduce((a, b) => int.parse(a) > int.parse(b) ? a : b);
        list.add(StepModel(
            data[maxKey]["step"].toString(), data[maxKey]["time"].toString()));
      } else {
        list.add(StepModel("0", "0"));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: listFuture,
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text("데이터를 불러올 수 없습니다."));
          } else {
            List<StepModel> steps = snapshot.data as List<StepModel>;
            // List goalList = snapshot.data![1];
            // print(goalList);
            return Container(
              child: BarChartSample1(list: steps,),
            );
          }
        },
      ),
    );
  }
}
