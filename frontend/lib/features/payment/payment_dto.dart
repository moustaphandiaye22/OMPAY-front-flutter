/// DTO pour les opérations de paiement
library;

/// Requête d'effectuation de paiement
class PaymentRequest {
  final double montant;
  final String devise;
  final String codePin;
  final String modePaiement;
  final String? donneesQR;
  final String? code;
  final String? numeroTelephone;

  PaymentRequest({
    required this.montant,
    this.devise = 'XOF',
    required this.codePin,
    required this.modePaiement,
    this.donneesQR,
    this.code,
    this.numeroTelephone,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'montant': montant,
      'devise': devise,
      'codePin': codePin,
      'modePaiement': modePaiement,
    };

    if (donneesQR != null) data['donneesQR'] = donneesQR;
    if (code != null) data['code'] = code;
    if (numeroTelephone != null) data['numeroTelephone'] = numeroTelephone;

    return data;
  }
}

/// Réponse d'effectuation de paiement
class PaymentResponse {
  final bool success;
  final String message;
  final PaymentData? data;

  PaymentResponse({required this.success, required this.message, this.data});

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null ? PaymentData.fromJson(json['data']) : null,
    );
  }
}

/// Données de paiement
class PaymentData {
  final String idTransaction;
  final String statut;
  final String montant;
  final String dateTransaction;
  final String reference;
  final String? recu;
  final String modePaiement;
  final MarchandData? marchand;
  final PaymentDestinataireData? destinataire;

  PaymentData({
    required this.idTransaction,
    required this.statut,
    required this.montant,
    required this.dateTransaction,
    required this.reference,
    this.recu,
    required this.modePaiement,
    this.marchand,
    this.destinataire,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      idTransaction: json['idTransaction'] as String,
      statut: json['statut'] as String,
      // Conversion défensive int -> String
      montant: (json['montant'] is int)
          ? (json['montant'] as int).toString()
          : json['montant'] as String,
      dateTransaction: json['dateTransaction'] as String,
      reference: json['reference'] as String,
      recu: json['recu'] as String?,
      modePaiement: json['modePaiement'] as String,
      marchand: json['marchand'] != null
          ? MarchandData.fromJson(json['marchand'])
          : null,
      destinataire: json['destinataire'] != null
          ? PaymentDestinataireData.fromJson(json['destinataire'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idTransaction': idTransaction,
      'statut': statut,
      'montant': montant,
      'dateTransaction': dateTransaction,
      'reference': reference,
      'recu': recu,
      'modePaiement': modePaiement,
      'marchand': marchand?.toJson(),
      'destinataire': destinataire?.toJson(),
    };
  }
}

/// Données du marchand
class MarchandData {
  final String nom;
  final String numeroTelephone;

  MarchandData({required this.nom, required this.numeroTelephone});

  factory MarchandData.fromJson(Map<String, dynamic> json) {
    return MarchandData(
      nom: json['nom'] as String,
      numeroTelephone: json['numeroTelephone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'nom': nom, 'numeroTelephone': numeroTelephone};
  }
}

/// Données du destinataire (pour paiements utilisateur)
class PaymentDestinataireData {
  final String nom;
  final String numeroTelephone;

  PaymentDestinataireData({required this.nom, required this.numeroTelephone});

  factory PaymentDestinataireData.fromJson(Map<String, dynamic> json) {
    return PaymentDestinataireData(
      nom: json['nom'] as String,
      numeroTelephone: json['numeroTelephone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'nom': nom, 'numeroTelephone': numeroTelephone};
  }
}
