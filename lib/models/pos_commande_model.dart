class PosCommandes {
  List<Commandes> commandes;

  PosCommandes({this.commandes});

  PosCommandes.fromJson(Map<String, dynamic> json) {
    if (json['commandes'] != null) {
      commandes = new List<Commandes>();
      json['commandes'].forEach((v) {
        commandes.add(new Commandes.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.commandes != null) {
      data['commandes'] = this.commandes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Commandes {
  String posVenteId;
  String gpsPosition;
  String delaiLivraison;
  String adresse;
  String acheteurNom;
  String telephone;
  List<Details> details;

  Commandes(
      {this.posVenteId,
      this.gpsPosition,
      this.delaiLivraison,
      this.adresse,
      this.acheteurNom,
      this.telephone,
      this.details});

  Commandes.fromJson(Map<String, dynamic> json) {
    posVenteId = json['pos_vente_id'];
    gpsPosition = json['gps_position'];
    delaiLivraison = json['delai_livraison'];
    adresse = json['adresse'];
    acheteurNom = json['acheteur_nom'];
    telephone = json['telephone'];
    if (json['details'] != null) {
      details = new List<Details>();
      json['details'].forEach((v) {
        details.add(new Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pos_vente_id'] = this.posVenteId;
    data['gps_position'] = this.gpsPosition;
    data['delai_livraison'] = this.delaiLivraison;
    data['adresse'] = this.adresse;
    data['acheteur_nom'] = this.acheteurNom;
    data['telephone'] = this.telephone;
    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
  String produitId;
  String prixUnitaire;
  String quantite;
  String titre;
  String image;

  Details(
      {this.produitId,
      this.prixUnitaire,
      this.quantite,
      this.titre,
      this.image});

  Details.fromJson(Map<String, dynamic> json) {
    produitId = json['produit_id'];
    prixUnitaire = json['prix_unitaire'];
    quantite = json['quantite'];
    titre = json['titre'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['produit_id'] = this.produitId;
    data['prix_unitaire'] = this.prixUnitaire;
    data['quantite'] = this.quantite;
    data['titre'] = this.titre;
    data['image'] = this.image;
    return data;
  }
}
