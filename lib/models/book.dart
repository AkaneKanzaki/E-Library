class Book {
  final String id;
  final String judul;
  final String penulis;
  final String penerbit;
  final String tahunTerbit;
  final String deskripsi;
  final String coverUrl;
  final bool tersedia;
  final String kategori;
  final String bookPath;
  final int jumlahHalaman;

  Book({
    required this.id,
    required this.judul,
    required this.penulis,
    required this.penerbit,
    required this.tahunTerbit,
    required this.deskripsi,
    required this.coverUrl,
    required this.tersedia,
    required this.kategori,
    required this.bookPath,
    required this.jumlahHalaman,
  });
} 