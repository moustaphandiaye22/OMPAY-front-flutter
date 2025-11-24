import 'package:flutter/material.dart';
import '../features/payment/payment_service_interface.dart';
import '../models/models.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentServiceInterface _paymentService;

  bool _isLoading = false;
  String? _errorMessage;
  PaymentResponse? _lastPaymentResponse;

  PaymentProvider(this._paymentService);

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PaymentResponse? get lastPaymentResponse => _lastPaymentResponse;

  // Methods
  Future<bool> makePayment({
    required double montant,
    required String codePin,
    required String modePaiement,
    String? donneesQR,
    String? code,
    String? numeroTelephone,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = PaymentRequest(
        montant: montant,
        devise: 'XOF',
        codePin: codePin,
        modePaiement: modePaiement,
        donneesQR: donneesQR,
        code: code,
        numeroTelephone: numeroTelephone,
      );

      final response = await _paymentService.effectuerPaiement(request);
      _lastPaymentResponse = response;

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
      _errorMessage = 'Erreur lors du paiement: ${e.toString().replaceAll('Exception: ', '')}';
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
    _lastPaymentResponse = null;
    notifyListeners();
  }
}