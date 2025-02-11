import 'package:flutter/material.dart';
import 'package:zippin_scan/core/styles/styles.dart';
import 'package:zippin_scan/core/utils/extensions.dart';

class CardContainer extends StatelessWidget {
  final Widget title;
  final List subtitle = [];
  final Widget scannedPackageSender;
  final Widget scannedPackageRecipient;
  final Widget scannedPackageState;

  CardContainer({
    super.key,
    required this.title,
    required this.scannedPackageSender,
    required this.scannedPackageRecipient,
    required this.scannedPackageState,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final Color color = CustommColorStyle.primaryColorLight;

    return Container(
      width: size.width * 0.8,
      height: size.height * 0.15,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: ListTile(
          title: title,
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              5.pv,
              scannedPackageSender,
              5.pv,
              scannedPackageRecipient,
              5.pv,
              scannedPackageState,
              5.pv,
            ],
          ),
        ),
      ),
    );
  }
}
