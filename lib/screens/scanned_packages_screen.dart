import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zippin_scan/core/Strings/custom_strings.dart';
import 'package:zippin_scan/core/styles/color_style.dart';
import 'package:zippin_scan/core/styles/text_style.dart';
import 'package:zippin_scan/core/utils/extensions.dart';
import 'package:zippin_scan/core/widgets/card_container.dart';
import 'package:zippin_scan/core/widgets/custom_divider.dart';

import '../bloc/bloc.dart';

class ScannedPackagesScreen extends StatelessWidget {
  const ScannedPackagesScreen({super.key});

  Color getStatusColor(String status) {
    switch (status) {
      case CustomStringState.inPreparation:
        return CustomColorState.inPreparation;
      case CustomStringState.inTransit:
        return CustomColorState.inTransit;
      case CustomStringState.failedDeliveryAttempt:
        return CustomColorState.failedDeliveryAttempt;
      case CustomStringState.returned:
        return CustomColorState.returned;
      default:
        return CustomColorState.notDefineState;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScanBloc, ScanState>(
      builder: (context, state) {
        if (state is ScanLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is ScanLoaded) {
          final scannedPackages = state.scannedPackages;

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: CustommColorStyle.primaryColor,
              title: Text(
                CustomStrings.scannedPackages,
                style: CustomTextStyle().title,
              ),
            ),
            body: ListView.builder(
              itemCount: scannedPackages.length,
              itemBuilder: (context, index) {
                final pkg = scannedPackages[index];
                return Column(
                  children: [
                    10.pv,
                    CardContainer(
                      title: Text(
                        'ID: ${pkg.id}',
                        textAlign: TextAlign.center,
                        style: CustomTextStyle().title,
                      ),
                      scannedPackageSender: Text(
                        '${CustomStrings.scannedPackageSender}'
                        '${pkg.remitente}',
                        style: CustomTextStyle().subtitle,
                      ),
                      scannedPackageRecipient: Text(
                        '${CustomStrings.scannedPackageRecipient}'
                        '${pkg.destinatario}',
                        style: CustomTextStyle().subtitle,
                      ),
                      scannedPackageState: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: CustomStrings.scannedPackageState,
                              style: CustomTextStyle().subtitle.copyWith(
                                  color: CustommColorStyle.primaryTextColor),
                            ),
                            TextSpan(
                              text: pkg.estado,
                              style: TextStyle(
                                color: getStatusColor(pkg.estado),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    10.pv,
                    CustomDivider(),
                    10.pv,
                  ],
                );
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: CustomStrings.labelhome,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt_outlined),
                  label: CustomStrings.labelScannedPackages,
                ),
              ],
              onTap: (index) {
                if (index == 0) {
                  Navigator.pushNamed(context, '/');
                }
              },
            ),
          );
        } else {
          return Scaffold(
            body: Center(child: Text(CustomStrings.noDataYet)),
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    label: CustomStrings.labelhome),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt_outlined),
                  label: CustomStrings.labelScannedPackages,
                ),
              ],
              onTap: (index) {
                if (index == 0) {
                  Navigator.pushNamed(context, '/');
                }
              },
            ),
          );
        }
      },
    );
  }
}
