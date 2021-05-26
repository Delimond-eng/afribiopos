import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/catalog_model.dart';

class InternalCart{

  static addToCart({produitId, produitTitre, produitImage, produitQte}) async{
    //List<Details> cartDetails = [];
    Details details = Details();
    details.titre = produitTitre;
    details.produitId = produitId;
    details.image = produitImage;
    details.quantite = produitQte;
    //cartDetails.add(details);
    LocalStorage().store(key: 'data', value: Details().toJson());
  }
}

class LocalStorage{
  read({String key}) async{
    final prefs = await SharedPreferences.getInstance();
    return jsonDecode(prefs.getString(key));
  }
  
  store({String key, value}) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  storeList({String key, value}) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }
  
  delete({String key}) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
    prefs.remove('count');
  }
}

Image imageFromBase64String(String base64String) {
  try{
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.scaleDown,
    );
  }catch(e){}

}

Stream<int> counterCart() async*{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  yield prefs.getInt('count');
}