import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../theme.dart';
import '../widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _bio = TextEditingController();
  Map<String, dynamic>? _profile;
  bool _loading = true;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _bio.dispose();
    super.dispose();
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  void _apply(Map res) {
    final p = Map<String, dynamic>.from(res['profile'] as Map);
    setState(() {
      _profile = p;
      _bio.text = (p['bio'] ?? '') as String;
    });
  }

  String _firstError(Map res) {
    final errors = res['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final first = errors.values.first;
      if (first is List && first.isNotEmpty) return first.first['message'].toString();
    }
    return res['message']?.toString() ?? 'Terjadi kesalahan.';
  }

  Future<void> _load() async {
    final request = context.read<CookieRequest>();
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await request.get('$baseUrl/akun/api/profil/');
      if (!mounted) return;
      if (res['status'] == true) {
        _apply(res);
      } else {
        _error = res['message']?.toString() ?? 'Gagal memuat profil.';
      }
    } catch (_) {
      _error = 'Tidak bisa terhubung ke server.';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<Map?> _post(String path, [Map<String, String> data = const {}]) async {
    final request = context.read<CookieRequest>();
    setState(() => _busy = true);
    try {
      final res = await request.post('$baseUrl$path', data);
      return res as Map;
    } catch (_) {
      if (mounted) _snack('Tidak bisa terhubung ke server.');
      return null;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _saveBio() async {
    final res = await _post('/akun/api/profil/edit/', {'bio': _bio.text});
    if (res == null || !mounted) return;
    if (res['status'] == true) {
      _apply(res);
      _snack('Bio berhasil disimpan.');
    } else {
      _snack(_firstError(res));
    }
  }

  Future<void> _toggleSeller() async {
    final res = await _post('/akun/api/toggle-seller/');
    if (res == null || !mounted) return;
    if (res['status'] == true) {
      _apply(res);
      _snack(res['message'].toString());
    } else {
      _snack(_firstError(res));
    }
  }

  Future<void> _deleteAccount() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus akun?'),
        content: const Text('Akun dan semua datanya akan dihapus permanen.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final res = await _post('/akun/api/hapus/');
    if (res == null || !mounted) return;
    if (res['status'] == true) {
      final request = context.read<CookieRequest>();
      await request.logout('$baseUrl/akun/api/logout/');
      if (!mounted) return;
      Navigator.of(context).pop();
      _snack('Akun kamu sudah dihapus.');
    } else {
      _snack(_firstError(res));
    }
  }

  Widget _infoRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: const TextStyle(color: AppColors.muted)),
          Text(value, style: GoogleFonts.archivo(fontWeight: FontWeight.w600)),
        ]),
      );

  Widget _content() {
    final p = _profile!;
    final isSeller = p['is_seller'] == true;
    final joined = (p['date_joined'] as String).substring(0, 10);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: ListView(padding: const EdgeInsets.all(24), children: [
          Text(p['username'] as String, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              label: Text(isSeller ? 'Seller' : 'Buyer'),
              backgroundColor: Colors.white,
              side: const BorderSide(color: AppColors.border),
            ),
          ),
          const SizedBox(height: 16),
          _infoRow('Bergabung', joined),
          _infoRow('Jumlah listing', '${p['product_count']}'),
          _infoRow('Toko', p['has_store'] == true ? 'Sudah punya' : 'Belum punya'),
          const SizedBox(height: 24),
          Text('Bio', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          TextField(
            controller: _bio,
            maxLines: 4,
            maxLength: 200,
            decoration: const InputDecoration(
              hintText: 'Ceritakan sedikit tentang dirimu atau gaya berpakaianmu.',
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _busy ? null : _saveBio,
            child: const Text('Simpan bio'),
          ),
          const SizedBox(height: 24),
          isSeller
              ? OutlinedButton(
                  onPressed: _busy ? null : _toggleSeller,
                  child: const Text('Nonaktifkan seller'),
                )
              : FilledButton(
                  onPressed: _busy ? null : _toggleSeller,
                  child: const Text('Jadi seller'),
                ),
          const SizedBox(height: 24),
          Center(
            child: TextButton(
              onPressed: _busy ? null : _deleteAccount,
              child: const Text('Hapus akun', style: TextStyle(color: Colors.red)),
            ),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_error != null || _profile == null) {
      body = Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(_error ?? 'Gagal memuat profil.'),
          TextButton(onPressed: _load, child: const Text('Coba lagi')),
        ]),
      );
    } else {
      body = _content();
    }
    return Scaffold(
      appBar: AppBar(title: const Logo(), backgroundColor: Colors.transparent),
      body: body,
    );
  }
}