import 'package:afribiopos01/models/catalog_model.dart';
import 'package:afribiopos01/services/http_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class StockPage extends StatefulWidget {
  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {


  final _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller.text = '1';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[100],
        iconTheme: IconThemeData(color: Colors.green[900]),
        brightness: Brightness.dark,
        elevation: 5,
        shadowColor: Colors.black12,
        centerTitle: true,
        title: Text('Ajout stock',
          style: TextStyle(
              color: Colors.green[900],
              shadows: [
                Shadow(
                    color: Colors.black26,
                    blurRadius: 2.0,
                    offset: Offset(0, 2)
                )
              ]
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: FutureBuilder(
          future: HttpService.getCatalog(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.data ==null){
              return loadingShimmed();
            }
            else{
              EasyLoading.dismiss();
              return Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: GridView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20.0,
                        crossAxisSpacing: 20.0,
                        childAspectRatio: 0.75
                    ),
                    itemBuilder: (context, index) => ItemCard(
                      produits: snapshot.data[index],
                      press: (){
                        showBottomSheet(context,
                          image: snapshot.data[index].image,
                          titre: snapshot.data[index].titre
                        );
                      },
                    )
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget loadingShimmed(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        itemCount: 16,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.75
        ),
        itemBuilder: (context, index) => GestureDetector(
          onTap: (){
            showBottomSheet(context,
              titre: 'Produit titre'
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
        ),
      ),
    );
  }

  void showBottomSheet(context, {String image, String titre}){
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)
          )
        ),
        elevation: 10,
        backgroundColor: Colors.green[50],
        context: context,
        builder: (context){
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: 100,
                      height: 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.green[900]
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      image==null || image=='' ? Image.asset('assets/images/cart_empty.png',
                        height: 100,
                        width: 150,
                        fit: BoxFit.fill,
                      )
                      :
                      Image.network(image,
                        fit: BoxFit.fill,
                        width: 150,
                        height: 100,
                      ),
                      SizedBox(height: 10,),
                      Text(titre,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.green[900],
                            fontWeight: FontWeight.w900,
                            fontSize: 18.0
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text('Veuillez ajouter votre stock du produit sélectionné!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('Quantité | Kg:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 5, right: 20, left: 20),
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 48.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      topLeft: Radius.circular(20)
                                  ),
                                  color: Colors.green.withOpacity(0.2)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: IconButton(
                                      icon: Icon(Icons.remove, size: 25, color: Colors.green[900]),
                                      onPressed: (){
                                        try{
                                          int currentValue = int.parse(_controller.text);
                                          currentValue--;
                                          _controller.text =
                                              (currentValue >= 1 ? currentValue : 1)
                                                  .toString();
                                        }
                                        catch(e){}
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
                                      bottomRight: Radius.circular(20),
                                      topRight: Radius.circular(20)
                                  ),
                                  color: Colors.green.withOpacity(0.4)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: IconButton(
                                      icon: Icon(Icons.add, size: 25, color: Colors.green[900]),
                                      onPressed: (){
                                        try{
                                          int currentValue = int.parse(_controller.text);
                                          currentValue++;
                                          _controller.text = (currentValue)
                                              .toString();
                                        }
                                        catch(e){}
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20,top: 5, bottom: 0),
                        child: AnimatedButton(
                          borderRadius: BorderRadius.circular(20),
                          pressEvent: (){},
                          text: 'AJOUTER',
                          color: Colors.green[900],
                          buttonTextStyle: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        }
    );
  }
  
}




class ItemCard extends StatelessWidget {
  final Function press;
  final Products produits;
  const ItemCard({
    Key key,
    this.press,
    this.produits,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16.0),
                      topLeft: Radius.circular(16.0)
                  ),
                ),
                child: Image.network(
                  produits.image.replaceAll('http', 'https'),
                  fit: BoxFit.fill,
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
            child: Center(
              child: Text(
                produits.titre,
                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
              ),
            ),
          ),

          OutlineButton(
              onPressed: press,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              borderSide: BorderSide(
                color: Colors.green[900]
              ),
              child: Text('ajouter stock'.toUpperCase(), style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 10,
                color: Colors.green[900]
              ),),
          )

        ],
      ),
    );
  }
}