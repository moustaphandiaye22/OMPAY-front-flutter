import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'fr'; // 'fr' pour français, 'en' pour anglais

  String get currentLanguage => _currentLanguage;

  bool get isFrench => _currentLanguage == 'fr';
  bool get isEnglish => _currentLanguage == 'en';

  void toggleLanguage() {
    _currentLanguage = _currentLanguage == 'fr' ? 'en' : 'fr';
    notifyListeners();
  }

  void setLanguage(String language) {
    if (language == 'fr' || language == 'en') {
      _currentLanguage = language;
      notifyListeners();
    }
  }

  // Méthodes de traduction
  String get darkMode => _currentLanguage == 'fr' ? 'Sombre' : 'Dark';
  String get scanner => _currentLanguage == 'fr' ? 'Scanner' : 'Scanner';
  String get language => _currentLanguage == 'fr' ? 'Français' : 'English';
  String get logout => _currentLanguage == 'fr' ? 'Se déconnecter' : 'Logout';
  String get version => _currentLanguage == 'fr' ? 'Version' : 'Version';
  String get hello => _currentLanguage == 'fr' ? 'Bonjour' : 'Hello';
  String get balance => _currentLanguage == 'fr' ? 'Solde' : 'Balance';
  String get pay => _currentLanguage == 'fr' ? 'Payer' : 'Pay';
  String get transfer => _currentLanguage == 'fr' ? 'Transférer' : 'Transfer';
  String get merchantCode => _currentLanguage == 'fr' ? 'Numéro/code marchand' : 'Merchant code/number';
  String get recipientNumber => _currentLanguage == 'fr' ? 'Numéro destinataire' : 'Recipient number';
  String get amount => _currentLanguage == 'fr' ? 'Montant' : 'Amount';
  String get validate => _currentLanguage == 'fr' ? 'Valider' : 'Validate';
  String get otherOperations => _currentLanguage == 'fr' ? 'Pour toute autre opération' : 'For any other operation';
  String get accessMaxIt => _currentLanguage == 'fr' ? 'Accéder à Max it' : 'Access Max it';
  String get history => _currentLanguage == 'fr' ? 'Historique' : 'History';
  String get transaction => _currentLanguage == 'fr' ? 'Transaction' : 'Transaction';
  String get unknownDate => _currentLanguage == 'fr' ? 'Date inconnue' : 'Unknown date';
  String get fillAllFields => _currentLanguage == 'fr' ? 'Veuillez remplir tous les champs' : 'Please fill all fields';
  String get invalidAmount => _currentLanguage == 'fr' ? 'Montant invalide' : 'Invalid amount';
  String get paymentSuccessful => _currentLanguage == 'fr' ? 'Paiement effectué avec succès' : 'Payment successful';
  String get transferSuccessful => _currentLanguage == 'fr' ? 'Transfert effectué avec succès' : 'Transfer successful';
  String get clickToScan => _currentLanguage == 'fr' ? 'Cliquer pour scanner' : 'Click to scan';
  String get phoneNumber => _currentLanguage == 'fr' ? 'Numéro de téléphone' : 'Phone number';
  String get otpCode => _currentLanguage == 'fr' ? 'Code OTP' : 'OTP Code';
  String get enterOtp => _currentLanguage == 'fr' ? 'Entrez le code OTP' : 'Enter OTP code';
  String get resendOtp => _currentLanguage == 'fr' ? 'Renvoyer le code' : 'Resend code';
  String get login => _currentLanguage == 'fr' ? 'Se connecter' : 'Login';
  String get register => _currentLanguage == 'fr' ? 'S\'inscrire' : 'Register';
  String get welcome => _currentLanguage == 'fr' ? 'Bienvenue' : 'Welcome';
  String get next => _currentLanguage == 'fr' ? 'Suivant' : 'Next';
  String get back => _currentLanguage == 'fr' ? 'Retour' : 'Back';
  String get confirm => _currentLanguage == 'fr' ? 'Confirmer' : 'Confirm';
  String get cancel => _currentLanguage == 'fr' ? 'Annuler' : 'Cancel';
  String get error => _currentLanguage == 'fr' ? 'Erreur' : 'Error';
  String get success => _currentLanguage == 'fr' ? 'Succès' : 'Success';
  String get loading => _currentLanguage == 'fr' ? 'Chargement...' : 'Loading...';
  String get retry => _currentLanguage == 'fr' ? 'Réessayer' : 'Retry';
  String get close => _currentLanguage == 'fr' ? 'Fermer' : 'Close';
}