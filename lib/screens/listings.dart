import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../models/product.dart';
import '../product_card.dart';

class ListingsPage extends StatefulWidget {
  const ListingsPage({super.key});

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  late Future<List<Product>> _products;

  @override
  void initState() {
    super.initState();
    _products = _load();
  }

  Future<List<Product>> _load() async {
    final request = context.read<CookieRequest>();
    final res = await request.get('$baseUrl/listing/json/');
    final products = res['products'] as List;
    return products
        .map((product) => Product.fromJson(product as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listing')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: FutureBuilder<List<Product>>(
            future: _products,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Gagal memuat listing. Pastikan server Django hidup.',
                      ),
                      TextButton(
                        onPressed: () => setState(() => _products = _load()),
                        child: const Text('Coba lagi'),
                      ),
                    ],
                  ),
                );
              }

              final products = snapshot.data!;
              if (products.isEmpty) {
                return const Center(child: Text('Belum ada listing.'));
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth >= 800
                      ? 4
                      : constraints.maxWidth >= 560
                      ? 3
                      : 2;
                  return GridView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.66,
                    ),
                    itemBuilder: (context, index) =>
                        ProductCard(product: products[index]),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
