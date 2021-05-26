import 'package:afribiopos01/pages/current_inventory_page.dart';
import 'package:afribiopos01/services/http_service.dart';
import 'package:afribiopos01/services/route_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {

  double totalOfDay = 0;

  void getTotal() async{
    WidgetsFlutterBinding.ensureInitialized();
    DateTime currentDate = DateTime.now().toLocal();
    String currentFormattedDate = DateFormat('dd/MM/yyyy').format(currentDate);
    HttpService.getInventories(date: currentFormattedDate).then((data){
      setState(() {
        totalOfDay = double.parse(data.inventaire.total.toString());
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getTotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(        // Add AppBar here only
        backgroundColor: Colors.green[100],
        elevation: 0.0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(
            color: Colors.green[900]
        ),
        title: Text("Inventaire",
            style: TextStyle(
                color: Colors.green[900],
                letterSpacing: 1.5,
                fontWeight: FontWeight.w900,
                shadows: [
                  Shadow(
                      color: Colors.black12,
                      blurRadius: 2.0,
                      offset: Offset(0, 2)
                  )
                ]
            )
        ),
      ),
      body: _customBody(),
      backgroundColor: Colors.white,
    );
  }

  Widget _customBody(){
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topDashboard(),
          /*SizedBox(height: 20.0),
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                color: Colors.green[300],
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    topRight: Radius.circular(30)
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(2,5),
                      blurRadius: 10,
                      spreadRadius: 2
                  )
                ]
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.shopping_basket_outlined, size: 50, color: Colors.white,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Produits vendus',
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.2,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      Text('$numberOfProductBuy',
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.2,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900
                        ),
                      ),
                    ],
                  ),
                  OutlineButton(
                    onPressed: (){
                      Navigator.push(context, SlideRightRoute(page: DetailInventory()));
                    },
                    child: Text('Voir details', style: TextStyle(color: Colors.white),),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    borderSide: BorderSide(
                        color: Colors.white
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 20.0,),
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                color: Colors.blue[500],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    topLeft: Radius.circular(30)
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black45,
                      offset: Offset(2,3),
                      blurRadius: 10,
                      spreadRadius: 1.5
                  )
                ]
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlineButton(
                    onPressed: (){},
                    child: Text('Voir details', style: TextStyle(color: Colors.white),),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    borderSide: BorderSide(
                        color: Colors.white
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Produits restants',
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.2,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      Text('500',
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.2,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.shopping_basket, size: 50, color: Colors.white,),
                ],
              ),
            ),
          ),*/
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: CalendarCarousel(
                    weekendTextStyle: TextStyle(
                      color: Colors.red,
                    ),
                    thisMonthDayBorderColor: Colors.grey,
                    weekFormat: false,
//      firstDayOfWeek: 4,
                    height: 400.0,
                    customGridViewPhysics: NeverScrollableScrollPhysics(),
                    showHeader: true,
                    headerTextStyle: TextStyle(
                        color: Colors.green[900],
                        fontSize: 18
                    ),

                    todayTextStyle: TextStyle(
                      color: Colors.blue,
                    ),
                    todayButtonColor: Colors.yellow,
                    selectedDayTextStyle: TextStyle(
                      color: Colors.yellow,
                    ),
                    prevDaysTextStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.pinkAccent,
                    ),
                    inactiveDaysTextStyle: TextStyle(
                      color: Colors.tealAccent,
                      fontSize: 16,
                    ),
                    onDayPressed: (date, events){
                      String currentFormattedDate = DateFormat('dd/MM/yyyy').format(date);
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)
                              )
                          ),
                          elevation: 10,
                          backgroundColor: Colors.white,
                          context: context,
                          builder: (context){
                            return SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(bottom: 10, top: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Voir l\'inventaire du',
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 15,
                                              letterSpacing: 1.2,
                                              fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5,),
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: Colors.green[50],
                                          ),
                                          child: Text(currentFormattedDate,
                                            style: TextStyle(
                                                color: Colors.green[900],
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 1.5
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            height: 50,
                                            decoration : BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  spreadRadius: 5,
                                                  blurRadius: 15,
                                                  offset: Offset(0,2)
                                                )
                                              ],
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.green[600],
                                                  Colors.green[900]
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter
                                              )
                                            ),
                                            child: FlatButton(
                                                onPressed: (){
                                                  print(currentFormattedDate);
                                                  EasyLoading.show(status: 'Chargement...');
                                                  HttpService.getInventories(date: currentFormattedDate).then((data){
                                                    if(data.inventaire.details.length == 0){
                                                      EasyLoading.showError('Il n\'y a pas d\'inventaire pour la date du $currentFormattedDate!!');
                                                      return;
                                                    }
                                                    EasyLoading.dismiss();
                                                    Navigator.push(context, SlideRightRoute(page: CurrentInventoryPage(
                                                      inventories: data.inventaire.details,
                                                      total: double.parse(data.inventaire.total.toString()),
                                                    )));
                                                  });
                                                },
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20)
                                                ),
                                                child: Text('CONTINUER',
                                                  style: TextStyle(
                                                      letterSpacing: 1.5,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 12
                                                  ),
                                                )
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
                    },
                    selectedDayButtonColor: Colors.green[700],
                    locale: 'fr',
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget topDashboard(){
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 0),
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.green[200],
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 10,
                  blurRadius: 10,
                  offset: Offset(0, 2)
              )
            ]
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)
                    )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text('Situation des ventes journalières'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.green[900],
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Journalier'.toUpperCase(),
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                shadows: [
                                  Shadow(
                                      color: Colors.black12,
                                      blurRadius: 2.0,
                                      offset: Offset(0, 2)
                                  )
                                ]
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right:160),
                            child: Divider(color: Colors.grey[200],),
                          ),
                          Text('$totalOfDay Fc',
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 30.0,
                                fontWeight: FontWeight.w900,
                                shadows: [
                                  Shadow(
                                      color: Colors.black38,
                                      blurRadius: 2.0,
                                      offset: Offset(0, 2)
                                  )
                                ]
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 2, left: 10, right: 10),
                child: FlatButton(
                  child: Text('Voir détail inventaire journalier', style: TextStyle(color: Colors.green[900]),),
                  onPressed: (){
                    DateTime currentDate = DateTime.now().toLocal();
                    String currentFormattedDate = DateFormat('dd/MM/yyyy').format(currentDate);
                    print(currentFormattedDate);

                    EasyLoading.show(status: 'Chargement...');
                    HttpService.getInventories(date: currentFormattedDate).then((data){
                      if(data.inventaire.details.length == 0){
                        EasyLoading.showError('Il n\'y a pas d\'inventaire pour la date d\'aujourd\'hui!!');
                        return;
                      }
                      EasyLoading.dismiss();
                      Navigator.push(context, SlideRightRoute(page: CurrentInventoryPage(
                        inventories: data.inventaire.details,
                        total: double.parse(data.inventaire.total.toString()),
                      )));
                    });

                  },
                ),

              ),
            )
          ],
        ),
      ),
    );
  }
}
