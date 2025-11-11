# Com-Raider 🦒🌍

A beautiful Flutter app for families to discover and share fun places across Kenya's 47 counties.

## Features

✨ **Explore Places** - Browse family-friendly destinations with search and county filters
📍 **Add New Places** - Share your favorite spots with detailed descriptions
🔖 **Bookmark System** - Save your favorite places for quick access
🎨 **Modern UI** - Clean, spacious design with family-friendly green theme
📱 **Cross-Platform** - Works on Web, Android, and iOS

## Getting Started

### Run on Web
```bash
flutter run -d chrome
```

### Run on Mobile
```bash
flutter run
```

### Run on All Platforms
```bash
flutter run -d all
```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── theme.dart                   # Green family-friendly theme
├── constants/
│   └── counties.dart           # 47 Kenya counties
├── models/
│   ├── place.dart              # Place data model
│   └── user.dart               # User data model
├── services/
│   └── place_service.dart      # Place CRUD & local storage
├── screens/
│   ├── home_screen.dart        # Explore screen with search/filter
│   ├── add_place_screen.dart   # Add new place form
│   ├── bookmarks_screen.dart   # Saved places
│   └── place_detail_screen.dart # Detailed place view
└── widgets/
    └── place_card.dart         # Reusable place card
```

## Data Storage

- Uses **shared_preferences** for local persistence
- Works on both web and mobile
- Includes 15 sample places on first launch
- Data persists across app restarts

## Technologies

- Flutter 3.6+
- Material 3
- Google Fonts (Inter)
- Shared Preferences

## Sample Data

The app comes with 15 pre-loaded family-friendly places including:
- Giraffe Centre (Nairobi)
- Haller Park (Mombasa)
- Lake Nakuru National Park (Nakuru)
- Fort Jesus Museum (Mombasa)
- Karura Forest (Nairobi)
- And many more!

## Design Highlights

🎨 **Color Palette**
- Primary: Fresh Green (#2E7D32)
- Secondary: Light Green (#66BB6A)
- Accent: Warm Orange (#FF9800)

📐 **Layout Principles**
- Card-based design with 16px rounded corners
- Generous padding and spacing
- Responsive grid layout (1-3 columns based on screen size)
- Clean, minimal shadows

## Contributing

Feel free to add more places, improve the UI, or extend functionality!

---

Built with ❤️ for Kenyan families
