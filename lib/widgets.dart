import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(6)),
        child: Text('LP',
            style: GoogleFonts.archivo(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
      ),
      const SizedBox(width: 8),
      Text('LaPAKAIAN',
          style: GoogleFonts.archivo(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink)),
    ]);
  }
}

class LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscure;
  final String? hint;
  const LabeledField({
    super.key,
    required this.label,
    required this.controller,
    this.obscure = false,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: Theme.of(context).textTheme.labelLarge),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(hintText: hint),
      ),
    ]);
  }
}