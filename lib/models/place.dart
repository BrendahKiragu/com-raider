class Place {
  final String id;
  final String name;
  final String description;
  final String county;
  final bool isBookmarked;
  final DateTime createdAt;
  final DateTime updatedAt;
  // A few Unsplash-backed image URLs to display on detail page
  final List<String> imageUrls;
  // Used to rank places for the Top 5 on Home
  final int popularity;

  Place({
    required this.id,
    required this.name,
    required this.description,
    required this.county,
    this.isBookmarked = false,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrls = const [],
    this.popularity = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'county': county,
    'isBookmarked': isBookmarked,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'imageUrls': imageUrls,
    'popularity': popularity,
  };

  factory Place.fromJson(Map<String, dynamic> json) => Place(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    county: json['county'] as String,
    isBookmarked: json['isBookmarked'] as bool? ?? false,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    imageUrls: (json['imageUrls'] as List?)?.map((e) => e.toString()).toList() ?? const [],
    popularity: (json['popularity'] as num?)?.toInt() ?? 0,
  );

  Place copyWith({
    String? id,
    String? name,
    String? description,
    String? county,
    bool? isBookmarked,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? imageUrls,
    int? popularity,
  }) => Place(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    county: county ?? this.county,
    isBookmarked: isBookmarked ?? this.isBookmarked,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    imageUrls: imageUrls ?? this.imageUrls,
    popularity: popularity ?? this.popularity,
  );
}
