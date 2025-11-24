import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'top_wave_clipper.dart';
import 'otp_verification_page.dart';
import '../../../views/custom_orange_button.dart';
import '../../../views/country_selector.dart';
import '../../../views/custom_text_field.dart';
import '../../../services/auth_provider.dart';
import '../../../utils/responsive_sizes.dart';

class OrangeMoneyLoginPage extends StatelessWidget {
  const OrangeMoneyLoginPage({Key? key}) : super(key: key);

  void _handleLogin(BuildContext context, AuthProvider authProvider) async {
    await authProvider.requestOTP();

    if (authProvider.isOTPRequested && authProvider.errorMessage == null) {
      // Navigation vers la page OTP
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OTPVerificationPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final sizes = ResponsiveSizes.fromContext(context);
    const int currentPage = 1;

    return Scaffold(
      body: Stack(
        children: [
          // Image de fond avec overlay
          Positioned.fill(
            child: Stack(
              children: [
                // Image de fond
                Positioned(
                  top: -50,
                  left: 0,
                  right: 0,
                  bottom: -50,
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
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Contenu
          Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 140),
                            // Titre Payer un marchand
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Payer ',
                                      style: TextStyle(
                                        fontSize: sizes.titleFontSize,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFFFF7900),
                                        height: 1.2,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'un marchand',
                                      style: TextStyle(
                                        fontSize: sizes.titleFontSize,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        height: 1.2,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Description
                            const Padding(
                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Text(
                                'Payez plus simplement et rapidement vos courses en scannant le QR code chez tous les commerçants agréés Orange Money.',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFFE0E0E0),
                                  height: 1.5,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 180),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Indicateurs de pagination
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == currentPage
                                ? const Color(0xFFFF7900)
                                : const Color(0xFF555555),
                          ),
                        );
                      }),
                    ),
                  ),
                  // Section de connexion avec effet d'onde
                  Stack(
                    children: [
                      // Effet d'onde en arrière-plan
                      CustomPaint(
                        size: Size(MediaQuery.of(context).size.width, 400),
                        painter: TopWaveClipper(),
                      ),
                      // Contenu de la section de connexion
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 60),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1C1C1C),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(28, 32, 28, 32),
                          child: Column(
                            children: [
                              // Titre Bienvenue
                              Text(
                                'Bienvenue sur OM Pay!',
                                style: TextStyle(
                                  fontSize: sizes.welcomeFontSize,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Sous-titre
                              Text(
                                'Entrez votre numéro mobile pour vous connecter',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: sizes.subtitleFontSize,
                                  color: Color(0xFF999999),
                                  height: 1.4,
                                  letterSpacing: 0,
                                ),
                              ),
                              const SizedBox(height: 28),
                              // Champs de saisie
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Sélecteur de code pays
                                  CountrySelector(height: sizes.inputHeight),
                                  const SizedBox(width: 10),
                                  // Champ numéro de téléphone
                                  Expanded(
                                    child: CustomTextField(
                                      controller: authProvider.phoneController,
                                      hintText: 'Saisir mon numéro',
                                      height: sizes.inputHeight,
                                      keyboardType: TextInputType.phone,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Bouton Se connecter
                              CustomOrangeButton(
                                text: 'Se connecter',
                                onPressed: () => _handleLogin(context, authProvider),
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
                              // Copyright
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.copyright,
                                    size: 11,
                                    color: Color(0xFF666666),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    'Copyright - Orange Money Group, tous droits réservés',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF666666),
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Texte Orange Money
              Positioned(
                top: 60,
                left: 20,
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Orange ',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFFF7900),
                          letterSpacing: 0,
                        ),
                      ),
                      TextSpan(
                        text: 'Money',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}