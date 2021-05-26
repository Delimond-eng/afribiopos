import 'package:afribiopos01/models/catalog_model.dart';
import 'package:flutter/material.dart';

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
    return GestureDetector(
      onTap: press,
      child: Container(
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

            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Center(
                child: Text(
                  '${produits.prixMoyen} FC | ${produits.unite}',
                  style: TextStyle(fontWeight: FontWeight.w900, color: Colors.green[900], fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}