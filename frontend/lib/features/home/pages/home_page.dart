import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../views/payment_tab_selector.dart';
import '../../../views/payment_card.dart';
import '../../../views/decorative_image_section.dart';
import '../../../views/empty_history_section.dart';
import '../../../views/custom_orange_button.dart';
import '../../../services/auth_provider.dart';
import '../../../services/payment_provider.dart';
import '../../../services/transfer_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final paymentProvider = Provider.of<PaymentProvider>(context);
    final transferProvider = Provider.of<TransferProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
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
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF333333),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Menu en haut à gauche
                      Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              // Ouvrir le menu
                              Scaffold.of(context).openDrawer();
                            },
                            icon: const Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
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
                                      const TextSpan(
                                        text: 'Bonjour ',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                      TextSpan(
                                        text: authProvider.userName,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFFFF7900),
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
                                        color: Colors.white.withOpacity(0.8),
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // QR Code aligné avec les autres éléments
                          Container(
                            width: 60,
                            height: 60,
                            child: const Icon(
                              Icons.qr_code_2,
                              color: Colors.white,
                              size: 60,
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
                        color: Colors.black.withOpacity(0.15),
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
                            color: Colors.black.withOpacity(0.06),
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
                                            color: const Color(0xFF1A1A1A),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: const Color(0xFF404040),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: TextField(
                                            controller: _recipientController,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: authProvider.isPayerSelected
                                                  ? 'Numéro/code marchand'
                                                  : 'Numéro destinataire',
                                              hintStyle: const TextStyle(
                                                color: Color(0xFF888888),
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
                                            color: const Color(0xFF1A1A1A),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: const Color(0xFF404040),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: TextField(
                                            controller: _amountController,
                                            keyboardType: TextInputType.number,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            decoration: const InputDecoration(
                                              hintText: 'Montant',
                                              hintStyle: TextStyle(
                                                color: Color(0xFF888888),
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
                                                  const SnackBar(content: Text('Veuillez remplir tous les champs')),
                                                );
                                                return;
                                              }

                                              final amount = double.tryParse(amountText);
                                              if (amount == null || amount <= 0) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Montant invalide')),
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
                                                    const SnackBar(content: Text('Paiement effectué avec succès')),
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
                                                    const SnackBar(content: Text('Transfert effectué avec succès')),
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
                                            child: const Text(
                                              'Valider',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Icône caméra sur l'image
                                  Container(
                                    width: 44,
                                    height: 44,
                                    margin: const EdgeInsets.only(top: 0),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.95),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        // Ouvrir scanner QR
                                      },
                                      icon: const Icon(
                                        Icons.camera_alt,
                                        color: Color(0xFFFF7900),
                                        size: 22,
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
                const SizedBox(height: 15),
                 // Section Max it
                const Text(
                  'Pour toute autre opération',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 12),
                // Bouton Max it
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3A),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7900),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Max it',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    title: const Text(
                      'Accéder à Max it',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                    onTap: () {
                      // Navigation vers Max it
                    },
                  ),
                ),
                const SizedBox(height: 15),
                // Section Historique
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Historique',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                    IconButton(
                      onPressed: authProvider.refreshUserData,
                      icon: authProvider.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Color(0xFFFF7900),
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(
                              Icons.refresh,
                              color: Color(0xFFFF7900),
                              size: 30,
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Historique des transactions
                authProvider.transactions.isEmpty
                    ? const EmptyHistorySection()
                    : Container(
                        constraints: const BoxConstraints(maxHeight: 300), // Limiter la hauteur
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(), // Permettre le scroll
                          itemCount: authProvider.transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = authProvider.transactions[index];
                            return Container(
                              margin: EdgeInsets.only(
                                top: index == 0 ? 16 : 8,
                                bottom: index == authProvider.transactions.length - 1 ? 16 : 8,
                                left: 16,
                                right: 16,
                              ),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3A3A3A),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: transaction.type == 'credit'
                                          ? Colors.green.withOpacity(0.2)
                                          : Colors.red.withOpacity(0.2),
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
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          transaction.dateTransaction != null
                                              ? '${transaction.dateTransaction!.day}/${transaction.dateTransaction!.month}/${transaction.dateTransaction!.year}'
                                              : 'Date inconnue',
                                          style: const TextStyle(
                                            color: Color(0xFF888888),
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
                      style: const TextStyle(
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
                      style: const TextStyle(
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