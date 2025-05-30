import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final void Function(String)? onChanged;
  final double bottomSpacing;
  final bool enabled;

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
    this.bottomSpacing = 8,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFFAFAFA);
    const borderColor = Color(0xFFE1E1E1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText.isNotEmpty) ...[
          Text(
            labelText,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 5),
        ],
        TextField(
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          enabled: enabled,
          style: const TextStyle(fontSize: 13, color: Colors.black),
          decoration: InputDecoration(
            hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
            hintText: hintText,
            filled: true,
            fillColor: backgroundColor,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: borderColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: borderColor, width: 1),
            ),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon != null
                ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: prefixIcon,
            )
                : null,
          ),
        ),
        SizedBox(height: bottomSpacing),
      ],
    );
  }
}

