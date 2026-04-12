import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import '../models/journal_entry.dart';

class CsvService {
  static const String _fileName = 'health_logs.csv';

  // Helper function to get the exact file path on the device
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  // Save a new entry to the CSV file
  Future<void> saveEntry(JournalEntry entry) async {
    final file = await _getLocalFile();
    List<List<dynamic>> csvData = [];

    // If file exists, read existing data first
    if (await file.exists()) {
      final String fileContent = await file.readAsString();
      csvData = const CsvToListConverter().convert(fileContent);
    }

    // Add the new row and save
    csvData.add(entry.toCsvRow());
    final String newCsvContent = const ListToCsvConverter().convert(csvData);
    await file.writeAsString(newCsvContent);
  }

  // Get all entries for a specific day
  Future<List<JournalEntry>> getEntriesForDay(DateTime targetDate) async {
    final file = await _getLocalFile();
    
    if (!(await file.exists())) {
      return []; // Return empty if no logs exist yet
    }

    final String fileContent = await file.readAsString();
    final List<List<dynamic>> csvData = const CsvToListConverter().convert(fileContent);

    List<JournalEntry> dayEntries = [];

    for (var row in csvData) {
      if (row.isNotEmpty) {
        JournalEntry entry = JournalEntry.fromCsvRow(row);
        // Check if the entry's date matches the target date (ignoring the exact time)
        if (entry.date.year == targetDate.year && 
            entry.date.month == targetDate.month && 
            entry.date.day == targetDate.day) {
          dayEntries.add(entry);
        }
      }
    }

    return dayEntries;
  }
}