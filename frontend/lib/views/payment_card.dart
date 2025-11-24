import 'package:flutter/material.dart';
import 'custom_text_field.dart';
import 'custom_orange_button.dart';

class PaymentCard extends StatefulWidget {
  final bool isPayerSelected;
  final Function(String merchant, String amount) onValidate;

  const PaymentCard({
    Key? key,
    required this.isPayerSelected,
    required this.onValidate,
  }) : super(key: key);

  @override
  State<PaymentCard> createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  final TextEditingController _merchantController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _merchantController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _handleValidate() {
    if (_merchantController.text.isNotEmpty && _amountController.text.isNotEmpty) {
      widget.onValidate(_merchantController.text, _amountController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        children: [
          // Champ numéro/code marchand
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF404040),
                width: 1.5,
              ),
            ),
            child: TextField(
              controller: _merchantController,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: widget.isPayerSelected
                    ? 'Saisir le numéro/code marchand'
                    : 'Saisir le numéro destinataire',
                hintStyle: const TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          // Champ montant
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(14),
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
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                hintText: 'Saisir le montant',
                hintStyle: TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Bouton Valider
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: _handleValidate,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7900),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: const Text(
                'Valider',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}