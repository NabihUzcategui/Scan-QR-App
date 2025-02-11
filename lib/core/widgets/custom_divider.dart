import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      indent: 30,
      endIndent: 30,
      thickness: 1,
      color: Colors.grey,
    );
  }
}