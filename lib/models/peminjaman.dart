class Peminjaman {
  final String id;
  final String userId;
  final String bookId;
  final DateTime tanggalPinjam;
  final DateTime? tanggalKembali; // Actual return date, null if not returned
  final DateTime batasWaktu; // Due date
  final String status; // 'dipinjam' atau 'dikembalikan'

  Peminjaman({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.tanggalPinjam,
    this.tanggalKembali,
    required this.batasWaktu,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'bookId': bookId,
      'tanggalPinjam': tanggalPinjam.toIso8601String(),
      'tanggalKembali': tanggalKembali?.toIso8601String(),
      'batasWaktu': batasWaktu.toIso8601String(),
      'status': status,
    };
  }

  factory Peminjaman.fromMap(Map<String, dynamic> map) {
    // Handling migration or missing fields gracefully
    DateTime pinjam = DateTime.parse(map['tanggalPinjam']);
    
    // Fallback if batasWaktu is missing (e.g. old data before migration)
    DateTime batas = map['batasWaktu'] != null 
        ? DateTime.parse(map['batasWaktu']) 
        : pinjam.add(const Duration(days: 7));
        
    return Peminjaman(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      bookId: map['bookId'] ?? '',
      tanggalPinjam: pinjam,
      tanggalKembali: map['tanggalKembali'] != null 
          ? DateTime.parse(map['tanggalKembali']) 
          : null,
      batasWaktu: batas,
      status: map['status'] ?? 'dipinjam',
    );
  }

  int hitungDenda() {
    // If not returned yet, check if late from current time
    // If returned, check if late from return date
    final compareDate = tanggalKembali ?? DateTime.now();
    
    // We only calculate days difference, strip the time
    final compareDay = DateTime(compareDate.year, compareDate.month, compareDate.day);
    final batasDay = DateTime(batasWaktu.year, batasWaktu.month, batasWaktu.day);

    if (compareDay.isAfter(batasDay)) {
      final daysLate = compareDay.difference(batasDay).inDays;
      return daysLate * 1000; // Rp. 1000 per day
    }
    return 0;
  }
}