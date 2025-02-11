import 'package:flutter/material.dart';
import 'package:zippin_scan/core/styles/color_style.dart';
import 'package:zippin_scan/core/styles/text_style.dart';

class BottonContainer extends StatelessWidget {
  const BottonContainer({
    super.key,
    required this.color,
    required this.child,
    required this.onTap,
    required this.customTextStyle,
  });

  final Color color;
  final Widget child;
  final Function()? onTap;
  final CustomTextStyle customTextStyle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width * 0.8,
        height: size.height * 0.08,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: CustommColorStyle.primaryColorDark,
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ]),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
