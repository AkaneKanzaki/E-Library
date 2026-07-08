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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'penulis': penulis,
      'penerbit': penerbit,
      'tahunTerbit': tahunTerbit,
      'deskripsi': deskripsi,
      'coverUrl': coverUrl,
      'tersedia': tersedia ? 1 : 0,
      'kategori': kategori,
      'bookPath': bookPath,
      'jumlahHalaman': jumlahHalaman,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] ?? '',
      judul: map['judul'] ?? '',
      penulis: map['penulis'] ?? '',
      penerbit: map['penerbit'] ?? '',
      tahunTerbit: map['tahunTerbit'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      coverUrl: map['coverUrl'] ?? '',
      tersedia: map['tersedia'] == 1,
      kategori: map['kategori'] ?? '',
      bookPath: map['bookPath'] ?? '',
      jumlahHalaman: map['jumlahHalaman'] ?? 0,
    );
  }
}