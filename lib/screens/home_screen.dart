import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zippin_scan/bloc/bloc.dart';
import 'package:zippin_scan/core/Strings/custom_strings.dart';
import 'package:zippin_scan/core/styles/styles.dart';
import 'package:zippin_scan/core/utils/extensions.dart';
import 'package:zippin_scan/core/widgets/widgets.dart';

class HomeScanScreen extends StatelessWidget {
  const HomeScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: CustommColorStyle.primaryColor,
        title: Text(
          CustomStrings.appName,
          style: CustomTextStyle().title,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            50.pv,
            BottonContainer(
              color: CustommColorStyle.secondaryColor,
              onTap: () {
                Navigator.pushNamed(context, '/scan');
              },
              customTextStyle: CustomTextStyle(),
              child: Text(
                CustomStrings.scanPackage,
                style: CustomTextStyle().title,
              ),
            ),
            50.pv,
            CustomDivider(),
            50.pv,
            Expanded(
              child:
                  BlocBuilder<ScanBloc, ScanState>(builder: (context, state) {
                if (state is ScanLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (state is ScanLoaded) {
                    final scannedPackages = state.scannedPackages;

                    return ListView.builder(
                      itemCount: scannedPackages.length,
                      itemBuilder: (context, index) {
                        final pkg = scannedPackages[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: ListTile(
                            title: Text(
                              '${CustomStrings.scannedPackageId} ${pkg.id}',
                              style: CustomTextStyle().title,
                            ),
                          ),
                        );
                      },
                    );
                  }
                }

                // ScanInitial u otro estado
                return Scaffold(
                  body: Center(child: Text(CustomStrings.noDataYet)),
                );
              }),
            ),
            BottomNavigationBar(
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
                if (index == 1) {
                  Navigator.pushNamed(context, '/scannedPackages');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
