import 'package:flutter/material.dart';
import '../features/auth/auth_service_interface.dart';
import '../models/models.dart';
import '../models/entities/transaction.dart';
import '../models/entities/payment.dart';
import '../models/entities/transfer.dart';

class AuthProvider extends ChangeNotifier {
  final AuthServiceInterface _authService;
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;

  AuthProvider(this._authService);

  // Getters
  TextEditingController get phoneController => _phoneController;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;

  // Actions
  Future<void> login() async {
    if (_phoneController.text.isEmpty) {
      _errorMessage = 'Veuillez saisir votre numéro de téléphone';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = LoginRequest(
        numeroTelephone: '+221${_phoneController.text}',
        codeOtp: null, // Request OTP first
      );

      final response = await _authService.connexion(request);

      if (response.success) {
        // Check if OTP was sent
        if (response.data?['otpEnvoye'] == true) {
          _isOTPRequested = true;
          _isLoading = false;
          notifyListeners();
          // Navigate to OTP page would happen here
        } else if (response.data?['jetonAcces'] != null) {
          // Direct login successful
          _isLoggedIn = true;
          _isLoading = false;
          notifyListeners();
        } else {
          throw Exception('Réponse inattendue du serveur');
        }
      } else {
        throw Exception(response.message);
      }

    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // OTP Management
  String _otpCode = '';
  bool _isOTPRequested = false;
  int _otpResendTimer = 0;
  bool _canResendOTP = true;

  // Home/Payment Management
  bool _isPayerSelected = true;
  User? _user;
  Wallet? _wallet;
  List<Transaction> _transactions = [];
  bool _balanceVisible = false;

  // Home Getters
  bool get isPayerSelected => _isPayerSelected;
  String get userName => _user?.nom ?? 'Utilisateur';
  String get userId => _user?.id ?? '';
  String get userBalance => _wallet?.solde?.toString() ?? '0';
  bool get balanceVisible => _balanceVisible;
  String get displayBalance => _balanceVisible ? '${userBalance} FCFA' : '******* FCFA';
  List<Transaction> get transactions => _transactions;
  List<Payment> get payments => _transactions.whereType<Payment>().toList();
  List<Transfer> get transfers => _transactions.whereType<Transfer>().toList();

  // Home Methods
  void togglePaymentTab(bool isPayer) {
    _isPayerSelected = isPayer;
    notifyListeners();
  }

  void toggleBalanceVisibility() {
    _balanceVisible = !_balanceVisible;
    notifyListeners();
  }

  // Load user data from API
  Future<void> loadUserData() async {
    try {
      print('🔄 Loading user data from API...');
      final accountResponse = await _authService.consulterCompte();
      print('📡 API Response success: ${accountResponse.success}');
      print('📡 API Response data: ${accountResponse.data}');

      if (accountResponse.success && accountResponse.data != null) {
        final accountData = accountResponse.data!;

        // Utiliser les données déjà parsées
        _user = accountData.utilisateur;
        _wallet = accountData.compte;
        _transactions = accountData.transactions;

        print('🎉 User data loaded successfully!');
        print('👤 User: ${_user?.nom}');
        print('💰 Balance: ${_wallet?.solde}');
        print('📊 Transactions: ${_transactions.length}');

        notifyListeners();
      } else {
        print('❌ API call failed: ${accountResponse.message}');
        // Ne pas créer de données fictives si l'utilisateur est connecté
        // Laisser les données nulles pour éviter les conflits
        notifyListeners();
      }
    } catch (e) {
      print('❌ Error loading user data: $e');
      // Ne pas créer de données fictives en cas d'erreur
      // Laisser les données nulles
      notifyListeners();
    }
  }

  // Créer des transactions fictives réalistes pour la démonstration
  List<Transaction> _createDemoTransactions() {
    return [
      Transaction(
        id: 'demo-tx-1',
        idPortefeuille: 'demo-wallet-id',
        type: 'paiement',
        montant: 2500.0,
        devise: 'FCFA',
        statut: 'reussie',
        dateTransaction: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Transaction(
        id: 'demo-tx-2',
        idPortefeuille: 'demo-wallet-id',
        type: 'transfert',
        montant: 1500.0,
        devise: 'FCFA',
        statut: 'reussie',
        dateTransaction: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Transaction(
        id: 'demo-tx-3',
        idPortefeuille: 'demo-wallet-id',
        type: 'paiement',
        montant: 7500.0,
        devise: 'FCFA',
        statut: 'reussie',
        dateTransaction: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      Transaction(
        id: 'demo-tx-4',
        idPortefeuille: 'demo-wallet-id',
        type: 'paiement',
        montant: 3200.0,
        devise: 'FCFA',
        statut: 'reussie',
        dateTransaction: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      Transaction(
        id: 'demo-tx-5',
        idPortefeuille: 'demo-wallet-id',
        type: 'transfert',
        montant: 5000.0,
        devise: 'FCFA',
        statut: 'reussie',
        dateTransaction: DateTime.now().subtract(const Duration(hours: 24)),
      ),
    ];
  }

  // Refresh user data (for manual refresh)
  Future<void> refreshUserData() async {
    _isLoading = true;
    notifyListeners();
    await loadUserData();
    _isLoading = false;
    notifyListeners();
  }

  // Payment Methods - REMOVED: Use PaymentProvider instead for single responsibility

  // Transfer Methods - REMOVED: Use TransferProvider instead for single responsibility

  // OTP Getters
  String get otpCode => _otpCode;
  bool get isOTPRequested => _isOTPRequested;
  int get otpResendTimer => _otpResendTimer;
  bool get canResendOTP => _canResendOTP;

  // Request OTP
  Future<void> requestOTP() async {
    print('AuthProvider.requestOTP called with phone: ${_phoneController.text}');

    if (_phoneController.text.isEmpty) {
      _errorMessage = 'Veuillez saisir votre numéro de téléphone';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = LoginRequest(
        numeroTelephone: '+221${_phoneController.text}',
        codeOtp: null,
      );

      print('Calling _authService.connexion...');
      final response = await _authService.connexion(request);
      print('AuthService response received: success=${response.success}, message=${response.message}');

      if (response.success && response.data?['otpEnvoye'] == true) {
        print('OTP request successful');
        _isOTPRequested = true;
        _isLoading = false;
        _otpResendTimer = 60; // 60 secondes avant de pouvoir renvoyer
        _startResendTimer();
        notifyListeners();
      } else {
        print('OTP request failed: ${response.message}');
        throw Exception(response.message);
      }

    } catch (e) {
      print('AuthProvider.requestOTP error: $e');
      _errorMessage = 'Erreur lors de l\'envoi de l\'OTP: ${e.toString().replaceAll('Exception: ', '')}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Verify OTP
  Future<void> verifyOTP(String otp) async {
    if (otp.length != 6) {
      _errorMessage = 'Le code OTP doit contenir 6 chiffres';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _otpCode = otp;
    notifyListeners();

    try {
      final request = LoginRequest(
        numeroTelephone: '+221${_phoneController.text}',
        codeOtp: otp,
      );

      final response = await _authService.connexion(request);

      if (response.success && response.data?['jetonAcces'] != null) {
        _isLoggedIn = true;
        // Load user data after successful login
        await loadUserData();
        _isLoading = false;
        notifyListeners();
        // Navigate to home page would happen here
      } else {
        throw Exception(response.message);
      }

    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Resend OTP
  Future<void> resendOTP() async {
    if (!_canResendOTP) return;

    _canResendOTP = false;
    _otpResendTimer = 60;
    _startResendTimer();

    try {
      // Simulation de renvoi OTP
      await Future.delayed(const Duration(seconds: 1));
      // Ici appeler l'API pour renvoyer l'OTP
    } catch (e) {
      _errorMessage = 'Erreur lors du renvoi de l\'OTP';
    }

    notifyListeners();
  }

  // Timer for OTP resend
  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_otpResendTimer > 0) {
        _otpResendTimer--;
        _startResendTimer();
      } else {
        _canResendOTP = true;
      }
      notifyListeners();
    });
  }

  // Reset OTP state
  void resetOTP() {
    _otpCode = '';
    _isOTPRequested = false;
    _otpResendTimer = 0;
    _canResendOTP = true;
  }

  Future<void> logout() async {
    try {
      await _authService.deconnexion();
    } catch (e) {
      // Even if logout fails, clear local state
      print('Logout error: $e');
    }

    _isLoggedIn = false;
    _phoneController.clear();
    _errorMessage = null;
    resetOTP();
    notifyListeners();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}