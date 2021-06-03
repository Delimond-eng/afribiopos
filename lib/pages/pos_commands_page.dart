import 'package:afribiopos01/manager/pos_command_manager.dart';
import 'package:afribiopos01/models/pos_commande_model.dart';
import 'package:afribiopos01/pages/details/commad_detail_page.dart';
import 'package:afribiopos01/services/route_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class PosCommandsPage extends StatefulWidget {
  PosCommandsPage({Key key, this.commands}) : super(key: key);

  final List<Commandes> commands;

  @override
  _PosCommandsPageState createState() => _PosCommandsPageState();
}

class _PosCommandsPageState extends State<PosCommandsPage> {
  final PosCommandsManager manager = PosCommandsManager();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Commandes à livrer",
          style: TextStyle(fontSize: 18.0),
        ),
        backgroundColor: Colors.green[800],
        elevation: 0,
      ),
      body: ListView.separated(
        itemCount: widget.commands.length,
        itemBuilder: (context, index) {
          Commandes command = widget.commands[index];
          return ListTile(
            title: Text("Adresse : ${command.adresse}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Coordonnés ${command.gpsPosition}", style: TextStyle(
                  fontSize: 11
                ),),
                Text("à livrer dans ${command.delaiLivraison}", style: TextStyle(
                    fontSize: 12,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold
                ),),
              ],
            ),
            leading: CircleAvatar(),
            trailing: Icon(Icons.chevron_right_rounded),
            onTap: () {
              List<Details> details = command.details;
              Navigator.push(
                  context,
                  SlideRightRoute(
                      page: CommandDetailsPage(
                        details: details,
                      )));
            },
          );
        },
        separatorBuilder: (contex, i) => Divider(),
      )
    );
  }
}
