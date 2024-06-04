import 'dart:async';
import 'dart:math';

import '../model/step.dart';
import 'colorExtension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'AppColor.dart';

class BarChartSample1 extends StatefulWidget {
  final List<StepModel> list;


  BarChartSample1({required this.list});

  List<Color> get availableColors => const <Color>[
        AppColors.contentColorPurple,
        AppColors.contentColorYellow,
        AppColors.contentColorBlue,
        AppColors.contentColorOrange,
        AppColors.contentColorPink,
        AppColors.contentColorRed,
      ];

  final Color barBackgroundColor =
      AppColors.contentColorWhite.darken().withOpacity(0.3);
  final Color barColor = AppColors.contentColorWhite;
  final Color touchedBarColor = AppColors.contentColorGreen;

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaterialApp(
        home: Column(
          children: [
            SizedBox(height: 25,),
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const Text(
                          '요일별 걸음수',
                          style: TextStyle(
                            color: AppColors.contentColorGreen,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          '일주일중 ~~~ 번 목표를 완수하셨어요!!',
                          style: TextStyle(
                            color: AppColors.contentColorGreen.darken(),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 38,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: BarChart(
                              isPlaying ? randomData() : mainBarData(),
                              swapAnimationDuration: animDuration,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: AppColors.contentColorGreen,
                        ),
                        onPressed: () {
                          setState(() {
                            isPlaying = !isPlaying;
                            if (isPlaying) {
                              refreshState();
                            }
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    barColor ??= widget.barColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? widget.touchedBarColor : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: widget.touchedBarColor.darken(80))
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            //최댓값 설정
            toY: 1000,
            color: widget.barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            StepModel model = widget.list[0];
            return makeGroupData(0, double.parse(model.step),
                isTouched: i == touchedIndex);
          case 1:
            StepModel model = widget.list[1];
            return makeGroupData(1, double.parse(model.step),
                isTouched: i == touchedIndex);
          case 2:
            StepModel model = widget.list[2];
            return makeGroupData(2, double.parse(model.step),
                isTouched: i == touchedIndex);
          case 3:
            StepModel model = widget.list[3];
            return makeGroupData(3, double.parse(model.step),
                isTouched: i == touchedIndex);
          case 4:
            StepModel model = widget.list[4];
            return makeGroupData(4, double.parse(model.step),
                isTouched: i == touchedIndex);
          case 5:
            StepModel model = widget.list[5];
            return makeGroupData(5, double.parse(model.step),
                isTouched: i == touchedIndex);
          case 6:
            StepModel model = widget.list[6];
            return makeGroupData(6, double.parse(model.step),
                isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            switch (group.x) {
              case 0:
                weekDay = '월요일';
                break;
              case 1:
                weekDay = '화요일';
                break;
              case 2:
                weekDay = '수요일';
                break;
              case 3:
                weekDay = '목요일';
                break;
              case 4:
                weekDay = '금요일';
                break;
              case 5:
                weekDay = '토요일';
                break;
              case 6:
                weekDay = '일요일';
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).toString(),
                  style: const TextStyle(
                    color: Colors.white, //widget.touchedBarColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('월', style: style);
        break;
      case 1:
        text = const Text('화', style: style);
        break;
      case 2:
        text = const Text('수', style: style);
        break;
      case 3:
        text = const Text('목', style: style);
        break;
      case 4:
        text = const Text('금', style: style);
        break;
      case 5:
        text = const Text('토', style: style);
        break;
      case 6:
        text = const Text('일', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 5,
      child: text,
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(
              0,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
                  Random().nextInt(widget.availableColors.length)],
            );
          case 1:
            return makeGroupData(
              1,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
                  Random().nextInt(widget.availableColors.length)],
            );
          case 2:
            return makeGroupData(
              2,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
                  Random().nextInt(widget.availableColors.length)],
            );
          case 3:
            return makeGroupData(
              3,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
                  Random().nextInt(widget.availableColors.length)],
            );
          case 4:
            return makeGroupData(
              4,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
                  Random().nextInt(widget.availableColors.length)],
            );
          case 5:
            return makeGroupData(
              5,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
                  Random().nextInt(widget.availableColors.length)],
            );
          case 6:
            return makeGroupData(
              6,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
                  Random().nextInt(widget.availableColors.length)],
            );
          default:
            return throw Error();
        }
      }),
      gridData: const FlGridData(show: false),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
      animDuration + const Duration(milliseconds: 50),
    );
    if (isPlaying) {
      await refreshState();
    }
  }
}
