import 'package:euclipse/utility/utility.dart';
import 'package:flutter/material.dart';

class StartNavigation extends StatelessWidget {
  const StartNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Utility().getFirstPageNavigation();
  }
}
