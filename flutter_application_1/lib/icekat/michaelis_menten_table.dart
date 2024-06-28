import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluto_grid/pluto_grid.dart';

PlutoRow mmRowMapper(String name, double vMax, double km, double? kcat) {
  return PlutoRow(cells: {
    'name': PlutoCell(value: name),
    'vMax': PlutoCell(value: vMax),
    'km': PlutoCell(value: km),
    'kcatDiv': PlutoCell(value: (kcat == null) ? 'NaN' : kcat / km),
    'kcat': PlutoCell(value: (kcat == null) ? 'NaN' : kcat)
  });
}

List<PlutoColumn> mmCols = [
  PlutoColumn(
    title: '',
    field: 'name',
    type: PlutoColumnType.text(),
    readOnly: true,
    width: 90
  ),
  PlutoColumn(
    title: 'Vmax',
    field: 'vMax',
    type: PlutoColumnType.text(),
    formatter: (value) => value.toStringAsExponential(2),
    readOnly: true,
    width: 100
  ),
  PlutoColumn(
    title: 'Km',
    field: 'km',
    type: PlutoColumnType.text(),
    formatter: (value) => value.toStringAsExponential(2),
    readOnly: true,
    width: 100
  ),
  PlutoColumn(
    title: 'kcat/km',
    field: 'kcatDiv',
    type: PlutoColumnType.text(),
    formatter: (value) { if (value is String) { return value; } else { return  value.toStringAsExponential(2); } },
    readOnly: true,
    width: 100
  ),
  PlutoColumn(
    title: 'kcat',
    field: 'kcat',
    type: PlutoColumnType.text(),
    formatter: (value) { if (value is String) { return value; } else { return  value.toStringAsExponential(2); } },
    readOnly: true,
    width: 100
  )
];

class MMTable extends StatelessWidget {
  final Map<String, dynamic> mmModel;
  MMTable(this.mmModel);
  @override
  Widget build(BuildContext context) {
    List<PlutoRow> rows = [];
    rows.add(mmRowMapper('Fit Value', mmModel['vMax'], mmModel['km'], mmModel['kcat']));
    rows.add(mmRowMapper('Std. Error', mmModel['s-vMax'], mmModel['s-km'], mmModel['s-kcat']));

    return PlutoGrid(
      key: Key('${mmModel}'),
      columns: mmCols, 
      rows: rows
    );
  }
}