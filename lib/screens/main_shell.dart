import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../theme.dart';
import '../widgets.dart';
import 'catalog.dart';
import 'home.dart';
import 'listings.dart';
import 'login.dart';
import 'profile.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  String? _category;
  int _index = 0;
  int _profileVersion = 0;

  Future<void> _login() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const LoginPage()));
    if (mounted) setState(() => _profileVersion++);
  }

  @override
  Widget build(BuildContext context) {
    final loggedIn = context.watch<CookieRequest>().loggedIn;

    final pages = <Widget>[
      HomePage(onOpenCatalog: (category) => setState(() {
        _category = category;
        _index = 1;
      })),
      CatalogPage(category: _category, onCategoryChanged: (value) {
        setState(() => _category = value);
      }),
      const ListingsPage(),
      loggedIn
          ? const _Placeholder(
              title: 'Wishlist',
              note: 'Dikerjakan di modul Katalog & Wishlist.',
            )
          : _LoginPrompt(title: 'Wishlist', onLogin: _login),
      loggedIn
          ? ProfilePage(key: ValueKey(_profileVersion))
          : _LoginPrompt(title: 'Profil', onLogin: _login),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        backgroundColor: Colors.white,
        indicatorColor: AppColors.border,
        onDestinationSelected: (i) => setState(() {
          _index = i;
          if (i == 4) _profileVersion++;
        }),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Katalog',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'Listing',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final String title;
  final String note;
  const _Placeholder({required this.title, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Logo(), backgroundColor: Colors.transparent),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(note, style: const TextStyle(color: AppColors.muted)),
          ],
        ),
      ),
    );
  }
}

class _LoginPrompt extends StatelessWidget {
  final String title;
  final VoidCallback onLogin;
  const _LoginPrompt({required this.title, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Logo(), backgroundColor: Colors.transparent),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Masuk untuk membuka $title'),
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: FilledButton(
                onPressed: onLogin,
                child: const Text('Masuk'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
