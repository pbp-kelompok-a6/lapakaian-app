# LaPAKAIAN Mobile — Gaya Berkelanjutan, Peduli Lingkungan

Proyek Akhir Semester — Mata Kuliah Pemrograman Berbasis Platform (PBP)
Fakultas Ilmu Komputer, Universitas Indonesia — Kelompok A-6

<img src="assets/logo.png" width="96" alt="Logo LaPAKAIAN">

## Anggota Kelompok A-6

| Nama | NPM |
|---|---|
| Naurah Claradinda Aulia Pane | 2506657163 |
| Emil Ananta Kautsar | 2506622121 |
| Joanna Prittavidya Putri Arianto | 2506539265 |
| Razan Muhammad Fathin Lesmana | 2506603646 |
| Goeij Angelatika Goeyanto | 2506656772 |

## Deskripsi Aplikasi

LaPAKAIAN adalah marketplace sederhana untuk jual-beli baju thrift/preloved, dibangun di bawah tema besar **Sustainable Living** (sub-tema Slow Fashion & Conscious Shopping).

Baju bekas yang masih layak pakai sering berakhir menjadi sampah karena pemiliknya tidak tahu harus menjualnya ke mana. Di sisi lain, banyak calon pembeli yang ingin berbelanja lebih hemat dan ramah lingkungan, tetapi kesulitan menemukan tempat jual-beli baju bekas yang rapi dan terpercaya. LaPAKAIAN menjembatani keduanya lewat satu akun untuk semua pengguna: setiap pengguna dapat menjelajah katalog, menyimpan baju favorit ke wishlist, dan mulai berjualan kapan saja tanpa akun terpisah. Dengan begitu, siklus hidup pakaian menjadi lebih panjang dan sampah fashion berkurang.

Repositori ini adalah **versi mobile (Flutter)** dari aplikasi web LaPAKAIAN yang dibuat pada Proyek Tengah Semester.

## Daftar Modul dan Pembagian Kerja

Setiap anggota melanjutkan modul yang sama dengan modul pada versi web.

| Modul | Penanggung jawab | Cakupan |
|---|---|---|
| Akun, Profil & Landing Page | Naurah | Beranda, masuk, daftar, profil (lihat/edit bio), aktivasi peran seller, hapus akun |
| Listing Baju | Goeij Angelatika Goeyanto | Tambah, lihat, edit, hapus listing; tandai terjual; My Listings |
| Profil Toko & Size Chart | Emil Ananta Kautsar | Buka/edit/tutup toko, profil toko, size chart per brand |
| Katalog & Wishlist | Razan Muhammad Fathin Lesmana | Katalog dengan filter, wishlist dan catatan |
| Ulasan | Joanna Prittavidya Putri Arianto | Tambah, lihat, edit, hapus ulasan |

## Peran Pengguna

Aplikasi memakai **satu jenis akun** untuk semua pengguna (tidak ada pilihan role saat registrasi).

| Peran | Hak akses |
|---|---|
| Pengunjung (belum login) | Menjelajah katalog, mencari/filter produk, membuka detail produk |
| Buyer (pembeli) | Peran default setelah login: wishlist dan menulis ulasan |
| Seller (penjual) | Peran tambahan lewat tombol "Jadi Seller" di Profil: mengelola listing dan profil toko |

Status seller disimpan sebagai field pada model Profile di backend, sehingga satu akun dapat menjadi buyer sekaligus seller.

## Alur Integrasi Data Aplikasi Mobile dengan Web

Aplikasi Flutter tidak memiliki database sendiri. Seluruh data berasal dari backend Django (proyek web LaPAKAIAN) melalui web service berformat JSON.

1. Pengguna membuka halaman di aplikasi Flutter, misalnya Beranda atau Profil.
2. Flutter mengirim request HTTP ke endpoint Django memakai `CookieRequest` dari paket `pbp_django_auth`, yang menyimpan cookie sesi Django.
3. Django memproses request (termasuk pengecekan login lewat sesi) dan mengembalikan respons JSON.
4. Flutter mengubah JSON menjadi model Dart (misalnya `Product`) dan menampilkannya sebagai widget.
5. Aksi pengguna seperti login, daftar, edit bio, dan toggle seller dikirim lewat request POST ke endpoint yang sesuai, lalu tampilan diperbarui dari respons.

Contoh endpoint yang dipakai:

| Fungsi | Method | Endpoint |
|---|---|---|
| Login | POST | `/akun/api/login/` |
| Registrasi | POST | `/akun/api/register/` |
| Logout | POST | `/akun/api/logout/` |
| Lihat profil | GET | `/akun/api/profil/` |
| Edit bio | POST | `/akun/api/profil/edit/` |
| Toggle seller | POST | `/akun/api/toggle-seller/` |
| Hapus akun | POST | `/akun/api/hapus/` |
| Daftar produk (Beranda) | GET | `/listing/json/` |

Alamat server diatur di `lib/config.dart`.

## Teknologi

- Flutter (Dart), paket `provider`, `pbp_django_auth`, dan `google_fonts`
- Backend: Django (proyek web LaPAKAIAN)
- Desain: Figma

## Cara Menjalankan

1. Jalankan backend Django terlebih dahulu (`python manage.py runserver`).
2. Jalankan `flutter pub get`.
3. Atur `baseUrl` di `lib/config.dart` (emulator Android: `http://10.0.2.2:8000`, Chrome: `http://127.0.0.1:8000`).
4. Jalankan `flutter run`.

## Tautan

- **Repositori Flutter:** https://github.com/pbp-kelompok-a6/lapakaian-app
- **Repositori Django (backend):** https://github.com/pbp-kelompok-a6/Slow-Fashion-Conscious-Shopping
- **Deployment web (PWS):** https://naurah-claradinda-lapakaian.pws.cs.ui.ac.id/
- **Desain Figma:** https://www.figma.com/design/kYuHhSBpmqhh0wkD6b6EmD/LaPAKAIAN--Copy-?node-id=0-1&p=f&t=5glAVt0DNjdGUWlY-0
- **Mock API Size Chart:** https://adbff5e9-8baf-4330-8890-d931a43d0a06.mock.pstmn.io/sizechart
- **Unduh APK:** _(diisi setelah build release di Bitrise)_