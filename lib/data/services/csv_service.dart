import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import '../models/journal_entry.dart';

class CsvService {
  static const String _fileName = 'health_logs.csv';

  // Helper function to get the exact file path on the device
  Future<File> getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  // Save a new entry to the CSV file
  Future<void> saveEntry(JournalEntry entry) async {
    final file = await getLocalFile();
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
    final file = await getLocalFile();

    if (!(await file.exists())) {
      return []; // Return empty if no logs exist yet
    }

    final String fileContent = await file.readAsString();
    final List<List<dynamic>> csvData = const CsvToListConverter().convert(
      fileContent,
    );

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

  // Get the count of unique days with entries in the last 7 days
  Future<int> getWeeklyRhythmCount() async {
    final file = await getLocalFile();
    if (!(await file.exists())) return 0;

    final String fileContent = await file.readAsString();
    final List<List<dynamic>> csvData = const CsvToListConverter().convert(
      fileContent,
    );

    DateTime today = DateTime.now();
    DateTime sevenDaysAgo = today.subtract(const Duration(days: 7));
    Set<String> daysWithEntries = {};

    for (var row in csvData) {
      if (row.isNotEmpty) {
        try {
          DateTime entryDate = DateTime.parse(row[0].toString());
          // Check if the entry is within the last 7 days
          if (entryDate.isAfter(sevenDaysAgo)) {
            // Save as a string (YYYY-MM-DD) so multiple entries on the same day only count as 1
            daysWithEntries.add(
              "${entryDate.year}-${entryDate.month}-${entryDate.day}",
            );
          }
        } catch (e) {
          // Ignore any malformed rows
        }
      }
    }
    return daysWithEntries.length;
  }

  Future<void> deleteEntry(JournalEntry entryToDelete) async {
    final file = await getLocalFile();
    if (!(await file.exists())) return;

    final String fileContent = await file.readAsString();
    final List<List<dynamic>> csvData = const CsvToListConverter().convert(
      fileContent,
    );

    // Convert the entry we want to delete into a CSV row to compare
    final targetRowString = entryToDelete.toCsvRow().join(',');

    // Filter out the row that matches exactly
    final List<List<dynamic>> updatedCsvData = csvData.where((row) {
      return row.join(',') != targetRowString;
    }).toList();

    // Save the newly updated list back to the file
    final String newCsvContent = const ListToCsvConverter().convert(
      updatedCsvData,
    );
    await file.writeAsString(newCsvContent);
  }

  Future<JournalEntry?> getMostRecentEntry() async {
    final file = await getLocalFile();
    if (!(await file.exists())) return null;

    final String fileContent = await file.readAsString();
    final List<List<dynamic>> csvData = const CsvToListConverter().convert(
      fileContent,
    );

    // Read from the bottom up to find the newest row
    for (int i = csvData.length - 1; i >= 0; i--) {
      if (csvData[i].isNotEmpty) {
        try {
          return JournalEntry.fromCsvRow(csvData[i]);
        } catch (e) {
          continue; // Skip any corrupted rows
        }
      }
    }
    return null; // Return null if no valid entries exist
  }
}
