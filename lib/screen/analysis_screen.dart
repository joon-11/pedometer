//analysis
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../model/step.dart';


class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _State();
}

class _State extends State<AnalysisScreen> {
  FirebaseDatabase _realtime = FirebaseDatabase.instance;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    DataSnapshot ref = await _realtime.ref("step/20240527").get();
    Map<dynamic, dynamic> data = ref.value as Map<dynamic, dynamic>;

    data.forEach((key, value) {
      print(value['step']);
      print(value['time']);
    });
  }
  // @override
  // void initState(){
  //   super.initState();
  //   fetch();
  // }
  //
  // Future<void> fetch() async{
  //   DatabaseReference ref = FirebaseDatabase.instance.ref("steps/2024527");
  //   DataSnapshot snapshot = await ref.get();
  //
  //   Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
  //   print(data.values);
  //
  //   // List<StepModel> _data = data.values.map((e) => StepModel.fromJson(e)).toList();
  //   // print(_data);
  //   // snapshot.ref.onValue.listen((event) {
  //   //   print(event.snapshot.value);
  //   // });
  //   // data.forEach((key, value) {
  //   //   var temp = jsonDecode(value);
  //   //   print(temp);
  //   // });
  //   // print(steps);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text("asdad"),),
      ),
    );
  }
}
