import 'dart:async';
import 'dart:io';

import 'package:afribiopos01/pages/get_start_page.dart';
import 'package:afribiopos01/services/http_service.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:foreground_service/foreground_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configLoading();
  loadData();
  runApp(MyApp());
}

void maybeStartFGS() async {
  if (!(await ForegroundService.foregroundServiceIsStarted())) {
    await ForegroundService.setServiceIntervalSeconds(120);
    await ForegroundService.startForegroundService(foregroundServiceFunctions);
    await ForegroundService.getWakeLock();
  }
}

void foregroundServiceFunctions() {
  HttpService.getStart(opt: 'start').forEach((element) {
    print(element);
    ForegroundService.notification.setTitle('afribio pos');
    ForegroundService.notification.setText("${element['reponse']['status']} started");
  });
}

void toggleForegroundServiceOnOff() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final fgsIsRunning = await ForegroundService.foregroundServiceIsStarted();

  if (fgsIsRunning) {
    await ForegroundService.stopForegroundService();
    HttpService.getStart(opt: 'off').forEach((element) {print(element); });
    prefs.setString('option', 'off');

  } else {
    maybeStartFGS();
    prefs.setString('option', 'start');
  }
}


void loadData() async{
  try{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('localCartData');
    WidgetsFlutterBinding.ensureInitialized();
  }
  catch(e){
    print('error');
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
    //..customAnimation = CustomAnimation();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<DataConnectionStatus> listener;

  checkConnection(BuildContext context) async{
    listener = DataConnectionChecker().onStatusChange.listen((status) async{
      if(status== DataConnectionStatus.disconnected){
        EasyLoading.showInfo('Pour utiliser afribio POS, activez les données mobiles ou connectez-vous au wifi!',maskType: EasyLoadingMaskType.black, duration: Duration(seconds: 5));
        await Future.delayed(Duration(seconds: 5), (){
          exit(0);
        });
      }
    });
  }
  
  @override
  void initState() {
    super.initState();
    checkConnection(context);
  }


  @override
  void dispose(){
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'afribio POS'.toUpperCase(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('fr')
      ],
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: GetStartPage(),
      builder: EasyLoading.init(),
    );
  }
}


