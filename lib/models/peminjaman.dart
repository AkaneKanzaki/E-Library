class Peminjaman {
  final String id;
  final String userId;
  final String bookId;
  final DateTime tanggalPinjam;
  final DateTime tanggalKembali;
  final String status; // 'dipinjam' atau 'dikembalikan'

  Peminjaman({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.tanggalPinjam,
    required this.tanggalKembali,
    required this.status,
  });
} 