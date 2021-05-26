import 'dart:convert';

class Products {
  String produitId;
  String titre;
  String image;
  String unite;
  int prixMoyen;

  Products(
      {this.produitId,
      this.titre,
      this.image,
      this.unite,
      this.prixMoyen});
}

class CardDetails {
  Reponse _reponse;

  CardDetails({Reponse reponse}) {
    this._reponse = reponse;
  }

  Reponse get reponse => _reponse;
  set reponse(Reponse reponse) => _reponse = reponse;

  CardDetails.fromJson(Map<String, dynamic> json) {
    _reponse =
    json['reponse'] != null ? new Reponse.fromJson(json['reponse']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._reponse != null) {
      data['reponse'] = this._reponse.toJson();
    }
    return data;
  }
}

class Reponse {
  String _status;
  int _posVenteId;
  List<Details> _details;

  Reponse({String status, int posVenteId, List<Details> details}) {
    this._status = status;
    this._posVenteId = posVenteId;
    this._details = details;
  }

  String get status => _status;
  set status(String status) => _status = status;
  int get posVenteId => _posVenteId;
  set posVenteId(int posVenteId) => _posVenteId = posVenteId;
  List<Details> get details => _details;
  set details(List<Details> details) => _details = details;

  Reponse.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _posVenteId = json['pos_vente_id'];
    if (json['details'] != null) {
      _details = new List<Details>();
      json['details'].forEach((v) {
        _details.add(new Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    data['pos_vente_id'] = this._posVenteId;
    if (this._details != null) {
      data['details'] = this._details.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
  String _produitId;
  String _image;
  String _titre;
  String _quantite;

  Details({String produitId, String image, String titre, String quantite}) {
    this._produitId = produitId;
    this._image = image;
    this._titre = titre;
    this._quantite = quantite;
  }

  String get produitId => _produitId;
  set produitId(String produitId) => _produitId = produitId;
  String get image => _image;
  set image(String image) => _image = image;
  String get titre => _titre;
  set titre(String titre) => _titre = titre;
  String get quantite => _quantite;
  set quantite(String quantite) => _quantite = quantite;

  Details.fromJson(Map<String, dynamic> json) {
    _produitId = json['produit_id'];
    _image = json['image'];
    _titre = json['titre'];
    _quantite = json['quantite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['produit_id'] = this._produitId;
    data['image'] = this._image;
    data['titre'] = this._titre;
    data['quantite'] = this._quantite;
    return data;
  }
}