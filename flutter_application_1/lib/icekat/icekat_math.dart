import 'package:flutter/material.dart';
import 'package:scidart/numdart.dart' as nd;
import 'dart:math';


List<double> cubicSpline(List<dynamic> xAxis, List<dynamic> yAxis) {
  nd.PolyFit fit = nd.PolyFit(nd.Array(List<double>.from(xAxis)), nd.Array(List<double>.from(yAxis)), 3);
  return xAxis.map((x) => fit.predict(x)).toList();
}

List<double> linearCurve(List<dynamic> xAxis, double m, double b) {
  return xAxis.map<double>((x) => m*x+b).toList();
}

List<double> michaelisMentenCurve(List<dynamic> cAxis, double vMax, double km) {
  return cAxis.map<double>((c) => (vMax*c)/(km+c)).toList();
}

List<double> ic50Curve(List<dynamic> cAxis, double vMin, double vMax, double p50, double s) {
  return cAxis.map<double>((c) => vMin + (vMax-vMin)/(1+pow(10, s*(p50-c)))).toList();
}

List<int> limitedIndicies(List<dynamic> xAxis, List<dynamic> yAxis) {
  List<double> derivative = [];
  double min = double.infinity;
  double max = double.negativeInfinity;
  for (int i = 0; i < xAxis.length-1; i++) {
    double der = ((yAxis[i+1]-yAxis[i])/(xAxis[i+1]-xAxis[i])).abs();
    derivative.add(der);
    if (der < min) {
      min = der;
    }
    if (der > max) {
      max = der;
    }
  }
  
  List<int> iLimited = [];
  double threshold = 0.7*(max-min) + min;
  do {
    iLimited = [];
    for (int i = 0; i < derivative.length; i++) {
      if (derivative[i] > threshold) {
        iLimited.add(i);
      }
    }
    threshold *= 0.9;
  } while (iLimited.length < 4 && iLimited.length < derivative.length);

  return iLimited;
}

List<double> linearBestFit(List<dynamic> xAxis, List<dynamic> yAxis) {
  double sumX = 0;
  double sumY = 0;
  double sumXX = 0;
  for (int i = 0; i < xAxis.length; i++) {
    sumX += xAxis[i];
    sumY += yAxis[i];
    sumXX += xAxis[i]*xAxis[i];
  }
  double meanX = sumX/xAxis.length;
  double meanY = sumY/xAxis.length;
  
  double sumXYMean = 0;
  double sumXXMean = 0;
  for (int i = 0; i < xAxis.length; i++) {
    sumXYMean += (xAxis[i]-meanX)*(yAxis[i]-meanY);
    sumXXMean += (xAxis[i]-meanX)*(xAxis[i]-meanX);
  }
  double m = sumXYMean/sumXXMean;
  double b = meanY - m*meanX;
  List<double> yFit = linearCurve(xAxis, m, b);

  double errorSum = 0;
  for (int i = 0; i < yAxis.length; i++) {
    errorSum += (yAxis[i]-yFit[i])*(yAxis[i]-yFit[i]);
  }
  double s = sqrt(errorSum/((yAxis.length-2)*(sumXX*yAxis.length - sumX*sumX)));

  return [m, b, s];
}

List<double> michaelisMentenBestFit(List<dynamic> cAxis, List<dynamic> vAxis) {
  double vMax = double.negativeInfinity;
  for (int i = 0; i < vAxis.length; i++) {
    if (vAxis[i] > vMax) {
      vMax = vAxis[i];
    }
  }
  
  if (vMax == 0) {
    return [0, 0, 0, 0];
  }
  List<double> kmSum = [];
  double threshold = (0.1*vMax).abs();
  do {
    kmSum = [];
    for (int i = 0; i < cAxis.length; i++) {
      if ((vAxis[i] - (vMax/2)).abs() < threshold) {
        kmSum.add(cAxis[i]);
      }
    }
    threshold = threshold*1.5;
  } while (kmSum.length < 3 && kmSum.length < cAxis.length);
  double km = 0;
  for (double c in kmSum) { km += c; }
  km /= kmSum.length;

  double meanC = 0;
  double meanV = 0;
  for (int i = 0; i < cAxis.length; i++) { meanC += cAxis[i]; meanV += vAxis[i]; }
  meanC /= cAxis.length;
  meanV /= vAxis.length;

  double sum1 = 0;
  double sum2 = 0;
  for (int i = 0; i < cAxis.length; i++) { 
    sum1 += (cAxis[i]-meanC)*(cAxis[i]-meanC);
    sum2 += (vAxis[i]-meanV)*(vAxis[i]-meanV); 
  }
  double sVMax = sqrt(sum1/(cAxis.length-1));
  double sKm = sqrt(sum2/(vAxis.length-1));

  return [vMax, km, sVMax, sKm];
}

List<double> ic50BestFit(List<dynamic> cAxis, List<dynamic> vAxis) {
  double vMin = double.infinity;
  double vMax = double.negativeInfinity;
  for (int i = 0; i < vAxis.length; i++) {
    if (vAxis[i] < vMin) {
      vMin = vAxis[i];
    }
    if (vAxis[i] > vMax) {
      vMax = vAxis[i];
    }
  }

  List<double> limitedC = [];
  List<double> limitedV = [];
  for (int i in limitedIndicies(cAxis, vAxis)) {
    limitedC.add(cAxis[i]);
    limitedV.add(vAxis[i]);
  }
  double s = linearBestFit(limitedC, limitedV)[0];
  s /= s.abs();
  
  double p50 = 0;
  // double s = 1;
  for (int i = 0; i < cAxis.length; i++) {
    if (vAxis[i] == vMin || vAxis[i] == vMax) { continue; }
    p50 += 1/s * log((vMax-vMin)/(vAxis[i]-vMin) - 1)/log(10) + cAxis[i];
  }
  p50 /= cAxis.length;

  return [vMin, vMax, p50, s];
}