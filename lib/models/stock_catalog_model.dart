class Catalog {
  List<Produits> produits;

  Catalog({this.produits});

  Catalog.fromJson(Map<String, dynamic> json) {
    if (json['produits'] != null) {
      produits = new List<Produits>();
      json['produits'].forEach((v) {
        produits.add(new Produits.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.produits != null) {
      data['produits'] = this.produits.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Produits {
  String produitId;
  String titre;
  String image;
  String prixUnitaire;
  String quantite;
  String stock;
  String imageB64;

  Produits(
      {this.produitId, this.titre, this.image, this.prixUnitaire, this.quantite, this.stock, this.imageB64});

  Produits.fromJson(Map<String, dynamic> json) {
    produitId = json['produit_id'].toString();
    titre = json['titre'].toString();
    image = json['image'].toString();
    prixUnitaire = json['prix_unitaire'].toString();
    quantite = json['quantite'].toString();
    stock = json['stock'].toString();
    imageB64 = json['image_base64'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['produit_id'] = this.produitId;
    data['titre'] = this.titre;
    data['image'] = this.image;
    data['prix_unitaire'] = this.prixUnitaire;
    data['quantite'] = this.quantite;
    data['stock'] = this.stock;
    data['image_base64'] = this.imageB64;
    return data;
  }
}