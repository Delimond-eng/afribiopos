class Inventory {
  Inventaire inventaire;

  Inventory({this.inventaire});

  Inventory.fromJson(Map<String, dynamic> json) {
    inventaire = json['inventaire'] != null
        ? new Inventaire.fromJson(json['inventaire'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.inventaire != null) {
      data['inventaire'] = this.inventaire.toJson();
    }
    return data;
  }
}

class Inventaire {
  int total;
  List<Details> details;

  Inventaire({this.total, this.details});

  Inventaire.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['details'] != null) {
      details = new List<Details>();
      json['details'].forEach((v) {
        details.add(new Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
  String dateVente;
  String produitId;
  String prixUnitaire;
  String quantite;
  String titre;

  Details(
      {this.dateVente,
        this.produitId,
        this.prixUnitaire,
        this.quantite,
        this.titre});

  Details.fromJson(Map<String, dynamic> json) {
    dateVente = json['date_vente'];
    produitId = json['produit_id'];
    prixUnitaire = json['prix_unitaire'];
    quantite = json['quantite'];
    titre = json['titre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date_vente'] = this.dateVente;
    data['produit_id'] = this.produitId;
    data['prix_unitaire'] = this.prixUnitaire;
    data['quantite'] = this.quantite;
    data['titre'] = this.titre;
    return data;
  }
}

