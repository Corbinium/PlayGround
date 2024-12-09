import 'package:flutter_application_1/icekat/icekat_math.dart';
import 'package:flutter_application_1/icekat/sample_model.dart';

class CVGraphModel {
  List<double> cAxis = [];
  List<double> vAxis = [];
  List<double> vMM = [];
  List<double> vIC50 = [];

  double vMax = 0.0;
  double vMin = 0.0;
  double km = 0.0;
  double sVMax = 0.0;
  double sKm = 0.0;

  double pIC50 = 0.0;
  double slope = 0.0;

  CVGraphModel(List<SampleModel> csvMap, double subtraction, bool modelLine) {
    double vMax = double.negativeInfinity;
    double vMin = double.infinity;
    for (int i = 0 ; i < csvMap.length; i++) {
      cAxis.add(double.parse(csvMap[i].name.replaceAll(RegExp(r'[^0-9|.]'), '')));
      double m = csvMap[i].m.abs() - subtraction;
      vAxis.add(m);
      if (m > vMax) { vMax = m; }
      if (m < vMin) { vMin = m; }
    }
    if (modelLine) { cvGraphSetup(); }
  }

  void cvGraphSetup() {
    List<double> mmMap = michaelisMentenBestFit(cAxis, vAxis);
    vMax = mmMap[0];
    km = mmMap[1];
    sVMax = mmMap[2];
    sKm = mmMap[3];
    vMM = michaelisMentenCurve(cAxis, vMax, km);

    // List<double> icMap = ic50BestFit(cAxis, vAxis);
    // vMin = icMap[0];
    // pIC50 = icMap[2];
    // slope = icMap[3];
    // vIC50 = ic50Curve(cAxis, vMin, vMax, pIC50, slope);
  }
}