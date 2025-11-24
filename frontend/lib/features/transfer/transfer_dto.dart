/// DTO pour les opérations de transfert
library;

import '../../models/entities/transfer.dart';

/// Requête d'effectuation de transfert
class TransferRequest {
  final String telephoneDestinataire;
  final double montant;
  final String devise;
  final String? note;
  final String codePin;

  TransferRequest({
    required this.telephoneDestinataire,
    required this.montant,
    this.devise = 'XOF',
    this.note,
    required this.codePin,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'telephoneDestinataire': telephoneDestinataire,
      'montant': montant,
      'devise': devise,
      'codePin': codePin,
    };

    if (note != null && note!.isNotEmpty) {
      data['note'] = note;
    }

    return data;
  }
}

/// Réponse d'effectuation de transfert
class TransferResponse {
  final bool success;
  final String message;
  final TransferData? data;

  TransferResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory TransferResponse.fromJson(Map<String, dynamic> json) {
    return TransferResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null ? TransferData.fromJson(json['data']) : null,
    );
  }
}

/// Données de transfert
class TransferData {
  final String idTransaction;
  final String statut;
  final String montant;
  final String dateTransaction;
  final String reference;
  final String? recu;
  final DestinataireData destinataire;

  TransferData({
    required this.idTransaction,
    required this.statut,
    required this.montant,
    required this.dateTransaction,
    required this.reference,
    this.recu,
    required this.destinataire,
  });

  factory TransferData.fromJson(Map<String, dynamic> json) {
    return TransferData(
      idTransaction: json['idTransaction'] as String,
      statut: json['statut'] as String,
      montant: json['montant'] as String,
      dateTransaction: json['dateTransaction'] as String,
      reference: json['reference'] as String,
      recu: json['recu'] as String?,
      destinataire: DestinataireData.fromJson(json['destinataire']),
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
      'destinataire': destinataire.toJson(),
    };
  }
}

/// Données du destinataire
class DestinataireData {
  final String nom;
  final String numeroTelephone;

  DestinataireData({
    required this.nom,
    required this.numeroTelephone,
  });

  factory DestinataireData.fromJson(Map<String, dynamic> json) {
    return DestinataireData(
      nom: json['nom'] as String,
      numeroTelephone: json['numeroTelephone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'numeroTelephone': numeroTelephone,
    };
  }
}

/// Requête d'annulation de transfert
class CancelTransferRequest {
  final String transferId;

  CancelTransferRequest({required this.transferId});

  Map<String, dynamic> toJson() {
    return {};
  }
}

/// Réponse d'annulation de transfert
class CancelTransferResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  CancelTransferResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory CancelTransferResponse.fromJson(Map<String, dynamic> json) {
    return CancelTransferResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>?,
    );
  }
}