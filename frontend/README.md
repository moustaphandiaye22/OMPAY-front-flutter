# OM Pay - Application de Paiement Mobile Orange Money

[![Flutter](https://img.shields.io/badge/Flutter-3.10.0-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0.0-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

OM Pay est une application mobile de paiement développée avec Flutter pour Orange Money. Elle permet aux utilisateurs de payer des marchands et de transférer de l'argent entre utilisateurs via des codes QR, offrant une expérience de paiement simple et sécurisée.

## 📋 Table des Matières

- [Fonctionnalités](#-fonctionnalités)
- [Architecture](#-architecture)
- [Technologies Utilisées](#-technologies-utilisées)
- [Installation et Configuration](#-installation-et-configuration)
- [Utilisation](#-utilisation)
- [Intégration API](#-intégration-api)
- [Structure du Projet](#-structure-du-projet)
- [Gestion d'État](#-gestion-détat)
- [Fonctionnalités Avancées](#-fonctionnalités-avancées)
- [Tests](#-tests)
- [Déploiement](#-déploiement)
- [Contribution](#-contribution)
- [Licence](#-licence)

## 🚀 Fonctionnalités

### Authentification
- Connexion via numéro de téléphone
- Vérification OTP (One-Time Password)
- Gestion de session utilisateur

### Paiements
- Paiement aux marchands via code QR
- Paiement direct via numéro de téléphone
- Scanner QR intégré
- Historique des transactions

### Transferts
- Transfert d'argent entre utilisateurs
- Validation en temps réel
- Notifications de transaction

### Portefeuille
- Consultation du solde
- Masquage/affichage du solde
- Historique des transactions

### Interface Utilisateur
- Thème sombre/clair
- Support multilingue (Français/Anglais)
- Design responsive
- Animations fluides

## 🏗️ Architecture

L'application suit une architecture modulaire avec séparation des responsabilités :

```
lib/
├── main.dart                    # Point d'entrée de l'application
├── features/                    # Fonctionnalités métier
│   ├── auth/                    # Authentification
│   ├── home/                    # Page d'accueil
│   ├── payment/                 # Paiements
│   ├── transfer/                # Transferts
│   └── wallet/                  # Portefeuille
├── services/                    # Services et providers
├── interfaces/                  # Interfaces et contrats
├── models/                      # Modèles de données
├── views/                       # Composants UI réutilisables
└── utils/                       # Utilitaires
```

### Pattern Architecture
- **MVVM (Model-View-ViewModel)** avec Provider pour la gestion d'état
- **Repository Pattern** pour l'accès aux données
- **Service Layer** pour la logique métier
- **Dependency Injection** via ServiceLocator

## 🛠️ Technologies Utilisées

### Framework
- **Flutter** 3.10.0 - Framework UI cross-platform
- **Dart** 3.0.0 - Langage de programmation

### Gestion d'État
- **Provider** 6.1.2 - Gestion d'état réactive

### Réseau et API
- **http** 1.6.0 - Client HTTP
- API REST Laravel backend

### Fonctionnalités Spéciales
- **mobile_scanner** 5.2.3 - Scanner QR code
- **qr_flutter** 4.1.0 - Génération QR code
- **permission_handler** 11.3.1 - Gestion des permissions
- **shared_preferences** 2.3.2 - Stockage local

### UI/UX
- **Material Design** - Design system Google
- **Custom Clippers** - Formes personnalisées
- **Responsive Design** - Adaptation multi-écrans

## 📦 Installation et Configuration

### Prérequis
- Flutter SDK 3.10.0 ou supérieur
- Dart SDK 3.0.0 ou supérieur
- Android Studio / VS Code
- Émulateur Android ou iOS

### Installation

1. **Cloner le repository**
   ```bash
   git clone https://github.com/your-repo/ompay-flutter.git
   cd ompay-flutter/frontend
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Configurer l'environnement**
   - Vérifier la configuration dans `utils/service_locator.dart`
   - URL de base API : `https://ompay-orange-money.onrender.com/api`

4. **Lancer l'application**
   ```bash
   flutter run
   ```

### Configuration Android
- SDK minimum : API 21 (Android 5.0)
- Permissions requises :
  - `android.permission.CAMERA` (pour le scanner QR)
  - `android.permission.INTERNET`

### Configuration iOS
- iOS 11.0 minimum
- Permissions dans `ios/Runner/Info.plist`

## 📱 Utilisation

### Première Connexion
1. Ouvrir l'application
2. Entrer votre numéro de téléphone Orange Money
3. Recevoir et saisir le code OTP
4. Accéder à votre compte

### Effectuer un Paiement
1. Sélectionner l'onglet "Payer"
2. Scanner le QR code du marchand ou saisir le code manuellement
3. Entrer le montant
4. Confirmer la transaction

### Transférer de l'Argent
1. Sélectionner l'onglet "Transférer"
2. Entrer le numéro du destinataire
3. Saisir le montant
4. Valider le transfert

### Consulter l'Historique
- Accéder à la section "Historique" sur la page d'accueil
- Voir toutes les transactions (crédits et débits)
- Actualiser avec le bouton de rafraîchissement

## 🔗 Intégration API

L'application communique avec un backend Laravel via une API REST :

### Endpoints Principaux

#### Authentification
- `POST /api/login` - Demande d'OTP
- `POST /api/verify-otp` - Vérification OTP
- `POST /api/logout` - Déconnexion

#### Paiements
- `POST /api/payments` - Effectuer un paiement
- `GET /api/payments/{id}` - Détails d'un paiement

#### Transferts
- `POST /api/transfers` - Effectuer un transfert
- `GET /api/transfers/{id}` - Détails d'un transfert

#### Portefeuille
- `GET /api/wallet/balance` - Solde du compte
- `GET /api/wallet/transactions` - Historique des transactions

### Gestion des Erreurs
- Codes HTTP standards (200, 400, 401, 500)
- Messages d'erreur localisés
- Retry automatique pour les erreurs réseau

## 📁 Structure du Projet

```
frontend/
├── android/                     # Configuration Android
├── ios/                        # Configuration iOS
├── lib/                        # Code source Dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── auth_service.dart
│   │   │   ├── auth_dto.dart
│   │   │   └── pages/
│   │   │       ├── login_page.dart
│   │   │       ├── otp_verification_page.dart
│   │   │       └── top_wave_clipper.dart
│   │   ├── home/
│   │   │   └── pages/
│   │   │       └── home_page.dart
│   │   ├── payment/
│   │   │   ├── payment_service.dart
│   │   │   └── payment_dto.dart
│   │   ├── transfer/
│   │   │   ├── transfer_service.dart
│   │   │   └── transfer_dto.dart
│   │   └── wallet/
│   │       ├── wallet_service.dart
│   │       └── wallet_dto.dart
│   ├── interfaces/
│   │   └── api_service.dart
│   ├── models/
│   │   ├── api_response.dart
│   │   └── entities/
│   │       ├── user.dart
│   │       ├── transaction.dart
│   │       ├── payment.dart
│   │       ├── transfer.dart
│   │       └── wallet.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── auth_provider.dart
│   │   ├── payment_provider.dart
│   │   ├── transfer_provider.dart
│   │   ├── theme_provider.dart
│   │   └── language_provider.dart
│   ├── utils/
│   │   ├── service_locator.dart
│   │   └── responsive_sizes.dart
│   └── views/
│       ├── custom_orange_button.dart
│       ├── custom_text_field.dart
│       ├── otp_input_field.dart
│       ├── payment_card.dart
│       └── country_selector.dart
├── assets/                      # Ressources statiques
│   ├── backgroundlogin.jpeg
│   ├── backgroundtransfert.png
│   └── ompay logo.png
└── test/                        # Tests unitaires
```

## 🎯 Gestion d'État

L'application utilise Provider pour une gestion d'état réactive :

### Providers Disponibles
- **AuthProvider** : Gestion de l'authentification et données utilisateur
- **PaymentProvider** : Gestion des paiements
- **TransferProvider** : Gestion des transferts
- **ThemeProvider** : Gestion du thème (clair/sombre)
- **LanguageProvider** : Gestion de la langue

### Pattern d'Utilisation
```dart
final authProvider = Provider.of<AuthProvider>(context);
final userName = authProvider.userName;
final balance = authProvider.userBalance;
```

## ⚡ Fonctionnalités Avancées

### Scanner QR Code
- Support des QR codes utilisateur (+221XXXXXXXXX)
- Support des QR codes marchand (JSON format)
- Interface scanner native avec overlay

### Sécurité
- Vérification OTP pour l'authentification
- Masquage du solde par défaut
- Validation des montants et numéros

### Accessibilité
- Support des lecteurs d'écran
- Contraste élevé pour la lisibilité
- Tailles de police adaptatives

### Performance
- Lazy loading des transactions
- Cache des données utilisateur
- Optimisation des images

## 🧪 Tests

### Tests Unitaires
```bash
flutter test
```

### Tests d'Intégration
```bash
flutter test integration_test/
```

### Tests sur Appareil
```bash
flutter test --device-id=<device-id>
```

## 🚀 Déploiement

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Distribution
- Google Play Store pour Android
- App Store pour iOS
- Stores alternatifs si nécessaire

## 🤝 Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/AmazingFeature`)
3. Commit vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

### Guidelines
- Suivre les conventions de nommage Dart
- Écrire des tests pour les nouvelles fonctionnalités
- Documenter les changements dans le README
- Respecter l'architecture existante


