
# LSP MOBILE

  

## Penjelasan Package yang digunakan

1. sqflite: ^2.3.0
> Deskripsi: Package ini adalah library SQLite untuk Flutter. SQLite adalah database ringan yang sering digunakan dalam pengembangan aplikasi mobile.

> Fungsionalitas: Digunakan untuk menyimpan dan mengelola data lokal dalam aplikasi Flutter.

2. path: ^1.8.3

> Deskripsi: Package ini digunakan untuk memanipulasi dan mengelola jalur file (file paths) di dalam aplikasi Flutter.

> Fungsionalitas: Berguna untuk mengakses, membuat, menghapus, dan mengelola file dan direktori di sistem file lokal perangkat.

3. shared_preferences: ^2.2.1

> Deskripsi: Package ini digunakan untuk menyimpan dan mengambil data sederhana sebagai pasangan kunci-nilai (key-value) di dalam aplikasi Flutter.

> Fungsionalitas: Berguna untuk menyimpan preferensi pengguna, seperti pengaturan aplikasi atau data kecil lainnya yang perlu dipertahankan antara sesi aplikasi.

4. fl_chart: ^0.63.0

> Deskripsi: Package ini menyediakan berbagai jenis grafik dan grafik untuk aplikasi Flutter.

> Fungsionalitas: Digunakan untuk membuat grafik, diagram batang, diagram lingkaran, dan berbagai jenis visualisasi data lainnya dalam aplikasi Flutter.

5. intl: ^0.18.1

> Deskripsi: Package ini adalah library internasionalisasi (i18n) untuk Flutter yang memungkinkan Anda untuk mengelola dan menampilkan teks dalam berbagai bahasa dan format tanggal dan waktu.

> Fungsionalitas: Digunakan untuk membuat aplikasi yang mendukung berbagai bahasa dan format tanggal/waktu yang berbeda.

6. flutter_launcher_icons: ^0.13.1

> Deskripsi: Package ini digunakan untuk menghasilkan ikon aplikasi dengan berbagai resolusi dari gambar yang diberikan.

> Fungsionalitas: Berguna untuk mengonversi gambar menjadi ikon yang dapat digunakan sebagai ikon aplikasi di berbagai platform (misalnya Android dan iOS).

## Penjelasan File
1. ColorConst
> berisi konstanta yang berkaitan dengan warna yang digunakan dalam aplikasi
2. ImageConst
> Berisi konstanta yang berkaitan dengan gambar atau ikon yang digunakan dalam aplikasi.
3. CashFlowModel
> Model data untuk merepresentasikan data uang yang akan masuk atau keluar.
4. UserModel
> Berisi definisi model data yang digunakan untuk merepresentasikan pengguna atau profil pengguna dalam aplikasi.
5. SQLiteRepository
> File yang berisi logika akses ke database SQLite dalam aplikasi Anda. Repository ini berfungsi untuk berinteraksi dengan database SQLite, melakukan operasi seperti menyimpan, mengambil, dan menghapus data, dan memastikan konsistensi data.
6. TextFormatter
> Berisi fungsi-fungsi atau utilitas yang digunakan untuk memformat teks atau data.
7. DateHelper
> Berisi fungsi-fungsi atau utilitas yang digunakan untuk memformat tanggal dan waktu.