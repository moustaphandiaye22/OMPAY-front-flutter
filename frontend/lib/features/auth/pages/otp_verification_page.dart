import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../views/custom_orange_button.dart';
import '../../../views/otp_input_group.dart';
import '../../../services/auth_provider.dart';
import '../../../utils/responsive_sizes.dart';
import '../../home/pages/home_page.dart';

class OTPVerificationPage extends StatelessWidget {
  const OTPVerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final sizes = ResponsiveSizes.fromContext(context);

    return Scaffold(
      body: Stack(
        children: [
          // Image de fond avec overlay
          Positioned.fill(
            child: Stack(
              children: [
                // Image de fond
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Image.asset(
                    'assets/backgroundlogin.jpeg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF1a3a52),
                              Color(0xFF0d1f2d),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Overlay gradient sombre
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Contenu principal
          SafeArea(
            child: Column(
              children: [
                const Spacer(),
                // Carte de vérification OTP
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE5E5E5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icône de sécurité
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.shield,
                            size: 45,
                            color: Color(0xFFFF7900),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Titre
                        const Text(
                          'Vérification OTP',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Description
                        Text(
                          'Entrez le code à 6 chiffres envoyé à\n${authProvider.phoneController.text}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF666666),
                            height: 1.5,
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Champs OTP
                        OTPInputGroup(
                          onCompleted: (otpCode) async {
                            await authProvider.verifyOTP(otpCode);

                            // Navigation vers l'accueil si connexion réussie
                            if (authProvider.isLoggedIn && authProvider.errorMessage == null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 28),
                        // Bouton Vérifier
                        CustomOrangeButton(
                          text: 'Vérifier',
                          onPressed: () {
                            // La vérification se fait automatiquement via onCompleted
                          },
                          height: sizes.buttonHeight,
                          isLoading: authProvider.isLoading,
                        ),
                        const SizedBox(height: 20),
                        // Message d'erreur
                        if (authProvider.errorMessage != null)
                          Text(
                            authProvider.errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        // Renvoyer le code
                        TextButton(
                          onPressed: authProvider.canResendOTP
                              ? () => authProvider.resendOTP()
                              : null,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            authProvider.canResendOTP
                                ? 'Renvoyer le code'
                                : 'Renvoyer dans ${authProvider.otpResendTimer}s',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: authProvider.canResendOTP
                                  ? const Color(0xFF666666)
                                  : const Color(0xFF999999),
                              decoration: authProvider.canResendOTP
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Retour à la connexion
                        TextButton(
                          onPressed: () {
                            authProvider.resetOTP();
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Retour à la connexion',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF999999),
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}