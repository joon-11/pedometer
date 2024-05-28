class StepModel {
  String step;
  String time;
  StepModel({required this.step, required this.time});
  factory StepModel.fromJson(Map<dynamic, dynamic> json) {
    return StepModel(
      step: json['step'],
      time: json['time'],
    );
  }
}
