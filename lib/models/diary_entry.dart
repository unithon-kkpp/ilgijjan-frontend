class DiaryEntry {
  final String id;
  final String date;
  final String weather;
  final String mood;
  final String? imageUrl;
  final String? content;
  final DateTime createdAt;

  DiaryEntry({
    required this.id,
    required this.date,
    required this.weather,
    required this.mood,
    this.imageUrl,
    this.content,
    required this.createdAt,
  });

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'weather': weather,
      'mood': mood,
      'imageUrl': imageUrl,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // JSON deserialization
  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      id: json['id'],
      date: json['date'],
      weather: json['weather'],
      mood: json['mood'],
      imageUrl: json['imageUrl'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Copy with method for immutability
  DiaryEntry copyWith({
    String? id,
    String? date,
    String? weather,
    String? mood,
    String? imageUrl,
    String? content,
    DateTime? createdAt,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      weather: weather ?? this.weather,
      mood: mood ?? this.mood,
      imageUrl: imageUrl ?? this.imageUrl,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}


