import 'package:flutter/material.dart';
import 'package:comraider/models/place.dart';
import 'package:comraider/services/place_service.dart';
import 'package:comraider/widgets/place_card.dart';
import 'package:comraider/screens/place_detail_screen.dart';
import 'package:comraider/screens/add_place_screen.dart';
import 'package:comraider/screens/bookmarks_screen.dart';
import 'package:comraider/constants/counties.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PlaceService _placeService = PlaceService();
  final TextEditingController _searchController = TextEditingController();
  String _selectedCounty = 'All Counties';
  bool _isLoading = true;
  List<Place> _filteredPlaces = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _placeService.initialize();
    setState(() {
      _filteredPlaces = _placeService.topFamous(limit: 5);
      _isLoading = false;
    });
  }

  void _filterPlaces() {
    setState(() {
      final isDefault = _searchController.text.isEmpty && (_selectedCounty == 'All Counties');
      _filteredPlaces = isDefault
          ? _placeService.topFamous(limit: 5)
          : _placeService.searchAndFilter(
              _searchController.text,
              _selectedCounty,
            );
    });
  }

  void _toggleBookmark(String id) async {
    await _placeService.toggleBookmark(id);
    setState(() {
      _filterPlaces();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Com-Raider',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark, color: theme.colorScheme.primary),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookmarksScreen()),
              );
              setState(() => _filterPlaces());
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
        ? Center(child: CircularProgressIndicator(color: theme.colorScheme.primary))
        : Column(
            children: [
              // Hero banner
              Container(
                height: 220,
                margin: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/family_picnic_outdoors_Kenya_green_1762880674837.jpg',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.15),
                            Colors.black.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Com-Raider',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Family adventures across Kenya 🇰🇪',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Icon(Icons.photo_camera, color: Colors.white.withValues(alpha: 0.9)),
                              const SizedBox(width: 8),
                              Text(
                                'Tap a place to view photos',
                                style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => _filterPlaces(),
                        decoration: InputDecoration(
                          hintText: 'Search places...',
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: theme.colorScheme.primary,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  _filterPlaces();
                                },
                              )
                            : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCounty,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down, color: theme.colorScheme.primary),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                          dropdownColor: theme.colorScheme.surface,
                          items: ['All Counties', ...kenyanCounties]
                            .map((county) => DropdownMenuItem(
                              value: county,
                              child: Text(county),
                            ))
                            .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedCounty = value;
                                _filterPlaces();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _searchController.text.isEmpty && _selectedCounty == 'All Counties'
                          ? 'Top 5 Famous Places'
                          : 'Results',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _filteredPlaces.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No places found',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your search or filter',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isWideScreen ? 3 : (screenWidth > 400 ? 2 : 1),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: _filteredPlaces.length,
                      itemBuilder: (context, index) {
                        final place = _filteredPlaces[index];
                        return PlaceCard(
                          place: place,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlaceDetailScreen(place: place),
                              ),
                            );
                            setState(() => _filterPlaces());
                          },
                          onBookmarkToggle: () => _toggleBookmark(place.id),
                        );
                      },
                    ),
              ),
            ],
          ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPlaceScreen()),
          );
          await _initializeData();
        },
        backgroundColor: theme.colorScheme.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Place',
          style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
