import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import '../../../views/payment_tab_selector.dart';
import '../../../views/empty_history_section.dart';
import '../../../services/auth_provider.dart';
import '../../../services/payment_provider.dart';
import '../../../services/transfer_provider.dart';
import '../../../services/theme_provider.dart';
import '../../../services/language_provider.dart';
import '../widgets/menu_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _isScanning = false;
  late MobileScannerController _scannerController;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController();

    // Charger les données utilisateur au démarrage de la page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isLoggedIn) {
        print('🏠 HomePage initState - Chargement des données utilisateur...');
        authProvider.loadUserData();
      }
    });
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final paymentProvider = Provider.of<PaymentProvider>(context);
    final transferProvider = Provider.of<TransferProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Fonction helper pour les couleurs adaptatives
    Color getAdaptiveColor(Color darkColor, Color lightColor) {
      return themeProvider.isDarkMode ? darkColor : lightColor;
    }

    // Fonction helper pour les couleurs de texte adaptatives
    Color getTextColor() {
      return themeProvider.isDarkMode ? Colors.white : Colors.black;
    }

    // Fonction helper pour les couleurs de fond adaptatives
    Color getBackgroundColor() {
      return themeProvider.isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
    }

    // Fonction helper pour les couleurs de surface adaptatives
    Color getSurfaceColor() {
      return themeProvider.isDarkMode ? const Color(0xFF2A2A2A) : Colors.white;
    }

    // Fonction helper pour les couleurs de surface secondaire adaptatives
    Color getSecondarySurfaceColor() {
      return themeProvider.isDarkMode ? const Color(0xFF3A3A3A) : Colors.grey.shade100;
    }

    // Debug logs pour vérifier les données utilisateur
    print('🏠 HomePage build - User data:');
    print('   - isLoggedIn: ${authProvider.isLoggedIn}');
    print('   - userName: ${authProvider.userName}');
    print('   - userBalance: ${authProvider.userBalance}');
    print('   - userPhone: ${authProvider.userPhone}');
    print('   - userQRCodeData: ${authProvider.userQRCodeData}');
    print('   - transactions count: ${authProvider.transactions.length}');

    return Scaffold(
      backgroundColor: getBackgroundColor(),
      drawer: const MenuDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête : Menu en haut, texte centré verticalement, QR aligné horizontalement
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: getAdaptiveColor(const Color(0xFF1E1E1E), Colors.white),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: getAdaptiveColor(const Color(0xFF333333), Colors.grey.shade300),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Menu en haut à gauche
                    Builder(
                      builder: (context) => Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              // Ouvrir le menu
                              Scaffold.of(context).openDrawer();
                            },
                            icon: Icon(
                              Icons.menu,
                              color: getTextColor(),
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Ligne avec Bonjour, Solde et QR alignés horizontalement
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Bonjour [nom] et Solde groupés
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Bonjour [nom]
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${languageProvider.hello} ',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: getTextColor(),
                                        letterSpacing: 0,
                                      ),
                                    ),
                                    TextSpan(
                                      text: authProvider.userName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFFFF7900), // Garde la couleur orange
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              // Solde avec icône œil
                              Row(
                                children: [
                                  Text(
                                    authProvider.displayBalance,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFFF7900),
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () => authProvider.toggleBalanceVisibility(),
                                    icon: Icon(
                                      authProvider.balanceVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: const Color(0xFFCCCCCC),
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // QR Code généré dynamiquement - Taille augmentée pour meilleure détection
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFFF7900),
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: authProvider.userQRCodeData.isNotEmpty
                              ? QrImageView(
                                  data: authProvider.userQRCodeData,
                                  version: QrVersions.auto,
                                  size: 70.0, // Taille augmentée de 50 à 70
                                  backgroundColor: Colors.white,
                                  eyeStyle: const QrEyeStyle(
                                    eyeShape: QrEyeShape.square,
                                    color: Color(0xFFFF7900),
                                  ),
                                  dataModuleStyle: const QrDataModuleStyle(
                                    dataModuleShape: QrDataModuleShape.square,
                                    color: Color(0xFFFF7900),
                                  ),
                                )
                              : const Icon(
                                  Icons.qr_code_2,
                                  color: Color(0xFFFF7900),
                                  size: 50, // Taille augmentée de 40 à 50
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              // Carte principale avec onglets et background (hauteur optimisée)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 0),
                constraints: const BoxConstraints(minHeight: 140), // Hauteur ultra-réduite
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x26000000),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      // Background image sans traits décoratifs
                      Positioned.fill(
                        child: Image.asset(
                          'assets/backgroundtransfert.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFF2A2A2A),
                            );
                          },
                        ),
                      ),
                      // Overlay léger pour lisibilité
                      Positioned.fill(
                        child: Container(
                          color: const Color(0x0F000000),
                        ),
                      ),
                      // Contenu entièrement sur l'image de background
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Onglets Payer / Transférer sur l'image
                            PaymentTabSelector(
                              isPayerSelected: authProvider.isPayerSelected,
                              onTabChanged: (isPayer) => authProvider.togglePaymentTab(isPayer),
                            ),
                            const SizedBox(height: 12),
                            // Ligne avec champs de saisie et icône caméra sur l'image
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Champs de saisie entièrement sur l'image
                                Expanded(
                                  child: Column(
                                    children: [
                                      // Champ numéro/code marchand sur l'image
                                      Container(
                                        height: 44,
                                        margin: const EdgeInsets.only(bottom: 12),
                                        decoration: BoxDecoration(
                                          color: getAdaptiveColor(const Color(0xFF1A1A1A), Colors.white),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: getAdaptiveColor(const Color(0xFF404040), Colors.grey.shade400),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: TextField(
                                          controller: _recipientController,
                                          style: TextStyle(
                                            color: getTextColor(),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: authProvider.isPayerSelected
                                                ? languageProvider.merchantCode
                                                : languageProvider.recipientNumber,
                                            hintStyle: TextStyle(
                                              color: getAdaptiveColor(const Color(0xFF888888), Colors.grey.shade600),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Champ montant sur l'image
                                      Container(
                                        height: 44,
                                        margin: const EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                          color: getAdaptiveColor(const Color(0xFF1A1A1A), Colors.white),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: getAdaptiveColor(const Color(0xFF404040), Colors.grey.shade400),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: TextField(
                                          controller: _amountController,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                            color: getTextColor(),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: languageProvider.amount,
                                            hintStyle: TextStyle(
                                              color: getAdaptiveColor(const Color(0xFF888888), Colors.grey.shade600),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Bouton Valider sur l'image
                                      SizedBox(
                                        width: double.infinity,
                                        height: 44,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            // Validation des champs
                                            final recipient = _recipientController.text.trim();
                                            final amountText = _amountController.text.trim();

                                            if (recipient.isEmpty || amountText.isEmpty) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text(languageProvider.fillAllFields)),
                                              );
                                              return;
                                            }

                                            final amount = double.tryParse(amountText);
                                            if (amount == null || amount <= 0) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text(languageProvider.invalidAmount)),
                                              );
                                              return;
                                            }

                                            // Validation selon le type (paiement ou transfert)
                                            if (authProvider.isPayerSelected) {
                                              // Logique de paiement marchand
                                              final formattedRecipient = recipient.startsWith('+221')
                                                  ? recipient
                                                  : '+221$recipient';
                                              final success = await paymentProvider.makePayment(
                                                montant: amount,
                                                codePin: '1234', // À remplacer par un vrai PIN
                                                modePaiement: 'telephone', // Mode par défaut
                                                numeroTelephone: formattedRecipient,
                                              );

                                              if (success) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text(languageProvider.paymentSuccessful)),
                                                );
                                                // Rafraîchir les données utilisateur
                                                await authProvider.refreshUserData();
                                                // Vider les champs
                                                _recipientController.clear();
                                                _amountController.clear();
                                              }
                                            } else {
                                              // Logique de transfert
                                              final formattedRecipient = recipient.startsWith('+221')
                                                  ? recipient
                                                  : '+221$recipient';
                                              final success = await transferProvider.makeTransfer(
                                                telephoneDestinataire: formattedRecipient,
                                                montant: amount,
                                                codePin: '1234', // À remplacer par un vrai PIN
                                              );

                                              if (success) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text(languageProvider.transferSuccessful)),
                                                );
                                                // Rafraîchir les données utilisateur
                                                await authProvider.refreshUserData();
                                                // Vider les champs
                                                _recipientController.clear();
                                                _amountController.clear();
                                              }
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFFF7900),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            elevation: 0,
                                            shadowColor: Colors.transparent,
                                          ),
                                          child: Text(
                                            languageProvider.validate,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white, // Bouton orange garde le texte blanc
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Zone scanner sur l'image
                                _isScanning
                                    ? Container(
                                        width: 100,
                                        height: 100,
                                        margin: const EdgeInsets.only(top: 0),
                                        decoration: BoxDecoration(
                                          color: const Color(0x1AFFFFFF),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: MobileScanner(
                                                controller: _scannerController,
                                                onDetect: (capture) async {
                                                  final List<Barcode> barcodes = capture.barcodes;
                                                  if (barcodes.isNotEmpty) {
                                                    final String? code = barcodes.first.rawValue;
                                                    if (code != null) {
                                                      // Vérifier si c'est un numéro de téléphone (QR code utilisateur)
                                                      final phoneRegex = RegExp(r'^\+?221[0-9]{9}$');
                                                      if (phoneRegex.hasMatch(code)) {
                                                        // C'est un QR code utilisateur (numéro de téléphone) - faire le paiement directement
                                                        setState(() {
                                                          _isScanning = false;
                                                        });

                                                        final amountText = _amountController.text.trim();
                                                        if (amountText.isEmpty) {
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(content: Text(languageProvider.fillAllFields)),
                                                          );
                                                          return;
                                                        }

                                                        final amount = double.tryParse(amountText);
                                                        if (amount == null || amount <= 0) {
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(content: Text(languageProvider.invalidAmount)),
                                                          );
                                                          return;
                                                        }

                                                        // Faire le paiement avec le QR code utilisateur
                                                        final success = await paymentProvider.makePayment(
                                                          montant: amount,
                                                          codePin: '1234', // À remplacer par un vrai PIN
                                                          modePaiement: 'qr_code',
                                                          donneesQR: code,
                                                        );

                                                        if (success) {
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(content: Text(languageProvider.paymentSuccessful)),
                                                          );
                                                          // Rafraîchir les données utilisateur
                                                          await authProvider.refreshUserData();
                                                          // Vider les champs
                                                          _recipientController.clear();
                                                          _amountController.clear();
                                                        }
                                                        return;
                                                      }

                                                      // Vérifier si c'est un QR code marchand (JSON)
                                                      try {
                                                        final qrData = jsonDecode(code);
                                                        if (qrData is Map && qrData['type'] == 'marchand') {
                                                          // C'est un QR code marchand - traiter comme code marchand
                                                          setState(() {
                                                            _recipientController.text = code;
                                                            _isScanning = false;
                                                          });
                                                          return;
                                                        }
                                                      } catch (e) {
                                                        // Ce n'est pas du JSON, traiter comme un code normal
                                                      }

                                                      // Code normal (marchand ou téléphone)
                                                      setState(() {
                                                        _recipientController.text = code;
                                                        _isScanning = false;
                                                      });
                                                    }
                                                  }
                                                },
                                              ),
                                            ),
                                            Positioned(
                                              top: 4,
                                              right: 4,
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints: BoxConstraints(),
                                                icon: Icon(Icons.close, color: Colors.white, size: 20),
                                                onPressed: () {
                                                  setState(() {
                                                    _isScanning = false;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        width: 100,
                                        height: 100,
                                        margin: const EdgeInsets.only(top: 0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            setState(() {
                                              _isScanning = true;
                                            });
                                          },
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.qr_code_scanner,
                                                color: Color(0xFFFF7900),
                                                size: 24,
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                languageProvider.clickToScan,
                                                style: TextStyle(
                                                  color: Color(0xFFFF7900),
                                                  fontSize: 10,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Section Max it réduite
              Container(
                height: 60, // Hauteur réduite
                decoration: BoxDecoration(
                  color: getSecondarySurfaceColor(),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: getAdaptiveColor(const Color(0x1A000000), const Color(0x1A000000)),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: ListTile(
                  dense: true, // Compact
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7900),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x33000000),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Max it',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    languageProvider.accessMaxIt,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: getTextColor(),
                      letterSpacing: 0.1,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: getTextColor(),
                    size: 16,
                  ),
                  onTap: () {
                    // Navigation vers Max it
                  },
                ),
              ),
              const SizedBox(height: 12),
              // Section Historique avec titre réduit
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    languageProvider.history,
                    style: TextStyle(
                      fontSize: 18, // Réduit de 24 à 18
                      fontWeight: FontWeight.w700,
                      color: getTextColor(),
                      letterSpacing: 0.2,
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: authProvider.refreshUserData,
                    icon: authProvider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Color(0xFFFF7900),
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.refresh,
                            color: Color(0xFFFF7900),
                            size: 24, // Réduit de 30 à 24
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Historique des transactions - Amélioré avec Expanded et ListView.builder
              Expanded(
                child: authProvider.transactions.isEmpty
                    ? const EmptyHistorySection()
                    : Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: getSurfaceColor(),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          physics: const BouncingScrollPhysics(),
                          itemCount: authProvider.transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = authProvider.transactions[index];
                            return Container(
                              margin: EdgeInsets.only(
                                bottom: index == authProvider.transactions.length - 1 ? 0 : 8,
                              ),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: getSecondarySurfaceColor(),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: transaction.type == 'credit'
                                          ? const Color(0x3333CC33)
                                          : const Color(0x33CC3333),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      transaction.type == 'credit'
                                          ? Icons.arrow_downward
                                          : Icons.arrow_upward,
                                      color: transaction.type == 'credit'
                                          ? Colors.green
                                          : Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Transaction ${transaction.id}',
                                          style: TextStyle(
                                            color: getTextColor(),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          transaction.dateTransaction != null
                                              ? '${transaction.dateTransaction!.day}/${transaction.dateTransaction!.month}/${transaction.dateTransaction!.year}'
                                              : 'Date inconnue',
                                          style: TextStyle(
                                            color: getAdaptiveColor(const Color(0xFF888888), Colors.grey.shade600),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${transaction.type == 'credit' ? '+' : '-'}${transaction.montant.toStringAsFixed(2)} FCFA',
                                    style: TextStyle(
                                      color: transaction.type == 'credit'
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ),

              // Messages d'erreur
              if (authProvider.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    authProvider.errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              if (paymentProvider.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Erreur paiement: ${paymentProvider.errorMessage}',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              if (transferProvider.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Erreur transfert: ${transferProvider.errorMessage}',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Indicateurs de chargement
              if (paymentProvider.isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: CircularProgressIndicator(
                    color: Color(0xFFFF7900),
                  ),
                ),

              if (transferProvider.isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: CircularProgressIndicator(
                    color: Color(0xFFFF7900),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}