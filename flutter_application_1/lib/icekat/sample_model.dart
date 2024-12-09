import 'package:flutter/material.dart';
import 'package:flutter_application_1/icekat/icekat_math.dart';

class SampleModel {
  String name = '';
  List<double> xFull = [];
  List<double> yFull = [];

  double start = 0.0;
  double end = 0.0;
  List<double> xAxis = [];
  List<double> yAxis = [];
  List<double> ySpline = [];
  List<double> yLinear = [];
  List<double> yLinearResidual = [];
 
  double yMin = double.negativeInfinity;
  double yMax = double.infinity;
  double m = 0.0;
  double b = 0.0;
  double s = 0.0;

  

  SampleModel();
  SampleModel.basic(this.name, this.xFull, this.yFull, this.start, this.end, this.xAxis, this.yAxis, this.ySpline, this.yLinear, this.yLinearResidual, this.yMin, this.yMax, this.m, this.b, this.s);

  Future<bool> setStartEnd(double start, double end) async {
    this.start = start;
    this.end = end;

    xAxis = [];
    yAxis = [];
    for (int i = 0; i < xFull.length; i++) {
      if (start <= xFull[i] && xFull[i] <= end) {
        xAxis.add(xFull[i]);
        yAxis.add(yFull[i]);
      }
    }

    ySpline = await cubicSpline(xAxis, yAxis);

    List<double> xLimited = [];
    List<double> yLimited = [];
    for (int i in limitedIndicies(xAxis, ySpline)) {
      xLimited.add(xAxis[i]);
      yLimited.add(yAxis[i]);
    }
    List<double> linearMap = linearBestFit(xLimited, yLimited);
    m = linearMap[0];
    b = linearMap[1];
    s = linearMap[2];
    yLinear = linearCurve(xAxis, m, b);
    yLinearResidual = List.generate(xAxis.length, (i) => yLinear[i] - yAxis[i]);

    return true;
  }
}