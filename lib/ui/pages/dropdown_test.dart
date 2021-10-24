import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:temp_app/ui/base/base_page.dart';

import '../widgets/new_dropdown.dart';

class DropdownTestPage extends BasePage {
  DropdownTestPage({Key key})
      : super(
          key: key,
          state: _DropdownTestPageState(),
        );

  static route() {
    return MaterialPageRoute(builder: (context) => DropdownTestPage());
  }
}

class _DropdownTestPageState extends State<BaseStatefulWidget> {
  var items = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20
  ];
  var currentValues = [1];
  var currentValue = 1;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(currentValues.toString()),
          SizedBox(height: 124),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildOldDropdown(),
                SizedBox(height: 24),
                _buildNewDropdown(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOldDropdown() {
    return DropdownButton(
      value: currentValue,
      onChanged: (v) {
        setState(() {
          currentValue = v;
        });
      },
      onTap: () {
        setState(() {});
      },
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              onTap: () {
                setState(() {
                  currentValues.contains(e)
                      ? currentValues.remove(e)
                      : currentValues.add(e);
                });
              },
              child: Row(
                children: [
                  IgnorePointer(
                    child: Checkbox(
                      value: currentValues.contains(e),
                      onChanged: (bool value) {},
                    ),
                  ),
                  Text(e.toString()),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildNewDropdown() {
    return NewDropdownButton<int>(
      isSingleChoice: false,
      // isExpanded: true,
      value: currentValue,
      onChanged: (v) {
        setState(() {
          currentValue = v;
        });
      },
      onTap: () {
        setState(() {});
      },
      selectedItemBuilder: (c) => items
          .map((e) => Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "|-----|!!! ${currentValues.toString()} !!!|-----|",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ))
          .toList(),
      items: items
          .map(
            (e) => NewDropdownMenuItem<int>(
              value: e,
              onTap: () {
                setState(() {
                  currentValues.contains(e)
                      ? currentValues.remove(e)
                      : currentValues.add(e);
                });
              },
              childBuilder: (c, v) => Row(
                children: [
                  IgnorePointer(
                    child: Checkbox(
                      value: currentValues.contains(e),
                      onChanged: (bool value) {
                        //
                      },
                    ),
                  ),
                  Text(e.toString()),
                  Text("-----|"),
                ],
              ),
              child: Row(
                children: [
                  IgnorePointer(
                    child: Checkbox(
                      value: currentValues.contains(e),
                      onChanged: (bool value) {
                        //
                      },
                    ),
                  ),
                  Text(e.toString()),
                  Text("|-----|"),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
