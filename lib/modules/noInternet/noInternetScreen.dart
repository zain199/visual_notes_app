import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class NoInternetScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper(child: widget),
          minWidth: 360.0,
          defaultScale: true,
          breakpoints:const  [
            ResponsiveBreakpoint.autoScale(480, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET,scaleFactor: 1.5),
            ResponsiveBreakpoint.autoScale(1000, name: 'L TABLET' ,scaleFactor: 1.6),
            ResponsiveBreakpoint.autoScale(1500, name: DESKTOP ,scaleFactor: 1.7),
          ],
          breakpointsLandscape: const[
            ResponsiveBreakpoint.autoScaleDown(480, name: MOBILE),
            ResponsiveBreakpoint.autoScaleDown(800, name: TABLET,scaleFactor: 1.5),
            ResponsiveBreakpoint.autoScaleDown(1000, name: 'L TABLET' ,scaleFactor: 1.2),
            ResponsiveBreakpoint.autoScaleDown(1500, name: DESKTOP ,scaleFactor: 1.3),
          ]
      ),
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: const [
                Expanded(child: Icon(Icons.info_outline,size: 100.0,)),
                Expanded(child: Text('No Internet Connection',style: TextStyle(fontSize: 30.0),))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
