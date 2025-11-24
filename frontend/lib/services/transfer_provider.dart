import 'package:flutter/material.dart';
import '../features/transfer/transfer_service_interface.dart';
import '../models/models.dart';

class TransferProvider extends ChangeNotifier {
  final TransferServiceInterface _transferService;

  bool _isLoading = false;
  String? _errorMessage;
  TransferResponse? _lastTransferResponse;

  TransferProvider(this._transferService);

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  TransferResponse? get lastTransferResponse => _lastTransferResponse;

  // Methods
  Future<bool> makeTransfer({
    required String telephoneDestinataire,
    required double montant,
    String? note,
    required String codePin,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = TransferRequest(
        telephoneDestinataire: telephoneDestinataire,
        montant: montant,
        devise: 'XOF',
        note: note,
        codePin: codePin,
      );

      final response = await _transferService.effectuerTransfert(request);
      _lastTransferResponse = response;

      if (response.success) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erreur lors du transfert: ${e.toString().replaceAll('Exception: ', '')}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> cancelTransfer(String transferId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _transferService.annulerTransfert(transferId);

      if (response.success) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erreur lors de l\'annulation: ${e.toString().replaceAll('Exception: ', '')}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearLastResponse() {
    _lastTransferResponse = null;
    notifyListeners();
  }
}