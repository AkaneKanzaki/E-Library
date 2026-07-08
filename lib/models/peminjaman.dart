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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'bookId': bookId,
      'tanggalPinjam': tanggalPinjam.toIso8601String(),
      'tanggalKembali': tanggalKembali.toIso8601String(),
      'status': status,
    };
  }

  factory Peminjaman.fromMap(Map<String, dynamic> map) {
    return Peminjaman(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      bookId: map['bookId'] ?? '',
      tanggalPinjam: DateTime.parse(map['tanggalPinjam']),
      tanggalKembali: DateTime.parse(map['tanggalKembali']),
      status: map['status'] ?? 'dipinjam',
    );
  }
}