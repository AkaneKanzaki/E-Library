class Borrowing {
  final String id;
  final String userId;
  final String bookId;
  final DateTime borrowDate;
  final DateTime? returnDate; // Actual return date, null if not returned
  final DateTime dueDate; // Due date
  final String status; // 'borrowed' or 'returned'

  Borrowing({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.borrowDate,
    this.returnDate,
    required this.dueDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'bookId': bookId,
      'borrowDate': borrowDate.toIso8601String(),
      'returnDate': returnDate?.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'status': status,
    };
  }

  factory Borrowing.fromMap(Map<String, dynamic> map) {
    // Handling migration or missing fields gracefully
    DateTime borrowItem = DateTime.parse(map['borrowDate']);
    
    // Fallback if dueDate is missing (e.g. old data before migration)
    DateTime due = map['dueDate'] != null 
        ? DateTime.parse(map['dueDate']) 
        : borrowItem.add(const Duration(days: 7));
        
    return Borrowing(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      bookId: map['bookId'] ?? '',
      borrowDate: borrowItem,
      returnDate: map['returnDate'] != null 
          ? DateTime.parse(map['returnDate']) 
          : null,
      dueDate: due,
      status: map['status'] ?? 'borrowed',
    );
  }

  int calculateFine() {
    // If not returned yet, check if late from current time
    // If returned, check if late from return date
    final compareDate = returnDate ?? DateTime.now();
    
    // We only calculate days difference, strip the time
    final compareDay = DateTime(compareDate.year, compareDate.month, compareDate.day);
    final dueDay = DateTime(dueDate.year, dueDate.month, dueDate.day);

    if (compareDay.isAfter(dueDay)) {
      final daysLate = compareDay.difference(dueDay).inDays;
      return daysLate * 1000; // Rp. 1000 per day
    }
    return 0;
  }
}