import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

FlTitlesData standardChartTitles = FlTitlesData(
  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 15, getTitlesWidget: (value, meta) => (value != meta.max && value != meta.min) ? Text(stringFromDouble(value), textAlign: TextAlign.end) : Container())),
  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 60, getTitlesWidget: (value, meta) => (value != meta.max && value != meta.min) ? Text(stringFromDouble(value), textAlign: TextAlign.end) : Container())),
  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
);

LineTouchData standardLineTouchTooltip = LineTouchData(
  getTouchLineStart: (barData, i) => 0,
  getTouchLineEnd: (barData, i) => 0,
  touchTooltipData: LineTouchTooltipData(
    fitInsideHorizontally: true,
    fitInsideVertically: true,
    getTooltipColor: (touchedSpot) => Colors.grey.withOpacity(0.5),
    getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
      return LineTooltipItem('(${stringFromDouble(spot.x)}, ${stringFromDouble(spot.y)})', TextStyle(color: spot.bar.color));
    }).toList(),
  ),
);

String stringFromDouble(double value) {
  if ((0.01 <= value.abs() && value.abs() < 100) || value == 0) {
    return '${(value*1000).toInt()/1000}';
  } else {
    return value.toStringAsExponential(2);
  }
}