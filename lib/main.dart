import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'screens/main_shell.dart';
import 'theme.dart';

void main() => runApp(const LapakaianApp());

class LapakaianApp extends StatelessWidget {
  const LapakaianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => CookieRequest(),
      child: MaterialApp(
        title: 'LaPAKAIAN',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: const MainShell(),
      ),
    );
  }
}