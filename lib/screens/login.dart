import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../widgets.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _submit() async {
    final request = context.read<CookieRequest>();
    setState(() => _loading = true);
    try {
      final res = await request.login('$baseUrl/akun/api/login/', {
        'username': _username.text.trim(),
        'password': _password.text,
      });
      if (!mounted) return;
      if (request.loggedIn) {
        Navigator.of(context).pop(true);
        _snack('Selamat datang, ${res['username']}!');
      } else {
        _snack(res['message']?.toString() ?? 'Login gagal.');
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
          Text('Masuk', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          LabeledField(label: 'Nama pengguna', controller: _username),
          const SizedBox(height: 16),
          LabeledField(label: 'Password', controller: _password, obscure: true),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _loading ? null : _submit,
            child: Text(_loading ? 'Memproses...' : 'Masuk'),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const RegisterPage())),
              child: const Text('Belum punya akun? Daftar'),
            ),
          ),
        ]),
      ),
    );
  }
}