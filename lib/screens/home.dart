import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../theme.dart';
import '../widgets.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _openLogin() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginPage()));
    if (mounted) setState(() {});
  }

  Future<void> _logout() async {
    final request = context.read<CookieRequest>();
    await request.logout('$baseUrl/akun/api/logout/');
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Logo(),
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: request.loggedIn ? _logout : _openLogin,
            child: Text(request.loggedIn ? 'Keluar' : 'Masuk'),
          ),
        ],
      ),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        const Text('PRELOVED & THRIFT',
            style: TextStyle(fontSize: 12, letterSpacing: 1, color: AppColors.muted)),
        const SizedBox(height: 8),
        Text('Baju bagus layak dipakai lagi',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        const Text(
          'Beli dan jual baju preloved dari sesama pengguna, langsung dari lemari mereka.',
          style: TextStyle(color: AppColors.muted, fontSize: 15),
        ),
        const SizedBox(height: 24),
        FilledButton(onPressed: () {}, child: const Text('Belanja sekarang')),
        const SizedBox(height: 12),
        OutlinedButton(onPressed: () {}, child: const Text('Jadi seller')),
      ]),
    );
  }
}