import 'dart:io';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/spline/spline.dart' as sp;

class SplineInterpreter extends StatelessWidget {
  List<double> inX = [];
  List<double> x = [];
  List<List<double>> sensor = [];
  List<List<double>> python = []; 
  List<List<double>> dart = [];

  SplineInterpreter() {
    var file = sp.graphData['noise-spline-pcr'];

    if (file['inX'].isNotEmpty) {inX = file['inX'];}
    if (file['x'].isNotEmpty) {x = file['x'];}
    if (file['sensor'].isNotEmpty) {sensor = file['sensor'];}
    if (file['python'].isNotEmpty) {python = file['python'];}
    if (file['dart'].isNotEmpty) {dart = file['dart'];}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Row(
          children: [
            Column(
              children: _buildCharts(),
            ),
            Column(
              children: _buildDiffCharts()
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCharts() {
    List<Widget> charts = [];
    for (int i = 0; i < max(max(sensor.length, python.length), dart.length); i++) {
      charts.add(Text('Sensor ${sensors[i]}', style: const TextStyle(fontSize: 20)));
      charts.add(Container(
        width: 800,
        height: 400,
        child: LineChart(
          LineChartData(
            lineBarsData: _buildLines(i)
          ),
        ),
      ));
    }
    return charts;
  }

  List<LineChartBarData> _buildLines(int i) {
    List<LineChartBarData> lines = [];

    if (sensor.isNotEmpty && inX.isNotEmpty) {lines.add(LineChartBarData(
      color: Colors.grey.shade600,
      spots: List.generate(min(inX.length, sensor[i].length), (j) => FlSpot(inX[j], sensor[i][j])),
      dotData: const FlDotData(show: false),
    ));}

    if (python.isNotEmpty) {lines.add(LineChartBarData(
      color: Colors.red,
      spots: List.generate(min(x.length, python[i].length), (j) => FlSpot(x[j], python[i][j])),
      dotData: const FlDotData(show: false),
    ));}

    if (dart.isNotEmpty) {lines.add(LineChartBarData(
      color: Colors.green,
      spots: List.generate(min(x.length, dart[i].length), (j) => FlSpot(x[j], dart[i][j])),
      dotData: const FlDotData(show: false),
    ));}

    return lines;
  }

  List<Widget> _buildDiffCharts() {
    List<Widget> charts = [];
    for (int i = 0; i < max(max(sensor.length, python.length), dart.length); i++) {
      charts.add(Text('Sensor ${sensors[i]}', style: const TextStyle(fontSize: 20)));
      charts.add(Container(
        width: 800,
        height: 400,
        child: LineChart(
          LineChartData(
            lineBarsData: _buildDiffLines(i)
          ),
        ),
      ));
    }
    return charts;
  }

  List<LineChartBarData> _buildDiffLines(int i) {
    List<LineChartBarData> lines = [];

    if (python.isNotEmpty && dart.isNotEmpty) {lines.add(LineChartBarData(
      color: Colors.red,
      spots: List.generate(min(min(x.length, python[i].length), dart[i].length), (j) => FlSpot(x[j], python[i][j]-dart[i][j])),
      dotData: const FlDotData(show: false),
    ));}

    return lines;
  }
}

List<String> sensors = ['415', '445', '480', '515', '555', '590', '630', '680', 'NIR', 'Clear', 'Dark'];