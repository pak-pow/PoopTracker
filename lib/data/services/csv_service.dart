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

  // Get the current consecutive streak of daily logs
  Future<int> getCurrentStreak() async {
    final file = await getLocalFile();
    if (!(await file.exists())) return 0;

    final String fileContent = await file.readAsString();
    final List<List<dynamic>> csvData = const CsvToListConverter().convert(
      fileContent,
    );

    Set<String> daysWithEntries = {};

    for (var row in csvData) {
      if (row.isNotEmpty) {
        try {
          DateTime entryDate = DateTime.parse(row[0].toString());
          daysWithEntries.add(
              "${entryDate.year}-${entryDate.month}-${entryDate.day}");
        } catch (e) {
          // Ignore any malformed rows
        }
      }
    }

    if (daysWithEntries.isEmpty) return 0;

    int streak = 0;
    DateTime dateToCheck = DateTime.now();
    String todayKey = "${dateToCheck.year}-${dateToCheck.month}-${dateToCheck.day}";
    
    // If today is NOT logged, check if yesterday is logged, if neither, streak is 0.
    if (!daysWithEntries.contains(todayKey)) {
      dateToCheck = dateToCheck.subtract(const Duration(days: 1));
      String yesterdayKey = "${dateToCheck.year}-${dateToCheck.month}-${dateToCheck.day}";
      if (!daysWithEntries.contains(yesterdayKey)) {
         return 0; // The streak is dead
      }
    }

    // Now start counting backward consecutively
    while (true) {
      String dateKey = "${dateToCheck.year}-${dateToCheck.month}-${dateToCheck.day}";
      if (daysWithEntries.contains(dateKey)) {
        streak++;
        dateToCheck = dateToCheck.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  Future<void> deleteEntry(JournalEntry entryToDelete) async {
    final file = await getLocalFile();
    if (!(await file.exists())) return;

    final String fileContent = await file.readAsString();
    final List<List<dynamic>> csvData = const CsvToListConverter().convert(
      fileContent,
    );

    final String targetDateStr = entryToDelete.date.toIso8601String();

    // Filter out the row that matches exactly by timestamp
    final List<List<dynamic>> updatedCsvData = csvData.where((row) {
      if (row.isEmpty) return false;
      return row[0].toString() != targetDateStr;
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
