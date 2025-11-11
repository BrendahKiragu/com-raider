import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:comraider/models/place.dart';
import 'package:comraider/constants/counties.dart';

class PlaceService {
  static const String _storageKey = 'places';
  List<Place> _places = [];

  List<Place> get places => _places;

  Future<void> initialize() async {
    await _loadPlaces();
    if (_places.isEmpty) {
      await _loadSampleData();
    } else {
      // Try to ensure at least 3 places per county without overwriting user data
      await _ensureMinimumSampleData();
    }
  }

  Future<void> _loadPlaces() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? placesJson = prefs.getString(_storageKey);
      
      if (placesJson != null && placesJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(placesJson);
        _places = decoded.map((json) {
          try {
            return Place.fromJson(json as Map<String, dynamic>);
          } catch (e) {
            return null;
          }
        }).whereType<Place>().toList();
        
        await _savePlaces();
      }
    } catch (e) {
      _places = [];
    }
  }

  Future<void> _savePlaces() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String placesJson = jsonEncode(_places.map((p) => p.toJson()).toList());
      await prefs.setString(_storageKey, placesJson);
    } catch (e) {
      // Handle error silently
    }
  }

  String _unsplashUrl(String query, {int width = 800, int height = 600}) {
    final encoded = Uri.encodeComponent(query);
    return 'https://source.unsplash.com/${width}x${height}/?${encoded}';
  }

  List<String> _unsplashSetFor(String name, String county) {
    return [
      _unsplashUrl('$name, $county, Kenya'),
      _unsplashUrl('$county, family, picnic'),
      _unsplashUrl('Kenya, nature, $county'),
    ];
  }

  Place _makePlace({
    required String id,
    required String name,
    required String county,
    required String description,
    int popularity = 0,
    DateTime? now,
  }) {
    final ts = now ?? DateTime.now();
    return Place(
      id: id,
      name: name,
      description: description,
      county: county,
      createdAt: ts,
      updatedAt: ts,
      imageUrls: _unsplashSetFor(name, county),
      popularity: popularity,
    );
  }

  Future<void> _loadSampleData() async {
    final now = DateTime.now();

    // Curated famous places with higher popularity
    final curated = <Place>[
      _makePlace(
        id: 'curated-1',
        name: 'Giraffe Centre',
        county: 'Nairobi',
        description: 'Feed and interact with endangered Rothschild giraffes in a serene setting. Perfect for kids!',
        popularity: 100,
        now: now,
      ),
      _makePlace(
        id: 'curated-2',
        name: 'Diani Beach',
        county: 'Kwale',
        description: 'Pristine white sands and coral reefs. Water sports and family-friendly resorts.',
        popularity: 98,
        now: now,
      ),
      _makePlace(
        id: 'curated-3',
        name: 'Fort Jesus Museum',
        county: 'Mombasa',
        description: 'Historic Portuguese fort with interactive exhibits and coastal views.',
        popularity: 96,
        now: now,
      ),
      _makePlace(
        id: 'curated-4',
        name: 'Lake Nakuru National Park',
        county: 'Nakuru',
        description: 'Home to flamingos and rhinos. Great wildlife viewing for all ages.',
        popularity: 94,
        now: now,
      ),
      _makePlace(
        id: 'curated-5',
        name: "Hell's Gate National Park",
        county: 'Nakuru',
        description: 'Walk or cycle among wildlife, explore gorges and hot springs.',
        popularity: 92,
        now: now,
      ),
    ];

    // Generate at least 3 generic places per county
    final generated = <Place>[];
    int counter = 0;
    for (final county in kenyanCounties) {
      for (int i = 1; i <= 3; i++) {
        counter++;
        final name = i == 1
            ? '$county Family Park'
            : i == 2
                ? '$county Nature Trail'
                : '$county Picnic Gardens';
        final desc = i == 1
            ? 'Open green spaces, playgrounds, and picnic lawns ideal for families.'
            : i == 2
                ? 'Gentle walking paths, birdlife, and shaded rest points for kids.'
                : 'Manicured lawns with benches and kiosks—great for relaxed afternoons.';
        generated.add(_makePlace(
          id: 'gen-$county-$i',
          name: name,
          county: county,
          description: desc,
          popularity: 10 + (i * 2),
          now: now,
        ));
      }
    }

    // Merge curated and generated while avoiding duplicates by id
    _places = [...curated, ...generated];
    await _savePlaces();
  }

  Future<void> _ensureMinimumSampleData() async {
    final existingIds = _places.map((p) => p.id).toSet();
    final toAdd = <Place>[];
    final now = DateTime.now();

    // Ensure curated top famous exist
    List<Place> curatedNeeded = [
      _makePlace(
        id: 'curated-1',
        name: 'Giraffe Centre',
        county: 'Nairobi',
        description: 'Feed and interact with endangered Rothschild giraffes in a serene setting. Perfect for kids!',
        popularity: 100,
        now: now,
      ),
      _makePlace(
        id: 'curated-2',
        name: 'Diani Beach',
        county: 'Kwale',
        description: 'Pristine white sands and coral reefs. Water sports and family-friendly resorts.',
        popularity: 98,
        now: now,
      ),
      _makePlace(
        id: 'curated-3',
        name: 'Fort Jesus Museum',
        county: 'Mombasa',
        description: 'Historic Portuguese fort with interactive exhibits and coastal views.',
        popularity: 96,
        now: now,
      ),
      _makePlace(
        id: 'curated-4',
        name: 'Lake Nakuru National Park',
        county: 'Nakuru',
        description: 'Home to flamingos and rhinos. Great wildlife viewing for all ages.',
        popularity: 94,
        now: now,
      ),
      _makePlace(
        id: 'curated-5',
        name: "Hell's Gate National Park",
        county: 'Nakuru',
        description: 'Walk or cycle among wildlife, explore gorges and hot springs.',
        popularity: 92,
        now: now,
      ),
    ];
    for (final p in curatedNeeded) {
      if (!existingIds.contains(p.id)) toAdd.add(p);
    }

    // Ensure 3 per county
    for (final county in kenyanCounties) {
      for (int i = 1; i <= 3; i++) {
        final id = 'gen-$county-$i';
        if (!existingIds.contains(id)) {
          final name = i == 1
              ? '$county Family Park'
              : i == 2
                  ? '$county Nature Trail'
                  : '$county Picnic Gardens';
          final desc = i == 1
              ? 'Open green spaces, playgrounds, and picnic lawns ideal for families.'
              : i == 2
                  ? 'Gentle walking paths, birdlife, and shaded rest points for kids.'
                  : 'Manicured lawns with benches and kiosks—great for relaxed afternoons.';
          toAdd.add(_makePlace(
            id: id,
            name: name,
            county: county,
            description: desc,
            popularity: 10 + (i * 2),
            now: now,
          ));
        }
      }
    }

    if (toAdd.isNotEmpty) {
      _places.addAll(toAdd);
      await _savePlaces();
    }
  }

  Future<void> addPlace(Place place) async {
    _places.add(place);
    await _savePlaces();
  }

  Future<void> updatePlace(Place place) async {
    final index = _places.indexWhere((p) => p.id == place.id);
    if (index != -1) {
      _places[index] = place;
      await _savePlaces();
    }
  }

  Future<void> deletePlace(String id) async {
    _places.removeWhere((p) => p.id == id);
    await _savePlaces();
  }

  Future<void> toggleBookmark(String id) async {
    final index = _places.indexWhere((p) => p.id == id);
    if (index != -1) {
      _places[index] = _places[index].copyWith(
        isBookmarked: !_places[index].isBookmarked,
        updatedAt: DateTime.now(),
      );
      await _savePlaces();
    }
  }

  List<Place> getBookmarkedPlaces() => _places.where((p) => p.isBookmarked).toList();

  List<Place> searchPlaces(String query) {
    if (query.isEmpty) return _places;
    final lowerQuery = query.toLowerCase();
    return _places.where((p) =>
      p.name.toLowerCase().contains(lowerQuery) ||
      p.description.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  List<Place> filterByCounty(String county) {
    if (county.isEmpty || county == 'All Counties') return _places;
    return _places.where((p) => p.county == county).toList();
  }

  List<Place> searchAndFilter(String query, String county) {
    List<Place> results = _places;
    
    if (county.isNotEmpty && county != 'All Counties') {
      results = results.where((p) => p.county == county).toList();
    }
    
    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      results = results.where((p) =>
        p.name.toLowerCase().contains(lowerQuery) ||
        p.description.toLowerCase().contains(lowerQuery)
      ).toList();
    }
    
    return results;
  }

  List<Place> topFamous({int limit = 5}) {
    final sorted = [..._places]
      ..sort((a, b) => b.popularity.compareTo(a.popularity));
    return sorted.take(limit).toList();
  }
}
