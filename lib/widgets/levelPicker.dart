import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
class LevelPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RadioButtonGroup(
          labels: <String>[
            "Option 1",
            "Option 2",
          ],
          onSelected: (String selected) => print(selected)
      ),
    );
  }
}
