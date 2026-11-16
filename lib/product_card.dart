import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config.dart';
import 'models/product.dart';
import 'theme.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  Widget _placeholder() => const ColoredBox(
        color: AppColors.border,
        child: Center(child: Icon(Icons.checkroom, color: AppColors.hint, size: 32)),
      );

  @override
  Widget build(BuildContext context) {
    final meta = [product.brand, product.size].where((e) => e.isNotEmpty).join(' · ');
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: product.imageUrl == null
                ? _placeholder()
                : Image.network(
                    '$baseUrl${product.imageUrl}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => _placeholder(),
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.archivo(fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(meta,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: AppColors.muted)),
            const SizedBox(height: 6),
            Text(product.priceDisplay,
                style: GoogleFonts.archivo(fontSize: 14, fontWeight: FontWeight.w700)),
          ]),
        ),
      ]),
    );
  }
}