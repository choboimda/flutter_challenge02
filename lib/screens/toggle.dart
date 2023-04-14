import 'package:flutter/material.dart';

class ToggleTest extends StatefulWidget {
  const ToggleTest({super.key});

  @override
  State<ToggleTest> createState() => _ToggleTestState();
}

class _ToggleTestState extends State<ToggleTest> {
  final List<bool> _isSelected = [false, false, false];
  int selectCheck = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ToggleButtons(
                isSelected: _isSelected,
                onPressed: (index) {
                  setState(() {
                    _isSelected[index] = !_isSelected[index];
                    selectCheck = index;
                    if (selectCheck == index) {
                      _isSelected[index] = true;
                    }
                    for (int i = 0; i < _isSelected.length; i++) {
                      if (i == index) continue;
                      _isSelected[i] = false;
                      // Do something with list[i]
                    }
                  });
                },
                children: const [
          Icon(Icons.ac_unit),
          Icon(Icons.call),
          Icon(Icons.cake),
        ])));
  }
}
