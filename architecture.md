# Com-Raider Architecture

## Overview
Com-Raider is a Flutter app for families to discover and share fun places across Kenya's 47 counties. The app supports both web and mobile platforms with local storage persistence.

## Tech Stack
- Flutter SDK 3.6+
- Material 3 (custom modern design)
- Local Storage: shared_preferences for web/mobile persistence

## Project Structure
```
lib/
├── main.dart                 # App entry point
├── theme.dart               # Custom theme with green family-friendly colors
├── constants/
│   └── counties.dart        # List of 47 Kenya counties
├── models/
│   ├── place.dart          # Place data model
│   └── user.dart           # User data model (for future features)
├── services/
│   └── place_service.dart  # Place CRUD operations & local storage
├── screens/
│   ├── home_screen.dart    # Main explore/list screen with search & filters
│   ├── add_place_screen.dart # Form to add new places
│   ├── bookmarks_screen.dart # List of bookmarked places
│   └── place_detail_screen.dart # Detailed view of a place
└── widgets/
    ├── place_card.dart     # Reusable place card component
    ├── county_filter_chip.dart # County selection chips
    └── search_bar_widget.dart  # Custom search bar
```

## Data Models

### Place Model
- id (String)
- name (String)
- description (String)
- county (String)
- isBookmarked (bool)
- createdAt (DateTime)
- updatedAt (DateTime)

### User Model (for future features)
- id (String)
- name (String)
- email (String)
- createdAt (DateTime)
- updatedAt (DateTime)

## Key Features

### 1. Home/Explore Screen
- Grid/List view of places
- Search bar (by name/description)
- County filter dropdown/chips
- Quick bookmark toggle on cards
- Responsive layout for web

### 2. Add Place Screen
- Form with name input
- Multi-line description
- County dropdown (47 counties)
- Submit button
- Form validation

### 3. Bookmarks Screen
- Filtered view of bookmarked places
- Same card layout as home
- Empty state when no bookmarks

### 4. Place Detail Screen
- Full place information
- Larger description area
- Bookmark toggle button
- Back navigation

## State Management
- StatefulWidget for local state management
- No external state management library needed
- Service layer handles data operations

## Design System

### Color Palette (Family-Friendly)
- Primary: Fresh green (#2E7D32 - green.shade800)
- Secondary: Light green (#66BB6A - green.shade400)
- Accent: Warm orange (#FF9800)
- Background: Off-white (#F5F5F5)
- Card: White (#FFFFFF)
- Text: Dark grey (#212121)

### Typography
- Google Fonts: Inter (clean, modern, readable)
- Generous spacing
- Clear hierarchy

### Layout Principles
- Card-based design
- Rounded corners (16dp)
- Generous padding (16-24dp)
- Minimal shadows
- Clean, spacious layout

## Local Storage Strategy
- Use shared_preferences package
- Store places as JSON array
- Load on app start
- Save on every add/update/bookmark change
- Include sample data on first launch

## Sample Data
- 10-15 sample places covering different counties
- Realistic Kenyan locations (e.g., Nairobi, Mombasa, Nakuru)
- Family-friendly descriptions

## Implementation Steps
1. ✅ Set up theme with green color palette
2. ✅ Create constants file with 47 counties
3. ✅ Build Place and User data models
4. ✅ Implement PlaceService with local storage
5. ✅ Create reusable widgets (PlaceCard, SearchBar)
6. ✅ Build Home/Explore screen with search & filter
7. ✅ Build Add Place screen with form
8. ✅ Build Bookmarks screen
9. ✅ Build Place Detail screen
10. ✅ Add navigation between screens
11. ✅ Test and debug
12. ✅ Verify web compatibility

## Running the App
```bash
# For web
flutter run -d chrome

# For mobile
flutter run

# For all platforms
flutter run -d all
```
