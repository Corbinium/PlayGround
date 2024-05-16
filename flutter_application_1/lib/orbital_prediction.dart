import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

double massE = 5.972e24;
double radiusE = 6.371e6;
double omegaE = 72.72e-6;
double massM = 7.347e22;
double radiusM = 01.737e6;
double omegaM = 2.663e-6;

class OrbitalGraph extends StatelessWidget {
  OrbitalGraph({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrbitalPrediction prediction = OrbitalPrediction(
      ME: massE,
      XE: 0,
      YE: 0,
      WE: omegaE,
      RE: radiusE,
      THETAE: 0,
      MM: massM,
      XM: 384.4e6,
      YM: 0,
      WM: omegaM,
      RM: radiusM,
      THETAM: 0,
      M: 10000,
      FT: [
        ThrustStage(0, 45, 1500000, Colors.red),
        ThrustStage(46, 1339, 10000, Colors.green),
        ThrustStage(1339, 10000, 6195, Colors.brown),
        ThrustStage(10001, 80000, 0, Colors.black),
        ThrustStage(80001, 95500, -2380, Colors.brown),
        ThrustStage(95501, 124600, 0, Colors.black),
        ThrustStage(124601, 129000, 9400, Colors.green),
        ThrustStage(129001, 197500, 0, Colors.black),
        ThrustStage(197501, 198600, -40000, Colors.orange),
        ThrustStage(198601, 201000, -700, Colors.green),
        ThrustStage(201001, 201500, -100000, Colors.red),
      ],
      dt: 100,
    );

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    double scaler = max(w, h) / (max((prediction.XE-prediction.XM).abs(), (prediction.YE-prediction.YM).abs()) * 1.25);
    double shiftX = w/10;
    double shiftY = h/2;

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: OrbitalCanvas(prediction, scaler, shiftX, shiftY),
    );
  }
}

class OrbitalCanvas extends StatelessWidget {
  OrbitalPrediction prediction;
  double scaler;
  double shiftX;
  double shiftY;
  OrbitalCanvas(this.prediction, this.scaler, this.shiftX, this.shiftY, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(child: CustomPaint(painter: OrbitalPaint(prediction, scaler, shiftX, shiftY)));
  }
}

class OrbitalPaint extends CustomPainter {
  OrbitalPrediction prediction;
  double scaler;
  double shiftX;
  double shiftY;
  OrbitalPaint(this.prediction, this.scaler, this.shiftX, this.shiftY);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawArc(Rect.fromCircle(center: Offset(prediction.XE*scaler+shiftX, prediction.YE*scaler+shiftY), radius: prediction.RE*scaler), 0, 2*pi, true, Paint()..color = Colors.blue.shade700);
    canvas.drawArc(Rect.fromCircle(center: Offset(prediction.XM*scaler+shiftX, prediction.YM*scaler+shiftY), radius: prediction.RM*scaler), 0, 2*pi, true, Paint()..color = Colors.black);
  
    Paint line = Paint();
    line.color = Colors.red;
    line.strokeWidth = 2;

    for (int s = 0; s < prediction.FT.length; s++) {
      Paint line = Paint();
      line.color = prediction.FT[s].color;
      line.strokeWidth = 2;
      List<Offset> points = [];
      for (int i = prediction.FT[s].start~/prediction.dt; i < prediction.FT[s].end~/prediction.dt; i++) {
        points.add(Offset(prediction.path[i][0]*scaler+shiftX, prediction.path[i][1]*scaler+shiftY));
      }
      canvas.drawPoints(PointMode.points, points, line);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class OrbitalPrediction {
  double G = 6.6743e-11;

  double ME;
  double XE;
  double YE;
  double WE;
  double RE;
  double THETAE;

  double MM;
  double XM;
  double YM;
  double WM;
  double RM;
  double THETAM;

  double M;
  List<ThrustStage> FT;

  double dt;

  late List<List<double>> path;

  OrbitalPrediction({required this.ME, required this.XE, required this.YE, required this.WE, required this.RE, required this.THETAE, required this.MM, required this.XM, required this.YM, required this.WM, required this.RM, required this.THETAM, required this.M, required this.FT, required this.dt}) {
    path = calculatePath(FT.last.end);
  }

  List<List<double>> calculatePath(int steps) {
    List<List<double>> path = [];
    double vx = WE * RE * -sin(THETAE);
    double vy = WE * RE * cos(THETAE);
    double thetaR = THETAE;
    path.add([RE*cos(THETAE), RE*sin(THETAE)]);
    double x = path[0][0];
    double y = path[0][1];

    for (int i = 0; i < steps; i++) {
      double axT = thrust(i)*cos(thetaR)/M;
      double axE = -G*ME*cos(atan2( y-YE, x-XE ))/(pow(x-XE, 2)+pow(y-YE, 2));
      double axM = -G*MM*cos(atan2( y-YM, x-XM ))/(pow(x-XM, 2)+pow(y-YM, 2));
      vx += (axT+axE+axM);
      double xOld = x;
      x += vx;

      double ayT = thrust(i)*sin(thetaR)/M;
      double ayE = -G*ME*sin(atan2( y-YE, x-XE ))/(pow(x-XE, 2)+pow(y-YE, 2));
      double ayM = -G*MM*sin(atan2( y-YM, x-XM ))/(pow(x-XM, 2)+pow(y-YM, 2));
      vy += (ayT+ayE+ayM);
      double yOld = y;
      y += vy;
      
      thetaR = atan2(y-yOld, x-xOld);

      if (i % dt == 0) { path.add([x, y]); }
    }

    return path;
  }

  double thrust(int t) {
    for (ThrustStage stage in FT) {
      if (stage.start <= t && t <= stage.end) {
        return stage.thrust;
      }
    }
    return 0;
  }
}

class ThrustStage {
  int start;
  int end;
  double thrust;
  Color color;
  ThrustStage(this.start, this.end, this.thrust, this.color);
}