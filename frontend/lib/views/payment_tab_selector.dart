import 'package:flutter/material.dart';

class PaymentTabSelector extends StatelessWidget {
  final bool isPayerSelected;
  final Function(bool) onTabChanged;

  const PaymentTabSelector({
    Key? key,
    required this.isPayerSelected,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          // Onglet Payer
          GestureDetector(
            onTap: () => onTabChanged(true),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isPayerSelected
                            ? const Color(0xFFFF7900)
                            : const Color(0xFF666666),
                        width: 2,
                      ),
                      color: Colors.transparent,
                    ),
                    child: isPayerSelected
                        ? Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFF7900),
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Payer',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isPayerSelected
                          ? Colors.white
                          : const Color(0xFF666666),
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Onglet Transférer
          GestureDetector(
            onTap: () => onTabChanged(false),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: !isPayerSelected
                            ? const Color(0xFFFF7900)
                            : const Color(0xFF666666),
                        width: 2,
                      ),
                      color: Colors.transparent,
                    ),
                    child: !isPayerSelected
                        ? Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFF7900),
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Transférer',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: !isPayerSelected
                          ? Colors.white
                          : const Color(0xFF666666),
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_right_alt,
                    color: !isPayerSelected
                        ? const Color(0xFFFF7900)
                        : const Color(0xFF666666),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}