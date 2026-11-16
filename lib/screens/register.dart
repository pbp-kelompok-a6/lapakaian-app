import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../widgets.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  String _firstError(Map res) {
    final errors = res['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final first = errors.values.first;
      if (first is List && first.isNotEmpty) return first.first['message'].toString();
    }
    return res['message']?.toString() ?? 'Registrasi gagal.';
  }

  Future<void> _submit() async {
    final request = context.read<CookieRequest>();
    setState(() => _loading = true);
    try {
      final user = _username.text.trim();
      final res = await request.post('$baseUrl/akun/api/register/', {
        'username': user,
        'password1': _password.text,
        'password2': _confirm.text,
      });
      if (!mounted) return;
      if (res['status'] == true) {
        await request.login('$baseUrl/akun/api/login/', {
          'username': user,
          'password': _password.text,
        });
        if (!mounted) return;
        Navigator.of(context).pop(true);
        _snack('Akun berhasil dibuat. Selamat datang di LaPAKAIAN!');
      } else {
        _snack(_firstError(res));
      }
    } catch (_) {
      if (mounted) _snack('Tidak bisa terhubung ke server.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Logo(), backgroundColor: Colors.transparent),
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(24), children: [
          Text('Daftar', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          LabeledField(label: 'Nama pengguna', controller: _username),
          const SizedBox(height: 16),
          LabeledField(label: 'Password', controller: _password, obscure: true),
          const SizedBox(height: 16),
          LabeledField(label: 'Ulangi password', controller: _confirm, obscure: true),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _loading ? null : _submit,
            child: Text(_loading ? 'Memproses...' : 'Buat akun'),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginPage())),
              child: const Text('Sudah punya akun? Masuk'),
            ),
          ),
        ]),
      ),
    );
  }
}