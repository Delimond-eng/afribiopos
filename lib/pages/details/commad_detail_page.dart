import 'package:afribiopos01/models/pos_commande_model.dart';
import 'package:flutter/material.dart';

class CommandDetailsPage extends StatefulWidget {
  final List<Details> details;
  CommandDetailsPage({Key key, this.details}) : super(key: key);

  @override
  _CommandDetailsPageState createState() => _CommandDetailsPageState();
}

class _CommandDetailsPageState extends State<CommandDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Commandes à livrer",
          style: TextStyle(fontSize: 18.0),
        ),
        elevation: 0,
      ),
      body: ListView.builder(
          itemCount: widget.details.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(widget.details[index].titre),
              leading: CircleAvatar(
                backgroundColor: Colors.green,
                child: Image.network(widget.details[index].image),
              ),
              subtitle: Text("Quantité : ${widget.details[index].quantite}"),
              trailing: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "prix unitaire",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0),
                  ),
                  Text(
                    "Quantité",
                    style:
                        TextStyle(fontWeight: FontWeight.w900, fontSize: 12.0),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
