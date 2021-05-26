import 'package:afribiopos01/screens/auth_screen.dart';
import 'package:afribiopos01/screens/home_screens.dart';
import 'package:afribiopos01/services/http_service.dart';
import 'package:afribiopos01/widgets/get_start_widget.dart';
import 'package:flutter/material.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
class GetStartPage extends StatefulWidget {
  @override
  _GetStartPageState createState() => _GetStartPageState();
}

class _GetStartPageState extends State<GetStartPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoubleBackToCloseApp(
        child: StartWidget(
          onStart: () async{
           try{
             SharedPreferences prefs = await SharedPreferences.getInstance();
             String user = prefs.getString('auth_data');

             if(user ==null || user == ''){
               Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>AuthScreen()),(Route<dynamic> route) =>false);
               EasyLoading.dismiss();
             }
             else{
               HttpService.getCatalog().then((value){
                 EasyLoading.dismiss();
                 Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen(catalogList: value.produits)),(Route<dynamic> route) =>false);
               }).asStream();

             }
           }
           catch(e){}
          },
        ),
        snackBar: const SnackBar(
          content: Text('Cliquez encore pour quitter !!', textAlign: TextAlign.center,),
        ),
      ),
    );
  }
}
