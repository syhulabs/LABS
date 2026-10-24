/// Plain models for the JSON catalog (assets/catalog/platforms.json) and
/// user-supplied catalog update files with the same shape.
class CatalogCategory {
  const CatalogCategory({required this.id, required this.label});
  final String id;
  final String label;

  factory CatalogCategory.fromJson(Map<String, dynamic> j) =>
      CatalogCategory(id: j['id'] as String, label: j['label'] as String);
}

class CatalogPlatform {
  const CatalogPlatform({
    required this.id,
    required this.name,
    required this.categories,
    this.website,
    this.type = 'service',
    this.vendor,
    this.icon,
    this.description = '',
    this.logoAsset,
  });

  final String id;
  final String name;
  final List<String> categories;
  final String? website;
  final String type;
  final String? vendor;
  final String? icon;
  final String description;
  final String? logoAsset;

  factory CatalogPlatform.fromJson(Map<String, dynamic> j) => CatalogPlatform(
        id: j['id'] as String,
        name: j['name'] as String,
        categories: (j['categories'] as List? ?? const [])
            .map((e) => e.toString())
            .toList(),
        website: j['website'] as String?,
        type: (j['type'] as String?) ?? 'service',
        vendor: j['vendor'] as String?,
        icon: j['icon'] as String?,
        description: (j['description'] as String?) ?? '',
        logoAsset: j['logoAsset'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'categories': categories,
        'website': website,
        'type': type,
        'vendor': vendor,
        'icon': icon,
        'description': description,
        if (logoAsset != null) 'logoAsset': logoAsset,
      };
}

class CatalogDocument {
  const CatalogDocument({
    required this.version,
    required this.categories,
    required this.platforms,
  });

  final int version;
  final List<CatalogCategory> categories;
  final List<CatalogPlatform> platforms;

  factory CatalogDocument.fromJson(Map<String, dynamic> j) {
    final platforms = (j['platforms'] as List? ?? const [])
        .cast<Map<String, dynamic>>()
        .map(CatalogPlatform.fromJson)
        .toList();
    final ids = <String>{};
    for (final p in platforms) {
      if (!ids.add(p.id)) {
        throw FormatException('Duplicate platform id in catalog: ${p.id}');
      }
      if (p.name.trim().isEmpty) {
        throw FormatException('Platform ${p.id} has an empty name');
      }
    }
    return CatalogDocument(
      version: (j['version'] as num?)?.toInt() ?? 1,
      categories: (j['categories'] as List? ?? const [])
          .cast<Map<String, dynamic>>()
          .map(CatalogCategory.fromJson)
          .toList(),
      platforms: platforms,
    );
  }
}
