/// Represents a single Kanji flashcard entry.
class KanjiCard {
  final String id;
  final String kanji;
  final String meaning;
  final String onyomi;   // On'yomi (Chinese reading) in katakana
  final String kunyomi;  // Kun'yomi (Japanese reading) in hiragana
  final String jlptLevel;
  final String exampleWord;
  final String exampleReading;
  final String exampleMeaning;
  CardStatus status;

  KanjiCard({
    required this.id,
    required this.kanji,
    required this.meaning,
    required this.onyomi,
    required this.kunyomi,
    required this.jlptLevel,
    required this.exampleWord,
    required this.exampleReading,
    required this.exampleMeaning,
    this.status = CardStatus.unseen,
  });

  KanjiCard copyWith({CardStatus? status}) {
    return KanjiCard(
      id: id,
      kanji: kanji,
      meaning: meaning,
      onyomi: onyomi,
      kunyomi: kunyomi,
      jlptLevel: jlptLevel,
      exampleWord: exampleWord,
      exampleReading: exampleReading,
      exampleMeaning: exampleMeaning,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kanji': kanji,
      'meaning': meaning,
      'onyomi': onyomi,
      'kunyomi': kunyomi,
      'jlptLevel': jlptLevel,
      'exampleWord': exampleWord,
      'exampleReading': exampleReading,
      'exampleMeaning': exampleMeaning,
      'status': status.name,
    };
  }
}

enum CardStatus {
  unseen,
  mastered,
  reviewLater,
}

extension CardStatusX on CardStatus {
  String get label {
    switch (this) {
      case CardStatus.unseen:
        return 'New';
      case CardStatus.mastered:
        return 'Mastered';
      case CardStatus.reviewLater:
        return 'Review Later';
    }
  }
}
