import 'package:afribiopos01/manager/pos_command_manager.dart';
import 'package:afribiopos01/models/pos_commande_model.dart';
import 'package:afribiopos01/pages/details/commad_detail_page.dart';
import 'package:afribiopos01/services/route_service.dart';
import 'package:flutter/material.dart';

class PosCommandsPage extends StatefulWidget {
  PosCommandsPage({Key key}) : super(key: key);

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
      body: StreamBuilder<PosCommandes>(
        stream: manager.posCommandView,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<Commandes> commands = snapshot.data.commandes;
          return ListView.separated(
            itemCount: commands.length,
            itemBuilder: (context, index) {
              Commandes command = commands[index];
              return Card(
                elevation: 2,
                color: (index % 2 == 0) ? Colors.green[100] : null,
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Commande ${command.adresse}"),
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.red, Colors.yellow])),
                        padding: EdgeInsets.all(5),
                        child: Text("à livrer dans ${command.delaiLivraison}"),
                      )
                    ],
                  ),
                  subtitle: Text("Coordonnés ${command.gpsPosition}"),
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
                ),
              );
            },
            separatorBuilder: (contex, i) => Divider(),
          );
        },
      ),
    );
  }
}
