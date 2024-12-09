import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/icekat/cv_graph_model.dart';
import 'package:flutter_application_1/icekat/sample_model.dart';
import 'package:pluto_grid/pluto_grid.dart';

PlutoRow rateRowMapper(String key, double m, double start, double end) {
  return PlutoRow(cells: {
    'key': PlutoCell(value: key),
    'm': PlutoCell(value: m),
    'start': PlutoCell(value: start),
    'end': PlutoCell(value: end)
  });
}

List<PlutoColumn> rateCols = [
  PlutoColumn(
    title: 'Sample',
    field: 'key',
    type: PlutoColumnType.text(),
    readOnly: true,
    width: 90
  ),
  PlutoColumn(
    title: 'Slope (Initial Rate)',
    field: 'm',
    type: PlutoColumnType.text(),
    formatter: (value) => value.toStringAsExponential(2),
    readOnly: true,
    width: 160
  ),
  PlutoColumn(
    title: 'Start',
    field: 'start',
    type: PlutoColumnType.text(),
    readOnly: true,
    width: 90
  ),
  PlutoColumn(
    title: 'End',
    field: 'end',
    type: PlutoColumnType.text(),
    readOnly: true,
    width: 90
  ),
];

class RateTable extends StatelessWidget {
  final List<SampleModel> model;
  final double subtraction;
  RateTable(this.model, this.subtraction);
  @override
  Widget build(BuildContext context) {
    List<PlutoRow> rows = [];
    for (int i = 0; i < model.length; i++) {
      rows.add(rateRowMapper(model[i].name, model[i].m.abs() - subtraction.abs(), model[i].start, model[i].end));
    }

    return PlutoGrid(
      key: Key('${model.map((s) => s.name)}'),
      columns: rateCols, 
      rows: rows,
    );
  }
}