import '../models/diary_entry.dart';

class DiaryService {
  static final DiaryService _instance = DiaryService._internal();
  factory DiaryService() => _instance;
  DiaryService._internal();

  // Mock data for demonstration
  final List<DiaryEntry> _entries = [
    DiaryEntry(
      id: '1',
      date: '2025년 8월 1일',
      weather: 'cloud',
      mood: 'happy',
      createdAt: DateTime.now(),
    ),
    DiaryEntry(
      id: '2',
      date: '2025년 8월 1일',
      weather: 'cloud',
      mood: 'happy',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    DiaryEntry(
      id: '3',
      date: '2025년 8월 1일',
      weather: 'cloud',
      mood: 'happy',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  // Get all diary entries
  List<DiaryEntry> getAllEntries() {
    return List.from(_entries);
  }

  // Get diary entries by year and month
  List<DiaryEntry> getEntriesByYearMonth(String year, String month) {
    return _entries.where((entry) {
      return entry.date.contains(year) && entry.date.contains(month);
    }).toList();
  }

  // Add new diary entry
  void addEntry(DiaryEntry entry) {
    _entries.add(entry);
  }

  // Update diary entry
  void updateEntry(DiaryEntry entry) {
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      _entries[index] = entry;
    }
  }

  // Delete diary entry
  void deleteEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
  }

  // Get diary entry by id
  DiaryEntry? getEntryById(String id) {
    try {
      return _entries.firstWhere((entry) => entry.id == id);
    } catch (e) {
      return null;
    }
  }
}


