
import 'dart:convert';
import 'dart:ui';
import 'package:afribiopos01/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'home_screens.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>{
  bool _isObscure =true;
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  final _textEmail = TextEditingController();
  final _textPass = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        reverse: true,
        child: Container(
          padding: EdgeInsets.only(top:150, left: 30, right: 30,),
          child: Column(
            children: [
              Stack(
                overflow: Overflow.visible,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.55,
                    decoration: BoxDecoration(
                        color: Colors.green[700],
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black45,
                              spreadRadius: 5,
                              blurRadius: 20,
                              offset: Offset(0,10)
                          )
                        ]
                    ),

                    child: Padding(
                      padding: const EdgeInsets.only(top: 80, left: 10, right: 10),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Text('Connexion'.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.green[50],
                                  letterSpacing: 1.5,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black26,
                                        offset: Offset(0,2),
                                        blurRadius: 2
                                    )
                                  ]
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50.0  ,
                                padding: EdgeInsets.only(
                                    top: 4.0,
                                    right: 16.0,
                                    left: 16.0,
                                    bottom: 4.0
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20.0)
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        spreadRadius: 4,
                                        blurRadius: 5,
                                        offset: Offset(0,2)
                                    )
                                  ],
                                  color: Colors.green[50],
                                ),
                                child: TextField(
                                  controller: _textEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      hintText: 'Email...',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      icon: Icon(Icons.email_outlined,
                                          color: Colors.black38
                                      ),
                                      border: InputBorder.none,
                                      counterText: ''
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50.0  ,
                                padding: EdgeInsets.only(
                                    top: 4.0,
                                    right: 16.0,
                                    left: 16.0,
                                    bottom: 4.0
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20.0)
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        spreadRadius: 4,
                                        blurRadius: 5,
                                        offset: Offset(0,2)
                                    )
                                  ],
                                  color: Colors.green[50],
                                ),
                                child: TextField(
                                  controller: _textPass,
                                  keyboardType: TextInputType.text,
                                  obscureText: _isObscure,
                                  decoration: InputDecoration(
                                      hintText: 'Mot de passe...',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      icon: Icon(Icons.lock_outline,
                                          color: Colors.black38
                                      ),
                                      border: InputBorder.none,
                                      counterText: '',
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                            _isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),color:Colors.black38,
                                        onPressed: (){
                                          setState(() {
                                            _isObscure = !_isObscure;
                                          });
                                        },
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: RoundedLoadingButton(
                              elevation: 10,

                              color: Colors.green[900],
                              borderRadius: 20,
                              curve: Curves.easeIn,
                              child: Text('Connecter'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 2.0,
                                ),
                              ),
                              controller: _btnController,
                              onPressed: () async{
                                if(_textEmail.text =='' || _textPass.text==''){
                                  _btnController.stop();
                                  EasyLoading.showToast('L\'adresse mail et le mot de passe sont requis !!');
                                }else{
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  await HttpService.login(
                                      email: _textEmail.text,
                                      password: _textPass.text
                                  ).then((resp){
                                    print(resp);
                                    EasyLoading.dismiss();
                                    String status = resp['reponse']['status'];
                                    if(status =='success'){
                                      String hasPos = resp['reponse']['data_user']['pos_id'];
                                      if(hasPos == '' || hasPos ==null){
                                        _btnController.stop();
                                        EasyLoading.showInfo('Desolé ! vous n\'êtes pas autorisés à utiliser le POS !!');
                                      }
                                      else
                                      {
                                        prefs.setString('auth_data', jsonEncode(resp['reponse']['data_user']));
                                        HttpService.getCatalog().then((value){
                                          _btnController.success();
                                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen(catalogList: value.produits)),(Route<dynamic> route) =>false);
                                        });
                                      }
                                    }
                                    else{
                                      EasyLoading.showInfo('Vos identifiant sont erronés !');
                                      _btnController.stop();
                                    }

                                  });
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: -40,
                      right: 0,
                      left: 0,
                      child: Center(
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.green[300],
                                      Colors.green[100],
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                      offset: Offset(0,2)
                                  )
                                ]
                            ),
                            child: Icon(Icons.person_outline, color: Colors.green[800], size: 60,),
                          )
                      )
                  )
                ],
              ),
              
              Container(
                child: MediaQuery.of(context).viewInsets.bottom == 0 ?
                Padding(
                  padding: EdgeInsets.only(top: 90),
                  child: Column(
                    children: [
                      Text('Powered by RT Group drc',
                        style: TextStyle(color: Colors.green[900],fontSize: 14, letterSpacing: 1.5,fontWeight: FontWeight.w400) ,
                      )
                    ],
                  ),
                ) : null
              )
            ],
          ),
        ),
      ),
    );
  }
}
