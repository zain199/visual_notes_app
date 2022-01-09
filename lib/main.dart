import 'package:connectivity/connectivity.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:visual_notes_app/layout/visualNotesHome/cubit/app_cubit.dart';
import 'package:visual_notes_app/layout/visualNotesHome/homeLayout.dart';
import 'package:visual_notes_app/modules/noInternet/noInternetScreen.dart';
import 'package:visual_notes_app/shared/blocobcerver.dart';
import 'package:visual_notes_app/shared/styles/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();

  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => const MyApp(), // Wrap your app
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          if(snapshot==null)
          {
            return const Center(child: CircularProgressIndicator(),);
          }
          var resualt = snapshot.data;
          switch(resualt){
            case ConnectivityResult.mobile:
            case ConnectivityResult.wifi:
              return  BlocProvider(
                  create: (context) => AppCubit()..getNotes('notes')..getLastId(),
                  child:MaterialApp(
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
                debugShowCheckedModeBanner: false,
                darkTheme: ThemeData(
                  textTheme: const TextTheme(
                    bodyText1: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    bodyText2: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  dividerTheme: DividerThemeData(
                    color: colorApp,
                    thickness: 1,
                  ),
                  primarySwatch: Colors.green,
                  scaffoldBackgroundColor: HexColor('33312b'),
                  appBarTheme: AppBarTheme(
                    backgroundColor: HexColor('33312b'),
                    elevation: 0,
                    actionsIconTheme: IconThemeData(color: colorApp),
                    iconTheme: const IconThemeData(color: Colors.white),
                    titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25),
                    systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: HexColor('33312b'),
                      statusBarIconBrightness: Brightness.light,
                    ),
                  ),
                  bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    selectedItemColor: colorApp,
                    unselectedItemColor: Colors.grey,
                    type: BottomNavigationBarType.fixed,
                    elevation: 50,
                    backgroundColor: HexColor('33312b'),
                  ),
                ),
                themeMode: ThemeMode.dark,

                home: HomeLayout(),
              )
              );
            case ConnectivityResult.none:
            default:
              return NoInternetScreen();
          }
        },

    );
  }
}
