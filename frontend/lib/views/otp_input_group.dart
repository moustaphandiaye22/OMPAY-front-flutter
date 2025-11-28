import 'package:flutter/material.dart';
import 'otp_input_field.dart';

class OTPInputGroup extends StatefulWidget {
  final Function(String) onCompleted;
  final int length;

  const OTPInputGroup({
    Key? key,
    required this.onCompleted,
    this.length = 6,
  }) : super(key: key);

  @override
  State<OTPInputGroup> createState() => _OTPInputGroupState();
}

class _OTPInputGroupState extends State<OTPInputGroup> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late String _otpCode;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.length,
      (index) => FocusNode(),
    );
    _otpCode = '';
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    // Mettre à jour le code OTP
    _otpCode = _controllers.map((controller) => controller.text).join();

    if (value.isNotEmpty && index < widget.length - 1) {
      // Passer au champ suivant
      _focusNodes[index + 1].requestFocus();
    } else if (_otpCode.length == widget.length) {
      // Code complet, notifier le parent
      widget.onCompleted(_otpCode);
    }
  }

  void _onFieldTap(int index) {
    if (_controllers[index].text.isNotEmpty) {
      _controllers[index].clear();
      _otpCode = _controllers.map((controller) => controller.text).join();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.length, (index) {
        return OTPInputField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          onChanged: (value) => _onChanged(value, index),
          onTap: () => _onFieldTap(index),
        );
      }),
    );
  }

  // Getter pour récupérer le code OTP actuel
  String get otpCode => _otpCode;

  // Méthode pour vider tous les champs
  void clear() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _otpCode = '';
    _focusNodes[0].requestFocus();
  }
}