import 'package:flutter/foundation.dart';

// Emulator Android memakai 10.0.2.2; Chrome/desktop memakai 127.0.0.1.
// Nanti ganti ke URL PWS untuk versi final.
String get baseUrl => kIsWeb ? 'http://127.0.0.1:8000' : 'http://10.0.2.2:8000';