import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../config.dart';

class StoreProfilePage extends StatefulWidget {
  const StoreProfilePage({super.key});

  @override
  State<StoreProfilePage> createState() => _StoreProfilePageState();
}

class _StoreProfilePageState extends State<StoreProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  Map<String, dynamic>? _store;
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _loadStore() async {
    if (_loading || !_formKey.currentState!.validate()) return;

    final username = _usernameController.text.trim();
    final request = context.read<CookieRequest>();

    FocusScope.of(context).unfocus();

    setState(() {
      _loading = true;
      _error = null;
      _store = null;
    });

    try {
      // Mengambil profil toko melalui Django REST Framework.
      final dynamic response = await request
          .get(
            '$baseUrl/toko/api/${Uri.encodeComponent(username)}/',
          )
          .timeout(const Duration(seconds: 15));

      if (!mounted) return;

      if (response is Map &&
          response['success'] == true &&
          response['store'] is Map) {
        setState(() {
          _store = Map<String, dynamic>.from(
            response['store'] as Map,
          );
        });
      } else {
        setState(() {
          _error =
              'Data toko tidak tersedia. Periksa username pemilik toko.';
        });
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _error =
            'Toko belum dapat dimuat. Pastikan username benar '
            'dan server Django dapat diakses, lalu coba lagi.';
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Widget _buildStoreCard(Map<String, dynamic> store) {
    final theme = Theme.of(context);
    final counts = store['counts'];
    final available = counts is Map ? counts['tersedia'] ?? 0 : 0;
    final sold = counts is Map ? counts['terjual'] ?? 0 : 0;

    final name = store['name']?.toString() ?? 'Toko';
    final username = store['username']?.toString() ?? '';
    final city = store['city']?.toString() ?? '';
    final description = store['description']?.toString() ?? '';
    final joined = store['joined_display']?.toString() ?? '';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.storefront_outlined,
              size: 56,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text('@$username'),
            const SizedBox(height: 16),
            Text(
              'Kota: ${city.isEmpty ? "Belum diisi" : city}',
            ),
            if (joined.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Bergabung sejak $joined'),
            ],
            const Divider(height: 32),
            Text(
              'Tentang toko',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              description.isEmpty
                  ? 'Pemilik belum menambahkan deskripsi toko.'
                  : description,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  label: Text('$available produk tersedia'),
                ),
                Chip(
                  label: Text('$sold produk terjual'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Toko'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                'Kenali toko pilihanmu',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                'Cari menggunakan username pemilik untuk melihat '
                'profil dan ringkasan produk tokonya.',
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _usernameController,
                  enabled: !_loading,
                  autocorrect: false,
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    labelText: 'Username pemilik toko',
                    hintText: 'Masukkan username tanpa @',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Isi username pemilik toko terlebih dahulu.';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _loadStore(),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _loading ? null : _loadStore,
                icon: const Icon(Icons.search),
                label: Text(
                  _loading ? 'Memuat toko...' : 'Lihat toko',
                ),
              ),
              const SizedBox(height: 24),
              if (_loading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else if (_error != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(Icons.info_outline),
                        const SizedBox(height: 12),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                          onPressed: _loadStore,
                          child: const Text('Coba lagi'),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_store != null)
                _buildStoreCard(_store!)
              else
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.storefront_outlined,
                        size: 64,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Temukan toko preloved favoritmu',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}