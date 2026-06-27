import '../models/kanji_card.dart';

/// Provides Kanji data grouped by JLPT level.
/// All data is embedded as const lists — no network or external files needed.
/// Source: Standard JLPT kanji lists (N5→N1 official vocabulary).
class KanjiService {
  KanjiService._();
  static final KanjiService instance = KanjiService._();

  // ── N5 — 80 total kanji at this level (showing 10) ───────────────────────
  static const List<Map<String, String>> _n5Raw = [
    {
      'id': 'n5_001',
      'kanji': '山',
      'meaning': 'Mountain',
      'onyomi': 'サン・セン',
      'kunyomi': 'やま',
      'exampleWord': '山田',
      'exampleReading': 'やまだ',
      'exampleMeaning': 'Yamada (surname)',
    },
    {
      'id': 'n5_002',
      'kanji': '川',
      'meaning': 'River',
      'onyomi': 'セン',
      'kunyomi': 'かわ',
      'exampleWord': '川口',
      'exampleReading': 'かわぐち',
      'exampleMeaning': 'River mouth',
    },
    {
      'id': 'n5_003',
      'kanji': '火',
      'meaning': 'Fire',
      'onyomi': 'カ',
      'kunyomi': 'ひ',
      'exampleWord': '火曜日',
      'exampleReading': 'かようび',
      'exampleMeaning': 'Tuesday',
    },
    {
      'id': 'n5_004',
      'kanji': '水',
      'meaning': 'Water',
      'onyomi': 'スイ',
      'kunyomi': 'みず',
      'exampleWord': '水曜日',
      'exampleReading': 'すいようび',
      'exampleMeaning': 'Wednesday',
    },
    {
      'id': 'n5_005',
      'kanji': '日',
      'meaning': 'Sun / Day',
      'onyomi': 'ニチ・ジツ',
      'kunyomi': 'ひ・か',
      'exampleWord': '日本',
      'exampleReading': 'にほん',
      'exampleMeaning': 'Japan',
    },
    {
      'id': 'n5_006',
      'kanji': '木',
      'meaning': 'Tree / Wood',
      'onyomi': 'モク・ボク',
      'kunyomi': 'き・こ',
      'exampleWord': '木曜日',
      'exampleReading': 'もくようび',
      'exampleMeaning': 'Thursday',
    },
    {
      'id': 'n5_007',
      'kanji': '人',
      'meaning': 'Person',
      'onyomi': 'ジン・ニン',
      'kunyomi': 'ひと',
      'exampleWord': '外人',
      'exampleReading': 'がいじん',
      'exampleMeaning': 'Foreigner',
    },
    {
      'id': 'n5_008',
      'kanji': '口',
      'meaning': 'Mouth / Opening',
      'onyomi': 'コウ・ク',
      'kunyomi': 'くち',
      'exampleWord': '入口',
      'exampleReading': 'いりぐち',
      'exampleMeaning': 'Entrance',
    },
    {
      'id': 'n5_009',
      'kanji': '月',
      'meaning': 'Moon / Month',
      'onyomi': 'ゲツ・ガツ',
      'kunyomi': 'つき',
      'exampleWord': '月曜日',
      'exampleReading': 'げつようび',
      'exampleMeaning': 'Monday',
    },
    {
      'id': 'n5_010',
      'kanji': '金',
      'meaning': 'Gold / Money',
      'onyomi': 'キン・コン',
      'kunyomi': 'かね・かな',
      'exampleWord': '金曜日',
      'exampleReading': 'きんようび',
      'exampleMeaning': 'Friday',
    },
  ];

  // ── N4 — 170 total kanji at this level (showing 10) ───────────────────────
  static const List<Map<String, String>> _n4Raw = [
    {
      'id': 'n4_001',
      'kanji': '海',
      'meaning': 'Sea / Ocean',
      'onyomi': 'カイ',
      'kunyomi': 'うみ',
      'exampleWord': '海外',
      'exampleReading': 'かいがい',
      'exampleMeaning': 'Overseas',
    },
    {
      'id': 'n4_002',
      'kanji': '風',
      'meaning': 'Wind / Style',
      'onyomi': 'フウ・フ',
      'kunyomi': 'かぜ・かざ',
      'exampleWord': '台風',
      'exampleReading': 'たいふう',
      'exampleMeaning': 'Typhoon',
    },
    {
      'id': 'n4_003',
      'kanji': '空',
      'meaning': 'Sky / Empty',
      'onyomi': 'クウ',
      'kunyomi': 'そら・あ(く)',
      'exampleWord': '空港',
      'exampleReading': 'くうこう',
      'exampleMeaning': 'Airport',
    },
    {
      'id': 'n4_004',
      'kanji': '町',
      'meaning': 'Town',
      'onyomi': 'チョウ',
      'kunyomi': 'まち',
      'exampleWord': '下町',
      'exampleReading': 'したまち',
      'exampleMeaning': 'Old downtown area',
    },
    {
      'id': 'n4_005',
      'kanji': '色',
      'meaning': 'Color',
      'onyomi': 'ショク・シキ',
      'kunyomi': 'いろ',
      'exampleWord': '景色',
      'exampleReading': 'けしき',
      'exampleMeaning': 'Scenery',
    },
    {
      'id': 'n4_006',
      'kanji': '牛',
      'meaning': 'Cow / Cattle',
      'onyomi': 'ギュウ',
      'kunyomi': 'うし',
      'exampleWord': '牛肉',
      'exampleReading': 'ぎゅうにく',
      'exampleMeaning': 'Beef',
    },
    {
      'id': 'n4_007',
      'kanji': '魚',
      'meaning': 'Fish',
      'onyomi': 'ギョ',
      'kunyomi': 'さかな・うお',
      'exampleWord': '金魚',
      'exampleReading': 'きんぎょ',
      'exampleMeaning': 'Goldfish',
    },
    {
      'id': 'n4_008',
      'kanji': '鳥',
      'meaning': 'Bird',
      'onyomi': 'チョウ',
      'kunyomi': 'とり',
      'exampleWord': '小鳥',
      'exampleReading': 'ことり',
      'exampleMeaning': 'Small bird',
    },
    {
      'id': 'n4_009',
      'kanji': '声',
      'meaning': 'Voice / Sound',
      'onyomi': 'セイ・ショウ',
      'kunyomi': 'こえ',
      'exampleWord': '大声',
      'exampleReading': 'おおごえ',
      'exampleMeaning': 'Loud voice',
    },
    {
      'id': 'n4_010',
      'kanji': '肉',
      'meaning': 'Meat / Flesh',
      'onyomi': 'ニク',
      'kunyomi': '—',
      'exampleWord': '鶏肉',
      'exampleReading': 'とりにく',
      'exampleMeaning': 'Chicken meat',
    },
  ];

  // ── N3 — 370 total kanji at this level (showing 10) ───────────────────────
  static const List<Map<String, String>> _n3Raw = [
    {
      'id': 'n3_001',
      'kanji': '悲',
      'meaning': 'Sad / Grief',
      'onyomi': 'ヒ',
      'kunyomi': 'かな(しい)',
      'exampleWord': '悲劇',
      'exampleReading': 'ひげき',
      'exampleMeaning': 'Tragedy',
    },
    {
      'id': 'n3_002',
      'kanji': '笑',
      'meaning': 'Laugh / Smile',
      'onyomi': 'ショウ',
      'kunyomi': 'わら(う)・え(む)',
      'exampleWord': '微笑',
      'exampleReading': 'びしょう',
      'exampleMeaning': 'Smile',
    },
    {
      'id': 'n3_003',
      'kanji': '夢',
      'meaning': 'Dream',
      'onyomi': 'ム',
      'kunyomi': 'ゆめ',
      'exampleWord': '夢中',
      'exampleReading': 'むちゅう',
      'exampleMeaning': 'Absorbed in something',
    },
    {
      'id': 'n3_004',
      'kanji': '星',
      'meaning': 'Star',
      'onyomi': 'セイ・ショウ',
      'kunyomi': 'ほし',
      'exampleWord': '星座',
      'exampleReading': 'せいざ',
      'exampleMeaning': 'Constellation',
    },
    {
      'id': 'n3_005',
      'kanji': '光',
      'meaning': 'Light / Shine',
      'onyomi': 'コウ',
      'kunyomi': 'ひかり・ひか(る)',
      'exampleWord': '観光',
      'exampleReading': 'かんこう',
      'exampleMeaning': 'Sightseeing',
    },
    {
      'id': 'n3_006',
      'kanji': '両',
      'meaning': 'Both / Two',
      'onyomi': 'リョウ',
      'kunyomi': 'りょう',
      'exampleWord': '両親',
      'exampleReading': 'りょうしん',
      'exampleMeaning': 'Both parents',
    },
    {
      'id': 'n3_007',
      'kanji': '打',
      'meaning': 'Hit / Strike',
      'onyomi': 'ダ',
      'kunyomi': 'う(つ)',
      'exampleWord': '打撃',
      'exampleReading': 'だげき',
      'exampleMeaning': 'Blow / Batting',
    },
    {
      'id': 'n3_008',
      'kanji': '感',
      'meaning': 'Feeling / Sense',
      'onyomi': 'カン',
      'kunyomi': '—',
      'exampleWord': '感動',
      'exampleReading': 'かんどう',
      'exampleMeaning': 'Being moved / Impressed',
    },
    {
      'id': 'n3_009',
      'kanji': '想',
      'meaning': 'Think / Imagine',
      'onyomi': 'ソウ・ソ',
      'kunyomi': '—',
      'exampleWord': '想像',
      'exampleReading': 'そうぞう',
      'exampleMeaning': 'Imagination',
    },
    {
      'id': 'n3_010',
      'kanji': '化',
      'meaning': 'Change / Transform',
      'onyomi': 'カ・ケ',
      'kunyomi': 'ば(ける)',
      'exampleWord': '文化',
      'exampleReading': 'ぶんか',
      'exampleMeaning': 'Culture',
    },
  ];

  // ── N2 — 370 total kanji at this level (showing 10) ───────────────────────
  static const List<Map<String, String>> _n2Raw = [
    {
      'id': 'n2_001',
      'kanji': '壁',
      'meaning': 'Wall',
      'onyomi': 'ヘキ',
      'kunyomi': 'かべ',
      'exampleWord': '壁画',
      'exampleReading': 'へきが',
      'exampleMeaning': 'Mural / Wall painting',
    },
    {
      'id': 'n2_002',
      'kanji': '縮',
      'meaning': 'Shrink / Reduce',
      'onyomi': 'シュク',
      'kunyomi': 'ちぢ(む)',
      'exampleWord': '短縮',
      'exampleReading': 'たんしゅく',
      'exampleMeaning': 'Shortening / Reduction',
    },
    {
      'id': 'n2_003',
      'kanji': '翌',
      'meaning': 'Following / Next',
      'onyomi': 'ヨク',
      'kunyomi': '—',
      'exampleWord': '翌日',
      'exampleReading': 'よくじつ',
      'exampleMeaning': 'The next day',
    },
    {
      'id': 'n2_004',
      'kanji': '遅',
      'meaning': 'Late / Slow',
      'onyomi': 'チ',
      'kunyomi': 'おそ(い)・おく(れる)',
      'exampleWord': '遅刻',
      'exampleReading': 'ちこく',
      'exampleMeaning': 'Being late',
    },
    {
      'id': 'n2_005',
      'kanji': '鋭',
      'meaning': 'Sharp / Keen',
      'onyomi': 'エイ',
      'kunyomi': 'するど(い)',
      'exampleWord': '鋭利',
      'exampleReading': 'えいり',
      'exampleMeaning': 'Sharp / Acute',
    },
    {
      'id': 'n2_006',
      'kanji': '距',
      'meaning': 'Distance',
      'onyomi': 'キョ',
      'kunyomi': '—',
      'exampleWord': '距離',
      'exampleReading': 'きょり',
      'exampleMeaning': 'Distance',
    },
    {
      'id': 'n2_007',
      'kanji': '眺',
      'meaning': 'View / Gaze',
      'onyomi': 'チョウ',
      'kunyomi': 'なが(める)',
      'exampleWord': '眺望',
      'exampleReading': 'ちょうぼう',
      'exampleMeaning': 'Scenic view',
    },
    {
      'id': 'n2_008',
      'kanji': '憧',
      'meaning': 'Yearn / Admire',
      'onyomi': 'ショウ・ドウ',
      'kunyomi': 'あこが(れる)',
      'exampleWord': '憧憬',
      'exampleReading': 'どうけい',
      'exampleMeaning': 'Longing / Aspiration',
    },
    {
      'id': 'n2_009',
      'kanji': '批',
      'meaning': 'Criticism',
      'onyomi': 'ヒ',
      'kunyomi': '—',
      'exampleWord': '批判',
      'exampleReading': 'ひはん',
      'exampleMeaning': 'Criticism / Critique',
    },
    {
      'id': 'n2_010',
      'kanji': '署',
      'meaning': 'Government office',
      'onyomi': 'ショ',
      'kunyomi': '—',
      'exampleWord': '警察署',
      'exampleReading': 'けいさつしょ',
      'exampleMeaning': 'Police station',
    },
  ];

  // ── N1 — 1000+ total kanji at this level (showing 10) ─────────────────────
  static const List<Map<String, String>> _n1Raw = [
    {
      'id': 'n1_001',
      'kanji': '謹',
      'meaning': 'Respect / Sincerity',
      'onyomi': 'キン',
      'kunyomi': 'つつし(む)',
      'exampleWord': '謹慎',
      'exampleReading': 'きんしん',
      'exampleMeaning': 'Confinement / Restraint',
    },
    {
      'id': 'n1_002',
      'kanji': '儚',
      'meaning': 'Fleeting / Ephemeral',
      'onyomi': 'ボウ・モウ',
      'kunyomi': 'はかな(い)',
      'exampleWord': '儚い夢',
      'exampleReading': 'はかないゆめ',
      'exampleMeaning': 'Fleeting dream',
    },
    {
      'id': 'n1_003',
      'kanji': '顕',
      'meaning': 'Appear / Manifest',
      'onyomi': 'ケン',
      'kunyomi': 'あらわ(れる)',
      'exampleWord': '顕著',
      'exampleReading': 'けんちょ',
      'exampleMeaning': 'Remarkable / Conspicuous',
    },
    {
      'id': 'n1_004',
      'kanji': '緻',
      'meaning': 'Fine / Minute',
      'onyomi': 'チ',
      'kunyomi': '—',
      'exampleWord': '緻密',
      'exampleReading': 'ちみつ',
      'exampleMeaning': 'Precise / Meticulous',
    },
    {
      'id': 'n1_005',
      'kanji': '憂',
      'meaning': 'Grief / Melancholy',
      'onyomi': 'ユウ',
      'kunyomi': 'うれ(い)・う(い)',
      'exampleWord': '憂鬱',
      'exampleReading': 'ゆううつ',
      'exampleMeaning': 'Depression / Gloom',
    },
    {
      'id': 'n1_006',
      'kanji': '凛',
      'meaning': 'Dignity / Biting cold',
      'onyomi': 'リン',
      'kunyomi': 'りり(しい)',
      'exampleWord': '凛々しい',
      'exampleReading': 'りりしい',
      'exampleMeaning': 'Gallant / Imposing',
    },
    {
      'id': 'n1_007',
      'kanji': '璧',
      'meaning': 'Jewel / Perfection',
      'onyomi': 'ヘキ',
      'kunyomi': '—',
      'exampleWord': '完璧',
      'exampleReading': 'かんぺき',
      'exampleMeaning': 'Perfect / Flawless',
    },
    {
      'id': 'n1_008',
      'kanji': '覇',
      'meaning': 'Supremacy / Domination',
      'onyomi': 'ハ',
      'kunyomi': '—',
      'exampleWord': '覇権',
      'exampleReading': 'はけん',
      'exampleMeaning': 'Hegemony / Supremacy',
    },
    {
      'id': 'n1_009',
      'kanji': '髄',
      'meaning': 'Marrow / Essence',
      'onyomi': 'ズイ',
      'kunyomi': '—',
      'exampleWord': '骨髄',
      'exampleReading': 'こつずい',
      'exampleMeaning': 'Bone marrow',
    },
    {
      'id': 'n1_010',
      'kanji': '鑑',
      'meaning': 'Mirror / Reflect / Judge',
      'onyomi': 'カン',
      'kunyomi': 'かがみ・かんが(みる)',
      'exampleWord': '鑑定',
      'exampleReading': 'かんてい',
      'exampleMeaning': 'Appraisal / Expert judgement',
    },
  ];

  // ── Internal State ────────────────────────────────────────────────────────

  late final Map<String, List<KanjiCard>> _cardsByLevel = {
    'N5': _parseLevel(_n5Raw, 'N5'),
    'N4': _parseLevel(_n4Raw, 'N4'),
    'N3': _parseLevel(_n3Raw, 'N3'),
    'N2': _parseLevel(_n2Raw, 'N2'),
    'N1': _parseLevel(_n1Raw, 'N1'),
  };

  static List<KanjiCard> _parseLevel(
    List<Map<String, String>> raw,
    String level,
  ) {
    return raw
        .map(
          (m) => KanjiCard(
            id: m['id']!,
            kanji: m['kanji']!,
            meaning: m['meaning']!,
            onyomi: m['onyomi']!,
            kunyomi: m['kunyomi']!,
            jlptLevel: level,
            exampleWord: m['exampleWord']!,
            exampleReading: m['exampleReading']!,
            exampleMeaning: m['exampleMeaning']!,
          ),
        )
        .toList();
  }

  // ── Public API ────────────────────────────────────────────────────────────

  List<String> get availableLevels => _cardsByLevel.keys.toList();

  List<KanjiCard> getCardsForLevel(String level) {
    return List<KanjiCard>.from(_cardsByLevel[level] ?? []);
  }

  Map<CardStatus, int> getProgressForLevel(String level) {
    final cards = _cardsByLevel[level] ?? [];
    final counts = <CardStatus, int>{};
    for (final status in CardStatus.values) {
      counts[status] = cards.where((c) => c.status == status).length;
    }
    return counts;
  }

  void updateCardStatus(String cardId, CardStatus newStatus) {
    for (final level in _cardsByLevel.values) {
      for (final card in level) {
        if (card.id == cardId) {
          card.status = newStatus;
          return;
        }
      }
    }
  }

  void resetLevel(String level) {
    final cards = _cardsByLevel[level] ?? [];
    for (final card in cards) {
      card.status = CardStatus.unseen;
    }
  }
}
