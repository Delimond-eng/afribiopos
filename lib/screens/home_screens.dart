import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:afribiopos01/main.dart';
import 'package:afribiopos01/models/stock_catalog_model.dart';
import 'package:afribiopos01/pages/cart_page.dart';
import 'package:afribiopos01/pages/get_start_page.dart';
import 'package:afribiopos01/pages/inventory_page.dart';
import 'package:afribiopos01/services/http_service.dart';
import 'package:afribiopos01/services/route_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart';
import 'package:afribiopos01/globals.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {

  List<Produits> catalogList =[];
  HomeScreen({Key key, this.catalogList}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const platform = const MethodChannel("com.flutter.pos");
  List<Produits> catalogList=[];
  List<Produits> _searchResult = [];
  TextEditingController _searchText = new TextEditingController();
  int _counter = 0;
  String startmsg="";
  bool isStart = false;
  String _authData;

  void _initLocalData() async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.getString('auth_data');
      setState(() {
        startmsg = prefs.getString('option') == null ? "off" : prefs.getString('option');
        _counter = prefs.getInt('count') == null ? 0 : prefs.getInt('count');
        try{
          _authData = prefs.getString('auth_data');
          /*Timer.periodic(Duration(seconds: 120), (timer) {
            HttpService.getCatalog().then((value) {
              setState(() {
                widget.catalogList = value.produits;
              });
            });
          });
           */
        }
        catch(e){}
      });
    }
    catch(e){}
  }

  void getCart() async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String jsonData = prefs.getString('localCartData');
      Iterable i = jsonDecode(jsonData);

      List<Produits> details = List<Produits>.from(i.map((model)=> Produits.fromJson(model)));
      Navigator.push(context, SlideRightRoute(page: CartPage(
          venteDetails: details
      )));
    }
    catch(e){
      EasyLoading.showInfo('le panier est vide !!');
    }
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    _searchResult  =  widget.catalogList.where((i) => i.titre.toLowerCase().contains(text)).toList();
    setState(() {});
  }

  void globalForegroundService() {
    debugPrint("current datetime is ${DateTime.now()}");
  }

  void _initCount() async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _counter = prefs.getInt('count') == null ? 0 : prefs.getInt('count');
      });
    }
    catch(ex){}
  }

  @override
  void initState() {
    super.initState();
    _initCount();
    _initLocalData();
    setState(() {
      _controller.text = '1';
      catalogList = widget.catalogList;
    });
  }


  Future<Null> refresh() async {
    await Future.delayed(Duration(seconds: 8));
    HttpService.getCatalog().then((value){
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen( catalogList:value.produits)),
              (Route<dynamic> route) => false);
    });
    return null;
  }

  void refreshing() async{
    EasyLoading.show(status: "Actualisation en cours...",maskType: EasyLoadingMaskType.black);
    await HttpService.getCatalog().then((value){
      EasyLoading.dismiss();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen( catalogList:value.produits)),
              (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      drawer: buildDrawer(),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text(
            'Cliquez encore pour quitter !!',
            textAlign: TextAlign.center,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: refresh,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
                child: Container(
                  margin: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1,
                          offset: Offset(0,1),
                          spreadRadius: 0
                        )
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    controller: _searchText,
                    onChanged: onSearchTextChanged,
                    decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        filled: true,
                        border: InputBorder.none,
                        hintText: "Recherche...",
                        hintStyle: TextStyle(color: Colors.grey),
                        suffixIcon: Container(
                          width: 60,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0,5),
                                  spreadRadius: 2
                                )
                              ],
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.green[300],
                                    Colors.green[700]
                                  ]
                              )
                          ),
                          child: Icon(
                            Icons.search,
                            color: Colors.green[50],
                          ),
                        ),
                        focusColor: Colors.green),
                  ),
                ),
              ),
              Expanded(
                  child: _searchText.text.isNotEmpty || _searchResult.length > 0
                      ? Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: GridView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: _searchResult.length,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20.0,
                            crossAxisSpacing: 20.0,
                            childAspectRatio: 0.75),
                        itemBuilder: (context, index) => ItemCard(
                          produits: _searchResult[index],
                          press: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder:
                                    (BuildContext context) {
                                      return dialog(
                                        pId: _searchResult[index].produitId,
                                        title: _searchResult[index].titre,
                                        image: _searchResult[index].imageB64,
                                        prix: _searchResult[index].prixUnitaire,
                                        stock: _searchResult[index].stock,
                                        unite: 'Kg',
                                      );
                                });
                          },
                        )),
                      )
                      : Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0),
                    child: catalogList.length == 0
                        ? Center(
                      child: Text('Vous n\'avez pas des produits !, veuillez commander sur la plateforme afribio.org !',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.pink,
                          fontSize: 16,
                          letterSpacing: 1.5
                        ),
                      ),
                    )
                        : GridView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: catalogList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20.0,
                            crossAxisSpacing: 20.0,
                            childAspectRatio: 0.75),
                        itemBuilder: (context, index){
                          return ItemCard(
                            produits: widget.catalogList[index],
                            press: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder:
                                      (BuildContext context) {
                                    return dialog(
                                      pId: widget.catalogList[index].produitId,
                                      title: widget.catalogList[index].titre,
                                      image: widget.catalogList[index].imageB64,
                                      prix: widget.catalogList[index].prixUnitaire,
                                      stock: widget.catalogList[index].stock,
                                      unite: 'Kg',
                                    );
                                  });
                            },
                          );
                        }
                    )
                  )
              ),

            ],
          ),
        ),
      ),
      floatingActionButton: MediaQuery.of(context).viewInsets.bottom == 0 ? Padding(
        padding: const EdgeInsets.only(right: 120),
        child: startmsg=='off' || startmsg==null ?  FloatingActionButton.extended(
          onPressed: () async{
            SharedPreferences prefs = await SharedPreferences.getInstance();
            AwesomeDialog(
              context: context,
              dialogType: DialogType.WARNING,
              headerAnimationLoop: true,
              customHeader: Icon(Icons.help_center, size: 60, color: Colors.blue[400],),
              animType: AnimType.SCALE,
              title: 'POS !',
              desc: 'Voulez-vous commencer votre journée ?',
              buttonsTextStyle: TextStyle(color: Colors.white),
              showCloseIcon: false,
              btnCancelOnPress: () {

              },
              btnCancelColor: Colors.grey[700],
              btnOkColor: Colors.blue[400],
              btnOkOnPress: () async{
                print(startmsg);
                toggleForegroundServiceOnOff();
                setState(() {
                  startmsg = prefs.getString('option');
                });
                await Future.delayed(Duration(seconds: 1));
                EasyLoading.dismiss();
                await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen(
                  catalogList: widget.catalogList,
                )),(Route<dynamic> route) =>false);

              },
            )..show();
          },
          tooltip: 'Demarrer la journée',
          icon: Icon(Icons.play_arrow_rounded),
          backgroundColor: Colors.green[700],
          label: Text("Demarrer la journée",
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
        ) : FloatingActionButton.extended(
          onPressed: () async{
            AwesomeDialog(
              context: context,
              dialogType: DialogType.WARNING,
              headerAnimationLoop: true,
              customHeader: Icon(Icons.help_center_rounded, size: 60, color: Colors.deepOrangeAccent,),
              animType: AnimType.SCALE,
              title: 'POS',
              desc: 'Voulez-vous clôturer votre journée ?',
              buttonsTextStyle: TextStyle(color: Colors.white),
              showCloseIcon: false,
              btnCancelOnPress: () {

              },
              btnCancelColor: Colors.grey[700],
              btnOkColor: Colors.deepOrangeAccent,
              btnOkOnPress: () async{
                EasyLoading.show(status: 'Patientez...');
                SharedPreferences prefs = await SharedPreferences.getInstance();
                print(startmsg);
                toggleForegroundServiceOnOff();
                setState(() {
                  startmsg = prefs.getString('option');
                });
                await Future.delayed(Duration(seconds: 1));
                EasyLoading.dismiss();
                await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen(
                  catalogList: widget.catalogList,
                )),(Route<dynamic> route) =>false);
              },
            )..show();

          },
          tooltip: 'Clôturer la journée',
          icon: Icon(Icons.close),
          backgroundColor: Colors.deepOrange,
          label: Text("Clôturer la journée",
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ) : null,
    );
  }
  final _controller = TextEditingController();
  Dialog dialog({pId, title, image, prix, stock, unite}){

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 20.0,top: 45.0
                  + 20.0, right: 20.0,bottom: 20.0
              ),
              margin: EdgeInsets.only(top: 45.0),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(color: Colors.black,offset: Offset(0,10),
                        blurRadius: 10
                    ),
                  ]
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(title,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
                  SizedBox(height: 15,),
                  Text('$prix FC | kg',style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900, color: Colors.green[900]),textAlign: TextAlign.center,),
                  SizedBox(height: 15.0,),
                  Align(alignment: Alignment.topLeft, child: Text('  Quantité :', style: TextStyle(fontWeight: FontWeight.bold),)),
                  SizedBox(height: 5.0,),
                  Row(
                    children: <Widget>[
                      Container(
                        height: 48.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                topLeft: Radius.circular(15)
                            ),
                            color: int.parse(_controller.text) > 1 ? Colors.green.withOpacity(0.4) : Colors.green.withOpacity(0.2)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: IconButton(
                                icon: Icon(Icons.remove, size: 25, color: Colors.green[900]),
                                onPressed: (){
                                  int currentValue = int.parse(_controller.text);
                                  currentValue--;
                                  _controller.text =
                                      (currentValue >= 1 ? currentValue : 1)
                                          .toString();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                          ),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              fillColor: Colors.transparent,
                              filled: true,
                              border: InputBorder.none,
                              hintText: "Quantité de kg...",
                            ),
                            controller: _controller,
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: false,
                              signed: true,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 48.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(15),
                                topRight: Radius.circular(15)
                            ),
                            color: int.parse(_controller.text) == 1 ? Colors.green.withOpacity(0.4) : Colors.green.withOpacity(0.2)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: IconButton(
                                icon: Icon(Icons.add, size: 25, color: Colors.green[900]),
                                onPressed: (){
                                  int currentValue = int.parse(_controller.text);
                                  currentValue++;
                                  _controller.text = (currentValue)
                                      .toString();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 22,),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FlatButton(
                              onPressed: () async{
                                try{
                                  EasyLoading.show(status: 'waiting...');
                                  await Future.delayed(Duration(milliseconds: 500));
                                  Produits prod = Produits(
                                    produitId: pId,
                                    prixUnitaire: prix,
                                    stock: stock,
                                    titre: title,
                                    quantite: _controller.text,
                                    imageB64: image
                                  );
                                  addToCart(produit: prod);
                                }
                                catch(ex){
                                  print(ex);
                                }
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)
                              ),
                              color: Colors.green,
                              child: Text('Ajouter au panier',style: TextStyle(fontSize: 12, color: Colors.white),)
                          ),
                          SizedBox(width: 10,),
                          FlatButton(
                              onPressed: () async{
                                setState(() {
                                  _controller.text = '1';
                                });
                                Navigator.pop(context);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)
                              ),
                              color: Colors.pinkAccent,
                              child: Text('Fermer',style: TextStyle(fontSize: 12, color: Colors.white),)
                          ),
                        ],
                      )
                  ),
                ],
              ),
            ),
            Positioned(
              left: 20.0,
              right: 20.0,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 50.0,
                child: ClipRRect(
                    child: imageFromBase64String(image)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addToCart({Produits produit}) async{
    if(startmsg == 'off' || startmsg==null){
      EasyLoading.showInfo('Vous devez commencer la journée pour effectuer une vente !', duration: Duration(seconds: 5));
      Navigator.pop(context);
    }
    else{
      if(int.parse(produit.quantite) > int.parse(produit.stock)){
        await EasyLoading.showToast('Stock insuffisant pour cette quantité !!',duration: Duration(seconds: 3));
        return;
      }
      else{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        try{
          String jsonData = prefs.getString('localCartData');
          Iterable i = jsonDecode(jsonData);
          List<Produits> detailsExist = List<Produits>.from(i.map((model)=> Produits.fromJson(model)));
          for(int i=0; i<detailsExist.length; i++){
            if(detailsExist[i].produitId == produit.produitId){
              await EasyLoading.showToast('Ce produit existe déjà dans le panier !!',duration: Duration(seconds: 3));
              return;
            }
          }
          detailsExist.add(produit);
          String data = jsonEncode(detailsExist);
          prefs.setInt('count', detailsExist.length);
          prefs.setString('localCartData', data);
          await EasyLoading.showSuccess('produit ajouté au panier!', duration: Duration(seconds: 1));
          setState(() {
            _counter =prefs.getInt('count')==null ?detailsExist.length :  prefs.getInt('count');
            _controller.text ='1';
          });
          Navigator.pop(context);
          //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()),(Route<dynamic> route) =>false);
        }
        catch(e)
        {
          List<Produits> list =[];
          list.add(produit);
          String data = jsonEncode(list);
          prefs.setInt('count', list.length);
          prefs.setString('localCartData', data);
          await EasyLoading.showSuccess('produit ajouté au panier!', duration: Duration(seconds: 1));
          setState(() {
            _counter =prefs.getInt('count')==null ?list.length :  prefs.getInt('count');
            _controller.text='1';
          });
          Navigator.pop(context);
          //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()),(Route<dynamic> route) =>false);
        }
      }
    }
  }
  //appbar
  AppBar buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.green[50]),
      backgroundColor: Colors.green[700],
      elevation: 0,
      brightness: Brightness.dark,
      title: Text(
        'afribio POS'.toUpperCase(),
        style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.green[50],
            letterSpacing: 3.0,
            fontSize: 17,
            shadows: [
              Shadow(blurRadius: 1, color: Colors.black26, offset: Offset(0, 1))
            ]),
      ),
      actions: [
        IconButton(icon: Icon(Icons.refresh_rounded), onPressed: (){
          refreshing();
        }),
        Badge(
          badgeContent: Text(
            _counter.toString(),
            style: TextStyle(color: Colors.white),
          ),
          position: BadgePosition.topEnd(top: 8, end: 3),
          child: IconButton(
              icon: Icon(Icons.shopping_basket),
              onPressed: () {
                getCart();
              }),
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      elevation: 20,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[50],
        ),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: DrawerHeader(
                curve: Curves.easeInCirc,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green[900],
                      Colors.green[600]
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                  )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          child: Text(jsonDecode(_authData)['nom_complet'].toString().substring(0,1).toUpperCase(),
                            style: TextStyle(
                              color: Colors.green[800],
                              fontWeight: FontWeight.w900,
                              fontSize: 30
                            ),
                          )
                        ),
                        SizedBox(height: 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(jsonDecode(_authData)['nom_complet'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black26,
                                        offset: Offset(0,1),
                                        blurRadius: 1
                                    )
                                  ]
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text(jsonDecode(_authData)['email'],
                              style: TextStyle(
                                  color: Colors.white60,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      offset: Offset(0,1),
                                      blurRadius: 1
                                    )
                                  ]
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      onTap: (){
                        Navigator.pop(context);
                        getCart();
                      },
                      leading: Badge(
                        badgeContent: Text(_counter.toString(), style: TextStyle(color: Colors.white),),
                        position: BadgePosition.topEnd(top: -2, end: 15),
                        child: Icon(Icons.shopping_basket, color: Colors.green[900],),
                      ),
                      title: Text('Panier',
                        style: TextStyle(
                            color: Colors.green[900],
                            fontWeight: FontWeight.w400,
                            shadows: [
                              Shadow(
                                  color: Colors.black26,
                                  offset: Offset(0,1),
                                  blurRadius: 1
                              )
                            ]
                        ),
                      )
                      ,
                    ),
                    ListTile(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.push(context, SlideRightRoute(page: InventoryPage()));
                      },
                      leading: Icon(Icons.list_alt_sharp, color: Colors.green[900]),
                      title: Text('Inventaire',
                        style: TextStyle(
                            color: Colors.green[900],
                            fontWeight: FontWeight.w400,
                            shadows: [
                              Shadow(
                                  color: Colors.black26,
                                  offset: Offset(0,1),
                                  blurRadius: 1
                              )
                            ]
                        ),
                      ),
                    ),

                    Divider(color: Colors.white12,thickness: 1,height: 0,),

                    ListTile(

                      onTap: () async{
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.WARNING,
                          headerAnimationLoop: true,
                          customHeader: Icon(Icons.help_center, size: 60, color: Colors.blue[400],),
                          animType: AnimType.SCALE,
                          title: 'Deconnexion...!',
                          desc: 'Etes-vous sûr de vouloir vous deconnecter du POS ?',
                          buttonsTextStyle: TextStyle(color: Colors.white),
                          showCloseIcon: false,
                          btnCancelOnPress: () {

                          },
                          btnCancelColor: Colors.grey[700],
                          btnOkColor: Colors.blue[400],
                          btnOkOnPress: () async{
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString('auth_data', '');
                            Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>GetStartPage()),(Route<dynamic> route) =>false);
                          },
                        )..show();
                      },
                      leading: Icon(Icons.lock, color: Colors.green[900]),
                      title: Text('Deconnecter',
                        style: TextStyle(
                            color: Colors.green[900],
                            fontWeight: FontWeight.w400,
                            shadows: [
                              Shadow(
                                  color: Colors.black26,
                                  offset: Offset(0,1),
                                  blurRadius: 1
                              )
                            ]
                        ),
                      ),
                    ),

                    Divider(color: Colors.white12,thickness: 1,height: 0,),

                    ListTile(
                      onTap: (){
                        setState(() {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.WARNING,
                            headerAnimationLoop: true,
                            customHeader: Icon(Icons.warning_amber_outlined, size: 60, color: Colors.deepOrange[300],),
                            animType: AnimType.SCALE,
                            title: 'Avertissement !',
                            desc: 'Etes-vous sûr de vouloir quitter cette application ?',
                            buttonsTextStyle: TextStyle(color: Colors.white),
                            showCloseIcon: false,
                            btnCancelOnPress: () {

                            },
                            btnCancelColor: Colors.grey[700],
                            btnOkColor: Colors.deepOrange[300],
                            btnOkOnPress: () async{
                              exit(0);
                            },
                          )..show();
                        });
                      },
                      leading: Icon(Icons.cancel, color: Colors.green[900],),
                      title: Text('Quitter',
                        style: TextStyle(
                            color: Colors.green[900],
                            fontWeight: FontWeight.w400,
                            shadows: [
                              Shadow(
                                  color: Colors.black26,
                                  offset: Offset(0,1),
                                  blurRadius: 1
                              )
                            ]
                        ),
                      ),
                    ),

                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final Function press;
  final Produits produits;
  const ItemCard({
    Key key,
    this.press,
    this.produits,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: EdgeInsets.only(bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16.0),
                        topLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0),
                      bottomLeft: Radius.circular(16.0)
                    ),
                        
                  ),
                  child: imageFromBase64String(produits.imageB64)
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
              child: Center(
                child: Text(
                  produits.titre,
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.black87),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Center(
                child: Text(
                  '${produits.prixUnitaire} FC | Kg',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.green[900],
                      fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
