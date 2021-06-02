import 'dart:convert';
import 'dart:io';

import 'package:afribiopos01/models/catalog_model.dart';
import 'package:afribiopos01/models/inventory_model.dart';
import 'package:afribiopos01/models/pos_commande_model.dart';
import 'package:afribiopos01/models/stock_catalog_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpService {
  static final String url = 'https://afribio.org';

  static Future login({String email, String password}) async {
    try {
      http.Response response = await http.post(
          Uri.parse('$url/acquereurs/login'),
          headers: {HttpHeaders.authorizationHeader: 'tP@d_4gB42c'},
          body: jsonEncode(<String, dynamic>{
            'email': email,
            'pass': password,
            'from': 'pos'
          }));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('login error $e');
    }
  }

  static Future<Catalog> getCatalog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authData = prefs.getString('auth_data');
    int posId = int.parse(jsonDecode(authData)['pos_id']);
    http.Response response = await http.post(Uri.parse('$url/pos/produits'),
        headers: {HttpHeaders.authorizationHeader: 'tP@d_4gB42c'},
        body: jsonEncode(<String, dynamic>{'pos_id': posId.toString()}));
    return Catalog.fromJson(jsonDecode(response.body));
  }

  static Stream<Catalog> getStreamCatalog() async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authData = prefs.getString('auth_data');
    int posId = int.parse(jsonDecode(authData)['pos_id']);
    http.Response response = await http.post(Uri.parse('$url/pos/produits'),
        headers: {HttpHeaders.authorizationHeader: 'tP@d_4gB42c'},
        body: jsonEncode(<String, dynamic>{'pos_id': posId.toString()}));
    yield Catalog.fromJson(jsonDecode(response.body));
  }

  static Future<Inventory> getInventories({String date}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authData = prefs.getString('auth_data');
    int posId = int.parse(jsonDecode(authData)['pos_id']);
    http.Response response = await http.post(
        Uri.parse('$url/pos/ventes/inventaire'),
        headers: {HttpHeaders.authorizationHeader: 'tP@d_4gB42c'},
        body: jsonEncode(
            <String, dynamic>{'pos_id': posId.toString(), 'date': date}));

    return Inventory.fromJson(jsonDecode(response.body));
  }

  static Future<List<Products>> filter(String text) async {
    http.Response response = await http.get(
        Uri.parse('$url/acquereurs/produit/all?q=$text'),
        headers: {HttpHeaders.authorizationHeader: 'tP@d_4gB42c'});

    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> data = map["produits"];

    List<Products> datas = [];

    for (var p in data) {
      Products produits = Products(
          produitId: p['produit_id'],
          titre: p['titre'],
          image: p['image'],
          prixMoyen: p['prix_moyen'],
          unite: p['unite']);
      datas.add(produits);
    }
    return datas;
  }

  static Future getStartDay({String opt}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authData = prefs.getString('auth_data');
    int posId = int.parse(jsonDecode(authData)['pos_id']);
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    try {
      http.Response response = await http.post(Uri.parse('$url/pos/gps'),
          headers: {HttpHeaders.authorizationHeader: 'tP@d_4gB42c'},
          body: jsonEncode(<String, dynamic>{
            'pos_id': posId.toString(),
            'gps_position': '${position.latitude} | ${position.longitude}',
            'activite': opt
          }));
      return jsonDecode(response.body);
    } catch (e) {}
  }

  static Stream getStart({opt}) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authData = prefs.getString('auth_data');
    int posId = int.parse(jsonDecode(authData)['pos_id']);
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    try {
      http.Response response = await http.post(Uri.parse('$url/pos/gps'),
          headers: {HttpHeaders.authorizationHeader: 'tP@d_4gB42c'},
          body: jsonEncode(<String, dynamic>{
            'pos_id': posId.toString(),
            'gps_position': '${position.latitude} | ${position.longitude}',
            'activite': opt
          }));
      yield jsonDecode(response.body);
    } catch (e) {}
  }

  static Future<CardDetails> addToCart(
      {productId, quantity, gps, posTradeId, prix}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authData = prefs.getString('auth_data');
    int posId = int.parse(jsonDecode(authData)['pos_id']);
    try {
      http.Response response;
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (posTradeId == '' || posTradeId == null) {
        response = await http.post(Uri.parse('$url/pos/ventes'),
            headers: {HttpHeaders.authorizationHeader: 'tP@d_4gB42c'},
            body: jsonEncode(<String, dynamic>{
              'pos_id': posId.toString(),
              'produit_id': productId,
              'quantite': quantity,
              'gps_position': '${position.latitude} | ${position.longitude}',
              'prix_unitaire': prix
            }));
      } else {
        response = await http.post(Uri.parse('$url/pos/ventes'),
            headers: {HttpHeaders.authorizationHeader: 'tP@d_4gB42c'},
            body: jsonEncode(<String, dynamic>{
              'pos_id': posId.toString(),
              'produit_id': productId,
              'quantite': quantity,
              'gps_position': '${position.latitude} | ${position.longitude}',
              'pos_vente_id': posTradeId,
              'prix_unitaire': prix
            }));
      }

      if (response.statusCode == 200) {
        return CardDetails.fromJson(jsonDecode(response.body));
      }
    } catch (ex) {
      print(ex);
    }
  }

  static Future validTrading({tradeId, customerPhone}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authData = prefs.getString('auth_data');
    int posId = int.parse(jsonDecode(authData)['pos_id']);
    try {
      http.Response response =
          await http.post(Uri.parse('$url/pos/ventes/confirmer'),
              headers: {HttpHeaders.authorizationHeader: 'tP@d_4gB42c'},
              body: jsonEncode(<String, dynamic>{
                'pos_id': posId.toString(),
                'pos_vente_id': tradeId,
                'acheteur_telephone': customerPhone,
              }));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (ex) {
      print(ex);
    }
  }

  static Future<PosCommandes> getPosCommands() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authData = prefs.getString('auth_data');
    int posId = int.parse(jsonDecode(authData)['pos_id']);

    http.Response response = await http.post(Uri.parse('$url/pos/commandes'),
        headers: {HttpHeaders.authorizationHeader: 'tP@d_4gB42c'},
        body: jsonEncode(<String, dynamic>{
          'pos_id': posId.toString(),
        }));

    if (response.statusCode == 200) {
      return PosCommandes.fromJson(jsonDecode(response.body));
    }
    return PosCommandes.fromJson(jsonDecode(response.body));
  }
}
