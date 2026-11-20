import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../models/product.dart';
import '../product_card.dart';
import '../theme.dart';
import '../widgets.dart';
import 'login.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  final void Function(String?) onOpenCatalog;

  const HomePage({super.key, required this.onOpenCatalog});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _categories = ['Atasan', 'Bawahan', 'Outerwear', 'Dress'];
  late Future<List<Product>> _products;

  @override
  void initState() {
    super.initState();
    _products = _load();
  }

  Future<List<Product>> _load() async {
    final request = context.read<CookieRequest>();
    final res = await request.get('$baseUrl/listing/json/');
    final list = (res['products'] as List).take(8);
    return list
        .map((j) => Product.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<void> _openLogin() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const LoginPage()));
    if (mounted) setState(() {});
  }

  Future<void> _openProfile() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const ProfilePage()));
    if (mounted) setState(() {});
  }

  Future<void> _logout() async {
    final request = context.read<CookieRequest>();
    await request.logout('$baseUrl/akun/api/logout/');
    if (mounted) setState(() {});
  }

  void _onSellerTap() {
    final request = context.read<CookieRequest>();
    if (request.loggedIn) {
      _openProfile();
    } else {
      _openLogin();
    }
  }

  Widget _sectionHeader(String title, String action, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.archivo(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        TextButton(onPressed: onTap, child: Text('$action →')),
      ],
    );
  }

  Widget _categoryTile(String label) {
    return InkWell(
      onTap: () => widget.onOpenCatalog(label),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GoogleFonts.archivo(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _productSection() {
    return FutureBuilder<List<Product>>(
      future: _products,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasError) {
          return Column(
            children: [
              const Text('Gagal memuat produk. Pastikan server Django hidup.'),
              TextButton(
                onPressed: () => setState(() => _products = _load()),
                child: const Text('Coba lagi'),
              ),
            ],
          );
        }
        final items = snap.data!;
        if (items.isEmpty) {
          return const Text(
            'Belum ada barang. Produk terbaru dari seller akan tampil di sini.',
          );
        }
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.66,
          ),
          itemBuilder: (context, i) => ProductCard(product: items[i]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Logo(),
        backgroundColor: Colors.transparent,
        actions: [
          if (request.loggedIn)
            TextButton(onPressed: _openProfile, child: const Text('Profil')),
          TextButton(
            onPressed: request.loggedIn ? _logout : _openLogin,
            child: Text(request.loggedIn ? 'Keluar' : 'Masuk'),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Text(
                'PRELOVED & THRIFT',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Baju bagus layak dipakai lagi',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              const Text(
                'Beli dan jual baju preloved dari sesama pengguna, langsung dari lemari mereka.',
                style: TextStyle(color: AppColors.muted, fontSize: 15),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => widget.onOpenCatalog(null),
                child: const Text('Belanja sekarang'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _onSellerTap,
                child: const Text('Jadi seller'),
              ),
              const SizedBox(height: 32),
              _sectionHeader(
                'Kategori',
                'Lihat semua',
                () => widget.onOpenCatalog(null),
              ),
              const SizedBox(height: 8),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.6,
                children: _categories.map(_categoryTile).toList(),
              ),
              const SizedBox(height: 32),
              _sectionHeader(
                'Baru masuk',
                'Lihat katalog',
                () => widget.onOpenCatalog(null),
              ),
              const SizedBox(height: 8),
              _productSection(),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.ink,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lemari penuh? Jual di sini.',
                      style: GoogleFonts.archivo(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Buka toko gratis dengan akun yang sama, tambah barang, tentukan harga.',
                      style: TextStyle(color: Color(0xFFD8D2C7), fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.ink,
                      ),
                      onPressed: _onSellerTap,
                      child: const Text('Jadi seller'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
