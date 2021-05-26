class Response {
  Reponse reponse;

  Response({this.reponse});

  Response.fromJson(Map<String, dynamic> json) {
    reponse =
    json['reponse'] != null ? new Reponse.fromJson(json['reponse']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.reponse != null) {
      data['reponse'] = this.reponse.toJson();
    }
    return data;
  }
}

class Reponse {
  String status;
  String posVenteId;

  Reponse({this.status, this.posVenteId});

  Reponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    posVenteId = json['pos_vente_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['pos_vente_id'] = this.posVenteId;
    return data;
  }
}