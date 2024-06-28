import 'package:flutter/material.dart';

class DropDownBuilder extends StatefulWidget {
  final Function(String) onChanged;
  final List<String> items;
  final String? initValue;
  const DropDownBuilder({Key? key, required this.onChanged, required this.items, this.initValue}) : super(key: key);

  @override
  _DropDownBuilderState createState() => _DropDownBuilderState();
}

class _DropDownBuilderState extends State<DropDownBuilder> {
  String? dropdownValue;
  _DropDownBuilderState();

  @override
  Widget build(BuildContext context) {
    dropdownValue ??= widget.initValue ?? widget.items[0];
    return DropdownButton<String>(
      key: Key('$dropdownValue - ${widget.items} - ${widget.initValue}'),
      value: dropdownValue,
      onChanged: (String? newValue) {
        dropdownValue = newValue!;
        widget.onChanged(newValue);
        setState(() {});
      },
      items: widget.items.map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(
        value: value, 
        child: Text(value)
      )).toList(),
    );
  }
}