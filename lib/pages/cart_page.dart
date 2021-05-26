import 'dart:convert';

import 'package:afribiopos01/globals.dart';
import 'package:afribiopos01/models/stock_catalog_model.dart';
import 'package:afribiopos01/screens/home_screens.dart';
import 'package:afribiopos01/services/http_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
class CartPage extends StatefulWidget {
  final List<Produits> venteDetails;

  CartPage({Key key, this.venteDetails}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  static const platform = const MethodChannel("com.flutter.pos");
  final userTextPhone = TextEditingController();
  double total = 0;
  @override
  void initState() {
    super.initState();
    getTotal();
  }

  void getTotal(){
    for(int i=0; i<widget.venteDetails.length; i++){
      setState(() {
        total += (double.parse(widget.venteDetails[i].prixUnitaire)) * (double.parse(widget.venteDetails[i].quantite));
      });
    }
  }

  void deleteFromCart({int index}) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      String jsonData = prefs.getString('localCartData');
      Iterable i = jsonDecode(jsonData);
      List<Produits> existCart = List<Produits>.from(i.map((model)=>Produits.fromJson(model)));
      existCart.removeAt(index);
      String data = jsonEncode(existCart);
      prefs.setInt('count', existCart.length);
      LocalStorage().store(key: 'localCartData', value: data);
      setState(() {
        widget.venteDetails.removeAt(index);
        for(int i=0; i<widget.venteDetails.length; i++){
          setState(() {
            total = 0;
            total+=(double.parse(existCart[i].prixUnitaire)) * (double.parse(widget.venteDetails[i].quantite));
          });
        }
      });

    }
    catch(e)
    {
      print('error $e');
    }
  }

  void confirmTrade() async{
    try{
      EasyLoading.show(status: 'Patientez SVP...', maskType: EasyLoadingMaskType.black);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String jsonData = prefs.getString('localCartData');

      Iterable i = jsonDecode(jsonData);
      List<Produits> detailsExist = List<Produits>.from(i.map((model)=> Produits.fromJson(model)));

      if(detailsExist.length == 0){
        await EasyLoading.showInfo('Echec de confirmation !!',duration: Duration(seconds: 1));
        return;
      }
      String posVenteId ='';
      try{
        for(int i=0; i<detailsExist.length; i++){
          await HttpService.addToCart(
              productId: detailsExist[i].produitId,
              quantity: detailsExist[i].quantite,
              posTradeId: posVenteId == '' ? '' : int.parse(posVenteId),
              prix: detailsExist[i].prixUnitaire
          ).then((res) async{
            if(posVenteId == '' || posVenteId ==null){
              setState(() {
                posVenteId = res.reponse.posVenteId.toString();
                print(posVenteId);
              });
            }
          });
        }
      }catch(e){
        await EasyLoading.showInfo('Votre stock est epuisé !!',duration: Duration(seconds: 3));
        return;
      }
      await HttpService.validTrading(
        tradeId: int.parse(posVenteId),
        customerPhone: userTextPhone.text
      ).then((resp) async{
        if(resp ==null){
          EasyLoading.showError('Vente non effectuée !');
          await EasyLoading.dismiss();
        }
        if(resp['reponse']['status'] =='confirme'){
          printing();
          await HttpService.getCatalog().then((value) async{
            prefs.setString('localCartData', '[]');
            prefs.setInt('count', 0);
            EasyLoading.showSuccess('Vente effectuée !', duration: Duration(seconds: 3));
            //print
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen(catalogList: value.produits)),(Route<dynamic> route) =>false);
          });
        }
        else{
          EasyLoading.showError('Vente non effectuée !', duration: Duration(seconds: 1));
          await EasyLoading.dismiss();
        }
      });
    }
    catch(ex){
      await EasyLoading.showError('La vente n\'a pas été effectuée! réessayez SVP!', duration: Duration(seconds: 5));
      print(ex);
    }
  }

  void printing() async{
    String value;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = prefs.getString('localCartData');

    String jsonParserToArray = "{\"cart\" : $jsonData }";

    try{
      value = await platform.invokeMethod('printing',jsonParserToArray);
    }
    catch(e){
      print(e);
    }
    print(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        elevation: 0,
        title: Text('Panier',
          style: TextStyle(
              color: Colors.white,
              shadows: [
                Shadow(
                    color: Colors.black12,
                    blurRadius: 2.0,
                    offset: Offset(0, 2)
                )
              ]
          ),
        ),
        backgroundColor: Colors.green[700],
      ),
      body: widget.venteDetails.length == 0
          ? SingleChildScrollView(
        physics: BouncingScrollPhysics(),
            reverse: true,

            child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 60, left: 60, top: 80),
                          child: Image.asset('assets/images/nocart2.png'),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(height: 100,),
                      Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            verticalDirection: VerticalDirection.down,
                            children: [
                              Text('Votre panier est vide !',
                                style: TextStyle(
                                    color: Color(0xFF28558a),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                    letterSpacing: 2.0,
                                    shadows: [
                                      Shadow(
                                          color: Colors.black12,
                                          offset: Offset(0,2),
                                          blurRadius: 2.0
                                      )
                                    ]
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF28558a),
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            offset: Offset(0,3),
                                            blurRadius: 2,
                                            spreadRadius: 2
                                        )
                                      ]
                                  ),
                                  height:50.0,
                                  child: FlatButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      child: Text('Ajouter des produits'.toUpperCase(), style: TextStyle(color: Colors.white,letterSpacing: 1.5))
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                ],
            ),
          )
          : SingleChildScrollView(
        reverse: true,
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 0.75
                ),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.venteDetails.length,
                itemBuilder: (context, index){
                  return ItemCard(
                    id: widget.venteDetails[index].produitId,
                    title: widget.venteDetails[index].titre,
                    image: widget.venteDetails[index].imageB64,
                    quantite: widget.venteDetails[index].quantite,
                    prix: widget.venteDetails[index].prixUnitaire,
                    onDelete: (){
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.WARNING,
                        headerAnimationLoop: true,
                        customHeader: Icon(Icons.help_rounded, size: 60, color: Colors.deepOrange[300],),
                        animType: AnimType.SCALE,
                        title: 'Panier',
                        desc: 'Etes-vous sûr de vouloir supprimer ce produit du panier ?',
                        buttonsTextStyle: TextStyle(color: Colors.white),
                        showCloseIcon: false,
                        btnCancelOnPress: () {

                        },
                        btnCancelColor: Colors.grey[700],
                        btnOkOnPress: () async{
                          deleteFromCart(index: index);
                        },
                      )..show();
                    },
                  );
                },
              )
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
              child: Column(
                children: [
                  Divider(color: Colors.grey,height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total :',
                          style: TextStyle(
                            letterSpacing: 1.2,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text('$total Fc',
                          style: TextStyle(
                            letterSpacing: 1.2,
                            color: Colors.green[900],
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
              child: TextField(

                controller: userTextPhone,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  counterText: '',
                    suffixIcon: Icon(Icons.person_outline,color: Colors.green[700]),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green[700]),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green[800]),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: 'Entrez le téléphone du client...',
                    hintStyle: TextStyle(color: Colors.grey[400])),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0, top: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 60.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [
                      Colors.green[500],
                      Colors.green[900]
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                  )
                ),
                child: FlatButton(
                    onPressed: (){
                      confirmTrade();
                    },
                    child: Text('Valider commande'.toUpperCase(), style: TextStyle(color: Colors.white, letterSpacing: 1.2),)
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}

class ItemCard extends StatelessWidget {

  final Function onDelete;
  final String id;
  final String title;
  final String image;
  final String quantite;
  final String prix;

  ItemCard({Key key,this.id, this.onDelete, this.title, this.image, this.quantite, this.prix}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
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
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16.0)
                    ),
                    child: imageFromBase64String(image)
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                child: Center(
                  child: Text(
                    'Qté : ${quantite} Kg',
                    style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black87),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Center(
                  child: Text(
                    '${prix} FC | kg',
                    style: TextStyle(fontWeight: FontWeight.w900, color: Colors.green[900], fontSize: 18.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            height: 40,
            child: FloatingActionButton(
              backgroundColor: Colors.grey[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16)
                )
              ),
              onPressed: onDelete,
              child: Icon(Icons.clear, color: Colors.white,),
            )
          )
        )
      ],
    );
  }
}


