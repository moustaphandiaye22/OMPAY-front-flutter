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
      final errorText = e.toString();
      _errorMessage = errorText.replaceAll('Exception: ', '');
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
  String? _simulatedOtp; // OTP simulé pour les tests

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
  String get userPhone => _user?.numeroTelephone ?? '';
  String get userBalance => _wallet?.solde?.toString() ?? '0';
  bool get balanceVisible => _balanceVisible;
  String get displayBalance => _balanceVisible ? '${userBalance} FCFA' : '******* FCFA';
  String get userQRCodeData => _user?.qrCode?.donnees ?? userPhone; // Numéro de téléphone comme QR code
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
      final accountResponse = await _authService.consulterCompte();

      if (accountResponse.success && accountResponse.data != null) {
        final accountData = accountResponse.data!;

        // Utiliser les données déjà parsées
        _user = accountData.utilisateur;
        _wallet = accountData.compte;
        _transactions = accountData.transactions;

        notifyListeners();
      } else {
        // Ne pas créer de données fictives si l'utilisateur est connecté
        // Laisser les données nulles pour éviter les conflits
        notifyListeners();
      }
    } catch (e) {
      // Ne pas créer de données fictives en cas d'erreur
      // Laisser les données nulles
      notifyListeners();
    }
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
  String? get simulatedOtp => _simulatedOtp;

  // Request OTP
  Future<void> requestOTP() async {
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

      print('🔄 Requesting OTP for: +221${_phoneController.text}');
      final response = await _authService.connexion(request);
      print('📡 OTP Response: success=${response.success}, message=${response.message}');
      print('📦 OTP Data: ${response.data}');

      if (response.success && response.data?['otpEnvoye'] == true) {
        _isOTPRequested = true;
        _simulatedOtp = response.otpSimule; // Stocker l'OTP simulé
        _isLoading = false;
        _otpResendTimer = 60; // 60 secondes avant de pouvoir renvoyer
        _startResendTimer();
        print('✅ OTP Requested successfully, simulated OTP: $_simulatedOtp');
        notifyListeners();
      } else {
        print('❌ OTP Request failed: ${response.message}');
        throw Exception(response.message);
      }

    } catch (e) {
      final errorText = e.toString();
      _errorMessage = 'Erreur lors de l\'envoi de l\'OTP: ${errorText.replaceAll('Exception: ', '')}';
      _isLoading = false;
      print('💥 OTP Request error: $_errorMessage');
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

      print('🔐 Verifying OTP: $otp for phone: +221${_phoneController.text}');
      final response = await _authService.connexion(request);
      print('📡 OTP Verification Response: success=${response.success}, message=${response.message}');

      if (response.success && response.data?['jetonAcces'] != null) {
        _isLoggedIn = true;
        print('✅ OTP Verified successfully, user logged in');
        // Load user data after successful login
        await loadUserData();
        _isLoading = false;
        notifyListeners();
        print('🏠 User data loaded, navigation to home should happen automatically');
      } else {
        print('❌ OTP Verification failed: ${response.message}');
        throw Exception(response.message);
      }

    } catch (e) {
      final errorText = e.toString();
      _errorMessage = errorText.replaceAll('Exception: ', '');
      _isLoading = false;
      print('💥 OTP Verification error: $_errorMessage');
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
    _simulatedOtp = null;
  }

  Future<void> logout() async {
    try {
      await _authService.deconnexion();
    } catch (e) {
      // Even if logout fails, clear local state
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