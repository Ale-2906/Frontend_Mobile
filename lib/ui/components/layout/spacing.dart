import 'package:flutter/widgets.dart';

class Spacing extends StatelessWidget {
  final double height;
  final double width;

  const Spacing._({this.height = 0, this.width = 0});

  factory Spacing.vertical(double h) {
    return Spacing._(height: h);
  }

  factory Spacing.horizontal(double w) {
    return Spacing._(width: w);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, width: width);
  }
}
