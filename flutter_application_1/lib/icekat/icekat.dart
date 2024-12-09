import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resizable_widget/resizable_widget.dart';

import 'package:flutter_application_1/icekat/cv_graph_model.dart';
import 'package:flutter_application_1/icekat/drop_down_builder.dart';
import 'package:flutter_application_1/icekat/rate_table.dart';
import 'package:flutter_application_1/icekat/sample_model.dart';



class Icekat extends StatefulWidget {
  Icekat({Key? key}) : super(key: key);
  @override
  IcekatState createState() => IcekatState();
}  
class IcekatState extends State<Icekat> { 
  List<SampleModel> sampleModels = [];

  String yAxisSample = '';
  String subtraction = '';
  TextEditingController transformEquation = TextEditingController();
  TextEditingController timeMixToRead = TextEditingController();
  TextEditingController pEC50pIC50_bottom = TextEditingController();
  TextEditingController pEC50pIC50_top = TextEditingController();
  TextEditingController pEC50pIC50_hill = TextEditingController();

  TextEditingController startTime = TextEditingController(text: '0');
  TextEditingController endTime = TextEditingController(text: '1');

  TextEditingController hitThreshold = TextEditingController(text: '1.0');

  bool modelCV = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double inputWidth = (100~/(width/308))/100.0;
    List<double> ratios = [inputWidth, 0.76-inputWidth, 0.24];

    List<String> sampleOptions = sampleModels.map<String>((s) => s.name).toList();
    double subM = (subtraction == '') ? 0 : sampleModels.firstWhere((s) => s.name == subtraction).m;
    CVGraphModel? cvGraph = (sampleModels.isEmpty) ? null : CVGraphModel(sampleModels, subM, modelCV);
    int? yAxisIndex = (sampleModels.isEmpty) ? null : sampleModels.indexWhere((s) => s.name == yAxisSample);
    
    return Container(
      margin: EdgeInsets.all(20),
      color: Colors.white,
      child: ResizableWidget(
        key: Key('$yAxisSample - $sampleModels - $subtraction - ${startTime.text} - ${endTime.text}'),
        percentages: ratios,
        children: [
          Column(
            children: [
              TextButton(
                onPressed: uploadCSV,
                child: Text('Download CSV')
              ),
              Text('Model: Michaelis-Menten'),
              Row(
                children: [
                  Text('Choose Y-Axis Sample:  '),
                  DropDownBuilder(key: Key('${sampleOptions} - yaxis'), onChanged: (val) { yAxisSample = val; yAxisIndex = sampleModels.indexWhere((e) => e.name == yAxisSample); startTime.text = '${sampleModels[yAxisIndex!].start}'; endTime.text = '${sampleModels[yAxisIndex!].end}'; setState(() {}); }, items: sampleOptions, initValue: yAxisSample),
                ]
              ),
              Row(
                children: [
                  Text('Select Blank Sample for Subtraction:  '),
                  DropDownBuilder(key: Key('${sampleOptions} - subtract'), onChanged: (val) { subtraction = val; setState(() {}); }, items: ["", ...sampleOptions], initValue: subtraction),
                ]
              ),
              Row(
                children: [
                  Text('Start Time:  '),
                  Expanded(child: TextField(controller: startTime, textAlign: TextAlign.center,)),
                ]
              ),
              Row(
                children: [
                  Text('End Time:  '),
                  Expanded(child: TextField(controller: endTime, textAlign: TextAlign.center,)),
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: resetTimes,
                    child: Text('Reset Times')
                  ),
                  TextButton(
                    onPressed: () { sampleModels[yAxisIndex!].setStartEnd(double.parse(startTime.text), double.parse(endTime.text)); setState(() {}); },
                    child: Text('Update Graph')
                  ),
                ]
              ),
            ]
          ),
          Column(
            children: [
              Row(
                children: [
                  Expanded(child: Container(
                    padding: EdgeInsets.all(10),
                    height: height/2,
                    child: LineChart(
                      LineChartData(
                        minX: (yAxisIndex == null) ? 0 : sampleModels[yAxisIndex!].xAxis[0] - (sampleModels[yAxisIndex!].xAxis.last * 0.05),
                        maxX: (yAxisIndex == null) ? 0 : sampleModels[yAxisIndex!].xAxis.last + (sampleModels[yAxisIndex!].xAxis.last * 0.05),
                        lineTouchData: standardLineTouchTooltip,
                        titlesData: standardChartTitles,
                        lineBarsData: (yAxisIndex == null) ? [] : [
                          LineChartBarData(
                            color: Colors.grey.shade600,
                            spots: dotOnlyGraph(List.generate(sampleModels[yAxisIndex!].xAxis.length, (i) => FlSpot(sampleModels[yAxisIndex!].xAxis[i], sampleModels[yAxisIndex!].yAxis[i]))),
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, d, line, i) => FlDotCirclePainter(
                                radius: 2,
                                color: Colors.grey.shade600,
                              )
                            ),
                          ),
                          LineChartBarData(
                            color: Colors.green,
                            dotData: const FlDotData(show: false),
                            spots: List.generate(sampleModels[yAxisIndex!].xAxis.length, (i) => FlSpot(sampleModels[yAxisIndex!].xAxis[i], sampleModels[yAxisIndex!].ySpline[i])),
                          ),
                          LineChartBarData(
                            color: Colors.red,
                            dotData: const FlDotData(show: false),
                            spots: List.generate(sampleModels[yAxisIndex!].xAxis.length, (i) => FlSpot(sampleModels[yAxisIndex!].xAxis[i], sampleModels[yAxisIndex!].yLinear[i])),
                          )
                        ]
                      ),
                      key: Key("$yAxisSample - $subtraction - ${sampleModels.map((s) => s.name)}"),
                    ),
                  )),
                  Expanded(child: Container(
                    padding: EdgeInsets.all(10),
                    height: height/2,
                    child: LineChart(
                      LineChartData(
                        minX: (cvGraph == null) ? 0 : cvGraph.cAxis[0] - (cvGraph.cAxis.last * 0.05),
                        maxX: (cvGraph == null) ? 0 : cvGraph.cAxis.last + (cvGraph.cAxis.last * 0.05),
                        minY: (cvGraph == null) ? 0 : cvGraph.vMin - (cvGraph.vMax * 0.05),
                        maxY: (cvGraph == null) ? 0 : cvGraph.vMax + (cvGraph.vMax * 0.05),
                        lineTouchData: standardLineTouchTooltip,
                        titlesData: standardChartTitles,
                        lineBarsData: (cvGraph == null) ? [] : [
                          LineChartBarData(
                            color: Colors.grey.shade600,
                            spots: dotOnlyGraph(List.generate(cvGraph.cAxis.length, (i) => FlSpot(cvGraph.cAxis[i], cvGraph.vAxis[i]))),
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, d, line, i) => FlDotCirclePainter(
                                radius: 2,
                                color: Colors.grey.shade600,
                              )
                            ),
                          ),
                          (cvGraph.vMM.isNotEmpty) ? LineChartBarData(
                            color: Colors.black,
                            spots: List.generate(cvGraph.cAxis.length, (i) => FlSpot(cvGraph.cAxis[i], cvGraph.vMM![i])),
                            dotData: const FlDotData(show: false),
                          ) : LineChartBarData(),
                          (cvGraph.vMM.isNotEmpty) ? LineChartBarData(
                            color: Colors.black,
                            spots: [FlSpot(cvGraph.km, cvGraph.vMax/2)],
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, d, line, i) => FlDotCirclePainter(
                                radius: 4,
                                color: Colors.black,
                              )
                            ),
                          ) : LineChartBarData(),
                        ],
                      ),
                      key: Key("$yAxisSample - $subtraction - ${sampleModels.map((s) => s.name)}"),
                    ),
                  )),
                ]
              ),
              Expanded(child: Container(
                padding: EdgeInsets.all(10),
                width: width*ratios[1],
                child: LineChart(
                  LineChartData(
                    minX: (yAxisIndex == null) ? 0 : sampleModels[yAxisIndex!].xAxis[0] - (sampleModels[yAxisIndex!].xAxis.last * 0.05),
                    maxX: (yAxisIndex == null) ? 0 : sampleModels[yAxisIndex!].xAxis.last + (sampleModels[yAxisIndex!].xAxis.last * 0.05),
                    lineTouchData: standardLineTouchTooltip,
                    titlesData: standardChartTitles,
                    lineBarsData: (yAxisIndex == null) ? [] : [
                      LineChartBarData(
                        color: Colors.grey.shade600,
                        spots: dotOnlyGraph(List.generate(sampleModels[yAxisIndex!].xAxis.length, (i) => FlSpot(sampleModels[yAxisIndex!].xAxis[i], sampleModels[yAxisIndex!].yLinearResidual[i]))),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, d, line, i) => FlDotCirclePainter(
                            radius: 2,
                            color: Colors.grey.shade600,
                          )
                        ),
                      ),
                    ]
                  ),
                ),
              )),
            ],
          ),
          Column(
            children: [
              TextButton(
                onPressed: () async {
                  List<List<dynamic>> csvList = [['Sample', 'Slope']];
                  for (int i = 0; i < sampleModels.length; i++) {
                    csvList.add([sampleModels[i].name, sampleModels[i].m]);
                  }
                  String csv = const ListToCsvConverter().convert(csvList);

                  Uint8List bytes = utf8.encode(csv);
                  await FileSaver.instance.saveFile(
                    name: 'icekatSamples',
                    bytes: bytes,
                    ext: 'csv',
                    mimeType: MimeType.csv,
                  );
                },
                child: Text('Download CSV')
              ),
              TextButton(
                onPressed: () {
                  String csv = 'Sample\tSlope';
                  for (int i = 0; i < sampleModels.length; i++) {
                    csv += "\n${sampleModels[i].name}\t${sampleModels[i].m}";
                  }
                  Clipboard.setData(ClipboardData(text: csv));
                },
                child: Text('Copy to Clipboard'),
              ),
              Expanded(child: Container(
                padding: EdgeInsets.all(10),
                width: width*ratios[2],
                child: RateTable(sampleModels, subM)
              )),
            ]
          ),
        ],
      ),
    );
  }

  List<FlSpot> dotOnlyGraph(List<FlSpot> spots) {
    for (int i = 1; i < spots.length; i+=2) {
      spots.insert(i, FlSpot.nullSpot);
    }
    return spots;
  }

  void uploadCSV() async { 
    FilePickerResult? inFile = await FilePicker.platform.pickFiles(dialogTitle: "Pick a file");
    var csvList = CsvToListConverter().convert(utf8.decode(inFile!.files.single.bytes!.toList()));
    debugPrint(csvList[0].toString());
    yAxisSample = csvList[0][1];
    subtraction = '';
    startTime.text = '${csvList[1][0]}';
    endTime.text = '${csvList.last[0]}';

    setState(() {
      sampleModels = [];
      modelCV = false;
    });

    for (int c = 1; c < csvList[0].length; c++) {
      await Future.delayed(Duration(microseconds: 1));

      SampleModel sample = SampleModel();
      if (csvList[0][c] == '') { continue; }
      sample.name = csvList[0][c];
      setState(() {
        yAxisSample = sample.name;
      });
      for (int r = 1; r < csvList.length; r++) {
        sample.xFull.add(csvList[r][0]);
        sample.yFull.add(csvList[r][c]);
        if (csvList[r][c] < sample.yMin) { sample.yMin = csvList[r][c]; }
        if (csvList[r][c] > sample.yMax) { sample.yMax = csvList[r][c]; }
      }
      sample.setStartEnd(sample.xFull[0], sample.xFull.last);

      sampleModels.add(sample);
    }

    setState(() {
      modelCV = true;
    });
  }

  void resetTimes() async { 
    for (SampleModel s in sampleModels) {
      if (s.start != s.xFull[0] || s.end != s.xFull.last) {
        await s.setStartEnd(s.xFull[0], s.xFull.last);
      }
      setState(() {
        yAxisSample = s.name;
        startTime.text = '${s.start}';
        endTime.text = '${s.end}';
      });
      await Future.delayed(const Duration(microseconds: 1));
    }
  }
}

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