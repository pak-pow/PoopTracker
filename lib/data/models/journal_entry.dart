class JournalEntry {
  final DateTime date;
  final String type; // "Smooth & Soft", "Hard & Dry", etc.
  final double discomfort;
  final List<String> tags;
  final String notes;

  JournalEntry({
    required this.date,
    required this.type,
    required this.discomfort,
    required this.tags,
    required this.notes,
  });

  // Convert to a List of strings so we can save it as a CSV row
  List<dynamic> toCsvRow() {
    return [
      date.toIso8601String(),
      type,
      discomfort,
      tags.join('|'), // Join tags with a pipe character so it stays in one column
      notes,
    ];
  }

  // Convert a CSV row back into a JournalEntry object
  factory JournalEntry.fromCsvRow(List<dynamic> row) {
    return JournalEntry(
      date: DateTime.parse(row[0].toString()),
      type: row[1].toString(),
      discomfort: double.tryParse(row[2].toString()) ?? 1.0,
      tags: row[3].toString().isEmpty ? [] : row[3].toString().split('|'),
      notes: row[5].toString(),
    );
  }
}