import 'package:flutter/material.dart';
import 'package:bsr/constants/environment.dart';

import 'app.dart';

void main() async {
  await Environment.init();
  runApp(App());
}
