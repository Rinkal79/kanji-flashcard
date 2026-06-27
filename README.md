# 漢字 Kanji Flashcard App

A self-contained Flutter app for JLPT Kanji study with flip animations, swipe tracking, and progress persistence — no backend or external assets required.

---

## Quick Start

```bash
cd kanji_flashcard
flutter pub get
flutter run

flutter create.
```

Tested on Flutter 3.19+ / Dart 3.x.

---

## Project Structure

```
lib/
├── main.dart                  # App entry point, MaterialApp + theme wiring
├── theme/
│   └── app_theme.dart         # Color tokens, typography scale (Noto Serif/Sans)
├── models/
│   └── kanji_card.dart        # KanjiCard data class + CardStatus enum
├── services/
│   └── kanji_service.dart     # Singleton: mock data, status updates, progress
├── screens/
│   ├── home_screen.dart       # JLPT level list with progress bars
│   └── flashcard_screen.dart  # Swipe + flip review session + completion screen
└── widgets/
    └── flip_card.dart         # Reusable 3D flip card widget (front/back faces)
```

---

## Architecture Decisions

### Separation of Concerns
| Layer | File | Responsibility |
|---|---|---|
| Model | `kanji_card.dart` | Pure data, zero Flutter imports |
| Service | `kanji_service.dart` | State, CRUD, mock data |
| View | `*_screen.dart` | UI only, calls service |
| Widget | `flip_card.dart` | Animation, no business logic |

### Data Flow
```
KanjiService (singleton)
    └── getCardsForLevel(level) → List<KanjiCard>
    └── updateCardStatus(id, status) → mutates in-memory state
    └── getProgressForLevel(level) → Map<CardStatus, int>
    └── resetLevel(level) → resets all cards to .unseen
```

### FlipCardWidget
- Uses a single `AnimationController` rotating `0 → π` on the Y axis
- Matrix4 perspective (`setEntry(3, 2, 0.001)`) for realistic 3D depth
- `GlobalKey<FlipCardWidgetState>` lets the parent trigger flips programmatically (the "Flip" action button)
- Resets to front automatically via `didUpdateWidget` when card changes

### Swipe Detection
- Raw `onHorizontalDragUpdate` accumulates `_dragX`
- Live visual feedback: card tilts, color overlay fades in, label appears
- On release: if `|dragX| > 100px` → animate card off screen → advance index
- Buttons at bottom provide the same action for accessibility

---

## Adding More Kanji

Open `lib/services/kanji_service.dart` and append entries to the relevant list:

```dart
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
```

No other changes needed — the service, UI, and progress tracking pick it up automatically.

---

## Adding Persistence (next step)

Replace the in-memory map in `KanjiService` with `shared_preferences` or `hive`:

```dart
// Save on every status update
await prefs.setString('status_${cardId}', newStatus.name);

// Load on init
for (final card in level) {
  final saved = prefs.getString('status_${card.id}');
  if (saved != null) card.status = CardStatus.values.byName(saved);
}
```

---

## Design System

| Token | Value | Usage |
|---|---|---|
| `inkBlack` | `#1A1A2E` | Scaffold background |
| `deepIndigo` | `#16213E` | Card surfaces |
| `accentIndigo` | `#533483` | Primary accent, N5 |
| `vermillion` | `#E94560` | Secondary, review, N3 |
| `paperWarm` | `#F5F0E8` | Flashcard face |
| `masteredGreen` | `#10B981` | Mastered state |
| `reviewAmber` | `#F59E0B` | Review-later state |

Typography: **Noto Serif** for display (card kanji on back, headings) and **Noto Sans** for body — both support CJK characters natively.
