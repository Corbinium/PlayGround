import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/icekat/cv_graph_model.dart';
import 'package:flutter_application_1/icekat/drop_down_builder.dart';
import 'package:flutter_application_1/icekat/rate_table.dart';
import 'package:flutter_application_1/icekat/sample_model.dart';
import 'package:flutter_application_1/icekat/stock.dart';
import 'package:flutter_application_1/icekat/widget_stock.dart';
import 'package:resizable_widget/resizable_widget.dart';

class Icekat extends StatefulWidget {
  Icekat({Key? key}) : super(key: key);
  @override
  IcekatState createState() => IcekatState();
}  
class IcekatState extends State<Icekat> { 
  List<SampleModel> csvMap = basicData;

  String yAxisSample = basicData[0].name;
  String subtraction = '';
  TextEditingController transformEquation = TextEditingController();
  TextEditingController timeMixToRead = TextEditingController();
  TextEditingController pEC50pIC50_bottom = TextEditingController();
  TextEditingController pEC50pIC50_top = TextEditingController();
  TextEditingController pEC50pIC50_hill = TextEditingController();

  TextEditingController startTime = TextEditingController(text: '${basicData[0].start}');
  TextEditingController endTime = TextEditingController(text: '${basicData[0].end}');

  TextEditingController hitThreshold = TextEditingController(text: '1.0');

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double inputWidth = (100~/(width/308))/100.0;
    List<double> ratios = [inputWidth, 0.76-inputWidth, 0.24];
    List<String> sampleOptions = csvMap.map<String>((s) => s.name).toList();

    CVGraphModel cvGraph = CVGraphModel(csvMap, (subtraction == '') ? 0 : csvMap.firstWhere((s) => s.name == subtraction).m);
    int yAxisIndex = csvMap.indexWhere((s) => s.name == yAxisSample);

    // List<double> ySpline = cubicSpline(csvMap[yAxisSample]!['xAxis'], csvMap[yAxisSample]!['yAxis']);
    // List<double> linearMap = LinearBestFitLimited(csvMap[yAxisSample]!['xAxis'], ySpline);
    // List<double> yLinear = List.generate(csvMap[yAxisSample]!['xAxis'].length, (i) => csvMap[yAxisSample]!['xAxis'][i]*linearMap[0] + linearMap[1]);
    // List<double> yLinearResidual = List.generate(csvMap[yAxisSample]!['xAxis'].length, (i) => yLinear[i] - csvMap[yAxisSample]!['yAxis'][i]);
    
    return Container(
      margin: EdgeInsets.all(20),
      color: Colors.white,
      child: ResizableWidget(
        key: Key('$yAxisSample - $csvMap - $subtraction - ${startTime.text} - ${endTime.text}'),
        percentages: ratios,
        children: [
          Column(
            children: [
              TextButton(
                onPressed: uploadCsv,
                child: Text('Upload File')
              ),
              Text('Model: Michaelis-Menten'),
              // DropDownBuilder(onChanged: (val) { model = val; setState(() {}); }, items: modelOptions, ),
              Row(
                children: [
                  Text('Choose Y-Axis Sample:  '),
                  DropDownBuilder(key: Key('${sampleOptions} - yaxis'), onChanged: (val) { yAxisSample = val; startTime.text = '${csvMap[yAxisIndex].start}'; endTime.text = '${csvMap[yAxisIndex].end}'; setState(() {}); }, items: sampleOptions, initValue: yAxisSample),
                ]
              ),
              Row(
                children: [
                  Text('Select Blank Sample for Subtraction:  '),
                  DropDownBuilder(key: Key('${sampleOptions} - subtract'), onChanged: (val) { subtraction = val; setState(() {}); }, items: ["", ...sampleOptions], initValue: subtraction),
                ]
              ),
              // Text('Transform Equation'),
              // TextField(controller: transformEquation),
              // Text('Time Between Mixing and First Read'),
              // TextField(controller: timeMixToRead),
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
                    onPressed: () { 
                      for (int i = 0 ; i < csvMap.length; i++) { 
                        csvMap[i].setStartEnd(csvMap[i].xFull[0], csvMap[i].xFull.last);
                      } 
                      startTime.text = '${csvMap[yAxisIndex].start}';
                      endTime.text = '${csvMap[yAxisIndex].end}';
                      setState(() {});
                    },
                    child: Text('Reset Times')
                  ),
                  TextButton(
                    onPressed: () { csvMap[yAxisIndex].setStartEnd(double.parse(startTime.text), double.parse(endTime.text)); setState(() {}); },
                    child: Text('Update Graph')
                  ),
                ]
              )
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
                        minX: csvMap[yAxisIndex].xAxis[0] - (csvMap[yAxisIndex].xAxis.last * 0.05),
                        maxX: csvMap[yAxisIndex].xAxis.last + (csvMap[yAxisIndex].xAxis.last * 0.05),
                        lineTouchData: standardLineTouchTooltip,
                        titlesData: standardChartTitles,
                        lineBarsData: [
                          LineChartBarData(
                            color: Colors.grey.shade600,
                            spots: dotOnlyGraph(List.generate(csvMap[yAxisIndex].xAxis.length, (i) => FlSpot(csvMap[yAxisIndex].xAxis[i], csvMap[yAxisIndex].yAxis[i]))),
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
                            spots: List.generate(csvMap[yAxisIndex].xAxis.length, (i) => FlSpot(csvMap[yAxisIndex].xAxis[i], csvMap[yAxisIndex].ySpline[i])),
                          ),
                          LineChartBarData(
                            color: Colors.red,
                            dotData: const FlDotData(show: false),
                            spots: List.generate(csvMap[yAxisIndex].xAxis.length, (i) => FlSpot(csvMap[yAxisIndex].xAxis[i], csvMap[yAxisIndex].yLinear[i])),
                          )
                        ]
                      ),
                      key: Key("$yAxisSample - $subtraction - ${csvMap.map((s) => s.name)}"),
                    ),
                  )),
                  Expanded(child: Container(
                    padding: EdgeInsets.all(10),
                    height: height/2,
                    child: LineChart(
                      LineChartData(
                        minX: cvGraph.cAxis[0] - (cvGraph.cAxis.last * 0.05),
                        maxX: cvGraph.cAxis.last + (cvGraph.cAxis.last * 0.05),
                        minY: cvGraph.vMin - (cvGraph.vMax * 0.05),
                        maxY: cvGraph.vMax + (cvGraph.vMax * 0.05),
                        lineTouchData: standardLineTouchTooltip,
                        titlesData: standardChartTitles,
                        lineBarsData: [
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
                          LineChartBarData(
                            color: Colors.black,
                            spots: List.generate(cvGraph.cAxis.length, (i) => FlSpot(cvGraph.cAxis[i], cvGraph.vMM[i])),
                            dotData: const FlDotData(show: false),
                          ),
                          LineChartBarData(
                            color: Colors.black,
                            spots: [FlSpot(cvGraph.km, cvGraph.vMax/2)],
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, d, line, i) => FlDotCirclePainter(
                                radius: 4,
                                color: Colors.black,
                              )
                            ),
                          ),
                        ],
                      ),
                      key: Key("$yAxisSample - $subtraction - ${csvMap.map((s) => s.name)}"),
                    ),
                  )),
                ]
              ),
              Expanded(child: Container(
                padding: EdgeInsets.all(10),
                width: width*ratios[1],
                child: LineChart(
                  LineChartData(
                    minX: csvMap[yAxisIndex].xAxis[0] - (csvMap[yAxisIndex].xAxis.last * 0.05),
                    maxX: csvMap[yAxisIndex].xAxis.last + (csvMap[yAxisIndex].xAxis.last * 0.05),
                    lineTouchData: standardLineTouchTooltip,
                    titlesData: standardChartTitles,
                    lineBarsData: [
                      LineChartBarData(
                        color: Colors.grey.shade600,
                        spots: dotOnlyGraph(List.generate(csvMap[yAxisIndex].xAxis.length, (i) => FlSpot(csvMap[yAxisIndex].xAxis[i], csvMap[yAxisIndex].yLinearResidual[i]))),
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
                  // key: Key("$yAxisSample - $subtraction - ${csvMap.keys.toList()}"),
                ),
              )),
            ],
          ),
          Column(
            children: [
              TextButton(
                onPressed: () {},
                child: Text('Download CSV')
              ),
              TextButton(
                onPressed: () {
                  String csv = 'Sample\tSlope';
                  for (int i = 0; i < csvMap.length; i++) {
                    csv += "\n${csvMap[i].name}\t${csvMap[i].m}";
                  }
                  Clipboard.setData(ClipboardData(text: csv));
                },
                child: Text('Copy to Clipboard'),
              ),
              Expanded(child: Container(
                padding: EdgeInsets.all(10),
                width: width*ratios[2],
                child: RateTable(csvMap)
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

  void uploadCsv() async {
    FilePickerResult? inFile = await FilePicker.platform.pickFiles(dialogTitle: "Pick a file");
    var csvList = CsvToListConverter().convert(utf8.decode(inFile!.files.single.bytes!.toList()));
    csvList.removeAt(1);

    csvMap = [];
    for (int c = 1; c < csvList[0].length; c++) {
      SampleModel sample = SampleModel();
      if (csvList[0][c] == '') { continue; }
      sample.name = csvList[0][c];
      for (int r = 1; r < csvList.length; r++) {
        sample.xFull.add(csvList[r][0]);
        sample.yFull.add(csvList[r][c]);
        if (csvList[r][c] < sample.yMin) { sample.yMin = csvList[r][c]; }
        if (csvList[r][c] > sample.yMax) { sample.yMax = csvList[r][c]; }
      }
      sample.setStartEnd(sample.xFull[0], sample.xFull.last);

      csvMap.add(sample);
      debugPrint('complete ${csvList[0][c]}');
    }
    
    yAxisSample = csvList[0][1];
    subtraction = '';
    debugPrint('complete');
    setState(() {});
  }
}