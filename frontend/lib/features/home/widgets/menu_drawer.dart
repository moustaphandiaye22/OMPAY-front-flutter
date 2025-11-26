import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/auth_provider.dart';
import '../../../services/theme_provider.dart';
import '../../../services/language_provider.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  bool _isScannerEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return Consumer<LanguageProvider>(
              builder: (context, languageProvider, child) {
        return Drawer(
          backgroundColor: themeProvider.isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(height: 60),
                    // Profil utilisateur
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      child: Column(
                        children: [
                          // Avatar
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 50,
                              color: Color(0xFF999999),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Nom
                          Text(
                            authProvider.userName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Numéro
                          Text(
                            authProvider.userPhone.isNotEmpty ? authProvider.userPhone : 'Numéro non disponible',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                // Ligne séparatrice
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  height: 1,
                  color: themeProvider.isDarkMode ? const Color(0xFF4A4A4A) : Colors.grey.shade300,
                ),
                const SizedBox(height: 10),
                // Option Sombre avec toggle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.wb_sunny_outlined,
                        color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                        size: 28,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          languageProvider.darkMode,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      Transform.scale(
                        scale: 0.9,
                        child: Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (value) {
                            themeProvider.toggleTheme();
                          },
                          activeColor: themeProvider.isDarkMode ? Colors.white : Colors.black,
                          activeTrackColor: const Color(0xFF666666),
                          inactiveThumbColor: themeProvider.isDarkMode ? Colors.white : Colors.black,
                          inactiveTrackColor: const Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Option Scanner avec toggle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.qr_code_scanner,
                        color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                        size: 28,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          languageProvider.scanner,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      Transform.scale(
                        scale: 0.9,
                        child: Switch(
                          value: _isScannerEnabled,
                          onChanged: (value) {
                            setState(() {
                              _isScannerEnabled = value;
                            });
                          },
                          activeColor: themeProvider.isDarkMode ? Colors.white : Colors.black,
                          activeTrackColor: const Color(0xFF666666),
                          inactiveThumbColor: themeProvider.isDarkMode ? Colors.white : Colors.black,
                          inactiveTrackColor: const Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Option Langue
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: InkWell(
                    onTap: () {
                      languageProvider.toggleLanguage();
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.language,
                          color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                          size: 28,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            languageProvider.language,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Option Se déconnecter
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: InkWell(
                    onTap: () async {
                      // Logique de déconnexion via AuthProvider
                      await authProvider.logout();
                      // Navigation vers la page de connexion (le drawer se fermera automatiquement)
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          Navigator.of(context).pushReplacementNamed('/login');
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.power_settings_new,
                            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          languageProvider.logout,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Version en bas
          Container(
            padding: const EdgeInsets.all(24),
            child: const Text(
              'OMPAY Version - 1.1.0(35)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFF7900),
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
              },
            );
          },
        );
      },
    );
  }
}