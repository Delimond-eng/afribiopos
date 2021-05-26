
import 'package:afribiopos01/models/inventory_model.dart';
import 'package:flutter/material.dart';

class CurrentInventoryPage extends StatefulWidget {
  final List<Details> inventories;
  final double total;
  CurrentInventoryPage({Key key, this.inventories, this.total}) : super(key: key);
  @override
  _CurrentInventoryPageState createState() => _CurrentInventoryPageState();
}

class _CurrentInventoryPageState extends State<CurrentInventoryPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.green[900]
        ),
        backgroundColor: Colors.green[100],
        centerTitle: true,
        title: Text('Inventaire',
            style: TextStyle(
                color: Colors.green[900],
                shadows: [
                  Shadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 2)
                  )
                ]
            )
        ),
        elevation: 0,
      ),

      body: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          buildBody(),
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.green[100]
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                )
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('TOTAL : ',
                    style: TextStyle(
                        color: Colors.green[900],
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0
                    ),
                  ),
                  Text('${widget.total != null ? widget.total : 0 } Fc',
                    style: TextStyle(
                        color: Colors.green[900],
                        fontWeight: FontWeight.w900,
                        fontSize: 15.0
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildBody() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.inventories.length,
      itemBuilder: (context, i) {
        int total = (int.parse(widget.inventories[i].quantite)) * (int.parse(widget.inventories[i].prixUnitaire));
        return Container(
          decoration: BoxDecoration(
              border: Border(
                  right: BorderSide.none,
                  left: BorderSide.none,
                  top: BorderSide.none,
                  bottom: BorderSide(
                      color: Colors.grey.withOpacity(.2),
                      width: 1
                  )
              )
          ),
          child: ListTile(
            leading: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.green[100],
                    shape: BoxShape.circle
                ),
                child: Text(
                  '${widget.inventories[i].titre.substring(0,1).toUpperCase()}',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.green[900]
                  ),
                )
            ),
            title: Text(widget.inventories[i].titre,
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.green[900]
              ),
            ),
            subtitle: Text('Quantité : ${widget.inventories[i].quantite} Kg',
              style: TextStyle(
                  fontWeight: FontWeight.w500
              ),
            ),
            trailing: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Sous total'),
                  SizedBox(height: 5,),
                  Text('$total Fc', style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
