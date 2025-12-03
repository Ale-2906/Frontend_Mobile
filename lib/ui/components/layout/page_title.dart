import 'package:flutter/material.dart';
import '../../theme/text_styles.dart';

class PageTitle extends StatelessWidget {
  final String title;
  final double size;

  const PageTitle({
    super.key,
    required this.title,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.title.copyWith(fontSize: size),
    );
  }
}
