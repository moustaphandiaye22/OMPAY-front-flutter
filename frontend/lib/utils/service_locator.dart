import '../interfaces/api_service.dart';
import '../features/auth/auth_service_interface.dart';
import '../features/wallet/wallet_service_interface.dart';
import '../features/transfer/transfer_service_interface.dart';
import '../features/payment/payment_service_interface.dart';
import '../services/api_service.dart';
import '../services/auth_provider.dart';
import '../services/payment_provider.dart';
import '../services/transfer_provider.dart';
import '../features/auth/auth_service.dart';
import '../features/wallet/wallet_service.dart';
import '../features/transfer/transfer_service.dart';
import '../features/payment/payment_service.dart';

class ServiceLocator {
  static const String baseUrl = 'http://localhost:8000/api';

  late final ApiService _apiService;
  late final AuthServiceInterface _authService;
  late final WalletServiceInterface _walletService;
  late final TransferServiceInterface _transferService;
  late final PaymentServiceInterface _paymentService;

  // Providers
  late final AuthProvider _authProvider;
  late final PaymentProvider _paymentProvider;
  late final TransferProvider _transferProvider;

  ServiceLocator() {
    _initializeSync();
  }

  void _initializeSync() {
    _apiService = HttpApiService(baseUrl);
    _authService = AuthService(_apiService);
    _walletService = WalletService(_apiService);
    _transferService = TransferService(_apiService);
    _paymentService = PaymentService(_apiService);

    // Initialize providers
    _authProvider = AuthProvider(_authService);
    _paymentProvider = PaymentProvider(_paymentService);
    _transferProvider = TransferProvider(_transferService);
  }

  // Services
  AuthServiceInterface get authService => _authService;
  WalletServiceInterface get walletService => _walletService;
  TransferServiceInterface get transferService => _transferService;
  PaymentServiceInterface get paymentService => _paymentService;

  // Providers
  AuthProvider get authProvider => _authProvider;
  PaymentProvider get paymentProvider => _paymentProvider;
  TransferProvider get transferProvider => _transferProvider;
}