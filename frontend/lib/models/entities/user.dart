/// Données du QR Code utilisateur
class QRCodeData {
  final String id;
  final String donnees;
  final DateTime dateGeneration;

  QRCodeData({
    required this.id,
    required this.donnees,
    required this.dateGeneration,
  });

  factory QRCodeData.fromJson(Map<String, dynamic> json) {
    return QRCodeData(
      id: json['id'] as String,
      donnees: json['donnees'] as String,
      dateGeneration: DateTime.parse(json['dateGeneration']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'donnees': donnees,
      'dateGeneration': dateGeneration.toIso8601String(),
    };
  }
}

/// Entité Utilisateur - correspond au modèle Laravel Utilisateur
class User {
  final String id;
  final String numeroTelephone;
  final String? prenom;
  final String? nom;
  final String? email;
  final String? numeroCni;
  final String statutKyc;
  final bool biometrieActivee;
  final DateTime? dateCreation;
  final DateTime? derniereConnexion;
  final String? otp;
  final DateTime? otpExpiresAt;
  final QRCodeData? qrCode;

  User({
    required this.id,
    required this.numeroTelephone,
    this.prenom,
    this.nom,
    this.email,
    this.numeroCni,
    required this.statutKyc,
    required this.biometrieActivee,
    this.dateCreation,
    this.derniereConnexion,
    this.otp,
    this.otpExpiresAt,
    this.qrCode,
  });

  /// Nom complet calculé
  String get nomComplet => '$prenom $nom'.trim();

  /// Crée une instance User depuis un Map (réponse API)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      numeroTelephone: json['numeroTelephone'] ?? json['numero_telephone'] as String,
      prenom: json['prenom'] as String?,
      nom: json['nom'] as String?,
      email: json['email'] as String?,
      numeroCni: json['numeroCni'] ?? json['numero_cni'] as String?,
      statutKyc: json['statutKyc'] ?? json['statut_kyc'] ?? 'non_verifie',
      biometrieActivee: json['biometrieActivee'] ?? json['biometrie_activee'] ?? false,
      dateCreation: json['dateCreation'] != null
          ? DateTime.parse(json['dateCreation'])
          : json['date_creation'] != null
              ? DateTime.parse(json['date_creation'])
              : null,
      derniereConnexion: json['derniereConnexion'] != null
          ? DateTime.parse(json['derniereConnexion'])
          : json['derniere_connexion'] != null
              ? DateTime.parse(json['derniere_connexion'])
              : null,
      otp: json['otp'] as String?,
      otpExpiresAt: json['otpExpiresAt'] != null
          ? DateTime.parse(json['otpExpiresAt'])
          : json['otp_expires_at'] != null
              ? DateTime.parse(json['otp_expires_at'])
              : null,
      qrCode: json['qrCode'] != null
          ? QRCodeData.fromJson(json['qrCode'])
          : null,
    );
  }

  /// Convertit l'instance en Map pour les requêtes API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numeroTelephone': numeroTelephone,
      'prenom': prenom,
      'nom': nom,
      'email': email,
      'numeroCni': numeroCni,
      'statutKyc': statutKyc,
      'biometrieActivee': biometrieActivee,
      'dateCreation': dateCreation?.toIso8601String(),
      'derniereConnexion': derniereConnexion?.toIso8601String(),
      'otp': otp,
      'otpExpiresAt': otpExpiresAt?.toIso8601String(),
    };
  }

  /// Vérifie si l'utilisateur est vérifié KYC
  bool get estVerifie => statutKyc == 'verifie';

  /// Vérifie si l'utilisateur est bloqué
  bool get estBloque => false; // Logique à implémenter selon ParametresSecurite

  @override
  String toString() {
    return 'User{id: $id, nomComplet: $nomComplet, telephone: $numeroTelephone, statut: $statutKyc}';
  }
}