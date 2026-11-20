import 'package:flutter/material.dart';

import '../models/product.dart';
import '../product_card.dart';

class CatalogPage extends StatefulWidget {
  final String? category;
  final ValueChanged<String?> onCategoryChanged;

  const CatalogPage({super.key, this.category, required this.onCategoryChanged});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  static final examples = {
    'Atasan': Product(id: 1, name: 'Kemeja linen', brand: 'Lokal', size: 'M', priceDisplay: 'Rp65.000'),
    'Bawahan': Product(id: 2, name: 'Celana denim', brand: 'Preloved', size: 'L', priceDisplay: 'Rp85.000'),
    'Outerwear': Product(id: 3, name: 'Jaket katun', brand: 'Lokal', size: 'L', priceDisplay: 'Rp90.000'),
    'Dress': Product(id: 4, name: 'Dress floral', brand: 'Preloved', size: 'S', priceDisplay: 'Rp75.000'),
  };
  String query = '';

  @override
  Widget build(BuildContext context) {
    final products = examples.entries.where((entry) {
      final product = entry.value;
      return (widget.category == null || entry.key == widget.category) &&
          '${product.name} ${product.brand}'.toLowerCase().contains(query);
    }).map((entry) => entry.value).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Katalog')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Cari nama atau merek'),
            onChanged: (value) => setState(() => query = value.trim().toLowerCase()),
          ),
          const SizedBox(height: 12),
          Wrap(spacing: 8, children: [
            for (final category in [null, ...examples.keys])
              ChoiceChip(
                label: Text(category ?? 'Semua'),
                selected: category == widget.category,
                onSelected: (_) => widget.onCategoryChanged(category),
              ),
          ]),
          const SizedBox(height: 16),
          Text('Produk contoh', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (products.isEmpty)
            const Text('Produk tidak ditemukan. Coba kata kunci atau kategori lain.')
          else
            GridView.extent(
              maxCrossAxisExtent: 240,
              mainAxisExtent: 216,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [for (final product in products) ProductCard(product: product)],
            ),
        ],
      ),
    );
  }
}
