// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PlatformsTable extends Platforms
    with TableInfo<$PlatformsTable, Platform> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlatformsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriesMeta = const VerificationMeta(
    'categories',
  );
  @override
  late final GeneratedColumn<String> categories = GeneratedColumn<String>(
    'categories',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _websiteMeta = const VerificationMeta(
    'website',
  );
  @override
  late final GeneratedColumn<String> website = GeneratedColumn<String>(
    'website',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _platformTypeMeta = const VerificationMeta(
    'platformType',
  );
  @override
  late final GeneratedColumn<String> platformType = GeneratedColumn<String>(
    'platform_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('service'),
  );
  static const VerificationMeta _vendorMeta = const VerificationMeta('vendor');
  @override
  late final GeneratedColumn<String> vendor = GeneratedColumn<String>(
    'vendor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconSlugMeta = const VerificationMeta(
    'iconSlug',
  );
  @override
  late final GeneratedColumn<String> iconSlug = GeneratedColumn<String>(
    'icon_slug',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _logoAssetMeta = const VerificationMeta(
    'logoAsset',
  );
  @override
  late final GeneratedColumn<String> logoAsset = GeneratedColumn<String>(
    'logo_asset',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _inMyWorldMeta = const VerificationMeta(
    'inMyWorld',
  );
  @override
  late final GeneratedColumn<bool> inMyWorld = GeneratedColumn<bool>(
    'in_my_world',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("in_my_world" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _addedToMyWorldAtMeta = const VerificationMeta(
    'addedToMyWorldAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedToMyWorldAt =
      GeneratedColumn<DateTime>(
        'added_to_my_world_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _catalogVersionMeta = const VerificationMeta(
    'catalogVersion',
  );
  @override
  late final GeneratedColumn<int> catalogVersion = GeneratedColumn<int>(
    'catalog_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    categories,
    website,
    description,
    platformType,
    vendor,
    iconSlug,
    logoAsset,
    isCustom,
    isFavorite,
    inMyWorld,
    sortOrder,
    addedToMyWorldAt,
    catalogVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'platforms';
  @override
  VerificationContext validateIntegrity(
    Insertable<Platform> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('categories')) {
      context.handle(
        _categoriesMeta,
        categories.isAcceptableOrUnknown(data['categories']!, _categoriesMeta),
      );
    } else if (isInserting) {
      context.missing(_categoriesMeta);
    }
    if (data.containsKey('website')) {
      context.handle(
        _websiteMeta,
        website.isAcceptableOrUnknown(data['website']!, _websiteMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('platform_type')) {
      context.handle(
        _platformTypeMeta,
        platformType.isAcceptableOrUnknown(
          data['platform_type']!,
          _platformTypeMeta,
        ),
      );
    }
    if (data.containsKey('vendor')) {
      context.handle(
        _vendorMeta,
        vendor.isAcceptableOrUnknown(data['vendor']!, _vendorMeta),
      );
    }
    if (data.containsKey('icon_slug')) {
      context.handle(
        _iconSlugMeta,
        iconSlug.isAcceptableOrUnknown(data['icon_slug']!, _iconSlugMeta),
      );
    }
    if (data.containsKey('logo_asset')) {
      context.handle(
        _logoAssetMeta,
        logoAsset.isAcceptableOrUnknown(data['logo_asset']!, _logoAssetMeta),
      );
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('in_my_world')) {
      context.handle(
        _inMyWorldMeta,
        inMyWorld.isAcceptableOrUnknown(data['in_my_world']!, _inMyWorldMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('added_to_my_world_at')) {
      context.handle(
        _addedToMyWorldAtMeta,
        addedToMyWorldAt.isAcceptableOrUnknown(
          data['added_to_my_world_at']!,
          _addedToMyWorldAtMeta,
        ),
      );
    }
    if (data.containsKey('catalog_version')) {
      context.handle(
        _catalogVersionMeta,
        catalogVersion.isAcceptableOrUnknown(
          data['catalog_version']!,
          _catalogVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Platform map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Platform(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      categories: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categories'],
      )!,
      website: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}website'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      platformType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform_type'],
      )!,
      vendor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vendor'],
      ),
      iconSlug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_slug'],
      ),
      logoAsset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_asset'],
      ),
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      inMyWorld: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}in_my_world'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      addedToMyWorldAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_to_my_world_at'],
      ),
      catalogVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}catalog_version'],
      )!,
    );
  }

  @override
  $PlatformsTable createAlias(String alias) {
    return $PlatformsTable(attachedDatabase, alias);
  }
}

class Platform extends DataClass implements Insertable<Platform> {
  final String id;
  final String name;
  final String categories;
  final String? website;
  final String description;
  final String platformType;
  final String? vendor;
  final String? iconSlug;
  final String? logoAsset;
  final bool isCustom;
  final bool isFavorite;
  final bool inMyWorld;
  final int sortOrder;
  final DateTime? addedToMyWorldAt;
  final int catalogVersion;
  const Platform({
    required this.id,
    required this.name,
    required this.categories,
    this.website,
    required this.description,
    required this.platformType,
    this.vendor,
    this.iconSlug,
    this.logoAsset,
    required this.isCustom,
    required this.isFavorite,
    required this.inMyWorld,
    required this.sortOrder,
    this.addedToMyWorldAt,
    required this.catalogVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['categories'] = Variable<String>(categories);
    if (!nullToAbsent || website != null) {
      map['website'] = Variable<String>(website);
    }
    map['description'] = Variable<String>(description);
    map['platform_type'] = Variable<String>(platformType);
    if (!nullToAbsent || vendor != null) {
      map['vendor'] = Variable<String>(vendor);
    }
    if (!nullToAbsent || iconSlug != null) {
      map['icon_slug'] = Variable<String>(iconSlug);
    }
    if (!nullToAbsent || logoAsset != null) {
      map['logo_asset'] = Variable<String>(logoAsset);
    }
    map['is_custom'] = Variable<bool>(isCustom);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['in_my_world'] = Variable<bool>(inMyWorld);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || addedToMyWorldAt != null) {
      map['added_to_my_world_at'] = Variable<DateTime>(addedToMyWorldAt);
    }
    map['catalog_version'] = Variable<int>(catalogVersion);
    return map;
  }

  PlatformsCompanion toCompanion(bool nullToAbsent) {
    return PlatformsCompanion(
      id: Value(id),
      name: Value(name),
      categories: Value(categories),
      website: website == null && nullToAbsent
          ? const Value.absent()
          : Value(website),
      description: Value(description),
      platformType: Value(platformType),
      vendor: vendor == null && nullToAbsent
          ? const Value.absent()
          : Value(vendor),
      iconSlug: iconSlug == null && nullToAbsent
          ? const Value.absent()
          : Value(iconSlug),
      logoAsset: logoAsset == null && nullToAbsent
          ? const Value.absent()
          : Value(logoAsset),
      isCustom: Value(isCustom),
      isFavorite: Value(isFavorite),
      inMyWorld: Value(inMyWorld),
      sortOrder: Value(sortOrder),
      addedToMyWorldAt: addedToMyWorldAt == null && nullToAbsent
          ? const Value.absent()
          : Value(addedToMyWorldAt),
      catalogVersion: Value(catalogVersion),
    );
  }

  factory Platform.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Platform(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      categories: serializer.fromJson<String>(json['categories']),
      website: serializer.fromJson<String?>(json['website']),
      description: serializer.fromJson<String>(json['description']),
      platformType: serializer.fromJson<String>(json['platformType']),
      vendor: serializer.fromJson<String?>(json['vendor']),
      iconSlug: serializer.fromJson<String?>(json['iconSlug']),
      logoAsset: serializer.fromJson<String?>(json['logoAsset']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      inMyWorld: serializer.fromJson<bool>(json['inMyWorld']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      addedToMyWorldAt: serializer.fromJson<DateTime?>(
        json['addedToMyWorldAt'],
      ),
      catalogVersion: serializer.fromJson<int>(json['catalogVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'categories': serializer.toJson<String>(categories),
      'website': serializer.toJson<String?>(website),
      'description': serializer.toJson<String>(description),
      'platformType': serializer.toJson<String>(platformType),
      'vendor': serializer.toJson<String?>(vendor),
      'iconSlug': serializer.toJson<String?>(iconSlug),
      'logoAsset': serializer.toJson<String?>(logoAsset),
      'isCustom': serializer.toJson<bool>(isCustom),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'inMyWorld': serializer.toJson<bool>(inMyWorld),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'addedToMyWorldAt': serializer.toJson<DateTime?>(addedToMyWorldAt),
      'catalogVersion': serializer.toJson<int>(catalogVersion),
    };
  }

  Platform copyWith({
    String? id,
    String? name,
    String? categories,
    Value<String?> website = const Value.absent(),
    String? description,
    String? platformType,
    Value<String?> vendor = const Value.absent(),
    Value<String?> iconSlug = const Value.absent(),
    Value<String?> logoAsset = const Value.absent(),
    bool? isCustom,
    bool? isFavorite,
    bool? inMyWorld,
    int? sortOrder,
    Value<DateTime?> addedToMyWorldAt = const Value.absent(),
    int? catalogVersion,
  }) => Platform(
    id: id ?? this.id,
    name: name ?? this.name,
    categories: categories ?? this.categories,
    website: website.present ? website.value : this.website,
    description: description ?? this.description,
    platformType: platformType ?? this.platformType,
    vendor: vendor.present ? vendor.value : this.vendor,
    iconSlug: iconSlug.present ? iconSlug.value : this.iconSlug,
    logoAsset: logoAsset.present ? logoAsset.value : this.logoAsset,
    isCustom: isCustom ?? this.isCustom,
    isFavorite: isFavorite ?? this.isFavorite,
    inMyWorld: inMyWorld ?? this.inMyWorld,
    sortOrder: sortOrder ?? this.sortOrder,
    addedToMyWorldAt: addedToMyWorldAt.present
        ? addedToMyWorldAt.value
        : this.addedToMyWorldAt,
    catalogVersion: catalogVersion ?? this.catalogVersion,
  );
  Platform copyWithCompanion(PlatformsCompanion data) {
    return Platform(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      categories: data.categories.present
          ? data.categories.value
          : this.categories,
      website: data.website.present ? data.website.value : this.website,
      description: data.description.present
          ? data.description.value
          : this.description,
      platformType: data.platformType.present
          ? data.platformType.value
          : this.platformType,
      vendor: data.vendor.present ? data.vendor.value : this.vendor,
      iconSlug: data.iconSlug.present ? data.iconSlug.value : this.iconSlug,
      logoAsset: data.logoAsset.present ? data.logoAsset.value : this.logoAsset,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      inMyWorld: data.inMyWorld.present ? data.inMyWorld.value : this.inMyWorld,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      addedToMyWorldAt: data.addedToMyWorldAt.present
          ? data.addedToMyWorldAt.value
          : this.addedToMyWorldAt,
      catalogVersion: data.catalogVersion.present
          ? data.catalogVersion.value
          : this.catalogVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Platform(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categories: $categories, ')
          ..write('website: $website, ')
          ..write('description: $description, ')
          ..write('platformType: $platformType, ')
          ..write('vendor: $vendor, ')
          ..write('iconSlug: $iconSlug, ')
          ..write('logoAsset: $logoAsset, ')
          ..write('isCustom: $isCustom, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('inMyWorld: $inMyWorld, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('addedToMyWorldAt: $addedToMyWorldAt, ')
          ..write('catalogVersion: $catalogVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    categories,
    website,
    description,
    platformType,
    vendor,
    iconSlug,
    logoAsset,
    isCustom,
    isFavorite,
    inMyWorld,
    sortOrder,
    addedToMyWorldAt,
    catalogVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Platform &&
          other.id == this.id &&
          other.name == this.name &&
          other.categories == this.categories &&
          other.website == this.website &&
          other.description == this.description &&
          other.platformType == this.platformType &&
          other.vendor == this.vendor &&
          other.iconSlug == this.iconSlug &&
          other.logoAsset == this.logoAsset &&
          other.isCustom == this.isCustom &&
          other.isFavorite == this.isFavorite &&
          other.inMyWorld == this.inMyWorld &&
          other.sortOrder == this.sortOrder &&
          other.addedToMyWorldAt == this.addedToMyWorldAt &&
          other.catalogVersion == this.catalogVersion);
}

class PlatformsCompanion extends UpdateCompanion<Platform> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> categories;
  final Value<String?> website;
  final Value<String> description;
  final Value<String> platformType;
  final Value<String?> vendor;
  final Value<String?> iconSlug;
  final Value<String?> logoAsset;
  final Value<bool> isCustom;
  final Value<bool> isFavorite;
  final Value<bool> inMyWorld;
  final Value<int> sortOrder;
  final Value<DateTime?> addedToMyWorldAt;
  final Value<int> catalogVersion;
  final Value<int> rowid;
  const PlatformsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.categories = const Value.absent(),
    this.website = const Value.absent(),
    this.description = const Value.absent(),
    this.platformType = const Value.absent(),
    this.vendor = const Value.absent(),
    this.iconSlug = const Value.absent(),
    this.logoAsset = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.inMyWorld = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.addedToMyWorldAt = const Value.absent(),
    this.catalogVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlatformsCompanion.insert({
    required String id,
    required String name,
    required String categories,
    this.website = const Value.absent(),
    this.description = const Value.absent(),
    this.platformType = const Value.absent(),
    this.vendor = const Value.absent(),
    this.iconSlug = const Value.absent(),
    this.logoAsset = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.inMyWorld = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.addedToMyWorldAt = const Value.absent(),
    this.catalogVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       categories = Value(categories);
  static Insertable<Platform> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? categories,
    Expression<String>? website,
    Expression<String>? description,
    Expression<String>? platformType,
    Expression<String>? vendor,
    Expression<String>? iconSlug,
    Expression<String>? logoAsset,
    Expression<bool>? isCustom,
    Expression<bool>? isFavorite,
    Expression<bool>? inMyWorld,
    Expression<int>? sortOrder,
    Expression<DateTime>? addedToMyWorldAt,
    Expression<int>? catalogVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (categories != null) 'categories': categories,
      if (website != null) 'website': website,
      if (description != null) 'description': description,
      if (platformType != null) 'platform_type': platformType,
      if (vendor != null) 'vendor': vendor,
      if (iconSlug != null) 'icon_slug': iconSlug,
      if (logoAsset != null) 'logo_asset': logoAsset,
      if (isCustom != null) 'is_custom': isCustom,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (inMyWorld != null) 'in_my_world': inMyWorld,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (addedToMyWorldAt != null) 'added_to_my_world_at': addedToMyWorldAt,
      if (catalogVersion != null) 'catalog_version': catalogVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlatformsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? categories,
    Value<String?>? website,
    Value<String>? description,
    Value<String>? platformType,
    Value<String?>? vendor,
    Value<String?>? iconSlug,
    Value<String?>? logoAsset,
    Value<bool>? isCustom,
    Value<bool>? isFavorite,
    Value<bool>? inMyWorld,
    Value<int>? sortOrder,
    Value<DateTime?>? addedToMyWorldAt,
    Value<int>? catalogVersion,
    Value<int>? rowid,
  }) {
    return PlatformsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      categories: categories ?? this.categories,
      website: website ?? this.website,
      description: description ?? this.description,
      platformType: platformType ?? this.platformType,
      vendor: vendor ?? this.vendor,
      iconSlug: iconSlug ?? this.iconSlug,
      logoAsset: logoAsset ?? this.logoAsset,
      isCustom: isCustom ?? this.isCustom,
      isFavorite: isFavorite ?? this.isFavorite,
      inMyWorld: inMyWorld ?? this.inMyWorld,
      sortOrder: sortOrder ?? this.sortOrder,
      addedToMyWorldAt: addedToMyWorldAt ?? this.addedToMyWorldAt,
      catalogVersion: catalogVersion ?? this.catalogVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (categories.present) {
      map['categories'] = Variable<String>(categories.value);
    }
    if (website.present) {
      map['website'] = Variable<String>(website.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (platformType.present) {
      map['platform_type'] = Variable<String>(platformType.value);
    }
    if (vendor.present) {
      map['vendor'] = Variable<String>(vendor.value);
    }
    if (iconSlug.present) {
      map['icon_slug'] = Variable<String>(iconSlug.value);
    }
    if (logoAsset.present) {
      map['logo_asset'] = Variable<String>(logoAsset.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (inMyWorld.present) {
      map['in_my_world'] = Variable<bool>(inMyWorld.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (addedToMyWorldAt.present) {
      map['added_to_my_world_at'] = Variable<DateTime>(addedToMyWorldAt.value);
    }
    if (catalogVersion.present) {
      map['catalog_version'] = Variable<int>(catalogVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlatformsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categories: $categories, ')
          ..write('website: $website, ')
          ..write('description: $description, ')
          ..write('platformType: $platformType, ')
          ..write('vendor: $vendor, ')
          ..write('iconSlug: $iconSlug, ')
          ..write('logoAsset: $logoAsset, ')
          ..write('isCustom: $isCustom, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('inMyWorld: $inMyWorld, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('addedToMyWorldAt: $addedToMyWorldAt, ')
          ..write('catalogVersion: $catalogVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmailIdentitiesTable extends EmailIdentities
    with TableInfo<$EmailIdentitiesTable, EmailIdentity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmailIdentitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalizedAddressMeta = const VerificationMeta(
    'normalizedAddress',
  );
  @override
  late final GeneratedColumn<String> normalizedAddress =
      GeneratedColumn<String>(
        'normalized_address',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
      );
  static const VerificationMeta _providerMeta = const VerificationMeta(
    'provider',
  );
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
    'provider',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purposeMeta = const VerificationMeta(
    'purpose',
  );
  @override
  late final GeneratedColumn<String> purpose = GeneratedColumn<String>(
    'purpose',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _classificationMeta = const VerificationMeta(
    'classification',
  );
  @override
  late final GeneratedColumn<String> classification = GeneratedColumn<String>(
    'classification',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('personal'),
  );
  static const VerificationMeta _recoveryNotesMeta = const VerificationMeta(
    'recoveryNotes',
  );
  @override
  late final GeneratedColumn<String> recoveryNotes = GeneratedColumn<String>(
    'recovery_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    archivedAt,
    id,
    address,
    normalizedAddress,
    provider,
    displayName,
    purpose,
    classification,
    recoveryNotes,
    notes,
    status,
    isFavorite,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'email_identities';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmailIdentity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('normalized_address')) {
      context.handle(
        _normalizedAddressMeta,
        normalizedAddress.isAcceptableOrUnknown(
          data['normalized_address']!,
          _normalizedAddressMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedAddressMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('purpose')) {
      context.handle(
        _purposeMeta,
        purpose.isAcceptableOrUnknown(data['purpose']!, _purposeMeta),
      );
    }
    if (data.containsKey('classification')) {
      context.handle(
        _classificationMeta,
        classification.isAcceptableOrUnknown(
          data['classification']!,
          _classificationMeta,
        ),
      );
    }
    if (data.containsKey('recovery_notes')) {
      context.handle(
        _recoveryNotesMeta,
        recoveryNotes.isAcceptableOrUnknown(
          data['recovery_notes']!,
          _recoveryNotesMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmailIdentity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmailIdentity(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      normalizedAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_address'],
      )!,
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      ),
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      purpose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purpose'],
      ),
      classification: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}classification'],
      )!,
      recoveryNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recovery_notes'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
    );
  }

  @override
  $EmailIdentitiesTable createAlias(String alias) {
    return $EmailIdentitiesTable(attachedDatabase, alias);
  }
}

class EmailIdentity extends DataClass implements Insertable<EmailIdentity> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  final String id;
  final String address;
  final String normalizedAddress;
  final String? provider;
  final String? displayName;
  final String? purpose;
  final String classification;
  final String? recoveryNotes;
  final String? notes;
  final String status;
  final bool isFavorite;
  const EmailIdentity({
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
    required this.id,
    required this.address,
    required this.normalizedAddress,
    this.provider,
    this.displayName,
    this.purpose,
    required this.classification,
    this.recoveryNotes,
    this.notes,
    required this.status,
    required this.isFavorite,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['id'] = Variable<String>(id);
    map['address'] = Variable<String>(address);
    map['normalized_address'] = Variable<String>(normalizedAddress);
    if (!nullToAbsent || provider != null) {
      map['provider'] = Variable<String>(provider);
    }
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || purpose != null) {
      map['purpose'] = Variable<String>(purpose);
    }
    map['classification'] = Variable<String>(classification);
    if (!nullToAbsent || recoveryNotes != null) {
      map['recovery_notes'] = Variable<String>(recoveryNotes);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['status'] = Variable<String>(status);
    map['is_favorite'] = Variable<bool>(isFavorite);
    return map;
  }

  EmailIdentitiesCompanion toCompanion(bool nullToAbsent) {
    return EmailIdentitiesCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      id: Value(id),
      address: Value(address),
      normalizedAddress: Value(normalizedAddress),
      provider: provider == null && nullToAbsent
          ? const Value.absent()
          : Value(provider),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      purpose: purpose == null && nullToAbsent
          ? const Value.absent()
          : Value(purpose),
      classification: Value(classification),
      recoveryNotes: recoveryNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(recoveryNotes),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      status: Value(status),
      isFavorite: Value(isFavorite),
    );
  }

  factory EmailIdentity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmailIdentity(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      id: serializer.fromJson<String>(json['id']),
      address: serializer.fromJson<String>(json['address']),
      normalizedAddress: serializer.fromJson<String>(json['normalizedAddress']),
      provider: serializer.fromJson<String?>(json['provider']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      purpose: serializer.fromJson<String?>(json['purpose']),
      classification: serializer.fromJson<String>(json['classification']),
      recoveryNotes: serializer.fromJson<String?>(json['recoveryNotes']),
      notes: serializer.fromJson<String?>(json['notes']),
      status: serializer.fromJson<String>(json['status']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'id': serializer.toJson<String>(id),
      'address': serializer.toJson<String>(address),
      'normalizedAddress': serializer.toJson<String>(normalizedAddress),
      'provider': serializer.toJson<String?>(provider),
      'displayName': serializer.toJson<String?>(displayName),
      'purpose': serializer.toJson<String?>(purpose),
      'classification': serializer.toJson<String>(classification),
      'recoveryNotes': serializer.toJson<String?>(recoveryNotes),
      'notes': serializer.toJson<String?>(notes),
      'status': serializer.toJson<String>(status),
      'isFavorite': serializer.toJson<bool>(isFavorite),
    };
  }

  EmailIdentity copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> archivedAt = const Value.absent(),
    String? id,
    String? address,
    String? normalizedAddress,
    Value<String?> provider = const Value.absent(),
    Value<String?> displayName = const Value.absent(),
    Value<String?> purpose = const Value.absent(),
    String? classification,
    Value<String?> recoveryNotes = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    String? status,
    bool? isFavorite,
  }) => EmailIdentity(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    id: id ?? this.id,
    address: address ?? this.address,
    normalizedAddress: normalizedAddress ?? this.normalizedAddress,
    provider: provider.present ? provider.value : this.provider,
    displayName: displayName.present ? displayName.value : this.displayName,
    purpose: purpose.present ? purpose.value : this.purpose,
    classification: classification ?? this.classification,
    recoveryNotes: recoveryNotes.present
        ? recoveryNotes.value
        : this.recoveryNotes,
    notes: notes.present ? notes.value : this.notes,
    status: status ?? this.status,
    isFavorite: isFavorite ?? this.isFavorite,
  );
  EmailIdentity copyWithCompanion(EmailIdentitiesCompanion data) {
    return EmailIdentity(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      id: data.id.present ? data.id.value : this.id,
      address: data.address.present ? data.address.value : this.address,
      normalizedAddress: data.normalizedAddress.present
          ? data.normalizedAddress.value
          : this.normalizedAddress,
      provider: data.provider.present ? data.provider.value : this.provider,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      purpose: data.purpose.present ? data.purpose.value : this.purpose,
      classification: data.classification.present
          ? data.classification.value
          : this.classification,
      recoveryNotes: data.recoveryNotes.present
          ? data.recoveryNotes.value
          : this.recoveryNotes,
      notes: data.notes.present ? data.notes.value : this.notes,
      status: data.status.present ? data.status.value : this.status,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmailIdentity(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('address: $address, ')
          ..write('normalizedAddress: $normalizedAddress, ')
          ..write('provider: $provider, ')
          ..write('displayName: $displayName, ')
          ..write('purpose: $purpose, ')
          ..write('classification: $classification, ')
          ..write('recoveryNotes: $recoveryNotes, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    createdAt,
    updatedAt,
    archivedAt,
    id,
    address,
    normalizedAddress,
    provider,
    displayName,
    purpose,
    classification,
    recoveryNotes,
    notes,
    status,
    isFavorite,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmailIdentity &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt &&
          other.id == this.id &&
          other.address == this.address &&
          other.normalizedAddress == this.normalizedAddress &&
          other.provider == this.provider &&
          other.displayName == this.displayName &&
          other.purpose == this.purpose &&
          other.classification == this.classification &&
          other.recoveryNotes == this.recoveryNotes &&
          other.notes == this.notes &&
          other.status == this.status &&
          other.isFavorite == this.isFavorite);
}

class EmailIdentitiesCompanion extends UpdateCompanion<EmailIdentity> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<String> id;
  final Value<String> address;
  final Value<String> normalizedAddress;
  final Value<String?> provider;
  final Value<String?> displayName;
  final Value<String?> purpose;
  final Value<String> classification;
  final Value<String?> recoveryNotes;
  final Value<String?> notes;
  final Value<String> status;
  final Value<bool> isFavorite;
  final Value<int> rowid;
  const EmailIdentitiesCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.address = const Value.absent(),
    this.normalizedAddress = const Value.absent(),
    this.provider = const Value.absent(),
    this.displayName = const Value.absent(),
    this.purpose = const Value.absent(),
    this.classification = const Value.absent(),
    this.recoveryNotes = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmailIdentitiesCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    required String id,
    required String address,
    required String normalizedAddress,
    this.provider = const Value.absent(),
    this.displayName = const Value.absent(),
    this.purpose = const Value.absent(),
    this.classification = const Value.absent(),
    this.recoveryNotes = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       address = Value(address),
       normalizedAddress = Value(normalizedAddress);
  static Insertable<EmailIdentity> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? archivedAt,
    Expression<String>? id,
    Expression<String>? address,
    Expression<String>? normalizedAddress,
    Expression<String>? provider,
    Expression<String>? displayName,
    Expression<String>? purpose,
    Expression<String>? classification,
    Expression<String>? recoveryNotes,
    Expression<String>? notes,
    Expression<String>? status,
    Expression<bool>? isFavorite,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (id != null) 'id': id,
      if (address != null) 'address': address,
      if (normalizedAddress != null) 'normalized_address': normalizedAddress,
      if (provider != null) 'provider': provider,
      if (displayName != null) 'display_name': displayName,
      if (purpose != null) 'purpose': purpose,
      if (classification != null) 'classification': classification,
      if (recoveryNotes != null) 'recovery_notes': recoveryNotes,
      if (notes != null) 'notes': notes,
      if (status != null) 'status': status,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmailIdentitiesCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? archivedAt,
    Value<String>? id,
    Value<String>? address,
    Value<String>? normalizedAddress,
    Value<String?>? provider,
    Value<String?>? displayName,
    Value<String?>? purpose,
    Value<String>? classification,
    Value<String?>? recoveryNotes,
    Value<String?>? notes,
    Value<String>? status,
    Value<bool>? isFavorite,
    Value<int>? rowid,
  }) {
    return EmailIdentitiesCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      id: id ?? this.id,
      address: address ?? this.address,
      normalizedAddress: normalizedAddress ?? this.normalizedAddress,
      provider: provider ?? this.provider,
      displayName: displayName ?? this.displayName,
      purpose: purpose ?? this.purpose,
      classification: classification ?? this.classification,
      recoveryNotes: recoveryNotes ?? this.recoveryNotes,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      isFavorite: isFavorite ?? this.isFavorite,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (normalizedAddress.present) {
      map['normalized_address'] = Variable<String>(normalizedAddress.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (purpose.present) {
      map['purpose'] = Variable<String>(purpose.value);
    }
    if (classification.present) {
      map['classification'] = Variable<String>(classification.value);
    }
    if (recoveryNotes.present) {
      map['recovery_notes'] = Variable<String>(recoveryNotes.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmailIdentitiesCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('address: $address, ')
          ..write('normalizedAddress: $normalizedAddress, ')
          ..write('provider: $provider, ')
          ..write('displayName: $displayName, ')
          ..write('purpose: $purpose, ')
          ..write('classification: $classification, ')
          ..write('recoveryNotes: $recoveryNotes, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SecureItemsTable extends SecureItems
    with TableInfo<$SecureItemsTable, SecureItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SecureItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ciphertextMeta = const VerificationMeta(
    'ciphertext',
  );
  @override
  late final GeneratedColumn<Uint8List> ciphertext = GeneratedColumn<Uint8List>(
    'ciphertext',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nonceMeta = const VerificationMeta('nonce');
  @override
  late final GeneratedColumn<Uint8List> nonce = GeneratedColumn<Uint8List>(
    'nonce',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _keyIdMeta = const VerificationMeta('keyId');
  @override
  late final GeneratedColumn<String> keyId = GeneratedColumn<String>(
    'key_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('v1'),
  );
  static const VerificationMeta _lastViewedAtMeta = const VerificationMeta(
    'lastViewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastViewedAt = GeneratedColumn<DateTime>(
    'last_viewed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    id,
    title,
    kind,
    ciphertext,
    nonce,
    keyId,
    lastViewedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'secure_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<SecureItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('ciphertext')) {
      context.handle(
        _ciphertextMeta,
        ciphertext.isAcceptableOrUnknown(data['ciphertext']!, _ciphertextMeta),
      );
    } else if (isInserting) {
      context.missing(_ciphertextMeta);
    }
    if (data.containsKey('nonce')) {
      context.handle(
        _nonceMeta,
        nonce.isAcceptableOrUnknown(data['nonce']!, _nonceMeta),
      );
    } else if (isInserting) {
      context.missing(_nonceMeta);
    }
    if (data.containsKey('key_id')) {
      context.handle(
        _keyIdMeta,
        keyId.isAcceptableOrUnknown(data['key_id']!, _keyIdMeta),
      );
    }
    if (data.containsKey('last_viewed_at')) {
      context.handle(
        _lastViewedAtMeta,
        lastViewedAt.isAcceptableOrUnknown(
          data['last_viewed_at']!,
          _lastViewedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SecureItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SecureItem(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      ciphertext: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}ciphertext'],
      )!,
      nonce: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}nonce'],
      )!,
      keyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key_id'],
      )!,
      lastViewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_viewed_at'],
      ),
    );
  }

  @override
  $SecureItemsTable createAlias(String alias) {
    return $SecureItemsTable(attachedDatabase, alias);
  }
}

class SecureItem extends DataClass implements Insertable<SecureItem> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final String id;
  final String title;
  final String kind;
  final Uint8List ciphertext;
  final Uint8List nonce;
  final String keyId;
  final DateTime? lastViewedAt;
  const SecureItem({
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.title,
    required this.kind,
    required this.ciphertext,
    required this.nonce,
    required this.keyId,
    this.lastViewedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['kind'] = Variable<String>(kind);
    map['ciphertext'] = Variable<Uint8List>(ciphertext);
    map['nonce'] = Variable<Uint8List>(nonce);
    map['key_id'] = Variable<String>(keyId);
    if (!nullToAbsent || lastViewedAt != null) {
      map['last_viewed_at'] = Variable<DateTime>(lastViewedAt);
    }
    return map;
  }

  SecureItemsCompanion toCompanion(bool nullToAbsent) {
    return SecureItemsCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      id: Value(id),
      title: Value(title),
      kind: Value(kind),
      ciphertext: Value(ciphertext),
      nonce: Value(nonce),
      keyId: Value(keyId),
      lastViewedAt: lastViewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastViewedAt),
    );
  }

  factory SecureItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SecureItem(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      kind: serializer.fromJson<String>(json['kind']),
      ciphertext: serializer.fromJson<Uint8List>(json['ciphertext']),
      nonce: serializer.fromJson<Uint8List>(json['nonce']),
      keyId: serializer.fromJson<String>(json['keyId']),
      lastViewedAt: serializer.fromJson<DateTime?>(json['lastViewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'kind': serializer.toJson<String>(kind),
      'ciphertext': serializer.toJson<Uint8List>(ciphertext),
      'nonce': serializer.toJson<Uint8List>(nonce),
      'keyId': serializer.toJson<String>(keyId),
      'lastViewedAt': serializer.toJson<DateTime?>(lastViewedAt),
    };
  }

  SecureItem copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    String? id,
    String? title,
    String? kind,
    Uint8List? ciphertext,
    Uint8List? nonce,
    String? keyId,
    Value<DateTime?> lastViewedAt = const Value.absent(),
  }) => SecureItem(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    id: id ?? this.id,
    title: title ?? this.title,
    kind: kind ?? this.kind,
    ciphertext: ciphertext ?? this.ciphertext,
    nonce: nonce ?? this.nonce,
    keyId: keyId ?? this.keyId,
    lastViewedAt: lastViewedAt.present ? lastViewedAt.value : this.lastViewedAt,
  );
  SecureItem copyWithCompanion(SecureItemsCompanion data) {
    return SecureItem(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      kind: data.kind.present ? data.kind.value : this.kind,
      ciphertext: data.ciphertext.present
          ? data.ciphertext.value
          : this.ciphertext,
      nonce: data.nonce.present ? data.nonce.value : this.nonce,
      keyId: data.keyId.present ? data.keyId.value : this.keyId,
      lastViewedAt: data.lastViewedAt.present
          ? data.lastViewedAt.value
          : this.lastViewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SecureItem(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('kind: $kind, ')
          ..write('ciphertext: $ciphertext, ')
          ..write('nonce: $nonce, ')
          ..write('keyId: $keyId, ')
          ..write('lastViewedAt: $lastViewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    createdAt,
    updatedAt,
    id,
    title,
    kind,
    $driftBlobEquality.hash(ciphertext),
    $driftBlobEquality.hash(nonce),
    keyId,
    lastViewedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SecureItem &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.id == this.id &&
          other.title == this.title &&
          other.kind == this.kind &&
          $driftBlobEquality.equals(other.ciphertext, this.ciphertext) &&
          $driftBlobEquality.equals(other.nonce, this.nonce) &&
          other.keyId == this.keyId &&
          other.lastViewedAt == this.lastViewedAt);
}

class SecureItemsCompanion extends UpdateCompanion<SecureItem> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> id;
  final Value<String> title;
  final Value<String> kind;
  final Value<Uint8List> ciphertext;
  final Value<Uint8List> nonce;
  final Value<String> keyId;
  final Value<DateTime?> lastViewedAt;
  final Value<int> rowid;
  const SecureItemsCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.kind = const Value.absent(),
    this.ciphertext = const Value.absent(),
    this.nonce = const Value.absent(),
    this.keyId = const Value.absent(),
    this.lastViewedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SecureItemsCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String id,
    required String title,
    required String kind,
    required Uint8List ciphertext,
    required Uint8List nonce,
    this.keyId = const Value.absent(),
    this.lastViewedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       kind = Value(kind),
       ciphertext = Value(ciphertext),
       nonce = Value(nonce);
  static Insertable<SecureItem> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? kind,
    Expression<Uint8List>? ciphertext,
    Expression<Uint8List>? nonce,
    Expression<String>? keyId,
    Expression<DateTime>? lastViewedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (kind != null) 'kind': kind,
      if (ciphertext != null) 'ciphertext': ciphertext,
      if (nonce != null) 'nonce': nonce,
      if (keyId != null) 'key_id': keyId,
      if (lastViewedAt != null) 'last_viewed_at': lastViewedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SecureItemsCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? id,
    Value<String>? title,
    Value<String>? kind,
    Value<Uint8List>? ciphertext,
    Value<Uint8List>? nonce,
    Value<String>? keyId,
    Value<DateTime?>? lastViewedAt,
    Value<int>? rowid,
  }) {
    return SecureItemsCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      title: title ?? this.title,
      kind: kind ?? this.kind,
      ciphertext: ciphertext ?? this.ciphertext,
      nonce: nonce ?? this.nonce,
      keyId: keyId ?? this.keyId,
      lastViewedAt: lastViewedAt ?? this.lastViewedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (ciphertext.present) {
      map['ciphertext'] = Variable<Uint8List>(ciphertext.value);
    }
    if (nonce.present) {
      map['nonce'] = Variable<Uint8List>(nonce.value);
    }
    if (keyId.present) {
      map['key_id'] = Variable<String>(keyId.value);
    }
    if (lastViewedAt.present) {
      map['last_viewed_at'] = Variable<DateTime>(lastViewedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SecureItemsCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('kind: $kind, ')
          ..write('ciphertext: $ciphertext, ')
          ..write('nonce: $nonce, ')
          ..write('keyId: $keyId, ')
          ..write('lastViewedAt: $lastViewedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CredentialReferencesTable extends CredentialReferences
    with TableInfo<$CredentialReferencesTable, CredentialReference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CredentialReferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _managerMeta = const VerificationMeta(
    'manager',
  );
  @override
  late final GeneratedColumn<String> manager = GeneratedColumn<String>(
    'manager',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locatorMeta = const VerificationMeta(
    'locator',
  );
  @override
  late final GeneratedColumn<String> locator = GeneratedColumn<String>(
    'locator',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usernameHintMeta = const VerificationMeta(
    'usernameHint',
  );
  @override
  late final GeneratedColumn<String> usernameHint = GeneratedColumn<String>(
    'username_hint',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vaultItemIdMeta = const VerificationMeta(
    'vaultItemId',
  );
  @override
  late final GeneratedColumn<String> vaultItemId = GeneratedColumn<String>(
    'vault_item_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES secure_items (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    id,
    label,
    manager,
    locator,
    usernameHint,
    notes,
    vaultItemId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'credential_references';
  @override
  VerificationContext validateIntegrity(
    Insertable<CredentialReference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('manager')) {
      context.handle(
        _managerMeta,
        manager.isAcceptableOrUnknown(data['manager']!, _managerMeta),
      );
    }
    if (data.containsKey('locator')) {
      context.handle(
        _locatorMeta,
        locator.isAcceptableOrUnknown(data['locator']!, _locatorMeta),
      );
    }
    if (data.containsKey('username_hint')) {
      context.handle(
        _usernameHintMeta,
        usernameHint.isAcceptableOrUnknown(
          data['username_hint']!,
          _usernameHintMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('vault_item_id')) {
      context.handle(
        _vaultItemIdMeta,
        vaultItemId.isAcceptableOrUnknown(
          data['vault_item_id']!,
          _vaultItemIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CredentialReference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CredentialReference(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      manager: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manager'],
      ),
      locator: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locator'],
      ),
      usernameHint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username_hint'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      vaultItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vault_item_id'],
      ),
    );
  }

  @override
  $CredentialReferencesTable createAlias(String alias) {
    return $CredentialReferencesTable(attachedDatabase, alias);
  }
}

class CredentialReference extends DataClass
    implements Insertable<CredentialReference> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final String id;
  final String label;
  final String? manager;
  final String? locator;
  final String? usernameHint;
  final String? notes;
  final String? vaultItemId;
  const CredentialReference({
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.label,
    this.manager,
    this.locator,
    this.usernameHint,
    this.notes,
    this.vaultItemId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || manager != null) {
      map['manager'] = Variable<String>(manager);
    }
    if (!nullToAbsent || locator != null) {
      map['locator'] = Variable<String>(locator);
    }
    if (!nullToAbsent || usernameHint != null) {
      map['username_hint'] = Variable<String>(usernameHint);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || vaultItemId != null) {
      map['vault_item_id'] = Variable<String>(vaultItemId);
    }
    return map;
  }

  CredentialReferencesCompanion toCompanion(bool nullToAbsent) {
    return CredentialReferencesCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      id: Value(id),
      label: Value(label),
      manager: manager == null && nullToAbsent
          ? const Value.absent()
          : Value(manager),
      locator: locator == null && nullToAbsent
          ? const Value.absent()
          : Value(locator),
      usernameHint: usernameHint == null && nullToAbsent
          ? const Value.absent()
          : Value(usernameHint),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      vaultItemId: vaultItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(vaultItemId),
    );
  }

  factory CredentialReference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CredentialReference(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      manager: serializer.fromJson<String?>(json['manager']),
      locator: serializer.fromJson<String?>(json['locator']),
      usernameHint: serializer.fromJson<String?>(json['usernameHint']),
      notes: serializer.fromJson<String?>(json['notes']),
      vaultItemId: serializer.fromJson<String?>(json['vaultItemId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'manager': serializer.toJson<String?>(manager),
      'locator': serializer.toJson<String?>(locator),
      'usernameHint': serializer.toJson<String?>(usernameHint),
      'notes': serializer.toJson<String?>(notes),
      'vaultItemId': serializer.toJson<String?>(vaultItemId),
    };
  }

  CredentialReference copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    String? id,
    String? label,
    Value<String?> manager = const Value.absent(),
    Value<String?> locator = const Value.absent(),
    Value<String?> usernameHint = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> vaultItemId = const Value.absent(),
  }) => CredentialReference(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    id: id ?? this.id,
    label: label ?? this.label,
    manager: manager.present ? manager.value : this.manager,
    locator: locator.present ? locator.value : this.locator,
    usernameHint: usernameHint.present ? usernameHint.value : this.usernameHint,
    notes: notes.present ? notes.value : this.notes,
    vaultItemId: vaultItemId.present ? vaultItemId.value : this.vaultItemId,
  );
  CredentialReference copyWithCompanion(CredentialReferencesCompanion data) {
    return CredentialReference(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      manager: data.manager.present ? data.manager.value : this.manager,
      locator: data.locator.present ? data.locator.value : this.locator,
      usernameHint: data.usernameHint.present
          ? data.usernameHint.value
          : this.usernameHint,
      notes: data.notes.present ? data.notes.value : this.notes,
      vaultItemId: data.vaultItemId.present
          ? data.vaultItemId.value
          : this.vaultItemId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CredentialReference(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('manager: $manager, ')
          ..write('locator: $locator, ')
          ..write('usernameHint: $usernameHint, ')
          ..write('notes: $notes, ')
          ..write('vaultItemId: $vaultItemId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    createdAt,
    updatedAt,
    id,
    label,
    manager,
    locator,
    usernameHint,
    notes,
    vaultItemId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CredentialReference &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.id == this.id &&
          other.label == this.label &&
          other.manager == this.manager &&
          other.locator == this.locator &&
          other.usernameHint == this.usernameHint &&
          other.notes == this.notes &&
          other.vaultItemId == this.vaultItemId);
}

class CredentialReferencesCompanion
    extends UpdateCompanion<CredentialReference> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> id;
  final Value<String> label;
  final Value<String?> manager;
  final Value<String?> locator;
  final Value<String?> usernameHint;
  final Value<String?> notes;
  final Value<String?> vaultItemId;
  final Value<int> rowid;
  const CredentialReferencesCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.manager = const Value.absent(),
    this.locator = const Value.absent(),
    this.usernameHint = const Value.absent(),
    this.notes = const Value.absent(),
    this.vaultItemId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CredentialReferencesCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String id,
    required String label,
    this.manager = const Value.absent(),
    this.locator = const Value.absent(),
    this.usernameHint = const Value.absent(),
    this.notes = const Value.absent(),
    this.vaultItemId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label);
  static Insertable<CredentialReference> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? id,
    Expression<String>? label,
    Expression<String>? manager,
    Expression<String>? locator,
    Expression<String>? usernameHint,
    Expression<String>? notes,
    Expression<String>? vaultItemId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (manager != null) 'manager': manager,
      if (locator != null) 'locator': locator,
      if (usernameHint != null) 'username_hint': usernameHint,
      if (notes != null) 'notes': notes,
      if (vaultItemId != null) 'vault_item_id': vaultItemId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CredentialReferencesCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? id,
    Value<String>? label,
    Value<String?>? manager,
    Value<String?>? locator,
    Value<String?>? usernameHint,
    Value<String?>? notes,
    Value<String?>? vaultItemId,
    Value<int>? rowid,
  }) {
    return CredentialReferencesCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      label: label ?? this.label,
      manager: manager ?? this.manager,
      locator: locator ?? this.locator,
      usernameHint: usernameHint ?? this.usernameHint,
      notes: notes ?? this.notes,
      vaultItemId: vaultItemId ?? this.vaultItemId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (manager.present) {
      map['manager'] = Variable<String>(manager.value);
    }
    if (locator.present) {
      map['locator'] = Variable<String>(locator.value);
    }
    if (usernameHint.present) {
      map['username_hint'] = Variable<String>(usernameHint.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (vaultItemId.present) {
      map['vault_item_id'] = Variable<String>(vaultItemId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CredentialReferencesCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('manager: $manager, ')
          ..write('locator: $locator, ')
          ..write('usernameHint: $usernameHint, ')
          ..write('notes: $notes, ')
          ..write('vaultItemId: $vaultItemId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServiceAccountsTable extends ServiceAccounts
    with TableInfo<$ServiceAccountsTable, ServiceAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _platformIdMeta = const VerificationMeta(
    'platformId',
  );
  @override
  late final GeneratedColumn<String> platformId = GeneratedColumn<String>(
    'platform_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES platforms (id)',
    ),
  );
  static const VerificationMeta _emailIdentityIdMeta = const VerificationMeta(
    'emailIdentityId',
  );
  @override
  late final GeneratedColumn<String> emailIdentityId = GeneratedColumn<String>(
    'email_identity_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES email_identities (id)',
    ),
  );
  static const VerificationMeta _accountNameMeta = const VerificationMeta(
    'accountName',
  );
  @override
  late final GeneratedColumn<String> accountName = GeneratedColumn<String>(
    'account_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _profileUrlMeta = const VerificationMeta(
    'profileUrl',
  );
  @override
  late final GeneratedColumn<String> profileUrl = GeneratedColumn<String>(
    'profile_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purposeMeta = const VerificationMeta(
    'purpose',
  );
  @override
  late final GeneratedColumn<String> purpose = GeneratedColumn<String>(
    'purpose',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _classificationMeta = const VerificationMeta(
    'classification',
  );
  @override
  late final GeneratedColumn<String> classification = GeneratedColumn<String>(
    'classification',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('personal'),
  );
  static const VerificationMeta _planMeta = const VerificationMeta('plan');
  @override
  late final GeneratedColumn<String> plan = GeneratedColumn<String>(
    'plan',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _billingCycleMeta = const VerificationMeta(
    'billingCycle',
  );
  @override
  late final GeneratedColumn<String> billingCycle = GeneratedColumn<String>(
    'billing_cycle',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isApiAccountMeta = const VerificationMeta(
    'isApiAccount',
  );
  @override
  late final GeneratedColumn<bool> isApiAccount = GeneratedColumn<bool>(
    'is_api_account',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_api_account" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastAccessedAtMeta = const VerificationMeta(
    'lastAccessedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAccessedAt =
      GeneratedColumn<DateTime>(
        'last_accessed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _credentialRefIdMeta = const VerificationMeta(
    'credentialRefId',
  );
  @override
  late final GeneratedColumn<String> credentialRefId = GeneratedColumn<String>(
    'credential_ref_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES credential_references (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    archivedAt,
    id,
    platformId,
    emailIdentityId,
    accountName,
    username,
    displayName,
    profileUrl,
    purpose,
    status,
    classification,
    plan,
    billingCycle,
    isApiAccount,
    notes,
    isFavorite,
    lastAccessedAt,
    credentialRefId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServiceAccount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('platform_id')) {
      context.handle(
        _platformIdMeta,
        platformId.isAcceptableOrUnknown(data['platform_id']!, _platformIdMeta),
      );
    } else if (isInserting) {
      context.missing(_platformIdMeta);
    }
    if (data.containsKey('email_identity_id')) {
      context.handle(
        _emailIdentityIdMeta,
        emailIdentityId.isAcceptableOrUnknown(
          data['email_identity_id']!,
          _emailIdentityIdMeta,
        ),
      );
    }
    if (data.containsKey('account_name')) {
      context.handle(
        _accountNameMeta,
        accountName.isAcceptableOrUnknown(
          data['account_name']!,
          _accountNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountNameMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('profile_url')) {
      context.handle(
        _profileUrlMeta,
        profileUrl.isAcceptableOrUnknown(data['profile_url']!, _profileUrlMeta),
      );
    }
    if (data.containsKey('purpose')) {
      context.handle(
        _purposeMeta,
        purpose.isAcceptableOrUnknown(data['purpose']!, _purposeMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('classification')) {
      context.handle(
        _classificationMeta,
        classification.isAcceptableOrUnknown(
          data['classification']!,
          _classificationMeta,
        ),
      );
    }
    if (data.containsKey('plan')) {
      context.handle(
        _planMeta,
        plan.isAcceptableOrUnknown(data['plan']!, _planMeta),
      );
    }
    if (data.containsKey('billing_cycle')) {
      context.handle(
        _billingCycleMeta,
        billingCycle.isAcceptableOrUnknown(
          data['billing_cycle']!,
          _billingCycleMeta,
        ),
      );
    }
    if (data.containsKey('is_api_account')) {
      context.handle(
        _isApiAccountMeta,
        isApiAccount.isAcceptableOrUnknown(
          data['is_api_account']!,
          _isApiAccountMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('last_accessed_at')) {
      context.handle(
        _lastAccessedAtMeta,
        lastAccessedAt.isAcceptableOrUnknown(
          data['last_accessed_at']!,
          _lastAccessedAtMeta,
        ),
      );
    }
    if (data.containsKey('credential_ref_id')) {
      context.handle(
        _credentialRefIdMeta,
        credentialRefId.isAcceptableOrUnknown(
          data['credential_ref_id']!,
          _credentialRefIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceAccount(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      platformId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform_id'],
      )!,
      emailIdentityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email_identity_id'],
      ),
      accountName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_name'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      ),
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      profileUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_url'],
      ),
      purpose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purpose'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      classification: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}classification'],
      )!,
      plan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan'],
      ),
      billingCycle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}billing_cycle'],
      ),
      isApiAccount: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_api_account'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      lastAccessedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_accessed_at'],
      ),
      credentialRefId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}credential_ref_id'],
      ),
    );
  }

  @override
  $ServiceAccountsTable createAlias(String alias) {
    return $ServiceAccountsTable(attachedDatabase, alias);
  }
}

class ServiceAccount extends DataClass implements Insertable<ServiceAccount> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  final String id;
  final String platformId;
  final String? emailIdentityId;
  final String accountName;
  final String? username;
  final String? displayName;
  final String? profileUrl;
  final String? purpose;
  final String status;
  final String classification;
  final String? plan;
  final String? billingCycle;
  final bool isApiAccount;
  final String? notes;
  final bool isFavorite;
  final DateTime? lastAccessedAt;
  final String? credentialRefId;
  const ServiceAccount({
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
    required this.id,
    required this.platformId,
    this.emailIdentityId,
    required this.accountName,
    this.username,
    this.displayName,
    this.profileUrl,
    this.purpose,
    required this.status,
    required this.classification,
    this.plan,
    this.billingCycle,
    required this.isApiAccount,
    this.notes,
    required this.isFavorite,
    this.lastAccessedAt,
    this.credentialRefId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['id'] = Variable<String>(id);
    map['platform_id'] = Variable<String>(platformId);
    if (!nullToAbsent || emailIdentityId != null) {
      map['email_identity_id'] = Variable<String>(emailIdentityId);
    }
    map['account_name'] = Variable<String>(accountName);
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || profileUrl != null) {
      map['profile_url'] = Variable<String>(profileUrl);
    }
    if (!nullToAbsent || purpose != null) {
      map['purpose'] = Variable<String>(purpose);
    }
    map['status'] = Variable<String>(status);
    map['classification'] = Variable<String>(classification);
    if (!nullToAbsent || plan != null) {
      map['plan'] = Variable<String>(plan);
    }
    if (!nullToAbsent || billingCycle != null) {
      map['billing_cycle'] = Variable<String>(billingCycle);
    }
    map['is_api_account'] = Variable<bool>(isApiAccount);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || lastAccessedAt != null) {
      map['last_accessed_at'] = Variable<DateTime>(lastAccessedAt);
    }
    if (!nullToAbsent || credentialRefId != null) {
      map['credential_ref_id'] = Variable<String>(credentialRefId);
    }
    return map;
  }

  ServiceAccountsCompanion toCompanion(bool nullToAbsent) {
    return ServiceAccountsCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      id: Value(id),
      platformId: Value(platformId),
      emailIdentityId: emailIdentityId == null && nullToAbsent
          ? const Value.absent()
          : Value(emailIdentityId),
      accountName: Value(accountName),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      profileUrl: profileUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(profileUrl),
      purpose: purpose == null && nullToAbsent
          ? const Value.absent()
          : Value(purpose),
      status: Value(status),
      classification: Value(classification),
      plan: plan == null && nullToAbsent ? const Value.absent() : Value(plan),
      billingCycle: billingCycle == null && nullToAbsent
          ? const Value.absent()
          : Value(billingCycle),
      isApiAccount: Value(isApiAccount),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isFavorite: Value(isFavorite),
      lastAccessedAt: lastAccessedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAccessedAt),
      credentialRefId: credentialRefId == null && nullToAbsent
          ? const Value.absent()
          : Value(credentialRefId),
    );
  }

  factory ServiceAccount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceAccount(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      id: serializer.fromJson<String>(json['id']),
      platformId: serializer.fromJson<String>(json['platformId']),
      emailIdentityId: serializer.fromJson<String?>(json['emailIdentityId']),
      accountName: serializer.fromJson<String>(json['accountName']),
      username: serializer.fromJson<String?>(json['username']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      profileUrl: serializer.fromJson<String?>(json['profileUrl']),
      purpose: serializer.fromJson<String?>(json['purpose']),
      status: serializer.fromJson<String>(json['status']),
      classification: serializer.fromJson<String>(json['classification']),
      plan: serializer.fromJson<String?>(json['plan']),
      billingCycle: serializer.fromJson<String?>(json['billingCycle']),
      isApiAccount: serializer.fromJson<bool>(json['isApiAccount']),
      notes: serializer.fromJson<String?>(json['notes']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      lastAccessedAt: serializer.fromJson<DateTime?>(json['lastAccessedAt']),
      credentialRefId: serializer.fromJson<String?>(json['credentialRefId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'id': serializer.toJson<String>(id),
      'platformId': serializer.toJson<String>(platformId),
      'emailIdentityId': serializer.toJson<String?>(emailIdentityId),
      'accountName': serializer.toJson<String>(accountName),
      'username': serializer.toJson<String?>(username),
      'displayName': serializer.toJson<String?>(displayName),
      'profileUrl': serializer.toJson<String?>(profileUrl),
      'purpose': serializer.toJson<String?>(purpose),
      'status': serializer.toJson<String>(status),
      'classification': serializer.toJson<String>(classification),
      'plan': serializer.toJson<String?>(plan),
      'billingCycle': serializer.toJson<String?>(billingCycle),
      'isApiAccount': serializer.toJson<bool>(isApiAccount),
      'notes': serializer.toJson<String?>(notes),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'lastAccessedAt': serializer.toJson<DateTime?>(lastAccessedAt),
      'credentialRefId': serializer.toJson<String?>(credentialRefId),
    };
  }

  ServiceAccount copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> archivedAt = const Value.absent(),
    String? id,
    String? platformId,
    Value<String?> emailIdentityId = const Value.absent(),
    String? accountName,
    Value<String?> username = const Value.absent(),
    Value<String?> displayName = const Value.absent(),
    Value<String?> profileUrl = const Value.absent(),
    Value<String?> purpose = const Value.absent(),
    String? status,
    String? classification,
    Value<String?> plan = const Value.absent(),
    Value<String?> billingCycle = const Value.absent(),
    bool? isApiAccount,
    Value<String?> notes = const Value.absent(),
    bool? isFavorite,
    Value<DateTime?> lastAccessedAt = const Value.absent(),
    Value<String?> credentialRefId = const Value.absent(),
  }) => ServiceAccount(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    id: id ?? this.id,
    platformId: platformId ?? this.platformId,
    emailIdentityId: emailIdentityId.present
        ? emailIdentityId.value
        : this.emailIdentityId,
    accountName: accountName ?? this.accountName,
    username: username.present ? username.value : this.username,
    displayName: displayName.present ? displayName.value : this.displayName,
    profileUrl: profileUrl.present ? profileUrl.value : this.profileUrl,
    purpose: purpose.present ? purpose.value : this.purpose,
    status: status ?? this.status,
    classification: classification ?? this.classification,
    plan: plan.present ? plan.value : this.plan,
    billingCycle: billingCycle.present ? billingCycle.value : this.billingCycle,
    isApiAccount: isApiAccount ?? this.isApiAccount,
    notes: notes.present ? notes.value : this.notes,
    isFavorite: isFavorite ?? this.isFavorite,
    lastAccessedAt: lastAccessedAt.present
        ? lastAccessedAt.value
        : this.lastAccessedAt,
    credentialRefId: credentialRefId.present
        ? credentialRefId.value
        : this.credentialRefId,
  );
  ServiceAccount copyWithCompanion(ServiceAccountsCompanion data) {
    return ServiceAccount(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      id: data.id.present ? data.id.value : this.id,
      platformId: data.platformId.present
          ? data.platformId.value
          : this.platformId,
      emailIdentityId: data.emailIdentityId.present
          ? data.emailIdentityId.value
          : this.emailIdentityId,
      accountName: data.accountName.present
          ? data.accountName.value
          : this.accountName,
      username: data.username.present ? data.username.value : this.username,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      profileUrl: data.profileUrl.present
          ? data.profileUrl.value
          : this.profileUrl,
      purpose: data.purpose.present ? data.purpose.value : this.purpose,
      status: data.status.present ? data.status.value : this.status,
      classification: data.classification.present
          ? data.classification.value
          : this.classification,
      plan: data.plan.present ? data.plan.value : this.plan,
      billingCycle: data.billingCycle.present
          ? data.billingCycle.value
          : this.billingCycle,
      isApiAccount: data.isApiAccount.present
          ? data.isApiAccount.value
          : this.isApiAccount,
      notes: data.notes.present ? data.notes.value : this.notes,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      lastAccessedAt: data.lastAccessedAt.present
          ? data.lastAccessedAt.value
          : this.lastAccessedAt,
      credentialRefId: data.credentialRefId.present
          ? data.credentialRefId.value
          : this.credentialRefId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceAccount(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('platformId: $platformId, ')
          ..write('emailIdentityId: $emailIdentityId, ')
          ..write('accountName: $accountName, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('profileUrl: $profileUrl, ')
          ..write('purpose: $purpose, ')
          ..write('status: $status, ')
          ..write('classification: $classification, ')
          ..write('plan: $plan, ')
          ..write('billingCycle: $billingCycle, ')
          ..write('isApiAccount: $isApiAccount, ')
          ..write('notes: $notes, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('lastAccessedAt: $lastAccessedAt, ')
          ..write('credentialRefId: $credentialRefId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    createdAt,
    updatedAt,
    archivedAt,
    id,
    platformId,
    emailIdentityId,
    accountName,
    username,
    displayName,
    profileUrl,
    purpose,
    status,
    classification,
    plan,
    billingCycle,
    isApiAccount,
    notes,
    isFavorite,
    lastAccessedAt,
    credentialRefId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceAccount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt &&
          other.id == this.id &&
          other.platformId == this.platformId &&
          other.emailIdentityId == this.emailIdentityId &&
          other.accountName == this.accountName &&
          other.username == this.username &&
          other.displayName == this.displayName &&
          other.profileUrl == this.profileUrl &&
          other.purpose == this.purpose &&
          other.status == this.status &&
          other.classification == this.classification &&
          other.plan == this.plan &&
          other.billingCycle == this.billingCycle &&
          other.isApiAccount == this.isApiAccount &&
          other.notes == this.notes &&
          other.isFavorite == this.isFavorite &&
          other.lastAccessedAt == this.lastAccessedAt &&
          other.credentialRefId == this.credentialRefId);
}

class ServiceAccountsCompanion extends UpdateCompanion<ServiceAccount> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<String> id;
  final Value<String> platformId;
  final Value<String?> emailIdentityId;
  final Value<String> accountName;
  final Value<String?> username;
  final Value<String?> displayName;
  final Value<String?> profileUrl;
  final Value<String?> purpose;
  final Value<String> status;
  final Value<String> classification;
  final Value<String?> plan;
  final Value<String?> billingCycle;
  final Value<bool> isApiAccount;
  final Value<String?> notes;
  final Value<bool> isFavorite;
  final Value<DateTime?> lastAccessedAt;
  final Value<String?> credentialRefId;
  final Value<int> rowid;
  const ServiceAccountsCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.platformId = const Value.absent(),
    this.emailIdentityId = const Value.absent(),
    this.accountName = const Value.absent(),
    this.username = const Value.absent(),
    this.displayName = const Value.absent(),
    this.profileUrl = const Value.absent(),
    this.purpose = const Value.absent(),
    this.status = const Value.absent(),
    this.classification = const Value.absent(),
    this.plan = const Value.absent(),
    this.billingCycle = const Value.absent(),
    this.isApiAccount = const Value.absent(),
    this.notes = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.lastAccessedAt = const Value.absent(),
    this.credentialRefId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServiceAccountsCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    required String id,
    required String platformId,
    this.emailIdentityId = const Value.absent(),
    required String accountName,
    this.username = const Value.absent(),
    this.displayName = const Value.absent(),
    this.profileUrl = const Value.absent(),
    this.purpose = const Value.absent(),
    this.status = const Value.absent(),
    this.classification = const Value.absent(),
    this.plan = const Value.absent(),
    this.billingCycle = const Value.absent(),
    this.isApiAccount = const Value.absent(),
    this.notes = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.lastAccessedAt = const Value.absent(),
    this.credentialRefId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       platformId = Value(platformId),
       accountName = Value(accountName);
  static Insertable<ServiceAccount> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? archivedAt,
    Expression<String>? id,
    Expression<String>? platformId,
    Expression<String>? emailIdentityId,
    Expression<String>? accountName,
    Expression<String>? username,
    Expression<String>? displayName,
    Expression<String>? profileUrl,
    Expression<String>? purpose,
    Expression<String>? status,
    Expression<String>? classification,
    Expression<String>? plan,
    Expression<String>? billingCycle,
    Expression<bool>? isApiAccount,
    Expression<String>? notes,
    Expression<bool>? isFavorite,
    Expression<DateTime>? lastAccessedAt,
    Expression<String>? credentialRefId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (id != null) 'id': id,
      if (platformId != null) 'platform_id': platformId,
      if (emailIdentityId != null) 'email_identity_id': emailIdentityId,
      if (accountName != null) 'account_name': accountName,
      if (username != null) 'username': username,
      if (displayName != null) 'display_name': displayName,
      if (profileUrl != null) 'profile_url': profileUrl,
      if (purpose != null) 'purpose': purpose,
      if (status != null) 'status': status,
      if (classification != null) 'classification': classification,
      if (plan != null) 'plan': plan,
      if (billingCycle != null) 'billing_cycle': billingCycle,
      if (isApiAccount != null) 'is_api_account': isApiAccount,
      if (notes != null) 'notes': notes,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (lastAccessedAt != null) 'last_accessed_at': lastAccessedAt,
      if (credentialRefId != null) 'credential_ref_id': credentialRefId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServiceAccountsCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? archivedAt,
    Value<String>? id,
    Value<String>? platformId,
    Value<String?>? emailIdentityId,
    Value<String>? accountName,
    Value<String?>? username,
    Value<String?>? displayName,
    Value<String?>? profileUrl,
    Value<String?>? purpose,
    Value<String>? status,
    Value<String>? classification,
    Value<String?>? plan,
    Value<String?>? billingCycle,
    Value<bool>? isApiAccount,
    Value<String?>? notes,
    Value<bool>? isFavorite,
    Value<DateTime?>? lastAccessedAt,
    Value<String?>? credentialRefId,
    Value<int>? rowid,
  }) {
    return ServiceAccountsCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      id: id ?? this.id,
      platformId: platformId ?? this.platformId,
      emailIdentityId: emailIdentityId ?? this.emailIdentityId,
      accountName: accountName ?? this.accountName,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      profileUrl: profileUrl ?? this.profileUrl,
      purpose: purpose ?? this.purpose,
      status: status ?? this.status,
      classification: classification ?? this.classification,
      plan: plan ?? this.plan,
      billingCycle: billingCycle ?? this.billingCycle,
      isApiAccount: isApiAccount ?? this.isApiAccount,
      notes: notes ?? this.notes,
      isFavorite: isFavorite ?? this.isFavorite,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      credentialRefId: credentialRefId ?? this.credentialRefId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (platformId.present) {
      map['platform_id'] = Variable<String>(platformId.value);
    }
    if (emailIdentityId.present) {
      map['email_identity_id'] = Variable<String>(emailIdentityId.value);
    }
    if (accountName.present) {
      map['account_name'] = Variable<String>(accountName.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (profileUrl.present) {
      map['profile_url'] = Variable<String>(profileUrl.value);
    }
    if (purpose.present) {
      map['purpose'] = Variable<String>(purpose.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (classification.present) {
      map['classification'] = Variable<String>(classification.value);
    }
    if (plan.present) {
      map['plan'] = Variable<String>(plan.value);
    }
    if (billingCycle.present) {
      map['billing_cycle'] = Variable<String>(billingCycle.value);
    }
    if (isApiAccount.present) {
      map['is_api_account'] = Variable<bool>(isApiAccount.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (lastAccessedAt.present) {
      map['last_accessed_at'] = Variable<DateTime>(lastAccessedAt.value);
    }
    if (credentialRefId.present) {
      map['credential_ref_id'] = Variable<String>(credentialRefId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceAccountsCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('platformId: $platformId, ')
          ..write('emailIdentityId: $emailIdentityId, ')
          ..write('accountName: $accountName, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('profileUrl: $profileUrl, ')
          ..write('purpose: $purpose, ')
          ..write('status: $status, ')
          ..write('classification: $classification, ')
          ..write('plan: $plan, ')
          ..write('billingCycle: $billingCycle, ')
          ..write('isApiAccount: $isApiAccount, ')
          ..write('notes: $notes, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('lastAccessedAt: $lastAccessedAt, ')
          ..write('credentialRefId: $credentialRefId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrganizationsTable extends Organizations
    with TableInfo<$OrganizationsTable, Organization> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrganizationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _websiteMeta = const VerificationMeta(
    'website',
  );
  @override
  late final GeneratedColumn<String> website = GeneratedColumn<String>(
    'website',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _primaryEmailIdMeta = const VerificationMeta(
    'primaryEmailId',
  );
  @override
  late final GeneratedColumn<String> primaryEmailId = GeneratedColumn<String>(
    'primary_email_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES email_identities (id)',
    ),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    archivedAt,
    id,
    name,
    kind,
    description,
    website,
    primaryEmailId,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'organizations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Organization> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('website')) {
      context.handle(
        _websiteMeta,
        website.isAcceptableOrUnknown(data['website']!, _websiteMeta),
      );
    }
    if (data.containsKey('primary_email_id')) {
      context.handle(
        _primaryEmailIdMeta,
        primaryEmailId.isAcceptableOrUnknown(
          data['primary_email_id']!,
          _primaryEmailIdMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Organization map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Organization(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      website: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}website'],
      ),
      primaryEmailId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_email_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $OrganizationsTable createAlias(String alias) {
    return $OrganizationsTable(attachedDatabase, alias);
  }
}

class Organization extends DataClass implements Insertable<Organization> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  final String id;
  final String name;
  final String kind;
  final String? description;
  final String? website;
  final String? primaryEmailId;
  final String? notes;
  const Organization({
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
    required this.id,
    required this.name,
    required this.kind,
    this.description,
    this.website,
    this.primaryEmailId,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || website != null) {
      map['website'] = Variable<String>(website);
    }
    if (!nullToAbsent || primaryEmailId != null) {
      map['primary_email_id'] = Variable<String>(primaryEmailId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  OrganizationsCompanion toCompanion(bool nullToAbsent) {
    return OrganizationsCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      id: Value(id),
      name: Value(name),
      kind: Value(kind),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      website: website == null && nullToAbsent
          ? const Value.absent()
          : Value(website),
      primaryEmailId: primaryEmailId == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryEmailId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Organization.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Organization(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kind: serializer.fromJson<String>(json['kind']),
      description: serializer.fromJson<String?>(json['description']),
      website: serializer.fromJson<String?>(json['website']),
      primaryEmailId: serializer.fromJson<String?>(json['primaryEmailId']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(kind),
      'description': serializer.toJson<String?>(description),
      'website': serializer.toJson<String?>(website),
      'primaryEmailId': serializer.toJson<String?>(primaryEmailId),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Organization copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> archivedAt = const Value.absent(),
    String? id,
    String? name,
    String? kind,
    Value<String?> description = const Value.absent(),
    Value<String?> website = const Value.absent(),
    Value<String?> primaryEmailId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => Organization(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    description: description.present ? description.value : this.description,
    website: website.present ? website.value : this.website,
    primaryEmailId: primaryEmailId.present
        ? primaryEmailId.value
        : this.primaryEmailId,
    notes: notes.present ? notes.value : this.notes,
  );
  Organization copyWithCompanion(OrganizationsCompanion data) {
    return Organization(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      description: data.description.present
          ? data.description.value
          : this.description,
      website: data.website.present ? data.website.value : this.website,
      primaryEmailId: data.primaryEmailId.present
          ? data.primaryEmailId.value
          : this.primaryEmailId,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Organization(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('description: $description, ')
          ..write('website: $website, ')
          ..write('primaryEmailId: $primaryEmailId, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    createdAt,
    updatedAt,
    archivedAt,
    id,
    name,
    kind,
    description,
    website,
    primaryEmailId,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Organization &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt &&
          other.id == this.id &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.description == this.description &&
          other.website == this.website &&
          other.primaryEmailId == this.primaryEmailId &&
          other.notes == this.notes);
}

class OrganizationsCompanion extends UpdateCompanion<Organization> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<String> id;
  final Value<String> name;
  final Value<String> kind;
  final Value<String?> description;
  final Value<String?> website;
  final Value<String?> primaryEmailId;
  final Value<String?> notes;
  final Value<int> rowid;
  const OrganizationsCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.description = const Value.absent(),
    this.website = const Value.absent(),
    this.primaryEmailId = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrganizationsCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    required String id,
    required String name,
    required String kind,
    this.description = const Value.absent(),
    this.website = const Value.absent(),
    this.primaryEmailId = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       kind = Value(kind);
  static Insertable<Organization> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? archivedAt,
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<String>? description,
    Expression<String>? website,
    Expression<String>? primaryEmailId,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (description != null) 'description': description,
      if (website != null) 'website': website,
      if (primaryEmailId != null) 'primary_email_id': primaryEmailId,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrganizationsCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? archivedAt,
    Value<String>? id,
    Value<String>? name,
    Value<String>? kind,
    Value<String?>? description,
    Value<String?>? website,
    Value<String?>? primaryEmailId,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return OrganizationsCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      description: description ?? this.description,
      website: website ?? this.website,
      primaryEmailId: primaryEmailId ?? this.primaryEmailId,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (website.present) {
      map['website'] = Variable<String>(website.value);
    }
    if (primaryEmailId.present) {
      map['primary_email_id'] = Variable<String>(primaryEmailId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrganizationsCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('description: $description, ')
          ..write('website: $website, ')
          ..write('primaryEmailId: $primaryEmailId, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ArtistsTable extends Artists with TableInfo<$ArtistsTable, Artist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArtistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genreMeta = const VerificationMeta('genre');
  @override
  late final GeneratedColumn<String> genre = GeneratedColumn<String>(
    'genre',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
    'bio',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _labelIdMeta = const VerificationMeta(
    'labelId',
  );
  @override
  late final GeneratedColumn<String> labelId = GeneratedColumn<String>(
    'label_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES organizations (id)',
    ),
  );
  static const VerificationMeta _primaryEmailIdMeta = const VerificationMeta(
    'primaryEmailId',
  );
  @override
  late final GeneratedColumn<String> primaryEmailId = GeneratedColumn<String>(
    'primary_email_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES email_identities (id)',
    ),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    archivedAt,
    id,
    name,
    genre,
    bio,
    labelId,
    primaryEmailId,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'artists';
  @override
  VerificationContext validateIntegrity(
    Insertable<Artist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('genre')) {
      context.handle(
        _genreMeta,
        genre.isAcceptableOrUnknown(data['genre']!, _genreMeta),
      );
    }
    if (data.containsKey('bio')) {
      context.handle(
        _bioMeta,
        bio.isAcceptableOrUnknown(data['bio']!, _bioMeta),
      );
    }
    if (data.containsKey('label_id')) {
      context.handle(
        _labelIdMeta,
        labelId.isAcceptableOrUnknown(data['label_id']!, _labelIdMeta),
      );
    }
    if (data.containsKey('primary_email_id')) {
      context.handle(
        _primaryEmailIdMeta,
        primaryEmailId.isAcceptableOrUnknown(
          data['primary_email_id']!,
          _primaryEmailIdMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Artist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Artist(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      genre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}genre'],
      ),
      bio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bio'],
      ),
      labelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label_id'],
      ),
      primaryEmailId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_email_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $ArtistsTable createAlias(String alias) {
    return $ArtistsTable(attachedDatabase, alias);
  }
}

class Artist extends DataClass implements Insertable<Artist> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  final String id;
  final String name;
  final String? genre;
  final String? bio;
  final String? labelId;
  final String? primaryEmailId;
  final String? notes;
  const Artist({
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
    required this.id,
    required this.name,
    this.genre,
    this.bio,
    this.labelId,
    this.primaryEmailId,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || genre != null) {
      map['genre'] = Variable<String>(genre);
    }
    if (!nullToAbsent || bio != null) {
      map['bio'] = Variable<String>(bio);
    }
    if (!nullToAbsent || labelId != null) {
      map['label_id'] = Variable<String>(labelId);
    }
    if (!nullToAbsent || primaryEmailId != null) {
      map['primary_email_id'] = Variable<String>(primaryEmailId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ArtistsCompanion toCompanion(bool nullToAbsent) {
    return ArtistsCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      id: Value(id),
      name: Value(name),
      genre: genre == null && nullToAbsent
          ? const Value.absent()
          : Value(genre),
      bio: bio == null && nullToAbsent ? const Value.absent() : Value(bio),
      labelId: labelId == null && nullToAbsent
          ? const Value.absent()
          : Value(labelId),
      primaryEmailId: primaryEmailId == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryEmailId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Artist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Artist(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      genre: serializer.fromJson<String?>(json['genre']),
      bio: serializer.fromJson<String?>(json['bio']),
      labelId: serializer.fromJson<String?>(json['labelId']),
      primaryEmailId: serializer.fromJson<String?>(json['primaryEmailId']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'genre': serializer.toJson<String?>(genre),
      'bio': serializer.toJson<String?>(bio),
      'labelId': serializer.toJson<String?>(labelId),
      'primaryEmailId': serializer.toJson<String?>(primaryEmailId),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Artist copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> archivedAt = const Value.absent(),
    String? id,
    String? name,
    Value<String?> genre = const Value.absent(),
    Value<String?> bio = const Value.absent(),
    Value<String?> labelId = const Value.absent(),
    Value<String?> primaryEmailId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => Artist(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    id: id ?? this.id,
    name: name ?? this.name,
    genre: genre.present ? genre.value : this.genre,
    bio: bio.present ? bio.value : this.bio,
    labelId: labelId.present ? labelId.value : this.labelId,
    primaryEmailId: primaryEmailId.present
        ? primaryEmailId.value
        : this.primaryEmailId,
    notes: notes.present ? notes.value : this.notes,
  );
  Artist copyWithCompanion(ArtistsCompanion data) {
    return Artist(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      genre: data.genre.present ? data.genre.value : this.genre,
      bio: data.bio.present ? data.bio.value : this.bio,
      labelId: data.labelId.present ? data.labelId.value : this.labelId,
      primaryEmailId: data.primaryEmailId.present
          ? data.primaryEmailId.value
          : this.primaryEmailId,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Artist(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('genre: $genre, ')
          ..write('bio: $bio, ')
          ..write('labelId: $labelId, ')
          ..write('primaryEmailId: $primaryEmailId, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    createdAt,
    updatedAt,
    archivedAt,
    id,
    name,
    genre,
    bio,
    labelId,
    primaryEmailId,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Artist &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt &&
          other.id == this.id &&
          other.name == this.name &&
          other.genre == this.genre &&
          other.bio == this.bio &&
          other.labelId == this.labelId &&
          other.primaryEmailId == this.primaryEmailId &&
          other.notes == this.notes);
}

class ArtistsCompanion extends UpdateCompanion<Artist> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<String> id;
  final Value<String> name;
  final Value<String?> genre;
  final Value<String?> bio;
  final Value<String?> labelId;
  final Value<String?> primaryEmailId;
  final Value<String?> notes;
  final Value<int> rowid;
  const ArtistsCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.genre = const Value.absent(),
    this.bio = const Value.absent(),
    this.labelId = const Value.absent(),
    this.primaryEmailId = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArtistsCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    required String id,
    required String name,
    this.genre = const Value.absent(),
    this.bio = const Value.absent(),
    this.labelId = const Value.absent(),
    this.primaryEmailId = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Artist> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? archivedAt,
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? genre,
    Expression<String>? bio,
    Expression<String>? labelId,
    Expression<String>? primaryEmailId,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (genre != null) 'genre': genre,
      if (bio != null) 'bio': bio,
      if (labelId != null) 'label_id': labelId,
      if (primaryEmailId != null) 'primary_email_id': primaryEmailId,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArtistsCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? archivedAt,
    Value<String>? id,
    Value<String>? name,
    Value<String?>? genre,
    Value<String?>? bio,
    Value<String?>? labelId,
    Value<String?>? primaryEmailId,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return ArtistsCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      id: id ?? this.id,
      name: name ?? this.name,
      genre: genre ?? this.genre,
      bio: bio ?? this.bio,
      labelId: labelId ?? this.labelId,
      primaryEmailId: primaryEmailId ?? this.primaryEmailId,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (genre.present) {
      map['genre'] = Variable<String>(genre.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (labelId.present) {
      map['label_id'] = Variable<String>(labelId.value);
    }
    if (primaryEmailId.present) {
      map['primary_email_id'] = Variable<String>(primaryEmailId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArtistsCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('genre: $genre, ')
          ..write('bio: $bio, ')
          ..write('labelId: $labelId, ')
          ..write('primaryEmailId: $primaryEmailId, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $YoutubeChannelsTable extends YoutubeChannels
    with TableInfo<$YoutubeChannelsTable, YoutubeChannel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $YoutubeChannelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _handleMeta = const VerificationMeta('handle');
  @override
  late final GeneratedColumn<String> handle = GeneratedColumn<String>(
    'handle',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
    'channel_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _channelTypeMeta = const VerificationMeta(
    'channelType',
  );
  @override
  late final GeneratedColumn<String> channelType = GeneratedColumn<String>(
    'channel_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purposeMeta = const VerificationMeta(
    'purpose',
  );
  @override
  late final GeneratedColumn<String> purpose = GeneratedColumn<String>(
    'purpose',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brandingNotesMeta = const VerificationMeta(
    'brandingNotes',
  );
  @override
  late final GeneratedColumn<String> brandingNotes = GeneratedColumn<String>(
    'branding_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _ownerEmailIdMeta = const VerificationMeta(
    'ownerEmailId',
  );
  @override
  late final GeneratedColumn<String> ownerEmailId = GeneratedColumn<String>(
    'owner_email_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES email_identities (id)',
    ),
  );
  static const VerificationMeta _artistIdMeta = const VerificationMeta(
    'artistId',
  );
  @override
  late final GeneratedColumn<String> artistId = GeneratedColumn<String>(
    'artist_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES artists (id)',
    ),
  );
  static const VerificationMeta _organizationIdMeta = const VerificationMeta(
    'organizationId',
  );
  @override
  late final GeneratedColumn<String> organizationId = GeneratedColumn<String>(
    'organization_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES organizations (id)',
    ),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    archivedAt,
    id,
    name,
    handle,
    channelId,
    url,
    channelType,
    purpose,
    brandingNotes,
    status,
    ownerEmailId,
    artistId,
    organizationId,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'youtube_channels';
  @override
  VerificationContext validateIntegrity(
    Insertable<YoutubeChannel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('handle')) {
      context.handle(
        _handleMeta,
        handle.isAcceptableOrUnknown(data['handle']!, _handleMeta),
      );
    }
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    }
    if (data.containsKey('channel_type')) {
      context.handle(
        _channelTypeMeta,
        channelType.isAcceptableOrUnknown(
          data['channel_type']!,
          _channelTypeMeta,
        ),
      );
    }
    if (data.containsKey('purpose')) {
      context.handle(
        _purposeMeta,
        purpose.isAcceptableOrUnknown(data['purpose']!, _purposeMeta),
      );
    }
    if (data.containsKey('branding_notes')) {
      context.handle(
        _brandingNotesMeta,
        brandingNotes.isAcceptableOrUnknown(
          data['branding_notes']!,
          _brandingNotesMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('owner_email_id')) {
      context.handle(
        _ownerEmailIdMeta,
        ownerEmailId.isAcceptableOrUnknown(
          data['owner_email_id']!,
          _ownerEmailIdMeta,
        ),
      );
    }
    if (data.containsKey('artist_id')) {
      context.handle(
        _artistIdMeta,
        artistId.isAcceptableOrUnknown(data['artist_id']!, _artistIdMeta),
      );
    }
    if (data.containsKey('organization_id')) {
      context.handle(
        _organizationIdMeta,
        organizationId.isAcceptableOrUnknown(
          data['organization_id']!,
          _organizationIdMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  YoutubeChannel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return YoutubeChannel(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      handle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}handle'],
      ),
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_id'],
      ),
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      ),
      channelType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_type'],
      ),
      purpose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purpose'],
      ),
      brandingNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branding_notes'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      ownerEmailId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_email_id'],
      ),
      artistId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artist_id'],
      ),
      organizationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organization_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $YoutubeChannelsTable createAlias(String alias) {
    return $YoutubeChannelsTable(attachedDatabase, alias);
  }
}

class YoutubeChannel extends DataClass implements Insertable<YoutubeChannel> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  final String id;
  final String name;
  final String? handle;
  final String? channelId;
  final String? url;
  final String? channelType;
  final String? purpose;
  final String? brandingNotes;
  final String status;
  final String? ownerEmailId;
  final String? artistId;
  final String? organizationId;
  final String? notes;
  const YoutubeChannel({
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
    required this.id,
    required this.name,
    this.handle,
    this.channelId,
    this.url,
    this.channelType,
    this.purpose,
    this.brandingNotes,
    required this.status,
    this.ownerEmailId,
    this.artistId,
    this.organizationId,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || handle != null) {
      map['handle'] = Variable<String>(handle);
    }
    if (!nullToAbsent || channelId != null) {
      map['channel_id'] = Variable<String>(channelId);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || channelType != null) {
      map['channel_type'] = Variable<String>(channelType);
    }
    if (!nullToAbsent || purpose != null) {
      map['purpose'] = Variable<String>(purpose);
    }
    if (!nullToAbsent || brandingNotes != null) {
      map['branding_notes'] = Variable<String>(brandingNotes);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || ownerEmailId != null) {
      map['owner_email_id'] = Variable<String>(ownerEmailId);
    }
    if (!nullToAbsent || artistId != null) {
      map['artist_id'] = Variable<String>(artistId);
    }
    if (!nullToAbsent || organizationId != null) {
      map['organization_id'] = Variable<String>(organizationId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  YoutubeChannelsCompanion toCompanion(bool nullToAbsent) {
    return YoutubeChannelsCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      id: Value(id),
      name: Value(name),
      handle: handle == null && nullToAbsent
          ? const Value.absent()
          : Value(handle),
      channelId: channelId == null && nullToAbsent
          ? const Value.absent()
          : Value(channelId),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      channelType: channelType == null && nullToAbsent
          ? const Value.absent()
          : Value(channelType),
      purpose: purpose == null && nullToAbsent
          ? const Value.absent()
          : Value(purpose),
      brandingNotes: brandingNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(brandingNotes),
      status: Value(status),
      ownerEmailId: ownerEmailId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerEmailId),
      artistId: artistId == null && nullToAbsent
          ? const Value.absent()
          : Value(artistId),
      organizationId: organizationId == null && nullToAbsent
          ? const Value.absent()
          : Value(organizationId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory YoutubeChannel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return YoutubeChannel(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      handle: serializer.fromJson<String?>(json['handle']),
      channelId: serializer.fromJson<String?>(json['channelId']),
      url: serializer.fromJson<String?>(json['url']),
      channelType: serializer.fromJson<String?>(json['channelType']),
      purpose: serializer.fromJson<String?>(json['purpose']),
      brandingNotes: serializer.fromJson<String?>(json['brandingNotes']),
      status: serializer.fromJson<String>(json['status']),
      ownerEmailId: serializer.fromJson<String?>(json['ownerEmailId']),
      artistId: serializer.fromJson<String?>(json['artistId']),
      organizationId: serializer.fromJson<String?>(json['organizationId']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'handle': serializer.toJson<String?>(handle),
      'channelId': serializer.toJson<String?>(channelId),
      'url': serializer.toJson<String?>(url),
      'channelType': serializer.toJson<String?>(channelType),
      'purpose': serializer.toJson<String?>(purpose),
      'brandingNotes': serializer.toJson<String?>(brandingNotes),
      'status': serializer.toJson<String>(status),
      'ownerEmailId': serializer.toJson<String?>(ownerEmailId),
      'artistId': serializer.toJson<String?>(artistId),
      'organizationId': serializer.toJson<String?>(organizationId),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  YoutubeChannel copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> archivedAt = const Value.absent(),
    String? id,
    String? name,
    Value<String?> handle = const Value.absent(),
    Value<String?> channelId = const Value.absent(),
    Value<String?> url = const Value.absent(),
    Value<String?> channelType = const Value.absent(),
    Value<String?> purpose = const Value.absent(),
    Value<String?> brandingNotes = const Value.absent(),
    String? status,
    Value<String?> ownerEmailId = const Value.absent(),
    Value<String?> artistId = const Value.absent(),
    Value<String?> organizationId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => YoutubeChannel(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    id: id ?? this.id,
    name: name ?? this.name,
    handle: handle.present ? handle.value : this.handle,
    channelId: channelId.present ? channelId.value : this.channelId,
    url: url.present ? url.value : this.url,
    channelType: channelType.present ? channelType.value : this.channelType,
    purpose: purpose.present ? purpose.value : this.purpose,
    brandingNotes: brandingNotes.present
        ? brandingNotes.value
        : this.brandingNotes,
    status: status ?? this.status,
    ownerEmailId: ownerEmailId.present ? ownerEmailId.value : this.ownerEmailId,
    artistId: artistId.present ? artistId.value : this.artistId,
    organizationId: organizationId.present
        ? organizationId.value
        : this.organizationId,
    notes: notes.present ? notes.value : this.notes,
  );
  YoutubeChannel copyWithCompanion(YoutubeChannelsCompanion data) {
    return YoutubeChannel(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      handle: data.handle.present ? data.handle.value : this.handle,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      url: data.url.present ? data.url.value : this.url,
      channelType: data.channelType.present
          ? data.channelType.value
          : this.channelType,
      purpose: data.purpose.present ? data.purpose.value : this.purpose,
      brandingNotes: data.brandingNotes.present
          ? data.brandingNotes.value
          : this.brandingNotes,
      status: data.status.present ? data.status.value : this.status,
      ownerEmailId: data.ownerEmailId.present
          ? data.ownerEmailId.value
          : this.ownerEmailId,
      artistId: data.artistId.present ? data.artistId.value : this.artistId,
      organizationId: data.organizationId.present
          ? data.organizationId.value
          : this.organizationId,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('YoutubeChannel(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('handle: $handle, ')
          ..write('channelId: $channelId, ')
          ..write('url: $url, ')
          ..write('channelType: $channelType, ')
          ..write('purpose: $purpose, ')
          ..write('brandingNotes: $brandingNotes, ')
          ..write('status: $status, ')
          ..write('ownerEmailId: $ownerEmailId, ')
          ..write('artistId: $artistId, ')
          ..write('organizationId: $organizationId, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    createdAt,
    updatedAt,
    archivedAt,
    id,
    name,
    handle,
    channelId,
    url,
    channelType,
    purpose,
    brandingNotes,
    status,
    ownerEmailId,
    artistId,
    organizationId,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is YoutubeChannel &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt &&
          other.id == this.id &&
          other.name == this.name &&
          other.handle == this.handle &&
          other.channelId == this.channelId &&
          other.url == this.url &&
          other.channelType == this.channelType &&
          other.purpose == this.purpose &&
          other.brandingNotes == this.brandingNotes &&
          other.status == this.status &&
          other.ownerEmailId == this.ownerEmailId &&
          other.artistId == this.artistId &&
          other.organizationId == this.organizationId &&
          other.notes == this.notes);
}

class YoutubeChannelsCompanion extends UpdateCompanion<YoutubeChannel> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<String> id;
  final Value<String> name;
  final Value<String?> handle;
  final Value<String?> channelId;
  final Value<String?> url;
  final Value<String?> channelType;
  final Value<String?> purpose;
  final Value<String?> brandingNotes;
  final Value<String> status;
  final Value<String?> ownerEmailId;
  final Value<String?> artistId;
  final Value<String?> organizationId;
  final Value<String?> notes;
  final Value<int> rowid;
  const YoutubeChannelsCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.handle = const Value.absent(),
    this.channelId = const Value.absent(),
    this.url = const Value.absent(),
    this.channelType = const Value.absent(),
    this.purpose = const Value.absent(),
    this.brandingNotes = const Value.absent(),
    this.status = const Value.absent(),
    this.ownerEmailId = const Value.absent(),
    this.artistId = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  YoutubeChannelsCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    required String id,
    required String name,
    this.handle = const Value.absent(),
    this.channelId = const Value.absent(),
    this.url = const Value.absent(),
    this.channelType = const Value.absent(),
    this.purpose = const Value.absent(),
    this.brandingNotes = const Value.absent(),
    this.status = const Value.absent(),
    this.ownerEmailId = const Value.absent(),
    this.artistId = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<YoutubeChannel> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? archivedAt,
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? handle,
    Expression<String>? channelId,
    Expression<String>? url,
    Expression<String>? channelType,
    Expression<String>? purpose,
    Expression<String>? brandingNotes,
    Expression<String>? status,
    Expression<String>? ownerEmailId,
    Expression<String>? artistId,
    Expression<String>? organizationId,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (handle != null) 'handle': handle,
      if (channelId != null) 'channel_id': channelId,
      if (url != null) 'url': url,
      if (channelType != null) 'channel_type': channelType,
      if (purpose != null) 'purpose': purpose,
      if (brandingNotes != null) 'branding_notes': brandingNotes,
      if (status != null) 'status': status,
      if (ownerEmailId != null) 'owner_email_id': ownerEmailId,
      if (artistId != null) 'artist_id': artistId,
      if (organizationId != null) 'organization_id': organizationId,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  YoutubeChannelsCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? archivedAt,
    Value<String>? id,
    Value<String>? name,
    Value<String?>? handle,
    Value<String?>? channelId,
    Value<String?>? url,
    Value<String?>? channelType,
    Value<String?>? purpose,
    Value<String?>? brandingNotes,
    Value<String>? status,
    Value<String?>? ownerEmailId,
    Value<String?>? artistId,
    Value<String?>? organizationId,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return YoutubeChannelsCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      id: id ?? this.id,
      name: name ?? this.name,
      handle: handle ?? this.handle,
      channelId: channelId ?? this.channelId,
      url: url ?? this.url,
      channelType: channelType ?? this.channelType,
      purpose: purpose ?? this.purpose,
      brandingNotes: brandingNotes ?? this.brandingNotes,
      status: status ?? this.status,
      ownerEmailId: ownerEmailId ?? this.ownerEmailId,
      artistId: artistId ?? this.artistId,
      organizationId: organizationId ?? this.organizationId,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (handle.present) {
      map['handle'] = Variable<String>(handle.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (channelType.present) {
      map['channel_type'] = Variable<String>(channelType.value);
    }
    if (purpose.present) {
      map['purpose'] = Variable<String>(purpose.value);
    }
    if (brandingNotes.present) {
      map['branding_notes'] = Variable<String>(brandingNotes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (ownerEmailId.present) {
      map['owner_email_id'] = Variable<String>(ownerEmailId.value);
    }
    if (artistId.present) {
      map['artist_id'] = Variable<String>(artistId.value);
    }
    if (organizationId.present) {
      map['organization_id'] = Variable<String>(organizationId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('YoutubeChannelsCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('handle: $handle, ')
          ..write('channelId: $channelId, ')
          ..write('url: $url, ')
          ..write('channelType: $channelType, ')
          ..write('purpose: $purpose, ')
          ..write('brandingNotes: $brandingNotes, ')
          ..write('status: $status, ')
          ..write('ownerEmailId: $ownerEmailId, ')
          ..write('artistId: $artistId, ')
          ..write('organizationId: $organizationId, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChannelManagersTable extends ChannelManagers
    with TableInfo<$ChannelManagersTable, ChannelManager> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChannelManagersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
    'channel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES youtube_channels (id)',
    ),
  );
  static const VerificationMeta _emailIdentityIdMeta = const VerificationMeta(
    'emailIdentityId',
  );
  @override
  late final GeneratedColumn<String> emailIdentityId = GeneratedColumn<String>(
    'email_identity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES email_identities (id)',
    ),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manager'),
  );
  @override
  List<GeneratedColumn> get $columns => [channelId, emailIdentityId, role];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'channel_managers';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChannelManager> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('email_identity_id')) {
      context.handle(
        _emailIdentityIdMeta,
        emailIdentityId.isAcceptableOrUnknown(
          data['email_identity_id']!,
          _emailIdentityIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_emailIdentityIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {channelId, emailIdentityId};
  @override
  ChannelManager map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChannelManager(
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_id'],
      )!,
      emailIdentityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email_identity_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
    );
  }

  @override
  $ChannelManagersTable createAlias(String alias) {
    return $ChannelManagersTable(attachedDatabase, alias);
  }
}

class ChannelManager extends DataClass implements Insertable<ChannelManager> {
  final String channelId;
  final String emailIdentityId;
  final String role;
  const ChannelManager({
    required this.channelId,
    required this.emailIdentityId,
    required this.role,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['channel_id'] = Variable<String>(channelId);
    map['email_identity_id'] = Variable<String>(emailIdentityId);
    map['role'] = Variable<String>(role);
    return map;
  }

  ChannelManagersCompanion toCompanion(bool nullToAbsent) {
    return ChannelManagersCompanion(
      channelId: Value(channelId),
      emailIdentityId: Value(emailIdentityId),
      role: Value(role),
    );
  }

  factory ChannelManager.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChannelManager(
      channelId: serializer.fromJson<String>(json['channelId']),
      emailIdentityId: serializer.fromJson<String>(json['emailIdentityId']),
      role: serializer.fromJson<String>(json['role']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'channelId': serializer.toJson<String>(channelId),
      'emailIdentityId': serializer.toJson<String>(emailIdentityId),
      'role': serializer.toJson<String>(role),
    };
  }

  ChannelManager copyWith({
    String? channelId,
    String? emailIdentityId,
    String? role,
  }) => ChannelManager(
    channelId: channelId ?? this.channelId,
    emailIdentityId: emailIdentityId ?? this.emailIdentityId,
    role: role ?? this.role,
  );
  ChannelManager copyWithCompanion(ChannelManagersCompanion data) {
    return ChannelManager(
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      emailIdentityId: data.emailIdentityId.present
          ? data.emailIdentityId.value
          : this.emailIdentityId,
      role: data.role.present ? data.role.value : this.role,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChannelManager(')
          ..write('channelId: $channelId, ')
          ..write('emailIdentityId: $emailIdentityId, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(channelId, emailIdentityId, role);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChannelManager &&
          other.channelId == this.channelId &&
          other.emailIdentityId == this.emailIdentityId &&
          other.role == this.role);
}

class ChannelManagersCompanion extends UpdateCompanion<ChannelManager> {
  final Value<String> channelId;
  final Value<String> emailIdentityId;
  final Value<String> role;
  final Value<int> rowid;
  const ChannelManagersCompanion({
    this.channelId = const Value.absent(),
    this.emailIdentityId = const Value.absent(),
    this.role = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChannelManagersCompanion.insert({
    required String channelId,
    required String emailIdentityId,
    this.role = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : channelId = Value(channelId),
       emailIdentityId = Value(emailIdentityId);
  static Insertable<ChannelManager> custom({
    Expression<String>? channelId,
    Expression<String>? emailIdentityId,
    Expression<String>? role,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (channelId != null) 'channel_id': channelId,
      if (emailIdentityId != null) 'email_identity_id': emailIdentityId,
      if (role != null) 'role': role,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChannelManagersCompanion copyWith({
    Value<String>? channelId,
    Value<String>? emailIdentityId,
    Value<String>? role,
    Value<int>? rowid,
  }) {
    return ChannelManagersCompanion(
      channelId: channelId ?? this.channelId,
      emailIdentityId: emailIdentityId ?? this.emailIdentityId,
      role: role ?? this.role,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (emailIdentityId.present) {
      map['email_identity_id'] = Variable<String>(emailIdentityId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelManagersCompanion(')
          ..write('channelId: $channelId, ')
          ..write('emailIdentityId: $emailIdentityId, ')
          ..write('role: $role, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('inProgress'),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _organizationIdMeta = const VerificationMeta(
    'organizationId',
  );
  @override
  late final GeneratedColumn<String> organizationId = GeneratedColumn<String>(
    'organization_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES organizations (id)',
    ),
  );
  static const VerificationMeta _artistIdMeta = const VerificationMeta(
    'artistId',
  );
  @override
  late final GeneratedColumn<String> artistId = GeneratedColumn<String>(
    'artist_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES artists (id)',
    ),
  );
  static const VerificationMeta _classificationMeta = const VerificationMeta(
    'classification',
  );
  @override
  late final GeneratedColumn<String> classification = GeneratedColumn<String>(
    'classification',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('personal'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    archivedAt,
    id,
    name,
    kind,
    status,
    description,
    url,
    organizationId,
    artistId,
    classification,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Project> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    }
    if (data.containsKey('organization_id')) {
      context.handle(
        _organizationIdMeta,
        organizationId.isAcceptableOrUnknown(
          data['organization_id']!,
          _organizationIdMeta,
        ),
      );
    }
    if (data.containsKey('artist_id')) {
      context.handle(
        _artistIdMeta,
        artistId.isAcceptableOrUnknown(data['artist_id']!, _artistIdMeta),
      );
    }
    if (data.containsKey('classification')) {
      context.handle(
        _classificationMeta,
        classification.isAcceptableOrUnknown(
          data['classification']!,
          _classificationMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      ),
      organizationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organization_id'],
      ),
      artistId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artist_id'],
      ),
      classification: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}classification'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Project extends DataClass implements Insertable<Project> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  final String id;
  final String name;
  final String kind;
  final String status;
  final String? description;
  final String? url;
  final String? organizationId;
  final String? artistId;
  final String classification;
  final String? notes;
  const Project({
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
    required this.id,
    required this.name,
    required this.kind,
    required this.status,
    this.description,
    this.url,
    this.organizationId,
    this.artistId,
    required this.classification,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['kind'] = Variable<String>(kind);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || organizationId != null) {
      map['organization_id'] = Variable<String>(organizationId);
    }
    if (!nullToAbsent || artistId != null) {
      map['artist_id'] = Variable<String>(artistId);
    }
    map['classification'] = Variable<String>(classification);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      id: Value(id),
      name: Value(name),
      kind: Value(kind),
      status: Value(status),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      organizationId: organizationId == null && nullToAbsent
          ? const Value.absent()
          : Value(organizationId),
      artistId: artistId == null && nullToAbsent
          ? const Value.absent()
          : Value(artistId),
      classification: Value(classification),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Project.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kind: serializer.fromJson<String>(json['kind']),
      status: serializer.fromJson<String>(json['status']),
      description: serializer.fromJson<String?>(json['description']),
      url: serializer.fromJson<String?>(json['url']),
      organizationId: serializer.fromJson<String?>(json['organizationId']),
      artistId: serializer.fromJson<String?>(json['artistId']),
      classification: serializer.fromJson<String>(json['classification']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(kind),
      'status': serializer.toJson<String>(status),
      'description': serializer.toJson<String?>(description),
      'url': serializer.toJson<String?>(url),
      'organizationId': serializer.toJson<String?>(organizationId),
      'artistId': serializer.toJson<String?>(artistId),
      'classification': serializer.toJson<String>(classification),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Project copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> archivedAt = const Value.absent(),
    String? id,
    String? name,
    String? kind,
    String? status,
    Value<String?> description = const Value.absent(),
    Value<String?> url = const Value.absent(),
    Value<String?> organizationId = const Value.absent(),
    Value<String?> artistId = const Value.absent(),
    String? classification,
    Value<String?> notes = const Value.absent(),
  }) => Project(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    status: status ?? this.status,
    description: description.present ? description.value : this.description,
    url: url.present ? url.value : this.url,
    organizationId: organizationId.present
        ? organizationId.value
        : this.organizationId,
    artistId: artistId.present ? artistId.value : this.artistId,
    classification: classification ?? this.classification,
    notes: notes.present ? notes.value : this.notes,
  );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      status: data.status.present ? data.status.value : this.status,
      description: data.description.present
          ? data.description.value
          : this.description,
      url: data.url.present ? data.url.value : this.url,
      organizationId: data.organizationId.present
          ? data.organizationId.value
          : this.organizationId,
      artistId: data.artistId.present ? data.artistId.value : this.artistId,
      classification: data.classification.present
          ? data.classification.value
          : this.classification,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('status: $status, ')
          ..write('description: $description, ')
          ..write('url: $url, ')
          ..write('organizationId: $organizationId, ')
          ..write('artistId: $artistId, ')
          ..write('classification: $classification, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    createdAt,
    updatedAt,
    archivedAt,
    id,
    name,
    kind,
    status,
    description,
    url,
    organizationId,
    artistId,
    classification,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt &&
          other.id == this.id &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.status == this.status &&
          other.description == this.description &&
          other.url == this.url &&
          other.organizationId == this.organizationId &&
          other.artistId == this.artistId &&
          other.classification == this.classification &&
          other.notes == this.notes);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<String> id;
  final Value<String> name;
  final Value<String> kind;
  final Value<String> status;
  final Value<String?> description;
  final Value<String?> url;
  final Value<String?> organizationId;
  final Value<String?> artistId;
  final Value<String> classification;
  final Value<String?> notes;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.status = const Value.absent(),
    this.description = const Value.absent(),
    this.url = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.artistId = const Value.absent(),
    this.classification = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    required String id,
    required String name,
    required String kind,
    this.status = const Value.absent(),
    this.description = const Value.absent(),
    this.url = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.artistId = const Value.absent(),
    this.classification = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       kind = Value(kind);
  static Insertable<Project> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? archivedAt,
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<String>? status,
    Expression<String>? description,
    Expression<String>? url,
    Expression<String>? organizationId,
    Expression<String>? artistId,
    Expression<String>? classification,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (status != null) 'status': status,
      if (description != null) 'description': description,
      if (url != null) 'url': url,
      if (organizationId != null) 'organization_id': organizationId,
      if (artistId != null) 'artist_id': artistId,
      if (classification != null) 'classification': classification,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? archivedAt,
    Value<String>? id,
    Value<String>? name,
    Value<String>? kind,
    Value<String>? status,
    Value<String?>? description,
    Value<String?>? url,
    Value<String?>? organizationId,
    Value<String?>? artistId,
    Value<String>? classification,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return ProjectsCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      status: status ?? this.status,
      description: description ?? this.description,
      url: url ?? this.url,
      organizationId: organizationId ?? this.organizationId,
      artistId: artistId ?? this.artistId,
      classification: classification ?? this.classification,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (organizationId.present) {
      map['organization_id'] = Variable<String>(organizationId.value);
    }
    if (artistId.present) {
      map['artist_id'] = Variable<String>(artistId.value);
    }
    if (classification.present) {
      map['classification'] = Variable<String>(classification.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('status: $status, ')
          ..write('description: $description, ')
          ..write('url: $url, ')
          ..write('organizationId: $organizationId, ')
          ..write('artistId: $artistId, ')
          ..write('classification: $classification, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LinksTable extends Links with TableInfo<$LinksTable, Link> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromTypeMeta = const VerificationMeta(
    'fromType',
  );
  @override
  late final GeneratedColumn<String> fromType = GeneratedColumn<String>(
    'from_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromIdMeta = const VerificationMeta('fromId');
  @override
  late final GeneratedColumn<String> fromId = GeneratedColumn<String>(
    'from_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toTypeMeta = const VerificationMeta('toType');
  @override
  late final GeneratedColumn<String> toType = GeneratedColumn<String>(
    'to_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toIdMeta = const VerificationMeta('toId');
  @override
  late final GeneratedColumn<String> toId = GeneratedColumn<String>(
    'to_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relationMeta = const VerificationMeta(
    'relation',
  );
  @override
  late final GeneratedColumn<String> relation = GeneratedColumn<String>(
    'relation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('related'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fromType,
    fromId,
    toType,
    toId,
    relation,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'links';
  @override
  VerificationContext validateIntegrity(
    Insertable<Link> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('from_type')) {
      context.handle(
        _fromTypeMeta,
        fromType.isAcceptableOrUnknown(data['from_type']!, _fromTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_fromTypeMeta);
    }
    if (data.containsKey('from_id')) {
      context.handle(
        _fromIdMeta,
        fromId.isAcceptableOrUnknown(data['from_id']!, _fromIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fromIdMeta);
    }
    if (data.containsKey('to_type')) {
      context.handle(
        _toTypeMeta,
        toType.isAcceptableOrUnknown(data['to_type']!, _toTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_toTypeMeta);
    }
    if (data.containsKey('to_id')) {
      context.handle(
        _toIdMeta,
        toId.isAcceptableOrUnknown(data['to_id']!, _toIdMeta),
      );
    } else if (isInserting) {
      context.missing(_toIdMeta);
    }
    if (data.containsKey('relation')) {
      context.handle(
        _relationMeta,
        relation.isAcceptableOrUnknown(data['relation']!, _relationMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {fromType, fromId, toType, toId, relation},
  ];
  @override
  Link map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Link(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fromType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_type'],
      )!,
      fromId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_id'],
      )!,
      toType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_type'],
      )!,
      toId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_id'],
      )!,
      relation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relation'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LinksTable createAlias(String alias) {
    return $LinksTable(attachedDatabase, alias);
  }
}

class Link extends DataClass implements Insertable<Link> {
  final String id;
  final String fromType;
  final String fromId;
  final String toType;
  final String toId;
  final String relation;
  final DateTime createdAt;
  const Link({
    required this.id,
    required this.fromType,
    required this.fromId,
    required this.toType,
    required this.toId,
    required this.relation,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['from_type'] = Variable<String>(fromType);
    map['from_id'] = Variable<String>(fromId);
    map['to_type'] = Variable<String>(toType);
    map['to_id'] = Variable<String>(toId);
    map['relation'] = Variable<String>(relation);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LinksCompanion toCompanion(bool nullToAbsent) {
    return LinksCompanion(
      id: Value(id),
      fromType: Value(fromType),
      fromId: Value(fromId),
      toType: Value(toType),
      toId: Value(toId),
      relation: Value(relation),
      createdAt: Value(createdAt),
    );
  }

  factory Link.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Link(
      id: serializer.fromJson<String>(json['id']),
      fromType: serializer.fromJson<String>(json['fromType']),
      fromId: serializer.fromJson<String>(json['fromId']),
      toType: serializer.fromJson<String>(json['toType']),
      toId: serializer.fromJson<String>(json['toId']),
      relation: serializer.fromJson<String>(json['relation']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fromType': serializer.toJson<String>(fromType),
      'fromId': serializer.toJson<String>(fromId),
      'toType': serializer.toJson<String>(toType),
      'toId': serializer.toJson<String>(toId),
      'relation': serializer.toJson<String>(relation),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Link copyWith({
    String? id,
    String? fromType,
    String? fromId,
    String? toType,
    String? toId,
    String? relation,
    DateTime? createdAt,
  }) => Link(
    id: id ?? this.id,
    fromType: fromType ?? this.fromType,
    fromId: fromId ?? this.fromId,
    toType: toType ?? this.toType,
    toId: toId ?? this.toId,
    relation: relation ?? this.relation,
    createdAt: createdAt ?? this.createdAt,
  );
  Link copyWithCompanion(LinksCompanion data) {
    return Link(
      id: data.id.present ? data.id.value : this.id,
      fromType: data.fromType.present ? data.fromType.value : this.fromType,
      fromId: data.fromId.present ? data.fromId.value : this.fromId,
      toType: data.toType.present ? data.toType.value : this.toType,
      toId: data.toId.present ? data.toId.value : this.toId,
      relation: data.relation.present ? data.relation.value : this.relation,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Link(')
          ..write('id: $id, ')
          ..write('fromType: $fromType, ')
          ..write('fromId: $fromId, ')
          ..write('toType: $toType, ')
          ..write('toId: $toId, ')
          ..write('relation: $relation, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, fromType, fromId, toType, toId, relation, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Link &&
          other.id == this.id &&
          other.fromType == this.fromType &&
          other.fromId == this.fromId &&
          other.toType == this.toType &&
          other.toId == this.toId &&
          other.relation == this.relation &&
          other.createdAt == this.createdAt);
}

class LinksCompanion extends UpdateCompanion<Link> {
  final Value<String> id;
  final Value<String> fromType;
  final Value<String> fromId;
  final Value<String> toType;
  final Value<String> toId;
  final Value<String> relation;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LinksCompanion({
    this.id = const Value.absent(),
    this.fromType = const Value.absent(),
    this.fromId = const Value.absent(),
    this.toType = const Value.absent(),
    this.toId = const Value.absent(),
    this.relation = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LinksCompanion.insert({
    required String id,
    required String fromType,
    required String fromId,
    required String toType,
    required String toId,
    this.relation = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fromType = Value(fromType),
       fromId = Value(fromId),
       toType = Value(toType),
       toId = Value(toId);
  static Insertable<Link> custom({
    Expression<String>? id,
    Expression<String>? fromType,
    Expression<String>? fromId,
    Expression<String>? toType,
    Expression<String>? toId,
    Expression<String>? relation,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromType != null) 'from_type': fromType,
      if (fromId != null) 'from_id': fromId,
      if (toType != null) 'to_type': toType,
      if (toId != null) 'to_id': toId,
      if (relation != null) 'relation': relation,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LinksCompanion copyWith({
    Value<String>? id,
    Value<String>? fromType,
    Value<String>? fromId,
    Value<String>? toType,
    Value<String>? toId,
    Value<String>? relation,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LinksCompanion(
      id: id ?? this.id,
      fromType: fromType ?? this.fromType,
      fromId: fromId ?? this.fromId,
      toType: toType ?? this.toType,
      toId: toId ?? this.toId,
      relation: relation ?? this.relation,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fromType.present) {
      map['from_type'] = Variable<String>(fromType.value);
    }
    if (fromId.present) {
      map['from_id'] = Variable<String>(fromId.value);
    }
    if (toType.present) {
      map['to_type'] = Variable<String>(toType.value);
    }
    if (toId.present) {
      map['to_id'] = Variable<String>(toId.value);
    }
    if (relation.present) {
      map['relation'] = Variable<String>(relation.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LinksCompanion(')
          ..write('id: $id, ')
          ..write('fromType: $fromType, ')
          ..write('fromId: $fromId, ')
          ..write('toType: $toType, ')
          ..write('toId: $toId, ')
          ..write('relation: $relation, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, color];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      ),
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final String id;
  final String name;
  final int? color;
  const Tag({required this.id, required this.name, this.color});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      name: Value(name),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
    );
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int?>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int?>(color),
    };
  }

  Tag copyWith({
    String? id,
    String? name,
    Value<int?> color = const Value.absent(),
  }) => Tag(
    id: id ?? this.id,
    name: name ?? this.name,
    color: color.present ? color.value : this.color,
  );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<String> id;
  final Value<String> name;
  final Value<int?> color;
  final Value<int> rowid;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagsCompanion.insert({
    required String id,
    required String name,
    this.color = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Tag> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? color,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int?>? color,
    Value<int>? rowid,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagLinksTable extends TagLinks with TableInfo<$TagLinksTable, TagLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id)',
    ),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [tagId, entityType, entityId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tag_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<TagLink> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tagId, entityType, entityId};
  @override
  TagLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TagLink(
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
    );
  }

  @override
  $TagLinksTable createAlias(String alias) {
    return $TagLinksTable(attachedDatabase, alias);
  }
}

class TagLink extends DataClass implements Insertable<TagLink> {
  final String tagId;
  final String entityType;
  final String entityId;
  const TagLink({
    required this.tagId,
    required this.entityType,
    required this.entityId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tag_id'] = Variable<String>(tagId);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    return map;
  }

  TagLinksCompanion toCompanion(bool nullToAbsent) {
    return TagLinksCompanion(
      tagId: Value(tagId),
      entityType: Value(entityType),
      entityId: Value(entityId),
    );
  }

  factory TagLink.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TagLink(
      tagId: serializer.fromJson<String>(json['tagId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tagId': serializer.toJson<String>(tagId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
    };
  }

  TagLink copyWith({String? tagId, String? entityType, String? entityId}) =>
      TagLink(
        tagId: tagId ?? this.tagId,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
      );
  TagLink copyWithCompanion(TagLinksCompanion data) {
    return TagLink(
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TagLink(')
          ..write('tagId: $tagId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tagId, entityType, entityId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagLink &&
          other.tagId == this.tagId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId);
}

class TagLinksCompanion extends UpdateCompanion<TagLink> {
  final Value<String> tagId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<int> rowid;
  const TagLinksCompanion({
    this.tagId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagLinksCompanion.insert({
    required String tagId,
    required String entityType,
    required String entityId,
    this.rowid = const Value.absent(),
  }) : tagId = Value(tagId),
       entityType = Value(entityType),
       entityId = Value(entityId);
  static Insertable<TagLink> custom({
    Expression<String>? tagId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tagId != null) 'tag_id': tagId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagLinksCompanion copyWith({
    Value<String>? tagId,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<int>? rowid,
  }) {
    return TagLinksCompanion(
      tagId: tagId ?? this.tagId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagLinksCompanion(')
          ..write('tagId: $tagId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomFieldsTable extends CustomFields
    with TableInfo<$CustomFieldsTable, CustomField> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomFieldsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    label,
    value,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_fields';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomField> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomField map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomField(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CustomFieldsTable createAlias(String alias) {
    return $CustomFieldsTable(attachedDatabase, alias);
  }
}

class CustomField extends DataClass implements Insertable<CustomField> {
  final String id;
  final String entityType;
  final String entityId;
  final String label;
  final String value;
  final int sortOrder;
  const CustomField({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.label,
    required this.value,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['label'] = Variable<String>(label);
    map['value'] = Variable<String>(value);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CustomFieldsCompanion toCompanion(bool nullToAbsent) {
    return CustomFieldsCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      label: Value(label),
      value: Value(value),
      sortOrder: Value(sortOrder),
    );
  }

  factory CustomField.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomField(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      label: serializer.fromJson<String>(json['label']),
      value: serializer.fromJson<String>(json['value']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'label': serializer.toJson<String>(label),
      'value': serializer.toJson<String>(value),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  CustomField copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? label,
    String? value,
    int? sortOrder,
  }) => CustomField(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    label: label ?? this.label,
    value: value ?? this.value,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  CustomField copyWithCompanion(CustomFieldsCompanion data) {
    return CustomField(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      label: data.label.present ? data.label.value : this.label,
      value: data.value.present ? data.value.value : this.value,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomField(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('label: $label, ')
          ..write('value: $value, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, entityType, entityId, label, value, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomField &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.label == this.label &&
          other.value == this.value &&
          other.sortOrder == this.sortOrder);
}

class CustomFieldsCompanion extends UpdateCompanion<CustomField> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> label;
  final Value<String> value;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const CustomFieldsCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.label = const Value.absent(),
    this.value = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomFieldsCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    required String label,
    required String value,
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityType = Value(entityType),
       entityId = Value(entityId),
       label = Value(label),
       value = Value(value);
  static Insertable<CustomField> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? label,
    Expression<String>? value,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (label != null) 'label': label,
      if (value != null) 'value': value,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomFieldsCompanion copyWith({
    Value<String>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? label,
    Value<String>? value,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return CustomFieldsCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      label: label ?? this.label,
      value: value ?? this.value,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomFieldsCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('label: $label, ')
          ..write('value: $value, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BankAccountsTable extends BankAccounts
    with TableInfo<$BankAccountsTable, BankAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BankAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bankNameMeta = const VerificationMeta(
    'bankName',
  );
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
    'bank_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _platformIdMeta = const VerificationMeta(
    'platformId',
  );
  @override
  late final GeneratedColumn<String> platformId = GeneratedColumn<String>(
    'platform_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES platforms (id)',
    ),
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _holderNameMeta = const VerificationMeta(
    'holderName',
  );
  @override
  late final GeneratedColumn<String> holderName = GeneratedColumn<String>(
    'holder_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountTypeMeta = const VerificationMeta(
    'accountType',
  );
  @override
  late final GeneratedColumn<String> accountType = GeneratedColumn<String>(
    'account_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _last4Meta = const VerificationMeta('last4');
  @override
  late final GeneratedColumn<String> last4 = GeneratedColumn<String>(
    'last4',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ifscMeta = const VerificationMeta('ifsc');
  @override
  late final GeneratedColumn<String> ifsc = GeneratedColumn<String>(
    'ifsc',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _branchMeta = const VerificationMeta('branch');
  @override
  late final GeneratedColumn<String> branch = GeneratedColumn<String>(
    'branch',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _swiftMeta = const VerificationMeta('swift');
  @override
  late final GeneratedColumn<String> swift = GeneratedColumn<String>(
    'swift',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _routingMeta = const VerificationMeta(
    'routing',
  );
  @override
  late final GeneratedColumn<String> routing = GeneratedColumn<String>(
    'routing',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _netbankingUsernameMeta =
      const VerificationMeta('netbankingUsername');
  @override
  late final GeneratedColumn<String> netbankingUsername =
      GeneratedColumn<String>(
        'netbanking_username',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _websiteMeta = const VerificationMeta(
    'website',
  );
  @override
  late final GeneratedColumn<String> website = GeneratedColumn<String>(
    'website',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _organizationIdMeta = const VerificationMeta(
    'organizationId',
  );
  @override
  late final GeneratedColumn<String> organizationId = GeneratedColumn<String>(
    'organization_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES organizations (id)',
    ),
  );
  static const VerificationMeta _classificationMeta = const VerificationMeta(
    'classification',
  );
  @override
  late final GeneratedColumn<String> classification = GeneratedColumn<String>(
    'classification',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('personal'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fullNumberVaultIdMeta = const VerificationMeta(
    'fullNumberVaultId',
  );
  @override
  late final GeneratedColumn<String> fullNumberVaultId =
      GeneratedColumn<String>(
        'full_number_vault_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES secure_items (id)',
        ),
      );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    archivedAt,
    id,
    bankName,
    platformId,
    nickname,
    holderName,
    accountType,
    last4,
    ifsc,
    branch,
    swift,
    routing,
    netbankingUsername,
    website,
    currency,
    organizationId,
    classification,
    notes,
    fullNumberVaultId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bank_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<BankAccount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bank_name')) {
      context.handle(
        _bankNameMeta,
        bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta),
      );
    } else if (isInserting) {
      context.missing(_bankNameMeta);
    }
    if (data.containsKey('platform_id')) {
      context.handle(
        _platformIdMeta,
        platformId.isAcceptableOrUnknown(data['platform_id']!, _platformIdMeta),
      );
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('holder_name')) {
      context.handle(
        _holderNameMeta,
        holderName.isAcceptableOrUnknown(data['holder_name']!, _holderNameMeta),
      );
    }
    if (data.containsKey('account_type')) {
      context.handle(
        _accountTypeMeta,
        accountType.isAcceptableOrUnknown(
          data['account_type']!,
          _accountTypeMeta,
        ),
      );
    }
    if (data.containsKey('last4')) {
      context.handle(
        _last4Meta,
        last4.isAcceptableOrUnknown(data['last4']!, _last4Meta),
      );
    }
    if (data.containsKey('ifsc')) {
      context.handle(
        _ifscMeta,
        ifsc.isAcceptableOrUnknown(data['ifsc']!, _ifscMeta),
      );
    }
    if (data.containsKey('branch')) {
      context.handle(
        _branchMeta,
        branch.isAcceptableOrUnknown(data['branch']!, _branchMeta),
      );
    }
    if (data.containsKey('swift')) {
      context.handle(
        _swiftMeta,
        swift.isAcceptableOrUnknown(data['swift']!, _swiftMeta),
      );
    }
    if (data.containsKey('routing')) {
      context.handle(
        _routingMeta,
        routing.isAcceptableOrUnknown(data['routing']!, _routingMeta),
      );
    }
    if (data.containsKey('netbanking_username')) {
      context.handle(
        _netbankingUsernameMeta,
        netbankingUsername.isAcceptableOrUnknown(
          data['netbanking_username']!,
          _netbankingUsernameMeta,
        ),
      );
    }
    if (data.containsKey('website')) {
      context.handle(
        _websiteMeta,
        website.isAcceptableOrUnknown(data['website']!, _websiteMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('organization_id')) {
      context.handle(
        _organizationIdMeta,
        organizationId.isAcceptableOrUnknown(
          data['organization_id']!,
          _organizationIdMeta,
        ),
      );
    }
    if (data.containsKey('classification')) {
      context.handle(
        _classificationMeta,
        classification.isAcceptableOrUnknown(
          data['classification']!,
          _classificationMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('full_number_vault_id')) {
      context.handle(
        _fullNumberVaultIdMeta,
        fullNumberVaultId.isAcceptableOrUnknown(
          data['full_number_vault_id']!,
          _fullNumberVaultIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BankAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BankAccount(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bankName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_name'],
      )!,
      platformId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform_id'],
      ),
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      )!,
      holderName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}holder_name'],
      ),
      accountType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_type'],
      ),
      last4: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last4'],
      ),
      ifsc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ifsc'],
      ),
      branch: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch'],
      ),
      swift: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}swift'],
      ),
      routing: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}routing'],
      ),
      netbankingUsername: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}netbanking_username'],
      ),
      website: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}website'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      organizationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organization_id'],
      ),
      classification: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}classification'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      fullNumberVaultId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_number_vault_id'],
      ),
    );
  }

  @override
  $BankAccountsTable createAlias(String alias) {
    return $BankAccountsTable(attachedDatabase, alias);
  }
}

class BankAccount extends DataClass implements Insertable<BankAccount> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  final String id;
  final String bankName;
  final String? platformId;
  final String nickname;
  final String? holderName;
  final String? accountType;
  final String? last4;
  final String? ifsc;
  final String? branch;
  final String? swift;
  final String? routing;
  final String? netbankingUsername;
  final String? website;
  final String currency;
  final String? organizationId;
  final String classification;
  final String? notes;
  final String? fullNumberVaultId;
  const BankAccount({
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
    required this.id,
    required this.bankName,
    this.platformId,
    required this.nickname,
    this.holderName,
    this.accountType,
    this.last4,
    this.ifsc,
    this.branch,
    this.swift,
    this.routing,
    this.netbankingUsername,
    this.website,
    required this.currency,
    this.organizationId,
    required this.classification,
    this.notes,
    this.fullNumberVaultId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['id'] = Variable<String>(id);
    map['bank_name'] = Variable<String>(bankName);
    if (!nullToAbsent || platformId != null) {
      map['platform_id'] = Variable<String>(platformId);
    }
    map['nickname'] = Variable<String>(nickname);
    if (!nullToAbsent || holderName != null) {
      map['holder_name'] = Variable<String>(holderName);
    }
    if (!nullToAbsent || accountType != null) {
      map['account_type'] = Variable<String>(accountType);
    }
    if (!nullToAbsent || last4 != null) {
      map['last4'] = Variable<String>(last4);
    }
    if (!nullToAbsent || ifsc != null) {
      map['ifsc'] = Variable<String>(ifsc);
    }
    if (!nullToAbsent || branch != null) {
      map['branch'] = Variable<String>(branch);
    }
    if (!nullToAbsent || swift != null) {
      map['swift'] = Variable<String>(swift);
    }
    if (!nullToAbsent || routing != null) {
      map['routing'] = Variable<String>(routing);
    }
    if (!nullToAbsent || netbankingUsername != null) {
      map['netbanking_username'] = Variable<String>(netbankingUsername);
    }
    if (!nullToAbsent || website != null) {
      map['website'] = Variable<String>(website);
    }
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || organizationId != null) {
      map['organization_id'] = Variable<String>(organizationId);
    }
    map['classification'] = Variable<String>(classification);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || fullNumberVaultId != null) {
      map['full_number_vault_id'] = Variable<String>(fullNumberVaultId);
    }
    return map;
  }

  BankAccountsCompanion toCompanion(bool nullToAbsent) {
    return BankAccountsCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      id: Value(id),
      bankName: Value(bankName),
      platformId: platformId == null && nullToAbsent
          ? const Value.absent()
          : Value(platformId),
      nickname: Value(nickname),
      holderName: holderName == null && nullToAbsent
          ? const Value.absent()
          : Value(holderName),
      accountType: accountType == null && nullToAbsent
          ? const Value.absent()
          : Value(accountType),
      last4: last4 == null && nullToAbsent
          ? const Value.absent()
          : Value(last4),
      ifsc: ifsc == null && nullToAbsent ? const Value.absent() : Value(ifsc),
      branch: branch == null && nullToAbsent
          ? const Value.absent()
          : Value(branch),
      swift: swift == null && nullToAbsent
          ? const Value.absent()
          : Value(swift),
      routing: routing == null && nullToAbsent
          ? const Value.absent()
          : Value(routing),
      netbankingUsername: netbankingUsername == null && nullToAbsent
          ? const Value.absent()
          : Value(netbankingUsername),
      website: website == null && nullToAbsent
          ? const Value.absent()
          : Value(website),
      currency: Value(currency),
      organizationId: organizationId == null && nullToAbsent
          ? const Value.absent()
          : Value(organizationId),
      classification: Value(classification),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      fullNumberVaultId: fullNumberVaultId == null && nullToAbsent
          ? const Value.absent()
          : Value(fullNumberVaultId),
    );
  }

  factory BankAccount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BankAccount(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      id: serializer.fromJson<String>(json['id']),
      bankName: serializer.fromJson<String>(json['bankName']),
      platformId: serializer.fromJson<String?>(json['platformId']),
      nickname: serializer.fromJson<String>(json['nickname']),
      holderName: serializer.fromJson<String?>(json['holderName']),
      accountType: serializer.fromJson<String?>(json['accountType']),
      last4: serializer.fromJson<String?>(json['last4']),
      ifsc: serializer.fromJson<String?>(json['ifsc']),
      branch: serializer.fromJson<String?>(json['branch']),
      swift: serializer.fromJson<String?>(json['swift']),
      routing: serializer.fromJson<String?>(json['routing']),
      netbankingUsername: serializer.fromJson<String?>(
        json['netbankingUsername'],
      ),
      website: serializer.fromJson<String?>(json['website']),
      currency: serializer.fromJson<String>(json['currency']),
      organizationId: serializer.fromJson<String?>(json['organizationId']),
      classification: serializer.fromJson<String>(json['classification']),
      notes: serializer.fromJson<String?>(json['notes']),
      fullNumberVaultId: serializer.fromJson<String?>(
        json['fullNumberVaultId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'id': serializer.toJson<String>(id),
      'bankName': serializer.toJson<String>(bankName),
      'platformId': serializer.toJson<String?>(platformId),
      'nickname': serializer.toJson<String>(nickname),
      'holderName': serializer.toJson<String?>(holderName),
      'accountType': serializer.toJson<String?>(accountType),
      'last4': serializer.toJson<String?>(last4),
      'ifsc': serializer.toJson<String?>(ifsc),
      'branch': serializer.toJson<String?>(branch),
      'swift': serializer.toJson<String?>(swift),
      'routing': serializer.toJson<String?>(routing),
      'netbankingUsername': serializer.toJson<String?>(netbankingUsername),
      'website': serializer.toJson<String?>(website),
      'currency': serializer.toJson<String>(currency),
      'organizationId': serializer.toJson<String?>(organizationId),
      'classification': serializer.toJson<String>(classification),
      'notes': serializer.toJson<String?>(notes),
      'fullNumberVaultId': serializer.toJson<String?>(fullNumberVaultId),
    };
  }

  BankAccount copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> archivedAt = const Value.absent(),
    String? id,
    String? bankName,
    Value<String?> platformId = const Value.absent(),
    String? nickname,
    Value<String?> holderName = const Value.absent(),
    Value<String?> accountType = const Value.absent(),
    Value<String?> last4 = const Value.absent(),
    Value<String?> ifsc = const Value.absent(),
    Value<String?> branch = const Value.absent(),
    Value<String?> swift = const Value.absent(),
    Value<String?> routing = const Value.absent(),
    Value<String?> netbankingUsername = const Value.absent(),
    Value<String?> website = const Value.absent(),
    String? currency,
    Value<String?> organizationId = const Value.absent(),
    String? classification,
    Value<String?> notes = const Value.absent(),
    Value<String?> fullNumberVaultId = const Value.absent(),
  }) => BankAccount(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    id: id ?? this.id,
    bankName: bankName ?? this.bankName,
    platformId: platformId.present ? platformId.value : this.platformId,
    nickname: nickname ?? this.nickname,
    holderName: holderName.present ? holderName.value : this.holderName,
    accountType: accountType.present ? accountType.value : this.accountType,
    last4: last4.present ? last4.value : this.last4,
    ifsc: ifsc.present ? ifsc.value : this.ifsc,
    branch: branch.present ? branch.value : this.branch,
    swift: swift.present ? swift.value : this.swift,
    routing: routing.present ? routing.value : this.routing,
    netbankingUsername: netbankingUsername.present
        ? netbankingUsername.value
        : this.netbankingUsername,
    website: website.present ? website.value : this.website,
    currency: currency ?? this.currency,
    organizationId: organizationId.present
        ? organizationId.value
        : this.organizationId,
    classification: classification ?? this.classification,
    notes: notes.present ? notes.value : this.notes,
    fullNumberVaultId: fullNumberVaultId.present
        ? fullNumberVaultId.value
        : this.fullNumberVaultId,
  );
  BankAccount copyWithCompanion(BankAccountsCompanion data) {
    return BankAccount(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      id: data.id.present ? data.id.value : this.id,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
      platformId: data.platformId.present
          ? data.platformId.value
          : this.platformId,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      holderName: data.holderName.present
          ? data.holderName.value
          : this.holderName,
      accountType: data.accountType.present
          ? data.accountType.value
          : this.accountType,
      last4: data.last4.present ? data.last4.value : this.last4,
      ifsc: data.ifsc.present ? data.ifsc.value : this.ifsc,
      branch: data.branch.present ? data.branch.value : this.branch,
      swift: data.swift.present ? data.swift.value : this.swift,
      routing: data.routing.present ? data.routing.value : this.routing,
      netbankingUsername: data.netbankingUsername.present
          ? data.netbankingUsername.value
          : this.netbankingUsername,
      website: data.website.present ? data.website.value : this.website,
      currency: data.currency.present ? data.currency.value : this.currency,
      organizationId: data.organizationId.present
          ? data.organizationId.value
          : this.organizationId,
      classification: data.classification.present
          ? data.classification.value
          : this.classification,
      notes: data.notes.present ? data.notes.value : this.notes,
      fullNumberVaultId: data.fullNumberVaultId.present
          ? data.fullNumberVaultId.value
          : this.fullNumberVaultId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BankAccount(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('bankName: $bankName, ')
          ..write('platformId: $platformId, ')
          ..write('nickname: $nickname, ')
          ..write('holderName: $holderName, ')
          ..write('accountType: $accountType, ')
          ..write('last4: $last4, ')
          ..write('ifsc: $ifsc, ')
          ..write('branch: $branch, ')
          ..write('swift: $swift, ')
          ..write('routing: $routing, ')
          ..write('netbankingUsername: $netbankingUsername, ')
          ..write('website: $website, ')
          ..write('currency: $currency, ')
          ..write('organizationId: $organizationId, ')
          ..write('classification: $classification, ')
          ..write('notes: $notes, ')
          ..write('fullNumberVaultId: $fullNumberVaultId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    createdAt,
    updatedAt,
    archivedAt,
    id,
    bankName,
    platformId,
    nickname,
    holderName,
    accountType,
    last4,
    ifsc,
    branch,
    swift,
    routing,
    netbankingUsername,
    website,
    currency,
    organizationId,
    classification,
    notes,
    fullNumberVaultId,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BankAccount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt &&
          other.id == this.id &&
          other.bankName == this.bankName &&
          other.platformId == this.platformId &&
          other.nickname == this.nickname &&
          other.holderName == this.holderName &&
          other.accountType == this.accountType &&
          other.last4 == this.last4 &&
          other.ifsc == this.ifsc &&
          other.branch == this.branch &&
          other.swift == this.swift &&
          other.routing == this.routing &&
          other.netbankingUsername == this.netbankingUsername &&
          other.website == this.website &&
          other.currency == this.currency &&
          other.organizationId == this.organizationId &&
          other.classification == this.classification &&
          other.notes == this.notes &&
          other.fullNumberVaultId == this.fullNumberVaultId);
}

class BankAccountsCompanion extends UpdateCompanion<BankAccount> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<String> id;
  final Value<String> bankName;
  final Value<String?> platformId;
  final Value<String> nickname;
  final Value<String?> holderName;
  final Value<String?> accountType;
  final Value<String?> last4;
  final Value<String?> ifsc;
  final Value<String?> branch;
  final Value<String?> swift;
  final Value<String?> routing;
  final Value<String?> netbankingUsername;
  final Value<String?> website;
  final Value<String> currency;
  final Value<String?> organizationId;
  final Value<String> classification;
  final Value<String?> notes;
  final Value<String?> fullNumberVaultId;
  final Value<int> rowid;
  const BankAccountsCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.bankName = const Value.absent(),
    this.platformId = const Value.absent(),
    this.nickname = const Value.absent(),
    this.holderName = const Value.absent(),
    this.accountType = const Value.absent(),
    this.last4 = const Value.absent(),
    this.ifsc = const Value.absent(),
    this.branch = const Value.absent(),
    this.swift = const Value.absent(),
    this.routing = const Value.absent(),
    this.netbankingUsername = const Value.absent(),
    this.website = const Value.absent(),
    this.currency = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.classification = const Value.absent(),
    this.notes = const Value.absent(),
    this.fullNumberVaultId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BankAccountsCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    required String id,
    required String bankName,
    this.platformId = const Value.absent(),
    required String nickname,
    this.holderName = const Value.absent(),
    this.accountType = const Value.absent(),
    this.last4 = const Value.absent(),
    this.ifsc = const Value.absent(),
    this.branch = const Value.absent(),
    this.swift = const Value.absent(),
    this.routing = const Value.absent(),
    this.netbankingUsername = const Value.absent(),
    this.website = const Value.absent(),
    this.currency = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.classification = const Value.absent(),
    this.notes = const Value.absent(),
    this.fullNumberVaultId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bankName = Value(bankName),
       nickname = Value(nickname);
  static Insertable<BankAccount> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? archivedAt,
    Expression<String>? id,
    Expression<String>? bankName,
    Expression<String>? platformId,
    Expression<String>? nickname,
    Expression<String>? holderName,
    Expression<String>? accountType,
    Expression<String>? last4,
    Expression<String>? ifsc,
    Expression<String>? branch,
    Expression<String>? swift,
    Expression<String>? routing,
    Expression<String>? netbankingUsername,
    Expression<String>? website,
    Expression<String>? currency,
    Expression<String>? organizationId,
    Expression<String>? classification,
    Expression<String>? notes,
    Expression<String>? fullNumberVaultId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (id != null) 'id': id,
      if (bankName != null) 'bank_name': bankName,
      if (platformId != null) 'platform_id': platformId,
      if (nickname != null) 'nickname': nickname,
      if (holderName != null) 'holder_name': holderName,
      if (accountType != null) 'account_type': accountType,
      if (last4 != null) 'last4': last4,
      if (ifsc != null) 'ifsc': ifsc,
      if (branch != null) 'branch': branch,
      if (swift != null) 'swift': swift,
      if (routing != null) 'routing': routing,
      if (netbankingUsername != null) 'netbanking_username': netbankingUsername,
      if (website != null) 'website': website,
      if (currency != null) 'currency': currency,
      if (organizationId != null) 'organization_id': organizationId,
      if (classification != null) 'classification': classification,
      if (notes != null) 'notes': notes,
      if (fullNumberVaultId != null) 'full_number_vault_id': fullNumberVaultId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BankAccountsCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? archivedAt,
    Value<String>? id,
    Value<String>? bankName,
    Value<String?>? platformId,
    Value<String>? nickname,
    Value<String?>? holderName,
    Value<String?>? accountType,
    Value<String?>? last4,
    Value<String?>? ifsc,
    Value<String?>? branch,
    Value<String?>? swift,
    Value<String?>? routing,
    Value<String?>? netbankingUsername,
    Value<String?>? website,
    Value<String>? currency,
    Value<String?>? organizationId,
    Value<String>? classification,
    Value<String?>? notes,
    Value<String?>? fullNumberVaultId,
    Value<int>? rowid,
  }) {
    return BankAccountsCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      id: id ?? this.id,
      bankName: bankName ?? this.bankName,
      platformId: platformId ?? this.platformId,
      nickname: nickname ?? this.nickname,
      holderName: holderName ?? this.holderName,
      accountType: accountType ?? this.accountType,
      last4: last4 ?? this.last4,
      ifsc: ifsc ?? this.ifsc,
      branch: branch ?? this.branch,
      swift: swift ?? this.swift,
      routing: routing ?? this.routing,
      netbankingUsername: netbankingUsername ?? this.netbankingUsername,
      website: website ?? this.website,
      currency: currency ?? this.currency,
      organizationId: organizationId ?? this.organizationId,
      classification: classification ?? this.classification,
      notes: notes ?? this.notes,
      fullNumberVaultId: fullNumberVaultId ?? this.fullNumberVaultId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (platformId.present) {
      map['platform_id'] = Variable<String>(platformId.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (holderName.present) {
      map['holder_name'] = Variable<String>(holderName.value);
    }
    if (accountType.present) {
      map['account_type'] = Variable<String>(accountType.value);
    }
    if (last4.present) {
      map['last4'] = Variable<String>(last4.value);
    }
    if (ifsc.present) {
      map['ifsc'] = Variable<String>(ifsc.value);
    }
    if (branch.present) {
      map['branch'] = Variable<String>(branch.value);
    }
    if (swift.present) {
      map['swift'] = Variable<String>(swift.value);
    }
    if (routing.present) {
      map['routing'] = Variable<String>(routing.value);
    }
    if (netbankingUsername.present) {
      map['netbanking_username'] = Variable<String>(netbankingUsername.value);
    }
    if (website.present) {
      map['website'] = Variable<String>(website.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (organizationId.present) {
      map['organization_id'] = Variable<String>(organizationId.value);
    }
    if (classification.present) {
      map['classification'] = Variable<String>(classification.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (fullNumberVaultId.present) {
      map['full_number_vault_id'] = Variable<String>(fullNumberVaultId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BankAccountsCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('bankName: $bankName, ')
          ..write('platformId: $platformId, ')
          ..write('nickname: $nickname, ')
          ..write('holderName: $holderName, ')
          ..write('accountType: $accountType, ')
          ..write('last4: $last4, ')
          ..write('ifsc: $ifsc, ')
          ..write('branch: $branch, ')
          ..write('swift: $swift, ')
          ..write('routing: $routing, ')
          ..write('netbankingUsername: $netbankingUsername, ')
          ..write('website: $website, ')
          ..write('currency: $currency, ')
          ..write('organizationId: $organizationId, ')
          ..write('classification: $classification, ')
          ..write('notes: $notes, ')
          ..write('fullNumberVaultId: $fullNumberVaultId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentCardsTable extends PaymentCards
    with TableInfo<$PaymentCardsTable, PaymentCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _issuingBankMeta = const VerificationMeta(
    'issuingBank',
  );
  @override
  late final GeneratedColumn<String> issuingBank = GeneratedColumn<String>(
    'issuing_bank',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _networkMeta = const VerificationMeta(
    'network',
  );
  @override
  late final GeneratedColumn<String> network = GeneratedColumn<String>(
    'network',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('debit'),
  );
  static const VerificationMeta _last4Meta = const VerificationMeta('last4');
  @override
  late final GeneratedColumn<String> last4 = GeneratedColumn<String>(
    'last4',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expMonthMeta = const VerificationMeta(
    'expMonth',
  );
  @override
  late final GeneratedColumn<int> expMonth = GeneratedColumn<int>(
    'exp_month',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expYearMeta = const VerificationMeta(
    'expYear',
  );
  @override
  late final GeneratedColumn<int> expYear = GeneratedColumn<int>(
    'exp_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bankAccountIdMeta = const VerificationMeta(
    'bankAccountId',
  );
  @override
  late final GeneratedColumn<String> bankAccountId = GeneratedColumn<String>(
    'bank_account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bank_accounts (id)',
    ),
  );
  static const VerificationMeta _classificationMeta = const VerificationMeta(
    'classification',
  );
  @override
  late final GeneratedColumn<String> classification = GeneratedColumn<String>(
    'classification',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('personal'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    archivedAt,
    id,
    nickname,
    issuingBank,
    network,
    kind,
    last4,
    expMonth,
    expYear,
    bankAccountId,
    classification,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentCard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('issuing_bank')) {
      context.handle(
        _issuingBankMeta,
        issuingBank.isAcceptableOrUnknown(
          data['issuing_bank']!,
          _issuingBankMeta,
        ),
      );
    }
    if (data.containsKey('network')) {
      context.handle(
        _networkMeta,
        network.isAcceptableOrUnknown(data['network']!, _networkMeta),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('last4')) {
      context.handle(
        _last4Meta,
        last4.isAcceptableOrUnknown(data['last4']!, _last4Meta),
      );
    }
    if (data.containsKey('exp_month')) {
      context.handle(
        _expMonthMeta,
        expMonth.isAcceptableOrUnknown(data['exp_month']!, _expMonthMeta),
      );
    }
    if (data.containsKey('exp_year')) {
      context.handle(
        _expYearMeta,
        expYear.isAcceptableOrUnknown(data['exp_year']!, _expYearMeta),
      );
    }
    if (data.containsKey('bank_account_id')) {
      context.handle(
        _bankAccountIdMeta,
        bankAccountId.isAcceptableOrUnknown(
          data['bank_account_id']!,
          _bankAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('classification')) {
      context.handle(
        _classificationMeta,
        classification.isAcceptableOrUnknown(
          data['classification']!,
          _classificationMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentCard(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      )!,
      issuingBank: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}issuing_bank'],
      ),
      network: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}network'],
      ),
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      last4: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last4'],
      ),
      expMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exp_month'],
      ),
      expYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exp_year'],
      ),
      bankAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_account_id'],
      ),
      classification: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}classification'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $PaymentCardsTable createAlias(String alias) {
    return $PaymentCardsTable(attachedDatabase, alias);
  }
}

class PaymentCard extends DataClass implements Insertable<PaymentCard> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  final String id;
  final String nickname;
  final String? issuingBank;
  final String? network;
  final String kind;
  final String? last4;
  final int? expMonth;
  final int? expYear;
  final String? bankAccountId;
  final String classification;
  final String? notes;
  const PaymentCard({
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
    required this.id,
    required this.nickname,
    this.issuingBank,
    this.network,
    required this.kind,
    this.last4,
    this.expMonth,
    this.expYear,
    this.bankAccountId,
    required this.classification,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['id'] = Variable<String>(id);
    map['nickname'] = Variable<String>(nickname);
    if (!nullToAbsent || issuingBank != null) {
      map['issuing_bank'] = Variable<String>(issuingBank);
    }
    if (!nullToAbsent || network != null) {
      map['network'] = Variable<String>(network);
    }
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || last4 != null) {
      map['last4'] = Variable<String>(last4);
    }
    if (!nullToAbsent || expMonth != null) {
      map['exp_month'] = Variable<int>(expMonth);
    }
    if (!nullToAbsent || expYear != null) {
      map['exp_year'] = Variable<int>(expYear);
    }
    if (!nullToAbsent || bankAccountId != null) {
      map['bank_account_id'] = Variable<String>(bankAccountId);
    }
    map['classification'] = Variable<String>(classification);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  PaymentCardsCompanion toCompanion(bool nullToAbsent) {
    return PaymentCardsCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      id: Value(id),
      nickname: Value(nickname),
      issuingBank: issuingBank == null && nullToAbsent
          ? const Value.absent()
          : Value(issuingBank),
      network: network == null && nullToAbsent
          ? const Value.absent()
          : Value(network),
      kind: Value(kind),
      last4: last4 == null && nullToAbsent
          ? const Value.absent()
          : Value(last4),
      expMonth: expMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(expMonth),
      expYear: expYear == null && nullToAbsent
          ? const Value.absent()
          : Value(expYear),
      bankAccountId: bankAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(bankAccountId),
      classification: Value(classification),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory PaymentCard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentCard(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      id: serializer.fromJson<String>(json['id']),
      nickname: serializer.fromJson<String>(json['nickname']),
      issuingBank: serializer.fromJson<String?>(json['issuingBank']),
      network: serializer.fromJson<String?>(json['network']),
      kind: serializer.fromJson<String>(json['kind']),
      last4: serializer.fromJson<String?>(json['last4']),
      expMonth: serializer.fromJson<int?>(json['expMonth']),
      expYear: serializer.fromJson<int?>(json['expYear']),
      bankAccountId: serializer.fromJson<String?>(json['bankAccountId']),
      classification: serializer.fromJson<String>(json['classification']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'id': serializer.toJson<String>(id),
      'nickname': serializer.toJson<String>(nickname),
      'issuingBank': serializer.toJson<String?>(issuingBank),
      'network': serializer.toJson<String?>(network),
      'kind': serializer.toJson<String>(kind),
      'last4': serializer.toJson<String?>(last4),
      'expMonth': serializer.toJson<int?>(expMonth),
      'expYear': serializer.toJson<int?>(expYear),
      'bankAccountId': serializer.toJson<String?>(bankAccountId),
      'classification': serializer.toJson<String>(classification),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  PaymentCard copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> archivedAt = const Value.absent(),
    String? id,
    String? nickname,
    Value<String?> issuingBank = const Value.absent(),
    Value<String?> network = const Value.absent(),
    String? kind,
    Value<String?> last4 = const Value.absent(),
    Value<int?> expMonth = const Value.absent(),
    Value<int?> expYear = const Value.absent(),
    Value<String?> bankAccountId = const Value.absent(),
    String? classification,
    Value<String?> notes = const Value.absent(),
  }) => PaymentCard(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    id: id ?? this.id,
    nickname: nickname ?? this.nickname,
    issuingBank: issuingBank.present ? issuingBank.value : this.issuingBank,
    network: network.present ? network.value : this.network,
    kind: kind ?? this.kind,
    last4: last4.present ? last4.value : this.last4,
    expMonth: expMonth.present ? expMonth.value : this.expMonth,
    expYear: expYear.present ? expYear.value : this.expYear,
    bankAccountId: bankAccountId.present
        ? bankAccountId.value
        : this.bankAccountId,
    classification: classification ?? this.classification,
    notes: notes.present ? notes.value : this.notes,
  );
  PaymentCard copyWithCompanion(PaymentCardsCompanion data) {
    return PaymentCard(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      id: data.id.present ? data.id.value : this.id,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      issuingBank: data.issuingBank.present
          ? data.issuingBank.value
          : this.issuingBank,
      network: data.network.present ? data.network.value : this.network,
      kind: data.kind.present ? data.kind.value : this.kind,
      last4: data.last4.present ? data.last4.value : this.last4,
      expMonth: data.expMonth.present ? data.expMonth.value : this.expMonth,
      expYear: data.expYear.present ? data.expYear.value : this.expYear,
      bankAccountId: data.bankAccountId.present
          ? data.bankAccountId.value
          : this.bankAccountId,
      classification: data.classification.present
          ? data.classification.value
          : this.classification,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentCard(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('nickname: $nickname, ')
          ..write('issuingBank: $issuingBank, ')
          ..write('network: $network, ')
          ..write('kind: $kind, ')
          ..write('last4: $last4, ')
          ..write('expMonth: $expMonth, ')
          ..write('expYear: $expYear, ')
          ..write('bankAccountId: $bankAccountId, ')
          ..write('classification: $classification, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    createdAt,
    updatedAt,
    archivedAt,
    id,
    nickname,
    issuingBank,
    network,
    kind,
    last4,
    expMonth,
    expYear,
    bankAccountId,
    classification,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentCard &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt &&
          other.id == this.id &&
          other.nickname == this.nickname &&
          other.issuingBank == this.issuingBank &&
          other.network == this.network &&
          other.kind == this.kind &&
          other.last4 == this.last4 &&
          other.expMonth == this.expMonth &&
          other.expYear == this.expYear &&
          other.bankAccountId == this.bankAccountId &&
          other.classification == this.classification &&
          other.notes == this.notes);
}

class PaymentCardsCompanion extends UpdateCompanion<PaymentCard> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<String> id;
  final Value<String> nickname;
  final Value<String?> issuingBank;
  final Value<String?> network;
  final Value<String> kind;
  final Value<String?> last4;
  final Value<int?> expMonth;
  final Value<int?> expYear;
  final Value<String?> bankAccountId;
  final Value<String> classification;
  final Value<String?> notes;
  final Value<int> rowid;
  const PaymentCardsCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.nickname = const Value.absent(),
    this.issuingBank = const Value.absent(),
    this.network = const Value.absent(),
    this.kind = const Value.absent(),
    this.last4 = const Value.absent(),
    this.expMonth = const Value.absent(),
    this.expYear = const Value.absent(),
    this.bankAccountId = const Value.absent(),
    this.classification = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentCardsCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    required String id,
    required String nickname,
    this.issuingBank = const Value.absent(),
    this.network = const Value.absent(),
    this.kind = const Value.absent(),
    this.last4 = const Value.absent(),
    this.expMonth = const Value.absent(),
    this.expYear = const Value.absent(),
    this.bankAccountId = const Value.absent(),
    this.classification = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nickname = Value(nickname);
  static Insertable<PaymentCard> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? archivedAt,
    Expression<String>? id,
    Expression<String>? nickname,
    Expression<String>? issuingBank,
    Expression<String>? network,
    Expression<String>? kind,
    Expression<String>? last4,
    Expression<int>? expMonth,
    Expression<int>? expYear,
    Expression<String>? bankAccountId,
    Expression<String>? classification,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (id != null) 'id': id,
      if (nickname != null) 'nickname': nickname,
      if (issuingBank != null) 'issuing_bank': issuingBank,
      if (network != null) 'network': network,
      if (kind != null) 'kind': kind,
      if (last4 != null) 'last4': last4,
      if (expMonth != null) 'exp_month': expMonth,
      if (expYear != null) 'exp_year': expYear,
      if (bankAccountId != null) 'bank_account_id': bankAccountId,
      if (classification != null) 'classification': classification,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentCardsCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? archivedAt,
    Value<String>? id,
    Value<String>? nickname,
    Value<String?>? issuingBank,
    Value<String?>? network,
    Value<String>? kind,
    Value<String?>? last4,
    Value<int?>? expMonth,
    Value<int?>? expYear,
    Value<String?>? bankAccountId,
    Value<String>? classification,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return PaymentCardsCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      issuingBank: issuingBank ?? this.issuingBank,
      network: network ?? this.network,
      kind: kind ?? this.kind,
      last4: last4 ?? this.last4,
      expMonth: expMonth ?? this.expMonth,
      expYear: expYear ?? this.expYear,
      bankAccountId: bankAccountId ?? this.bankAccountId,
      classification: classification ?? this.classification,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (issuingBank.present) {
      map['issuing_bank'] = Variable<String>(issuingBank.value);
    }
    if (network.present) {
      map['network'] = Variable<String>(network.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (last4.present) {
      map['last4'] = Variable<String>(last4.value);
    }
    if (expMonth.present) {
      map['exp_month'] = Variable<int>(expMonth.value);
    }
    if (expYear.present) {
      map['exp_year'] = Variable<int>(expYear.value);
    }
    if (bankAccountId.present) {
      map['bank_account_id'] = Variable<String>(bankAccountId.value);
    }
    if (classification.present) {
      map['classification'] = Variable<String>(classification.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentCardsCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('nickname: $nickname, ')
          ..write('issuingBank: $issuingBank, ')
          ..write('network: $network, ')
          ..write('kind: $kind, ')
          ..write('last4: $last4, ')
          ..write('expMonth: $expMonth, ')
          ..write('expYear: $expYear, ')
          ..write('bankAccountId: $bankAccountId, ')
          ..write('classification: $classification, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentMethodsTable extends PaymentMethods
    with TableInfo<$PaymentMethodsTable, PaymentMethod> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentMethodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES payment_cards (id)',
    ),
  );
  static const VerificationMeta _bankAccountIdMeta = const VerificationMeta(
    'bankAccountId',
  );
  @override
  late final GeneratedColumn<String> bankAccountId = GeneratedColumn<String>(
    'bank_account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bank_accounts (id)',
    ),
  );
  static const VerificationMeta _platformIdMeta = const VerificationMeta(
    'platformId',
  );
  @override
  late final GeneratedColumn<String> platformId = GeneratedColumn<String>(
    'platform_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES platforms (id)',
    ),
  );
  static const VerificationMeta _identifierHintMeta = const VerificationMeta(
    'identifierHint',
  );
  @override
  late final GeneratedColumn<String> identifierHint = GeneratedColumn<String>(
    'identifier_hint',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    archivedAt,
    id,
    label,
    kind,
    cardId,
    bankAccountId,
    platformId,
    identifierHint,
    isDefault,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_methods';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentMethod> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    }
    if (data.containsKey('bank_account_id')) {
      context.handle(
        _bankAccountIdMeta,
        bankAccountId.isAcceptableOrUnknown(
          data['bank_account_id']!,
          _bankAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('platform_id')) {
      context.handle(
        _platformIdMeta,
        platformId.isAcceptableOrUnknown(data['platform_id']!, _platformIdMeta),
      );
    }
    if (data.containsKey('identifier_hint')) {
      context.handle(
        _identifierHintMeta,
        identifierHint.isAcceptableOrUnknown(
          data['identifier_hint']!,
          _identifierHintMeta,
        ),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentMethod map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentMethod(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      ),
      bankAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_account_id'],
      ),
      platformId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform_id'],
      ),
      identifierHint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identifier_hint'],
      ),
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $PaymentMethodsTable createAlias(String alias) {
    return $PaymentMethodsTable(attachedDatabase, alias);
  }
}

class PaymentMethod extends DataClass implements Insertable<PaymentMethod> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  final String id;
  final String label;
  final String kind;
  final String? cardId;
  final String? bankAccountId;
  final String? platformId;
  final String? identifierHint;
  final bool isDefault;
  final String? notes;
  const PaymentMethod({
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
    required this.id,
    required this.label,
    required this.kind,
    this.cardId,
    this.bankAccountId,
    this.platformId,
    this.identifierHint,
    required this.isDefault,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || cardId != null) {
      map['card_id'] = Variable<String>(cardId);
    }
    if (!nullToAbsent || bankAccountId != null) {
      map['bank_account_id'] = Variable<String>(bankAccountId);
    }
    if (!nullToAbsent || platformId != null) {
      map['platform_id'] = Variable<String>(platformId);
    }
    if (!nullToAbsent || identifierHint != null) {
      map['identifier_hint'] = Variable<String>(identifierHint);
    }
    map['is_default'] = Variable<bool>(isDefault);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  PaymentMethodsCompanion toCompanion(bool nullToAbsent) {
    return PaymentMethodsCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      id: Value(id),
      label: Value(label),
      kind: Value(kind),
      cardId: cardId == null && nullToAbsent
          ? const Value.absent()
          : Value(cardId),
      bankAccountId: bankAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(bankAccountId),
      platformId: platformId == null && nullToAbsent
          ? const Value.absent()
          : Value(platformId),
      identifierHint: identifierHint == null && nullToAbsent
          ? const Value.absent()
          : Value(identifierHint),
      isDefault: Value(isDefault),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory PaymentMethod.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentMethod(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      kind: serializer.fromJson<String>(json['kind']),
      cardId: serializer.fromJson<String?>(json['cardId']),
      bankAccountId: serializer.fromJson<String?>(json['bankAccountId']),
      platformId: serializer.fromJson<String?>(json['platformId']),
      identifierHint: serializer.fromJson<String?>(json['identifierHint']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'kind': serializer.toJson<String>(kind),
      'cardId': serializer.toJson<String?>(cardId),
      'bankAccountId': serializer.toJson<String?>(bankAccountId),
      'platformId': serializer.toJson<String?>(platformId),
      'identifierHint': serializer.toJson<String?>(identifierHint),
      'isDefault': serializer.toJson<bool>(isDefault),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  PaymentMethod copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> archivedAt = const Value.absent(),
    String? id,
    String? label,
    String? kind,
    Value<String?> cardId = const Value.absent(),
    Value<String?> bankAccountId = const Value.absent(),
    Value<String?> platformId = const Value.absent(),
    Value<String?> identifierHint = const Value.absent(),
    bool? isDefault,
    Value<String?> notes = const Value.absent(),
  }) => PaymentMethod(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    id: id ?? this.id,
    label: label ?? this.label,
    kind: kind ?? this.kind,
    cardId: cardId.present ? cardId.value : this.cardId,
    bankAccountId: bankAccountId.present
        ? bankAccountId.value
        : this.bankAccountId,
    platformId: platformId.present ? platformId.value : this.platformId,
    identifierHint: identifierHint.present
        ? identifierHint.value
        : this.identifierHint,
    isDefault: isDefault ?? this.isDefault,
    notes: notes.present ? notes.value : this.notes,
  );
  PaymentMethod copyWithCompanion(PaymentMethodsCompanion data) {
    return PaymentMethod(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      kind: data.kind.present ? data.kind.value : this.kind,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      bankAccountId: data.bankAccountId.present
          ? data.bankAccountId.value
          : this.bankAccountId,
      platformId: data.platformId.present
          ? data.platformId.value
          : this.platformId,
      identifierHint: data.identifierHint.present
          ? data.identifierHint.value
          : this.identifierHint,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentMethod(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('kind: $kind, ')
          ..write('cardId: $cardId, ')
          ..write('bankAccountId: $bankAccountId, ')
          ..write('platformId: $platformId, ')
          ..write('identifierHint: $identifierHint, ')
          ..write('isDefault: $isDefault, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    createdAt,
    updatedAt,
    archivedAt,
    id,
    label,
    kind,
    cardId,
    bankAccountId,
    platformId,
    identifierHint,
    isDefault,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentMethod &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt &&
          other.id == this.id &&
          other.label == this.label &&
          other.kind == this.kind &&
          other.cardId == this.cardId &&
          other.bankAccountId == this.bankAccountId &&
          other.platformId == this.platformId &&
          other.identifierHint == this.identifierHint &&
          other.isDefault == this.isDefault &&
          other.notes == this.notes);
}

class PaymentMethodsCompanion extends UpdateCompanion<PaymentMethod> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<String> id;
  final Value<String> label;
  final Value<String> kind;
  final Value<String?> cardId;
  final Value<String?> bankAccountId;
  final Value<String?> platformId;
  final Value<String?> identifierHint;
  final Value<bool> isDefault;
  final Value<String?> notes;
  final Value<int> rowid;
  const PaymentMethodsCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.kind = const Value.absent(),
    this.cardId = const Value.absent(),
    this.bankAccountId = const Value.absent(),
    this.platformId = const Value.absent(),
    this.identifierHint = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentMethodsCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    required String id,
    required String label,
    required String kind,
    this.cardId = const Value.absent(),
    this.bankAccountId = const Value.absent(),
    this.platformId = const Value.absent(),
    this.identifierHint = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label),
       kind = Value(kind);
  static Insertable<PaymentMethod> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? archivedAt,
    Expression<String>? id,
    Expression<String>? label,
    Expression<String>? kind,
    Expression<String>? cardId,
    Expression<String>? bankAccountId,
    Expression<String>? platformId,
    Expression<String>? identifierHint,
    Expression<bool>? isDefault,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (kind != null) 'kind': kind,
      if (cardId != null) 'card_id': cardId,
      if (bankAccountId != null) 'bank_account_id': bankAccountId,
      if (platformId != null) 'platform_id': platformId,
      if (identifierHint != null) 'identifier_hint': identifierHint,
      if (isDefault != null) 'is_default': isDefault,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentMethodsCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? archivedAt,
    Value<String>? id,
    Value<String>? label,
    Value<String>? kind,
    Value<String?>? cardId,
    Value<String?>? bankAccountId,
    Value<String?>? platformId,
    Value<String?>? identifierHint,
    Value<bool>? isDefault,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return PaymentMethodsCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      id: id ?? this.id,
      label: label ?? this.label,
      kind: kind ?? this.kind,
      cardId: cardId ?? this.cardId,
      bankAccountId: bankAccountId ?? this.bankAccountId,
      platformId: platformId ?? this.platformId,
      identifierHint: identifierHint ?? this.identifierHint,
      isDefault: isDefault ?? this.isDefault,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (bankAccountId.present) {
      map['bank_account_id'] = Variable<String>(bankAccountId.value);
    }
    if (platformId.present) {
      map['platform_id'] = Variable<String>(platformId.value);
    }
    if (identifierHint.present) {
      map['identifier_hint'] = Variable<String>(identifierHint.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentMethodsCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('kind: $kind, ')
          ..write('cardId: $cardId, ')
          ..write('bankAccountId: $bankAccountId, ')
          ..write('platformId: $platformId, ')
          ..write('identifierHint: $identifierHint, ')
          ..write('isDefault: $isDefault, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubscriptionsTable extends Subscriptions
    with TableInfo<$SubscriptionsTable, Subscription> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _platformIdMeta = const VerificationMeta(
    'platformId',
  );
  @override
  late final GeneratedColumn<String> platformId = GeneratedColumn<String>(
    'platform_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES platforms (id)',
    ),
  );
  static const VerificationMeta _serviceNameMeta = const VerificationMeta(
    'serviceName',
  );
  @override
  late final GeneratedColumn<String> serviceName = GeneratedColumn<String>(
    'service_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES service_accounts (id)',
    ),
  );
  static const VerificationMeta _planMeta = const VerificationMeta('plan');
  @override
  late final GeneratedColumn<String> plan = GeneratedColumn<String>(
    'plan',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceMinorMeta = const VerificationMeta(
    'priceMinor',
  );
  @override
  late final GeneratedColumn<int> priceMinor = GeneratedColumn<int>(
    'price_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _billingCycleMeta = const VerificationMeta(
    'billingCycle',
  );
  @override
  late final GeneratedColumn<String> billingCycle = GeneratedColumn<String>(
    'billing_cycle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('monthly'),
  );
  static const VerificationMeta _cycleDaysMeta = const VerificationMeta(
    'cycleDays',
  );
  @override
  late final GeneratedColumn<int> cycleDays = GeneratedColumn<int>(
    'cycle_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextBillingDateMeta = const VerificationMeta(
    'nextBillingDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextBillingDate =
      GeneratedColumn<DateTime>(
        'next_billing_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _cancellationDateMeta = const VerificationMeta(
    'cancellationDate',
  );
  @override
  late final GeneratedColumn<DateTime> cancellationDate =
      GeneratedColumn<DateTime>(
        'cancellation_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _paymentMethodIdMeta = const VerificationMeta(
    'paymentMethodId',
  );
  @override
  late final GeneratedColumn<String> paymentMethodId = GeneratedColumn<String>(
    'payment_method_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES payment_methods (id)',
    ),
  );
  static const VerificationMeta _classificationMeta = const VerificationMeta(
    'classification',
  );
  @override
  late final GeneratedColumn<String> classification = GeneratedColumn<String>(
    'classification',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('personal'),
  );
  static const VerificationMeta _renewalUrlMeta = const VerificationMeta(
    'renewalUrl',
  );
  @override
  late final GeneratedColumn<String> renewalUrl = GeneratedColumn<String>(
    'renewal_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remindersEnabledMeta = const VerificationMeta(
    'remindersEnabled',
  );
  @override
  late final GeneratedColumn<bool> remindersEnabled = GeneratedColumn<bool>(
    'reminders_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminders_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchaseChannelMeta = const VerificationMeta(
    'purchaseChannel',
  );
  @override
  late final GeneratedColumn<String> purchaseChannel = GeneratedColumn<String>(
    'purchase_channel',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    archivedAt,
    id,
    platformId,
    serviceName,
    accountId,
    plan,
    priceMinor,
    currency,
    billingCycle,
    cycleDays,
    startDate,
    nextBillingDate,
    cancellationDate,
    status,
    paymentMethodId,
    classification,
    renewalUrl,
    remindersEnabled,
    notes,
    purchaseChannel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscriptions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Subscription> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('platform_id')) {
      context.handle(
        _platformIdMeta,
        platformId.isAcceptableOrUnknown(data['platform_id']!, _platformIdMeta),
      );
    }
    if (data.containsKey('service_name')) {
      context.handle(
        _serviceNameMeta,
        serviceName.isAcceptableOrUnknown(
          data['service_name']!,
          _serviceNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serviceNameMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('plan')) {
      context.handle(
        _planMeta,
        plan.isAcceptableOrUnknown(data['plan']!, _planMeta),
      );
    }
    if (data.containsKey('price_minor')) {
      context.handle(
        _priceMinorMeta,
        priceMinor.isAcceptableOrUnknown(data['price_minor']!, _priceMinorMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('billing_cycle')) {
      context.handle(
        _billingCycleMeta,
        billingCycle.isAcceptableOrUnknown(
          data['billing_cycle']!,
          _billingCycleMeta,
        ),
      );
    }
    if (data.containsKey('cycle_days')) {
      context.handle(
        _cycleDaysMeta,
        cycleDays.isAcceptableOrUnknown(data['cycle_days']!, _cycleDaysMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('next_billing_date')) {
      context.handle(
        _nextBillingDateMeta,
        nextBillingDate.isAcceptableOrUnknown(
          data['next_billing_date']!,
          _nextBillingDateMeta,
        ),
      );
    }
    if (data.containsKey('cancellation_date')) {
      context.handle(
        _cancellationDateMeta,
        cancellationDate.isAcceptableOrUnknown(
          data['cancellation_date']!,
          _cancellationDateMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('payment_method_id')) {
      context.handle(
        _paymentMethodIdMeta,
        paymentMethodId.isAcceptableOrUnknown(
          data['payment_method_id']!,
          _paymentMethodIdMeta,
        ),
      );
    }
    if (data.containsKey('classification')) {
      context.handle(
        _classificationMeta,
        classification.isAcceptableOrUnknown(
          data['classification']!,
          _classificationMeta,
        ),
      );
    }
    if (data.containsKey('renewal_url')) {
      context.handle(
        _renewalUrlMeta,
        renewalUrl.isAcceptableOrUnknown(data['renewal_url']!, _renewalUrlMeta),
      );
    }
    if (data.containsKey('reminders_enabled')) {
      context.handle(
        _remindersEnabledMeta,
        remindersEnabled.isAcceptableOrUnknown(
          data['reminders_enabled']!,
          _remindersEnabledMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('purchase_channel')) {
      context.handle(
        _purchaseChannelMeta,
        purchaseChannel.isAcceptableOrUnknown(
          data['purchase_channel']!,
          _purchaseChannelMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subscription map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subscription(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      platformId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform_id'],
      ),
      serviceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_name'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      ),
      plan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan'],
      ),
      priceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      billingCycle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}billing_cycle'],
      )!,
      cycleDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_days'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      ),
      nextBillingDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_billing_date'],
      ),
      cancellationDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cancellation_date'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      paymentMethodId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method_id'],
      ),
      classification: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}classification'],
      )!,
      renewalUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}renewal_url'],
      ),
      remindersEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminders_enabled'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      purchaseChannel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_channel'],
      ),
    );
  }

  @override
  $SubscriptionsTable createAlias(String alias) {
    return $SubscriptionsTable(attachedDatabase, alias);
  }
}

class Subscription extends DataClass implements Insertable<Subscription> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  final String id;
  final String? platformId;
  final String serviceName;
  final String? accountId;
  final String? plan;
  final int priceMinor;
  final String currency;
  final String billingCycle;
  final int? cycleDays;
  final DateTime? startDate;
  final DateTime? nextBillingDate;
  final DateTime? cancellationDate;
  final String status;
  final String? paymentMethodId;
  final String classification;
  final String? renewalUrl;
  final bool remindersEnabled;
  final String? notes;

  /// Where the subscription is billed: web | ios | android (PurchaseChannel).
  /// Null for rows created before schema v2.
  final String? purchaseChannel;
  const Subscription({
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
    required this.id,
    this.platformId,
    required this.serviceName,
    this.accountId,
    this.plan,
    required this.priceMinor,
    required this.currency,
    required this.billingCycle,
    this.cycleDays,
    this.startDate,
    this.nextBillingDate,
    this.cancellationDate,
    required this.status,
    this.paymentMethodId,
    required this.classification,
    this.renewalUrl,
    required this.remindersEnabled,
    this.notes,
    this.purchaseChannel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || platformId != null) {
      map['platform_id'] = Variable<String>(platformId);
    }
    map['service_name'] = Variable<String>(serviceName);
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    if (!nullToAbsent || plan != null) {
      map['plan'] = Variable<String>(plan);
    }
    map['price_minor'] = Variable<int>(priceMinor);
    map['currency'] = Variable<String>(currency);
    map['billing_cycle'] = Variable<String>(billingCycle);
    if (!nullToAbsent || cycleDays != null) {
      map['cycle_days'] = Variable<int>(cycleDays);
    }
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || nextBillingDate != null) {
      map['next_billing_date'] = Variable<DateTime>(nextBillingDate);
    }
    if (!nullToAbsent || cancellationDate != null) {
      map['cancellation_date'] = Variable<DateTime>(cancellationDate);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || paymentMethodId != null) {
      map['payment_method_id'] = Variable<String>(paymentMethodId);
    }
    map['classification'] = Variable<String>(classification);
    if (!nullToAbsent || renewalUrl != null) {
      map['renewal_url'] = Variable<String>(renewalUrl);
    }
    map['reminders_enabled'] = Variable<bool>(remindersEnabled);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || purchaseChannel != null) {
      map['purchase_channel'] = Variable<String>(purchaseChannel);
    }
    return map;
  }

  SubscriptionsCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionsCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      id: Value(id),
      platformId: platformId == null && nullToAbsent
          ? const Value.absent()
          : Value(platformId),
      serviceName: Value(serviceName),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      plan: plan == null && nullToAbsent ? const Value.absent() : Value(plan),
      priceMinor: Value(priceMinor),
      currency: Value(currency),
      billingCycle: Value(billingCycle),
      cycleDays: cycleDays == null && nullToAbsent
          ? const Value.absent()
          : Value(cycleDays),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      nextBillingDate: nextBillingDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextBillingDate),
      cancellationDate: cancellationDate == null && nullToAbsent
          ? const Value.absent()
          : Value(cancellationDate),
      status: Value(status),
      paymentMethodId: paymentMethodId == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethodId),
      classification: Value(classification),
      renewalUrl: renewalUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(renewalUrl),
      remindersEnabled: Value(remindersEnabled),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      purchaseChannel: purchaseChannel == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseChannel),
    );
  }

  factory Subscription.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subscription(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      id: serializer.fromJson<String>(json['id']),
      platformId: serializer.fromJson<String?>(json['platformId']),
      serviceName: serializer.fromJson<String>(json['serviceName']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      plan: serializer.fromJson<String?>(json['plan']),
      priceMinor: serializer.fromJson<int>(json['priceMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      billingCycle: serializer.fromJson<String>(json['billingCycle']),
      cycleDays: serializer.fromJson<int?>(json['cycleDays']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      nextBillingDate: serializer.fromJson<DateTime?>(json['nextBillingDate']),
      cancellationDate: serializer.fromJson<DateTime?>(
        json['cancellationDate'],
      ),
      status: serializer.fromJson<String>(json['status']),
      paymentMethodId: serializer.fromJson<String?>(json['paymentMethodId']),
      classification: serializer.fromJson<String>(json['classification']),
      renewalUrl: serializer.fromJson<String?>(json['renewalUrl']),
      remindersEnabled: serializer.fromJson<bool>(json['remindersEnabled']),
      notes: serializer.fromJson<String?>(json['notes']),
      purchaseChannel: serializer.fromJson<String?>(json['purchaseChannel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'id': serializer.toJson<String>(id),
      'platformId': serializer.toJson<String?>(platformId),
      'serviceName': serializer.toJson<String>(serviceName),
      'accountId': serializer.toJson<String?>(accountId),
      'plan': serializer.toJson<String?>(plan),
      'priceMinor': serializer.toJson<int>(priceMinor),
      'currency': serializer.toJson<String>(currency),
      'billingCycle': serializer.toJson<String>(billingCycle),
      'cycleDays': serializer.toJson<int?>(cycleDays),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'nextBillingDate': serializer.toJson<DateTime?>(nextBillingDate),
      'cancellationDate': serializer.toJson<DateTime?>(cancellationDate),
      'status': serializer.toJson<String>(status),
      'paymentMethodId': serializer.toJson<String?>(paymentMethodId),
      'classification': serializer.toJson<String>(classification),
      'renewalUrl': serializer.toJson<String?>(renewalUrl),
      'remindersEnabled': serializer.toJson<bool>(remindersEnabled),
      'notes': serializer.toJson<String?>(notes),
      'purchaseChannel': serializer.toJson<String?>(purchaseChannel),
    };
  }

  Subscription copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> archivedAt = const Value.absent(),
    String? id,
    Value<String?> platformId = const Value.absent(),
    String? serviceName,
    Value<String?> accountId = const Value.absent(),
    Value<String?> plan = const Value.absent(),
    int? priceMinor,
    String? currency,
    String? billingCycle,
    Value<int?> cycleDays = const Value.absent(),
    Value<DateTime?> startDate = const Value.absent(),
    Value<DateTime?> nextBillingDate = const Value.absent(),
    Value<DateTime?> cancellationDate = const Value.absent(),
    String? status,
    Value<String?> paymentMethodId = const Value.absent(),
    String? classification,
    Value<String?> renewalUrl = const Value.absent(),
    bool? remindersEnabled,
    Value<String?> notes = const Value.absent(),
    Value<String?> purchaseChannel = const Value.absent(),
  }) => Subscription(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    id: id ?? this.id,
    platformId: platformId.present ? platformId.value : this.platformId,
    serviceName: serviceName ?? this.serviceName,
    accountId: accountId.present ? accountId.value : this.accountId,
    plan: plan.present ? plan.value : this.plan,
    priceMinor: priceMinor ?? this.priceMinor,
    currency: currency ?? this.currency,
    billingCycle: billingCycle ?? this.billingCycle,
    cycleDays: cycleDays.present ? cycleDays.value : this.cycleDays,
    startDate: startDate.present ? startDate.value : this.startDate,
    nextBillingDate: nextBillingDate.present
        ? nextBillingDate.value
        : this.nextBillingDate,
    cancellationDate: cancellationDate.present
        ? cancellationDate.value
        : this.cancellationDate,
    status: status ?? this.status,
    paymentMethodId: paymentMethodId.present
        ? paymentMethodId.value
        : this.paymentMethodId,
    classification: classification ?? this.classification,
    renewalUrl: renewalUrl.present ? renewalUrl.value : this.renewalUrl,
    remindersEnabled: remindersEnabled ?? this.remindersEnabled,
    notes: notes.present ? notes.value : this.notes,
    purchaseChannel: purchaseChannel.present
        ? purchaseChannel.value
        : this.purchaseChannel,
  );
  Subscription copyWithCompanion(SubscriptionsCompanion data) {
    return Subscription(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      id: data.id.present ? data.id.value : this.id,
      platformId: data.platformId.present
          ? data.platformId.value
          : this.platformId,
      serviceName: data.serviceName.present
          ? data.serviceName.value
          : this.serviceName,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      plan: data.plan.present ? data.plan.value : this.plan,
      priceMinor: data.priceMinor.present
          ? data.priceMinor.value
          : this.priceMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      billingCycle: data.billingCycle.present
          ? data.billingCycle.value
          : this.billingCycle,
      cycleDays: data.cycleDays.present ? data.cycleDays.value : this.cycleDays,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      nextBillingDate: data.nextBillingDate.present
          ? data.nextBillingDate.value
          : this.nextBillingDate,
      cancellationDate: data.cancellationDate.present
          ? data.cancellationDate.value
          : this.cancellationDate,
      status: data.status.present ? data.status.value : this.status,
      paymentMethodId: data.paymentMethodId.present
          ? data.paymentMethodId.value
          : this.paymentMethodId,
      classification: data.classification.present
          ? data.classification.value
          : this.classification,
      renewalUrl: data.renewalUrl.present
          ? data.renewalUrl.value
          : this.renewalUrl,
      remindersEnabled: data.remindersEnabled.present
          ? data.remindersEnabled.value
          : this.remindersEnabled,
      notes: data.notes.present ? data.notes.value : this.notes,
      purchaseChannel: data.purchaseChannel.present
          ? data.purchaseChannel.value
          : this.purchaseChannel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subscription(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('platformId: $platformId, ')
          ..write('serviceName: $serviceName, ')
          ..write('accountId: $accountId, ')
          ..write('plan: $plan, ')
          ..write('priceMinor: $priceMinor, ')
          ..write('currency: $currency, ')
          ..write('billingCycle: $billingCycle, ')
          ..write('cycleDays: $cycleDays, ')
          ..write('startDate: $startDate, ')
          ..write('nextBillingDate: $nextBillingDate, ')
          ..write('cancellationDate: $cancellationDate, ')
          ..write('status: $status, ')
          ..write('paymentMethodId: $paymentMethodId, ')
          ..write('classification: $classification, ')
          ..write('renewalUrl: $renewalUrl, ')
          ..write('remindersEnabled: $remindersEnabled, ')
          ..write('notes: $notes, ')
          ..write('purchaseChannel: $purchaseChannel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    createdAt,
    updatedAt,
    archivedAt,
    id,
    platformId,
    serviceName,
    accountId,
    plan,
    priceMinor,
    currency,
    billingCycle,
    cycleDays,
    startDate,
    nextBillingDate,
    cancellationDate,
    status,
    paymentMethodId,
    classification,
    renewalUrl,
    remindersEnabled,
    notes,
    purchaseChannel,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subscription &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt &&
          other.id == this.id &&
          other.platformId == this.platformId &&
          other.serviceName == this.serviceName &&
          other.accountId == this.accountId &&
          other.plan == this.plan &&
          other.priceMinor == this.priceMinor &&
          other.currency == this.currency &&
          other.billingCycle == this.billingCycle &&
          other.cycleDays == this.cycleDays &&
          other.startDate == this.startDate &&
          other.nextBillingDate == this.nextBillingDate &&
          other.cancellationDate == this.cancellationDate &&
          other.status == this.status &&
          other.paymentMethodId == this.paymentMethodId &&
          other.classification == this.classification &&
          other.renewalUrl == this.renewalUrl &&
          other.remindersEnabled == this.remindersEnabled &&
          other.notes == this.notes &&
          other.purchaseChannel == this.purchaseChannel);
}

class SubscriptionsCompanion extends UpdateCompanion<Subscription> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<String> id;
  final Value<String?> platformId;
  final Value<String> serviceName;
  final Value<String?> accountId;
  final Value<String?> plan;
  final Value<int> priceMinor;
  final Value<String> currency;
  final Value<String> billingCycle;
  final Value<int?> cycleDays;
  final Value<DateTime?> startDate;
  final Value<DateTime?> nextBillingDate;
  final Value<DateTime?> cancellationDate;
  final Value<String> status;
  final Value<String?> paymentMethodId;
  final Value<String> classification;
  final Value<String?> renewalUrl;
  final Value<bool> remindersEnabled;
  final Value<String?> notes;
  final Value<String?> purchaseChannel;
  final Value<int> rowid;
  const SubscriptionsCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.platformId = const Value.absent(),
    this.serviceName = const Value.absent(),
    this.accountId = const Value.absent(),
    this.plan = const Value.absent(),
    this.priceMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.billingCycle = const Value.absent(),
    this.cycleDays = const Value.absent(),
    this.startDate = const Value.absent(),
    this.nextBillingDate = const Value.absent(),
    this.cancellationDate = const Value.absent(),
    this.status = const Value.absent(),
    this.paymentMethodId = const Value.absent(),
    this.classification = const Value.absent(),
    this.renewalUrl = const Value.absent(),
    this.remindersEnabled = const Value.absent(),
    this.notes = const Value.absent(),
    this.purchaseChannel = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubscriptionsCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    required String id,
    this.platformId = const Value.absent(),
    required String serviceName,
    this.accountId = const Value.absent(),
    this.plan = const Value.absent(),
    this.priceMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.billingCycle = const Value.absent(),
    this.cycleDays = const Value.absent(),
    this.startDate = const Value.absent(),
    this.nextBillingDate = const Value.absent(),
    this.cancellationDate = const Value.absent(),
    this.status = const Value.absent(),
    this.paymentMethodId = const Value.absent(),
    this.classification = const Value.absent(),
    this.renewalUrl = const Value.absent(),
    this.remindersEnabled = const Value.absent(),
    this.notes = const Value.absent(),
    this.purchaseChannel = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       serviceName = Value(serviceName);
  static Insertable<Subscription> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? archivedAt,
    Expression<String>? id,
    Expression<String>? platformId,
    Expression<String>? serviceName,
    Expression<String>? accountId,
    Expression<String>? plan,
    Expression<int>? priceMinor,
    Expression<String>? currency,
    Expression<String>? billingCycle,
    Expression<int>? cycleDays,
    Expression<DateTime>? startDate,
    Expression<DateTime>? nextBillingDate,
    Expression<DateTime>? cancellationDate,
    Expression<String>? status,
    Expression<String>? paymentMethodId,
    Expression<String>? classification,
    Expression<String>? renewalUrl,
    Expression<bool>? remindersEnabled,
    Expression<String>? notes,
    Expression<String>? purchaseChannel,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (id != null) 'id': id,
      if (platformId != null) 'platform_id': platformId,
      if (serviceName != null) 'service_name': serviceName,
      if (accountId != null) 'account_id': accountId,
      if (plan != null) 'plan': plan,
      if (priceMinor != null) 'price_minor': priceMinor,
      if (currency != null) 'currency': currency,
      if (billingCycle != null) 'billing_cycle': billingCycle,
      if (cycleDays != null) 'cycle_days': cycleDays,
      if (startDate != null) 'start_date': startDate,
      if (nextBillingDate != null) 'next_billing_date': nextBillingDate,
      if (cancellationDate != null) 'cancellation_date': cancellationDate,
      if (status != null) 'status': status,
      if (paymentMethodId != null) 'payment_method_id': paymentMethodId,
      if (classification != null) 'classification': classification,
      if (renewalUrl != null) 'renewal_url': renewalUrl,
      if (remindersEnabled != null) 'reminders_enabled': remindersEnabled,
      if (notes != null) 'notes': notes,
      if (purchaseChannel != null) 'purchase_channel': purchaseChannel,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubscriptionsCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? archivedAt,
    Value<String>? id,
    Value<String?>? platformId,
    Value<String>? serviceName,
    Value<String?>? accountId,
    Value<String?>? plan,
    Value<int>? priceMinor,
    Value<String>? currency,
    Value<String>? billingCycle,
    Value<int?>? cycleDays,
    Value<DateTime?>? startDate,
    Value<DateTime?>? nextBillingDate,
    Value<DateTime?>? cancellationDate,
    Value<String>? status,
    Value<String?>? paymentMethodId,
    Value<String>? classification,
    Value<String?>? renewalUrl,
    Value<bool>? remindersEnabled,
    Value<String?>? notes,
    Value<String?>? purchaseChannel,
    Value<int>? rowid,
  }) {
    return SubscriptionsCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      id: id ?? this.id,
      platformId: platformId ?? this.platformId,
      serviceName: serviceName ?? this.serviceName,
      accountId: accountId ?? this.accountId,
      plan: plan ?? this.plan,
      priceMinor: priceMinor ?? this.priceMinor,
      currency: currency ?? this.currency,
      billingCycle: billingCycle ?? this.billingCycle,
      cycleDays: cycleDays ?? this.cycleDays,
      startDate: startDate ?? this.startDate,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      cancellationDate: cancellationDate ?? this.cancellationDate,
      status: status ?? this.status,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      classification: classification ?? this.classification,
      renewalUrl: renewalUrl ?? this.renewalUrl,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      notes: notes ?? this.notes,
      purchaseChannel: purchaseChannel ?? this.purchaseChannel,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (platformId.present) {
      map['platform_id'] = Variable<String>(platformId.value);
    }
    if (serviceName.present) {
      map['service_name'] = Variable<String>(serviceName.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (plan.present) {
      map['plan'] = Variable<String>(plan.value);
    }
    if (priceMinor.present) {
      map['price_minor'] = Variable<int>(priceMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (billingCycle.present) {
      map['billing_cycle'] = Variable<String>(billingCycle.value);
    }
    if (cycleDays.present) {
      map['cycle_days'] = Variable<int>(cycleDays.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (nextBillingDate.present) {
      map['next_billing_date'] = Variable<DateTime>(nextBillingDate.value);
    }
    if (cancellationDate.present) {
      map['cancellation_date'] = Variable<DateTime>(cancellationDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (paymentMethodId.present) {
      map['payment_method_id'] = Variable<String>(paymentMethodId.value);
    }
    if (classification.present) {
      map['classification'] = Variable<String>(classification.value);
    }
    if (renewalUrl.present) {
      map['renewal_url'] = Variable<String>(renewalUrl.value);
    }
    if (remindersEnabled.present) {
      map['reminders_enabled'] = Variable<bool>(remindersEnabled.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (purchaseChannel.present) {
      map['purchase_channel'] = Variable<String>(purchaseChannel.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionsCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('platformId: $platformId, ')
          ..write('serviceName: $serviceName, ')
          ..write('accountId: $accountId, ')
          ..write('plan: $plan, ')
          ..write('priceMinor: $priceMinor, ')
          ..write('currency: $currency, ')
          ..write('billingCycle: $billingCycle, ')
          ..write('cycleDays: $cycleDays, ')
          ..write('startDate: $startDate, ')
          ..write('nextBillingDate: $nextBillingDate, ')
          ..write('cancellationDate: $cancellationDate, ')
          ..write('status: $status, ')
          ..write('paymentMethodId: $paymentMethodId, ')
          ..write('classification: $classification, ')
          ..write('renewalUrl: $renewalUrl, ')
          ..write('remindersEnabled: $remindersEnabled, ')
          ..write('notes: $notes, ')
          ..write('purchaseChannel: $purchaseChannel, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubscriptionEventsTable extends SubscriptionEvents
    with TableInfo<$SubscriptionEventsTable, SubscriptionEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subscriptionIdMeta = const VerificationMeta(
    'subscriptionId',
  );
  @override
  late final GeneratedColumn<String> subscriptionId = GeneratedColumn<String>(
    'subscription_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subscriptions (id)',
    ),
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, subscriptionId, at, kind, details];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscription_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubscriptionEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subscription_id')) {
      context.handle(
        _subscriptionIdMeta,
        subscriptionId.isAcceptableOrUnknown(
          data['subscription_id']!,
          _subscriptionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subscriptionIdMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubscriptionEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubscriptionEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      subscriptionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subscription_id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      ),
    );
  }

  @override
  $SubscriptionEventsTable createAlias(String alias) {
    return $SubscriptionEventsTable(attachedDatabase, alias);
  }
}

class SubscriptionEvent extends DataClass
    implements Insertable<SubscriptionEvent> {
  final String id;
  final String subscriptionId;
  final DateTime at;
  final String kind;
  final String? details;
  const SubscriptionEvent({
    required this.id,
    required this.subscriptionId,
    required this.at,
    required this.kind,
    this.details,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['subscription_id'] = Variable<String>(subscriptionId);
    map['at'] = Variable<DateTime>(at);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    return map;
  }

  SubscriptionEventsCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionEventsCompanion(
      id: Value(id),
      subscriptionId: Value(subscriptionId),
      at: Value(at),
      kind: Value(kind),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
    );
  }

  factory SubscriptionEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubscriptionEvent(
      id: serializer.fromJson<String>(json['id']),
      subscriptionId: serializer.fromJson<String>(json['subscriptionId']),
      at: serializer.fromJson<DateTime>(json['at']),
      kind: serializer.fromJson<String>(json['kind']),
      details: serializer.fromJson<String?>(json['details']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subscriptionId': serializer.toJson<String>(subscriptionId),
      'at': serializer.toJson<DateTime>(at),
      'kind': serializer.toJson<String>(kind),
      'details': serializer.toJson<String?>(details),
    };
  }

  SubscriptionEvent copyWith({
    String? id,
    String? subscriptionId,
    DateTime? at,
    String? kind,
    Value<String?> details = const Value.absent(),
  }) => SubscriptionEvent(
    id: id ?? this.id,
    subscriptionId: subscriptionId ?? this.subscriptionId,
    at: at ?? this.at,
    kind: kind ?? this.kind,
    details: details.present ? details.value : this.details,
  );
  SubscriptionEvent copyWithCompanion(SubscriptionEventsCompanion data) {
    return SubscriptionEvent(
      id: data.id.present ? data.id.value : this.id,
      subscriptionId: data.subscriptionId.present
          ? data.subscriptionId.value
          : this.subscriptionId,
      at: data.at.present ? data.at.value : this.at,
      kind: data.kind.present ? data.kind.value : this.kind,
      details: data.details.present ? data.details.value : this.details,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionEvent(')
          ..write('id: $id, ')
          ..write('subscriptionId: $subscriptionId, ')
          ..write('at: $at, ')
          ..write('kind: $kind, ')
          ..write('details: $details')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, subscriptionId, at, kind, details);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubscriptionEvent &&
          other.id == this.id &&
          other.subscriptionId == this.subscriptionId &&
          other.at == this.at &&
          other.kind == this.kind &&
          other.details == this.details);
}

class SubscriptionEventsCompanion extends UpdateCompanion<SubscriptionEvent> {
  final Value<String> id;
  final Value<String> subscriptionId;
  final Value<DateTime> at;
  final Value<String> kind;
  final Value<String?> details;
  final Value<int> rowid;
  const SubscriptionEventsCompanion({
    this.id = const Value.absent(),
    this.subscriptionId = const Value.absent(),
    this.at = const Value.absent(),
    this.kind = const Value.absent(),
    this.details = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubscriptionEventsCompanion.insert({
    required String id,
    required String subscriptionId,
    this.at = const Value.absent(),
    required String kind,
    this.details = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       subscriptionId = Value(subscriptionId),
       kind = Value(kind);
  static Insertable<SubscriptionEvent> custom({
    Expression<String>? id,
    Expression<String>? subscriptionId,
    Expression<DateTime>? at,
    Expression<String>? kind,
    Expression<String>? details,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subscriptionId != null) 'subscription_id': subscriptionId,
      if (at != null) 'at': at,
      if (kind != null) 'kind': kind,
      if (details != null) 'details': details,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubscriptionEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? subscriptionId,
    Value<DateTime>? at,
    Value<String>? kind,
    Value<String?>? details,
    Value<int>? rowid,
  }) {
    return SubscriptionEventsCompanion(
      id: id ?? this.id,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      at: at ?? this.at,
      kind: kind ?? this.kind,
      details: details ?? this.details,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subscriptionId.present) {
      map['subscription_id'] = Variable<String>(subscriptionId.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionEventsCompanion(')
          ..write('id: $id, ')
          ..write('subscriptionId: $subscriptionId, ')
          ..write('at: $at, ')
          ..write('kind: $kind, ')
          ..write('details: $details, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DocumentReferencesTable extends DocumentReferences
    with TableInfo<$DocumentReferencesTable, DocumentReference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentReferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locatorMeta = const VerificationMeta(
    'locator',
  );
  @override
  late final GeneratedColumn<String> locator = GeneratedColumn<String>(
    'locator',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    createdAt,
    updatedAt,
    id,
    title,
    locator,
    kind,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_references';
  @override
  VerificationContext validateIntegrity(
    Insertable<DocumentReference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('locator')) {
      context.handle(
        _locatorMeta,
        locator.isAcceptableOrUnknown(data['locator']!, _locatorMeta),
      );
    } else if (isInserting) {
      context.missing(_locatorMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DocumentReference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentReference(
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      locator: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locator'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $DocumentReferencesTable createAlias(String alias) {
    return $DocumentReferencesTable(attachedDatabase, alias);
  }
}

class DocumentReference extends DataClass
    implements Insertable<DocumentReference> {
  final DateTime createdAt;
  final DateTime updatedAt;
  final String id;
  final String title;
  final String locator;
  final String? kind;
  final String? notes;
  const DocumentReference({
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.title,
    required this.locator,
    this.kind,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['locator'] = Variable<String>(locator);
    if (!nullToAbsent || kind != null) {
      map['kind'] = Variable<String>(kind);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  DocumentReferencesCompanion toCompanion(bool nullToAbsent) {
    return DocumentReferencesCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      id: Value(id),
      title: Value(title),
      locator: Value(locator),
      kind: kind == null && nullToAbsent ? const Value.absent() : Value(kind),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory DocumentReference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentReference(
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      locator: serializer.fromJson<String>(json['locator']),
      kind: serializer.fromJson<String?>(json['kind']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'locator': serializer.toJson<String>(locator),
      'kind': serializer.toJson<String?>(kind),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  DocumentReference copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    String? id,
    String? title,
    String? locator,
    Value<String?> kind = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => DocumentReference(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    id: id ?? this.id,
    title: title ?? this.title,
    locator: locator ?? this.locator,
    kind: kind.present ? kind.value : this.kind,
    notes: notes.present ? notes.value : this.notes,
  );
  DocumentReference copyWithCompanion(DocumentReferencesCompanion data) {
    return DocumentReference(
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      locator: data.locator.present ? data.locator.value : this.locator,
      kind: data.kind.present ? data.kind.value : this.kind,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentReference(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('locator: $locator, ')
          ..write('kind: $kind, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(createdAt, updatedAt, id, title, locator, kind, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentReference &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.id == this.id &&
          other.title == this.title &&
          other.locator == this.locator &&
          other.kind == this.kind &&
          other.notes == this.notes);
}

class DocumentReferencesCompanion extends UpdateCompanion<DocumentReference> {
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> id;
  final Value<String> title;
  final Value<String> locator;
  final Value<String?> kind;
  final Value<String?> notes;
  final Value<int> rowid;
  const DocumentReferencesCompanion({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.locator = const Value.absent(),
    this.kind = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentReferencesCompanion.insert({
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String id,
    required String title,
    required String locator,
    this.kind = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       locator = Value(locator);
  static Insertable<DocumentReference> custom({
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? locator,
    Expression<String>? kind,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (locator != null) 'locator': locator,
      if (kind != null) 'kind': kind,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentReferencesCompanion copyWith({
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? id,
    Value<String>? title,
    Value<String>? locator,
    Value<String?>? kind,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return DocumentReferencesCompanion(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      title: title ?? this.title,
      locator: locator ?? this.locator,
      kind: kind ?? this.kind,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (locator.present) {
      map['locator'] = Variable<String>(locator.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentReferencesCompanion(')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('locator: $locator, ')
          ..write('kind: $kind, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditEventsTable extends AuditEvents
    with TableInfo<$AuditEventsTable, AuditEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    at,
    action,
    entityType,
    entityId,
    summary,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      ),
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      ),
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
    );
  }

  @override
  $AuditEventsTable createAlias(String alias) {
    return $AuditEventsTable(attachedDatabase, alias);
  }
}

class AuditEvent extends DataClass implements Insertable<AuditEvent> {
  final int id;
  final DateTime at;
  final String action;
  final String? entityType;
  final String? entityId;
  final String summary;
  const AuditEvent({
    required this.id,
    required this.at,
    required this.action,
    this.entityType,
    this.entityId,
    required this.summary,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['at'] = Variable<DateTime>(at);
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || entityType != null) {
      map['entity_type'] = Variable<String>(entityType);
    }
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<String>(entityId);
    }
    map['summary'] = Variable<String>(summary);
    return map;
  }

  AuditEventsCompanion toCompanion(bool nullToAbsent) {
    return AuditEventsCompanion(
      id: Value(id),
      at: Value(at),
      action: Value(action),
      entityType: entityType == null && nullToAbsent
          ? const Value.absent()
          : Value(entityType),
      entityId: entityId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityId),
      summary: Value(summary),
    );
  }

  factory AuditEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditEvent(
      id: serializer.fromJson<int>(json['id']),
      at: serializer.fromJson<DateTime>(json['at']),
      action: serializer.fromJson<String>(json['action']),
      entityType: serializer.fromJson<String?>(json['entityType']),
      entityId: serializer.fromJson<String?>(json['entityId']),
      summary: serializer.fromJson<String>(json['summary']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'at': serializer.toJson<DateTime>(at),
      'action': serializer.toJson<String>(action),
      'entityType': serializer.toJson<String?>(entityType),
      'entityId': serializer.toJson<String?>(entityId),
      'summary': serializer.toJson<String>(summary),
    };
  }

  AuditEvent copyWith({
    int? id,
    DateTime? at,
    String? action,
    Value<String?> entityType = const Value.absent(),
    Value<String?> entityId = const Value.absent(),
    String? summary,
  }) => AuditEvent(
    id: id ?? this.id,
    at: at ?? this.at,
    action: action ?? this.action,
    entityType: entityType.present ? entityType.value : this.entityType,
    entityId: entityId.present ? entityId.value : this.entityId,
    summary: summary ?? this.summary,
  );
  AuditEvent copyWithCompanion(AuditEventsCompanion data) {
    return AuditEvent(
      id: data.id.present ? data.id.value : this.id,
      at: data.at.present ? data.at.value : this.at,
      action: data.action.present ? data.action.value : this.action,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      summary: data.summary.present ? data.summary.value : this.summary,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditEvent(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('summary: $summary')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, at, action, entityType, entityId, summary);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditEvent &&
          other.id == this.id &&
          other.at == this.at &&
          other.action == this.action &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.summary == this.summary);
}

class AuditEventsCompanion extends UpdateCompanion<AuditEvent> {
  final Value<int> id;
  final Value<DateTime> at;
  final Value<String> action;
  final Value<String?> entityType;
  final Value<String?> entityId;
  final Value<String> summary;
  const AuditEventsCompanion({
    this.id = const Value.absent(),
    this.at = const Value.absent(),
    this.action = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.summary = const Value.absent(),
  });
  AuditEventsCompanion.insert({
    this.id = const Value.absent(),
    this.at = const Value.absent(),
    required String action,
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    required String summary,
  }) : action = Value(action),
       summary = Value(summary);
  static Insertable<AuditEvent> custom({
    Expression<int>? id,
    Expression<DateTime>? at,
    Expression<String>? action,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? summary,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (at != null) 'at': at,
      if (action != null) 'action': action,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (summary != null) 'summary': summary,
    });
  }

  AuditEventsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? at,
    Value<String>? action,
    Value<String?>? entityType,
    Value<String?>? entityId,
    Value<String>? summary,
  }) {
    return AuditEventsCompanion(
      id: id ?? this.id,
      at: at ?? this.at,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      summary: summary ?? this.summary,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditEventsCompanion(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('summary: $summary')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PlatformsTable platforms = $PlatformsTable(this);
  late final $EmailIdentitiesTable emailIdentities = $EmailIdentitiesTable(
    this,
  );
  late final $SecureItemsTable secureItems = $SecureItemsTable(this);
  late final $CredentialReferencesTable credentialReferences =
      $CredentialReferencesTable(this);
  late final $ServiceAccountsTable serviceAccounts = $ServiceAccountsTable(
    this,
  );
  late final $OrganizationsTable organizations = $OrganizationsTable(this);
  late final $ArtistsTable artists = $ArtistsTable(this);
  late final $YoutubeChannelsTable youtubeChannels = $YoutubeChannelsTable(
    this,
  );
  late final $ChannelManagersTable channelManagers = $ChannelManagersTable(
    this,
  );
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $LinksTable links = $LinksTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $TagLinksTable tagLinks = $TagLinksTable(this);
  late final $CustomFieldsTable customFields = $CustomFieldsTable(this);
  late final $BankAccountsTable bankAccounts = $BankAccountsTable(this);
  late final $PaymentCardsTable paymentCards = $PaymentCardsTable(this);
  late final $PaymentMethodsTable paymentMethods = $PaymentMethodsTable(this);
  late final $SubscriptionsTable subscriptions = $SubscriptionsTable(this);
  late final $SubscriptionEventsTable subscriptionEvents =
      $SubscriptionEventsTable(this);
  late final $DocumentReferencesTable documentReferences =
      $DocumentReferencesTable(this);
  late final $AuditEventsTable auditEvents = $AuditEventsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    platforms,
    emailIdentities,
    secureItems,
    credentialReferences,
    serviceAccounts,
    organizations,
    artists,
    youtubeChannels,
    channelManagers,
    projects,
    links,
    tags,
    tagLinks,
    customFields,
    bankAccounts,
    paymentCards,
    paymentMethods,
    subscriptions,
    subscriptionEvents,
    documentReferences,
    auditEvents,
    settings,
  ];
}

typedef $$PlatformsTableCreateCompanionBuilder = PlatformsCompanion Function({
  required String id,
  required String name,
  required String categories,
  Value<String?> website,
  Value<String> description,
  Value<String> platformType,
  Value<String?> vendor,
  Value<String?> iconSlug,
  Value<String?> logoAsset,
  Value<bool> isCustom,
  Value<bool> isFavorite,
  Value<bool> inMyWorld,
  Value<int> sortOrder,
  Value<DateTime?> addedToMyWorldAt,
  Value<int> catalogVersion,
  Value<int> rowid,
});
typedef $$PlatformsTableUpdateCompanionBuilder = PlatformsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> categories,
  Value<String?> website,
  Value<String> description,
  Value<String> platformType,
  Value<String?> vendor,
  Value<String?> iconSlug,
  Value<String?> logoAsset,
  Value<bool> isCustom,
  Value<bool> isFavorite,
  Value<bool> inMyWorld,
  Value<int> sortOrder,
  Value<DateTime?> addedToMyWorldAt,
  Value<int> catalogVersion,
  Value<int> rowid,
});

final class $$PlatformsTableReferences
    extends BaseReferences<_$AppDatabase, $PlatformsTable, Platform> {
  $$PlatformsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ServiceAccountsTable, List<ServiceAccount>>
  _serviceAccountsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.serviceAccounts,
    aliasName: 'platforms__id__service_accounts__platform_id',
  );

  $$ServiceAccountsTableProcessedTableManager get serviceAccountsRefs {
    final manager = $$ServiceAccountsTableTableManager(
      $_db,
      $_db.serviceAccounts,
    ).filter((f) => f.platformId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _serviceAccountsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BankAccountsTable, List<BankAccount>>
  _bankAccountsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bankAccounts,
    aliasName: 'platforms__id__bank_accounts__platform_id',
  );

  $$BankAccountsTableProcessedTableManager get bankAccountsRefs {
    final manager = $$BankAccountsTableTableManager(
      $_db,
      $_db.bankAccounts,
    ).filter((f) => f.platformId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bankAccountsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaymentMethodsTable, List<PaymentMethod>>
  _paymentMethodsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.paymentMethods,
    aliasName: 'platforms__id__payment_methods__platform_id',
  );

  $$PaymentMethodsTableProcessedTableManager get paymentMethodsRefs {
    final manager = $$PaymentMethodsTableTableManager(
      $_db,
      $_db.paymentMethods,
    ).filter((f) => f.platformId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentMethodsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SubscriptionsTable, List<Subscription>>
  _subscriptionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.subscriptions,
    aliasName: 'platforms__id__subscriptions__platform_id',
  );

  $$SubscriptionsTableProcessedTableManager get subscriptionsRefs {
    final manager = $$SubscriptionsTableTableManager(
      $_db,
      $_db.subscriptions,
    ).filter((f) => f.platformId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_subscriptionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlatformsTableFilterComposer
    extends Composer<_$AppDatabase, $PlatformsTable> {
  $$PlatformsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categories => $composableBuilder(
    column: $table.categories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platformType => $composableBuilder(
    column: $table.platformType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vendor => $composableBuilder(
    column: $table.vendor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconSlug => $composableBuilder(
    column: $table.iconSlug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoAsset => $composableBuilder(
    column: $table.logoAsset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get inMyWorld => $composableBuilder(
    column: $table.inMyWorld,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedToMyWorldAt => $composableBuilder(
    column: $table.addedToMyWorldAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get catalogVersion => $composableBuilder(
    column: $table.catalogVersion,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> serviceAccountsRefs(
    Expression<bool> Function($$ServiceAccountsTableFilterComposer f) f,
  ) {
    final $$ServiceAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serviceAccounts,
      getReferencedColumn: (t) => t.platformId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceAccountsTableFilterComposer(
            $db: $db,
            $table: $db.serviceAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bankAccountsRefs(
    Expression<bool> Function($$BankAccountsTableFilterComposer f) f,
  ) {
    final $$BankAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bankAccounts,
      getReferencedColumn: (t) => t.platformId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BankAccountsTableFilterComposer(
            $db: $db,
            $table: $db.bankAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paymentMethodsRefs(
    Expression<bool> Function($$PaymentMethodsTableFilterComposer f) f,
  ) {
    final $$PaymentMethodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.platformId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableFilterComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> subscriptionsRefs(
    Expression<bool> Function($$SubscriptionsTableFilterComposer f) f,
  ) {
    final $$SubscriptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subscriptions,
      getReferencedColumn: (t) => t.platformId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableFilterComposer(
            $db: $db,
            $table: $db.subscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlatformsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlatformsTable> {
  $$PlatformsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categories => $composableBuilder(
    column: $table.categories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platformType => $composableBuilder(
    column: $table.platformType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vendor => $composableBuilder(
    column: $table.vendor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconSlug => $composableBuilder(
    column: $table.iconSlug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoAsset => $composableBuilder(
    column: $table.logoAsset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get inMyWorld => $composableBuilder(
    column: $table.inMyWorld,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedToMyWorldAt => $composableBuilder(
    column: $table.addedToMyWorldAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get catalogVersion => $composableBuilder(
    column: $table.catalogVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlatformsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlatformsTable> {
  $$PlatformsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get categories => $composableBuilder(
    column: $table.categories,
    builder: (column) => column,
  );

  GeneratedColumn<String> get website =>
      $composableBuilder(column: $table.website, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get platformType => $composableBuilder(
    column: $table.platformType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vendor =>
      $composableBuilder(column: $table.vendor, builder: (column) => column);

  GeneratedColumn<String> get iconSlug =>
      $composableBuilder(column: $table.iconSlug, builder: (column) => column);

  GeneratedColumn<String> get logoAsset =>
      $composableBuilder(column: $table.logoAsset, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get inMyWorld =>
      $composableBuilder(column: $table.inMyWorld, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get addedToMyWorldAt => $composableBuilder(
    column: $table.addedToMyWorldAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get catalogVersion => $composableBuilder(
    column: $table.catalogVersion,
    builder: (column) => column,
  );

  Expression<T> serviceAccountsRefs<T extends Object>(
    Expression<T> Function($$ServiceAccountsTableAnnotationComposer a) f,
  ) {
    final $$ServiceAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serviceAccounts,
      getReferencedColumn: (t) => t.platformId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.serviceAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> bankAccountsRefs<T extends Object>(
    Expression<T> Function($$BankAccountsTableAnnotationComposer a) f,
  ) {
    final $$BankAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bankAccounts,
      getReferencedColumn: (t) => t.platformId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BankAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.bankAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> paymentMethodsRefs<T extends Object>(
    Expression<T> Function($$PaymentMethodsTableAnnotationComposer a) f,
  ) {
    final $$PaymentMethodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.platformId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableAnnotationComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> subscriptionsRefs<T extends Object>(
    Expression<T> Function($$SubscriptionsTableAnnotationComposer a) f,
  ) {
    final $$SubscriptionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subscriptions,
      getReferencedColumn: (t) => t.platformId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableAnnotationComposer(
            $db: $db,
            $table: $db.subscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlatformsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlatformsTable,
          Platform,
          $$PlatformsTableFilterComposer,
          $$PlatformsTableOrderingComposer,
          $$PlatformsTableAnnotationComposer,
          $$PlatformsTableCreateCompanionBuilder,
          $$PlatformsTableUpdateCompanionBuilder,
          (Platform, $$PlatformsTableReferences),
          Platform,
          PrefetchHooks Function({
            bool serviceAccountsRefs,
            bool bankAccountsRefs,
            bool paymentMethodsRefs,
            bool subscriptionsRefs,
          })
        > {
  $$PlatformsTableTableManager(_$AppDatabase db, $PlatformsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlatformsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlatformsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlatformsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> categories = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> platformType = const Value.absent(),
                Value<String?> vendor = const Value.absent(),
                Value<String?> iconSlug = const Value.absent(),
                Value<String?> logoAsset = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> inMyWorld = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime?> addedToMyWorldAt = const Value.absent(),
                Value<int> catalogVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlatformsCompanion(
                id: id,
                name: name,
                categories: categories,
                website: website,
                description: description,
                platformType: platformType,
                vendor: vendor,
                iconSlug: iconSlug,
                logoAsset: logoAsset,
                isCustom: isCustom,
                isFavorite: isFavorite,
                inMyWorld: inMyWorld,
                sortOrder: sortOrder,
                addedToMyWorldAt: addedToMyWorldAt,
                catalogVersion: catalogVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String categories,
                Value<String?> website = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> platformType = const Value.absent(),
                Value<String?> vendor = const Value.absent(),
                Value<String?> iconSlug = const Value.absent(),
                Value<String?> logoAsset = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> inMyWorld = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime?> addedToMyWorldAt = const Value.absent(),
                Value<int> catalogVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlatformsCompanion.insert(
                id: id,
                name: name,
                categories: categories,
                website: website,
                description: description,
                platformType: platformType,
                vendor: vendor,
                iconSlug: iconSlug,
                logoAsset: logoAsset,
                isCustom: isCustom,
                isFavorite: isFavorite,
                inMyWorld: inMyWorld,
                sortOrder: sortOrder,
                addedToMyWorldAt: addedToMyWorldAt,
                catalogVersion: catalogVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlatformsTable, Platform>(table),
                  $$PlatformsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                serviceAccountsRefs = false,
                bankAccountsRefs = false,
                paymentMethodsRefs = false,
                subscriptionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (serviceAccountsRefs) db.serviceAccounts,
                    if (bankAccountsRefs) db.bankAccounts,
                    if (paymentMethodsRefs) db.paymentMethods,
                    if (subscriptionsRefs) db.subscriptions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (serviceAccountsRefs)
                        await $_getPrefetchedDataByColumns<
                          Platform,
                          $PlatformsTable,
                          ServiceAccount,
                          $ServiceAccountsTable
                        >(
                          currentTable: table,
                          referencedTable: $$PlatformsTableReferences
                              ._serviceAccountsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlatformsTableReferences(
                                db,
                                table,
                                p0,
                              ).serviceAccountsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'platform_id',
                          typedResults: items,
                        ),
                      if (bankAccountsRefs)
                        await $_getPrefetchedDataByColumns<
                          Platform,
                          $PlatformsTable,
                          BankAccount,
                          $BankAccountsTable
                        >(
                          currentTable: table,
                          referencedTable: $$PlatformsTableReferences
                              ._bankAccountsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlatformsTableReferences(
                                db,
                                table,
                                p0,
                              ).bankAccountsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'platform_id',
                          typedResults: items,
                        ),
                      if (paymentMethodsRefs)
                        await $_getPrefetchedDataByColumns<
                          Platform,
                          $PlatformsTable,
                          PaymentMethod,
                          $PaymentMethodsTable
                        >(
                          currentTable: table,
                          referencedTable: $$PlatformsTableReferences
                              ._paymentMethodsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlatformsTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentMethodsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'platform_id',
                          typedResults: items,
                        ),
                      if (subscriptionsRefs)
                        await $_getPrefetchedDataByColumns<
                          Platform,
                          $PlatformsTable,
                          Subscription,
                          $SubscriptionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$PlatformsTableReferences
                              ._subscriptionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlatformsTableReferences(
                                db,
                                table,
                                p0,
                              ).subscriptionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'platform_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PlatformsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlatformsTable,
      Platform,
      $$PlatformsTableFilterComposer,
      $$PlatformsTableOrderingComposer,
      $$PlatformsTableAnnotationComposer,
      $$PlatformsTableCreateCompanionBuilder,
      $$PlatformsTableUpdateCompanionBuilder,
      (Platform, $$PlatformsTableReferences),
      Platform,
      PrefetchHooks Function({
        bool serviceAccountsRefs,
        bool bankAccountsRefs,
        bool paymentMethodsRefs,
        bool subscriptionsRefs,
      })
    >;
typedef $$EmailIdentitiesTableCreateCompanionBuilder =
    EmailIdentitiesCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      required String id,
      required String address,
      required String normalizedAddress,
      Value<String?> provider,
      Value<String?> displayName,
      Value<String?> purpose,
      Value<String> classification,
      Value<String?> recoveryNotes,
      Value<String?> notes,
      Value<String> status,
      Value<bool> isFavorite,
      Value<int> rowid,
    });
typedef $$EmailIdentitiesTableUpdateCompanionBuilder =
    EmailIdentitiesCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      Value<String> id,
      Value<String> address,
      Value<String> normalizedAddress,
      Value<String?> provider,
      Value<String?> displayName,
      Value<String?> purpose,
      Value<String> classification,
      Value<String?> recoveryNotes,
      Value<String?> notes,
      Value<String> status,
      Value<bool> isFavorite,
      Value<int> rowid,
    });

final class $$EmailIdentitiesTableReferences
    extends
        BaseReferences<_$AppDatabase, $EmailIdentitiesTable, EmailIdentity> {
  $$EmailIdentitiesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ServiceAccountsTable, List<ServiceAccount>>
  _serviceAccountsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.serviceAccounts,
    aliasName: 'email_identities__id__service_accounts__email_identity_id',
  );

  $$ServiceAccountsTableProcessedTableManager get serviceAccountsRefs {
    final manager =
        $$ServiceAccountsTableTableManager($_db, $_db.serviceAccounts).filter(
          (f) => f.emailIdentityId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _serviceAccountsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrganizationsTable, List<Organization>>
  _organizationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.organizations,
    aliasName: 'email_identities__id__organizations__primary_email_id',
  );

  $$OrganizationsTableProcessedTableManager get organizationsRefs {
    final manager = $$OrganizationsTableTableManager(
      $_db,
      $_db.organizations,
    ).filter((f) => f.primaryEmailId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_organizationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ArtistsTable, List<Artist>> _artistsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.artists,
    aliasName: 'email_identities__id__artists__primary_email_id',
  );

  $$ArtistsTableProcessedTableManager get artistsRefs {
    final manager = $$ArtistsTableTableManager(
      $_db,
      $_db.artists,
    ).filter((f) => f.primaryEmailId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_artistsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$YoutubeChannelsTable, List<YoutubeChannel>>
  _youtubeChannelsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.youtubeChannels,
    aliasName: 'email_identities__id__youtube_channels__owner_email_id',
  );

  $$YoutubeChannelsTableProcessedTableManager get youtubeChannelsRefs {
    final manager = $$YoutubeChannelsTableTableManager(
      $_db,
      $_db.youtubeChannels,
    ).filter((f) => f.ownerEmailId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _youtubeChannelsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ChannelManagersTable, List<ChannelManager>>
  _channelManagersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.channelManagers,
    aliasName: 'email_identities__id__channel_managers__email_identity_id',
  );

  $$ChannelManagersTableProcessedTableManager get channelManagersRefs {
    final manager =
        $$ChannelManagersTableTableManager($_db, $_db.channelManagers).filter(
          (f) => f.emailIdentityId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _channelManagersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EmailIdentitiesTableFilterComposer
    extends Composer<_$AppDatabase, $EmailIdentitiesTable> {
  $$EmailIdentitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedAddress => $composableBuilder(
    column: $table.normalizedAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recoveryNotes => $composableBuilder(
    column: $table.recoveryNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> serviceAccountsRefs(
    Expression<bool> Function($$ServiceAccountsTableFilterComposer f) f,
  ) {
    final $$ServiceAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serviceAccounts,
      getReferencedColumn: (t) => t.emailIdentityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceAccountsTableFilterComposer(
            $db: $db,
            $table: $db.serviceAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> organizationsRefs(
    Expression<bool> Function($$OrganizationsTableFilterComposer f) f,
  ) {
    final $$OrganizationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.primaryEmailId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableFilterComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> artistsRefs(
    Expression<bool> Function($$ArtistsTableFilterComposer f) f,
  ) {
    final $$ArtistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.artists,
      getReferencedColumn: (t) => t.primaryEmailId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistsTableFilterComposer(
            $db: $db,
            $table: $db.artists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> youtubeChannelsRefs(
    Expression<bool> Function($$YoutubeChannelsTableFilterComposer f) f,
  ) {
    final $$YoutubeChannelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.youtubeChannels,
      getReferencedColumn: (t) => t.ownerEmailId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YoutubeChannelsTableFilterComposer(
            $db: $db,
            $table: $db.youtubeChannels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> channelManagersRefs(
    Expression<bool> Function($$ChannelManagersTableFilterComposer f) f,
  ) {
    final $$ChannelManagersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.channelManagers,
      getReferencedColumn: (t) => t.emailIdentityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChannelManagersTableFilterComposer(
            $db: $db,
            $table: $db.channelManagers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmailIdentitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $EmailIdentitiesTable> {
  $$EmailIdentitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedAddress => $composableBuilder(
    column: $table.normalizedAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recoveryNotes => $composableBuilder(
    column: $table.recoveryNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmailIdentitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmailIdentitiesTable> {
  $$EmailIdentitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get normalizedAddress => $composableBuilder(
    column: $table.normalizedAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get purpose =>
      $composableBuilder(column: $table.purpose, builder: (column) => column);

  GeneratedColumn<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recoveryNotes => $composableBuilder(
    column: $table.recoveryNotes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  Expression<T> serviceAccountsRefs<T extends Object>(
    Expression<T> Function($$ServiceAccountsTableAnnotationComposer a) f,
  ) {
    final $$ServiceAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serviceAccounts,
      getReferencedColumn: (t) => t.emailIdentityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.serviceAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> organizationsRefs<T extends Object>(
    Expression<T> Function($$OrganizationsTableAnnotationComposer a) f,
  ) {
    final $$OrganizationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.primaryEmailId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableAnnotationComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> artistsRefs<T extends Object>(
    Expression<T> Function($$ArtistsTableAnnotationComposer a) f,
  ) {
    final $$ArtistsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.artists,
      getReferencedColumn: (t) => t.primaryEmailId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistsTableAnnotationComposer(
            $db: $db,
            $table: $db.artists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> youtubeChannelsRefs<T extends Object>(
    Expression<T> Function($$YoutubeChannelsTableAnnotationComposer a) f,
  ) {
    final $$YoutubeChannelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.youtubeChannels,
      getReferencedColumn: (t) => t.ownerEmailId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YoutubeChannelsTableAnnotationComposer(
            $db: $db,
            $table: $db.youtubeChannels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> channelManagersRefs<T extends Object>(
    Expression<T> Function($$ChannelManagersTableAnnotationComposer a) f,
  ) {
    final $$ChannelManagersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.channelManagers,
      getReferencedColumn: (t) => t.emailIdentityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChannelManagersTableAnnotationComposer(
            $db: $db,
            $table: $db.channelManagers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmailIdentitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmailIdentitiesTable,
          EmailIdentity,
          $$EmailIdentitiesTableFilterComposer,
          $$EmailIdentitiesTableOrderingComposer,
          $$EmailIdentitiesTableAnnotationComposer,
          $$EmailIdentitiesTableCreateCompanionBuilder,
          $$EmailIdentitiesTableUpdateCompanionBuilder,
          (EmailIdentity, $$EmailIdentitiesTableReferences),
          EmailIdentity,
          PrefetchHooks Function({
            bool serviceAccountsRefs,
            bool organizationsRefs,
            bool artistsRefs,
            bool youtubeChannelsRefs,
            bool channelManagersRefs,
          })
        > {
  $$EmailIdentitiesTableTableManager(
    _$AppDatabase db,
    $EmailIdentitiesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmailIdentitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmailIdentitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmailIdentitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> normalizedAddress = const Value.absent(),
                Value<String?> provider = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> purpose = const Value.absent(),
                Value<String> classification = const Value.absent(),
                Value<String?> recoveryNotes = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmailIdentitiesCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                id: id,
                address: address,
                normalizedAddress: normalizedAddress,
                provider: provider,
                displayName: displayName,
                purpose: purpose,
                classification: classification,
                recoveryNotes: recoveryNotes,
                notes: notes,
                status: status,
                isFavorite: isFavorite,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                required String id,
                required String address,
                required String normalizedAddress,
                Value<String?> provider = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> purpose = const Value.absent(),
                Value<String> classification = const Value.absent(),
                Value<String?> recoveryNotes = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmailIdentitiesCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                id: id,
                address: address,
                normalizedAddress: normalizedAddress,
                provider: provider,
                displayName: displayName,
                purpose: purpose,
                classification: classification,
                recoveryNotes: recoveryNotes,
                notes: notes,
                status: status,
                isFavorite: isFavorite,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EmailIdentitiesTable, EmailIdentity>(table),
                  $$EmailIdentitiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                serviceAccountsRefs = false,
                organizationsRefs = false,
                artistsRefs = false,
                youtubeChannelsRefs = false,
                channelManagersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (serviceAccountsRefs) db.serviceAccounts,
                    if (organizationsRefs) db.organizations,
                    if (artistsRefs) db.artists,
                    if (youtubeChannelsRefs) db.youtubeChannels,
                    if (channelManagersRefs) db.channelManagers,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (serviceAccountsRefs)
                        await $_getPrefetchedDataByColumns<
                          EmailIdentity,
                          $EmailIdentitiesTable,
                          ServiceAccount,
                          $ServiceAccountsTable
                        >(
                          currentTable: table,
                          referencedTable: $$EmailIdentitiesTableReferences
                              ._serviceAccountsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmailIdentitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).serviceAccountsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'email_identity_id',
                          typedResults: items,
                        ),
                      if (organizationsRefs)
                        await $_getPrefetchedDataByColumns<
                          EmailIdentity,
                          $EmailIdentitiesTable,
                          Organization,
                          $OrganizationsTable
                        >(
                          currentTable: table,
                          referencedTable: $$EmailIdentitiesTableReferences
                              ._organizationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmailIdentitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).organizationsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'primary_email_id',
                          typedResults: items,
                        ),
                      if (artistsRefs)
                        await $_getPrefetchedDataByColumns<
                          EmailIdentity,
                          $EmailIdentitiesTable,
                          Artist,
                          $ArtistsTable
                        >(
                          currentTable: table,
                          referencedTable: $$EmailIdentitiesTableReferences
                              ._artistsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmailIdentitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).artistsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'primary_email_id',
                          typedResults: items,
                        ),
                      if (youtubeChannelsRefs)
                        await $_getPrefetchedDataByColumns<
                          EmailIdentity,
                          $EmailIdentitiesTable,
                          YoutubeChannel,
                          $YoutubeChannelsTable
                        >(
                          currentTable: table,
                          referencedTable: $$EmailIdentitiesTableReferences
                              ._youtubeChannelsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmailIdentitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).youtubeChannelsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'owner_email_id',
                          typedResults: items,
                        ),
                      if (channelManagersRefs)
                        await $_getPrefetchedDataByColumns<
                          EmailIdentity,
                          $EmailIdentitiesTable,
                          ChannelManager,
                          $ChannelManagersTable
                        >(
                          currentTable: table,
                          referencedTable: $$EmailIdentitiesTableReferences
                              ._channelManagersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmailIdentitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).channelManagersRefs,
                          currentColumn: 'id',
                          referencedColumn: 'email_identity_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EmailIdentitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmailIdentitiesTable,
      EmailIdentity,
      $$EmailIdentitiesTableFilterComposer,
      $$EmailIdentitiesTableOrderingComposer,
      $$EmailIdentitiesTableAnnotationComposer,
      $$EmailIdentitiesTableCreateCompanionBuilder,
      $$EmailIdentitiesTableUpdateCompanionBuilder,
      (EmailIdentity, $$EmailIdentitiesTableReferences),
      EmailIdentity,
      PrefetchHooks Function({
        bool serviceAccountsRefs,
        bool organizationsRefs,
        bool artistsRefs,
        bool youtubeChannelsRefs,
        bool channelManagersRefs,
      })
    >;
typedef $$SecureItemsTableCreateCompanionBuilder =
    SecureItemsCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required String id,
      required String title,
      required String kind,
      required Uint8List ciphertext,
      required Uint8List nonce,
      Value<String> keyId,
      Value<DateTime?> lastViewedAt,
      Value<int> rowid,
    });
typedef $$SecureItemsTableUpdateCompanionBuilder =
    SecureItemsCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> id,
      Value<String> title,
      Value<String> kind,
      Value<Uint8List> ciphertext,
      Value<Uint8List> nonce,
      Value<String> keyId,
      Value<DateTime?> lastViewedAt,
      Value<int> rowid,
    });

final class $$SecureItemsTableReferences
    extends BaseReferences<_$AppDatabase, $SecureItemsTable, SecureItem> {
  $$SecureItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $CredentialReferencesTable,
    List<CredentialReference>
  >
  _credentialReferencesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.credentialReferences,
        aliasName: 'secure_items__id__credential_references__vault_item_id',
      );

  $$CredentialReferencesTableProcessedTableManager
  get credentialReferencesRefs {
    final manager = $$CredentialReferencesTableTableManager(
      $_db,
      $_db.credentialReferences,
    ).filter((f) => f.vaultItemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _credentialReferencesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BankAccountsTable, List<BankAccount>>
  _bankAccountsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bankAccounts,
    aliasName: 'secure_items__id__bank_accounts__full_number_vault_id',
  );

  $$BankAccountsTableProcessedTableManager get bankAccountsRefs {
    final manager = $$BankAccountsTableTableManager($_db, $_db.bankAccounts)
        .filter(
          (f) => f.fullNumberVaultId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_bankAccountsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SecureItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SecureItemsTable> {
  $$SecureItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get ciphertext => $composableBuilder(
    column: $table.ciphertext,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get nonce => $composableBuilder(
    column: $table.nonce,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keyId => $composableBuilder(
    column: $table.keyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastViewedAt => $composableBuilder(
    column: $table.lastViewedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> credentialReferencesRefs(
    Expression<bool> Function($$CredentialReferencesTableFilterComposer f) f,
  ) {
    final $$CredentialReferencesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.credentialReferences,
      getReferencedColumn: (t) => t.vaultItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CredentialReferencesTableFilterComposer(
            $db: $db,
            $table: $db.credentialReferences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bankAccountsRefs(
    Expression<bool> Function($$BankAccountsTableFilterComposer f) f,
  ) {
    final $$BankAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bankAccounts,
      getReferencedColumn: (t) => t.fullNumberVaultId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BankAccountsTableFilterComposer(
            $db: $db,
            $table: $db.bankAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SecureItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SecureItemsTable> {
  $$SecureItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get ciphertext => $composableBuilder(
    column: $table.ciphertext,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get nonce => $composableBuilder(
    column: $table.nonce,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keyId => $composableBuilder(
    column: $table.keyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastViewedAt => $composableBuilder(
    column: $table.lastViewedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SecureItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SecureItemsTable> {
  $$SecureItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<Uint8List> get ciphertext => $composableBuilder(
    column: $table.ciphertext,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get nonce =>
      $composableBuilder(column: $table.nonce, builder: (column) => column);

  GeneratedColumn<String> get keyId =>
      $composableBuilder(column: $table.keyId, builder: (column) => column);

  GeneratedColumn<DateTime> get lastViewedAt => $composableBuilder(
    column: $table.lastViewedAt,
    builder: (column) => column,
  );

  Expression<T> credentialReferencesRefs<T extends Object>(
    Expression<T> Function($$CredentialReferencesTableAnnotationComposer a) f,
  ) {
    final $$CredentialReferencesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.credentialReferences,
          getReferencedColumn: (t) => t.vaultItemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CredentialReferencesTableAnnotationComposer(
                $db: $db,
                $table: $db.credentialReferences,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> bankAccountsRefs<T extends Object>(
    Expression<T> Function($$BankAccountsTableAnnotationComposer a) f,
  ) {
    final $$BankAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bankAccounts,
      getReferencedColumn: (t) => t.fullNumberVaultId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BankAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.bankAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SecureItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SecureItemsTable,
          SecureItem,
          $$SecureItemsTableFilterComposer,
          $$SecureItemsTableOrderingComposer,
          $$SecureItemsTableAnnotationComposer,
          $$SecureItemsTableCreateCompanionBuilder,
          $$SecureItemsTableUpdateCompanionBuilder,
          (SecureItem, $$SecureItemsTableReferences),
          SecureItem,
          PrefetchHooks Function({
            bool credentialReferencesRefs,
            bool bankAccountsRefs,
          })
        > {
  $$SecureItemsTableTableManager(_$AppDatabase db, $SecureItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SecureItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SecureItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SecureItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<Uint8List> ciphertext = const Value.absent(),
                Value<Uint8List> nonce = const Value.absent(),
                Value<String> keyId = const Value.absent(),
                Value<DateTime?> lastViewedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SecureItemsCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                title: title,
                kind: kind,
                ciphertext: ciphertext,
                nonce: nonce,
                keyId: keyId,
                lastViewedAt: lastViewedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required String id,
                required String title,
                required String kind,
                required Uint8List ciphertext,
                required Uint8List nonce,
                Value<String> keyId = const Value.absent(),
                Value<DateTime?> lastViewedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SecureItemsCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                title: title,
                kind: kind,
                ciphertext: ciphertext,
                nonce: nonce,
                keyId: keyId,
                lastViewedAt: lastViewedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SecureItemsTable, SecureItem>(table),
                  $$SecureItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({credentialReferencesRefs = false, bankAccountsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (credentialReferencesRefs) db.credentialReferences,
                    if (bankAccountsRefs) db.bankAccounts,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (credentialReferencesRefs)
                        await $_getPrefetchedDataByColumns<
                          SecureItem,
                          $SecureItemsTable,
                          CredentialReference,
                          $CredentialReferencesTable
                        >(
                          currentTable: table,
                          referencedTable: $$SecureItemsTableReferences
                              ._credentialReferencesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SecureItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).credentialReferencesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'vault_item_id',
                          typedResults: items,
                        ),
                      if (bankAccountsRefs)
                        await $_getPrefetchedDataByColumns<
                          SecureItem,
                          $SecureItemsTable,
                          BankAccount,
                          $BankAccountsTable
                        >(
                          currentTable: table,
                          referencedTable: $$SecureItemsTableReferences
                              ._bankAccountsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SecureItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).bankAccountsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'full_number_vault_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SecureItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SecureItemsTable,
      SecureItem,
      $$SecureItemsTableFilterComposer,
      $$SecureItemsTableOrderingComposer,
      $$SecureItemsTableAnnotationComposer,
      $$SecureItemsTableCreateCompanionBuilder,
      $$SecureItemsTableUpdateCompanionBuilder,
      (SecureItem, $$SecureItemsTableReferences),
      SecureItem,
      PrefetchHooks Function({
        bool credentialReferencesRefs,
        bool bankAccountsRefs,
      })
    >;
typedef $$CredentialReferencesTableCreateCompanionBuilder =
    CredentialReferencesCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required String id,
      required String label,
      Value<String?> manager,
      Value<String?> locator,
      Value<String?> usernameHint,
      Value<String?> notes,
      Value<String?> vaultItemId,
      Value<int> rowid,
    });
typedef $$CredentialReferencesTableUpdateCompanionBuilder =
    CredentialReferencesCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> id,
      Value<String> label,
      Value<String?> manager,
      Value<String?> locator,
      Value<String?> usernameHint,
      Value<String?> notes,
      Value<String?> vaultItemId,
      Value<int> rowid,
    });

final class $$CredentialReferencesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CredentialReferencesTable,
          CredentialReference
        > {
  $$CredentialReferencesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SecureItemsTable _vaultItemIdTable(_$AppDatabase db) => db.secureItems
      .createAlias('credential_references__vault_item_id__secure_items__id');

  $$SecureItemsTableProcessedTableManager? get vaultItemId {
    final $_column = $_itemColumn<String>('vault_item_id');
    if ($_column == null) return null;
    final manager = $$SecureItemsTableTableManager(
      $_db,
      $_db.secureItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vaultItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ServiceAccountsTable, List<ServiceAccount>>
  _serviceAccountsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.serviceAccounts,
    aliasName: 'credential_references__id__service_accounts__credential_ref_id',
  );

  $$ServiceAccountsTableProcessedTableManager get serviceAccountsRefs {
    final manager =
        $$ServiceAccountsTableTableManager($_db, $_db.serviceAccounts).filter(
          (f) => f.credentialRefId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _serviceAccountsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CredentialReferencesTableFilterComposer
    extends Composer<_$AppDatabase, $CredentialReferencesTable> {
  $$CredentialReferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get manager => $composableBuilder(
    column: $table.manager,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locator => $composableBuilder(
    column: $table.locator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usernameHint => $composableBuilder(
    column: $table.usernameHint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$SecureItemsTableFilterComposer get vaultItemId {
    final $$SecureItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vaultItemId,
      referencedTable: $db.secureItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SecureItemsTableFilterComposer(
            $db: $db,
            $table: $db.secureItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> serviceAccountsRefs(
    Expression<bool> Function($$ServiceAccountsTableFilterComposer f) f,
  ) {
    final $$ServiceAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serviceAccounts,
      getReferencedColumn: (t) => t.credentialRefId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceAccountsTableFilterComposer(
            $db: $db,
            $table: $db.serviceAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CredentialReferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $CredentialReferencesTable> {
  $$CredentialReferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manager => $composableBuilder(
    column: $table.manager,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locator => $composableBuilder(
    column: $table.locator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usernameHint => $composableBuilder(
    column: $table.usernameHint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$SecureItemsTableOrderingComposer get vaultItemId {
    final $$SecureItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vaultItemId,
      referencedTable: $db.secureItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SecureItemsTableOrderingComposer(
            $db: $db,
            $table: $db.secureItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CredentialReferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CredentialReferencesTable> {
  $$CredentialReferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get manager =>
      $composableBuilder(column: $table.manager, builder: (column) => column);

  GeneratedColumn<String> get locator =>
      $composableBuilder(column: $table.locator, builder: (column) => column);

  GeneratedColumn<String> get usernameHint => $composableBuilder(
    column: $table.usernameHint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$SecureItemsTableAnnotationComposer get vaultItemId {
    final $$SecureItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vaultItemId,
      referencedTable: $db.secureItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SecureItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.secureItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> serviceAccountsRefs<T extends Object>(
    Expression<T> Function($$ServiceAccountsTableAnnotationComposer a) f,
  ) {
    final $$ServiceAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serviceAccounts,
      getReferencedColumn: (t) => t.credentialRefId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.serviceAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CredentialReferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CredentialReferencesTable,
          CredentialReference,
          $$CredentialReferencesTableFilterComposer,
          $$CredentialReferencesTableOrderingComposer,
          $$CredentialReferencesTableAnnotationComposer,
          $$CredentialReferencesTableCreateCompanionBuilder,
          $$CredentialReferencesTableUpdateCompanionBuilder,
          (CredentialReference, $$CredentialReferencesTableReferences),
          CredentialReference,
          PrefetchHooks Function({bool vaultItemId, bool serviceAccountsRefs})
        > {
  $$CredentialReferencesTableTableManager(
    _$AppDatabase db,
    $CredentialReferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CredentialReferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CredentialReferencesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CredentialReferencesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String?> manager = const Value.absent(),
                Value<String?> locator = const Value.absent(),
                Value<String?> usernameHint = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> vaultItemId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CredentialReferencesCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                label: label,
                manager: manager,
                locator: locator,
                usernameHint: usernameHint,
                notes: notes,
                vaultItemId: vaultItemId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required String id,
                required String label,
                Value<String?> manager = const Value.absent(),
                Value<String?> locator = const Value.absent(),
                Value<String?> usernameHint = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> vaultItemId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CredentialReferencesCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                label: label,
                manager: manager,
                locator: locator,
                usernameHint: usernameHint,
                notes: notes,
                vaultItemId: vaultItemId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CredentialReferencesTable, CredentialReference>(
                    table,
                  ),
                  $$CredentialReferencesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({vaultItemId = false, serviceAccountsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (serviceAccountsRefs) db.serviceAccounts,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (vaultItemId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.vaultItemId,
                            referencedTable:
                                $$CredentialReferencesTableReferences
                                    ._vaultItemIdTable(db),
                            referencedColumn:
                                $$CredentialReferencesTableReferences
                                    ._vaultItemIdTable(db)
                                    .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (serviceAccountsRefs)
                        await $_getPrefetchedDataByColumns<
                          CredentialReference,
                          $CredentialReferencesTable,
                          ServiceAccount,
                          $ServiceAccountsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CredentialReferencesTableReferences
                              ._serviceAccountsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CredentialReferencesTableReferences(
                                db,
                                table,
                                p0,
                              ).serviceAccountsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'credential_ref_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CredentialReferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CredentialReferencesTable,
      CredentialReference,
      $$CredentialReferencesTableFilterComposer,
      $$CredentialReferencesTableOrderingComposer,
      $$CredentialReferencesTableAnnotationComposer,
      $$CredentialReferencesTableCreateCompanionBuilder,
      $$CredentialReferencesTableUpdateCompanionBuilder,
      (CredentialReference, $$CredentialReferencesTableReferences),
      CredentialReference,
      PrefetchHooks Function({bool vaultItemId, bool serviceAccountsRefs})
    >;
typedef $$ServiceAccountsTableCreateCompanionBuilder =
    ServiceAccountsCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      required String id,
      required String platformId,
      Value<String?> emailIdentityId,
      required String accountName,
      Value<String?> username,
      Value<String?> displayName,
      Value<String?> profileUrl,
      Value<String?> purpose,
      Value<String> status,
      Value<String> classification,
      Value<String?> plan,
      Value<String?> billingCycle,
      Value<bool> isApiAccount,
      Value<String?> notes,
      Value<bool> isFavorite,
      Value<DateTime?> lastAccessedAt,
      Value<String?> credentialRefId,
      Value<int> rowid,
    });
typedef $$ServiceAccountsTableUpdateCompanionBuilder =
    ServiceAccountsCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      Value<String> id,
      Value<String> platformId,
      Value<String?> emailIdentityId,
      Value<String> accountName,
      Value<String?> username,
      Value<String?> displayName,
      Value<String?> profileUrl,
      Value<String?> purpose,
      Value<String> status,
      Value<String> classification,
      Value<String?> plan,
      Value<String?> billingCycle,
      Value<bool> isApiAccount,
      Value<String?> notes,
      Value<bool> isFavorite,
      Value<DateTime?> lastAccessedAt,
      Value<String?> credentialRefId,
      Value<int> rowid,
    });

final class $$ServiceAccountsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ServiceAccountsTable, ServiceAccount> {
  $$ServiceAccountsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PlatformsTable _platformIdTable(_$AppDatabase db) =>
      db.platforms.createAlias('service_accounts__platform_id__platforms__id');

  $$PlatformsTableProcessedTableManager get platformId {
    final $_column = $_itemColumn<String>('platform_id')!;

    final manager = $$PlatformsTableTableManager(
      $_db,
      $_db.platforms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_platformIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EmailIdentitiesTable _emailIdentityIdTable(_$AppDatabase db) => db
      .emailIdentities
      .createAlias('service_accounts__email_identity_id__email_identities__id');

  $$EmailIdentitiesTableProcessedTableManager? get emailIdentityId {
    final $_column = $_itemColumn<String>('email_identity_id');
    if ($_column == null) return null;
    final manager = $$EmailIdentitiesTableTableManager(
      $_db,
      $_db.emailIdentities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_emailIdentityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CredentialReferencesTable _credentialRefIdTable(_$AppDatabase db) =>
      db.credentialReferences.createAlias(
        'service_accounts__credential_ref_id__credential_references__id',
      );

  $$CredentialReferencesTableProcessedTableManager? get credentialRefId {
    final $_column = $_itemColumn<String>('credential_ref_id');
    if ($_column == null) return null;
    final manager = $$CredentialReferencesTableTableManager(
      $_db,
      $_db.credentialReferences,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_credentialRefIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SubscriptionsTable, List<Subscription>>
  _subscriptionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.subscriptions,
    aliasName: 'service_accounts__id__subscriptions__account_id',
  );

  $$SubscriptionsTableProcessedTableManager get subscriptionsRefs {
    final manager = $$SubscriptionsTableTableManager(
      $_db,
      $_db.subscriptions,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_subscriptionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ServiceAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $ServiceAccountsTable> {
  $$ServiceAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileUrl => $composableBuilder(
    column: $table.profileUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plan => $composableBuilder(
    column: $table.plan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get billingCycle => $composableBuilder(
    column: $table.billingCycle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isApiAccount => $composableBuilder(
    column: $table.isApiAccount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAccessedAt => $composableBuilder(
    column: $table.lastAccessedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PlatformsTableFilterComposer get platformId {
    final $$PlatformsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.platformId,
      referencedTable: $db.platforms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlatformsTableFilterComposer(
            $db: $db,
            $table: $db.platforms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmailIdentitiesTableFilterComposer get emailIdentityId {
    final $$EmailIdentitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.emailIdentityId,
      referencedTable: $db.emailIdentities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailIdentitiesTableFilterComposer(
            $db: $db,
            $table: $db.emailIdentities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CredentialReferencesTableFilterComposer get credentialRefId {
    final $$CredentialReferencesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.credentialRefId,
      referencedTable: $db.credentialReferences,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CredentialReferencesTableFilterComposer(
            $db: $db,
            $table: $db.credentialReferences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> subscriptionsRefs(
    Expression<bool> Function($$SubscriptionsTableFilterComposer f) f,
  ) {
    final $$SubscriptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subscriptions,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableFilterComposer(
            $db: $db,
            $table: $db.subscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServiceAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiceAccountsTable> {
  $$ServiceAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileUrl => $composableBuilder(
    column: $table.profileUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plan => $composableBuilder(
    column: $table.plan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get billingCycle => $composableBuilder(
    column: $table.billingCycle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isApiAccount => $composableBuilder(
    column: $table.isApiAccount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAccessedAt => $composableBuilder(
    column: $table.lastAccessedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlatformsTableOrderingComposer get platformId {
    final $$PlatformsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.platformId,
      referencedTable: $db.platforms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlatformsTableOrderingComposer(
            $db: $db,
            $table: $db.platforms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmailIdentitiesTableOrderingComposer get emailIdentityId {
    final $$EmailIdentitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.emailIdentityId,
      referencedTable: $db.emailIdentities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailIdentitiesTableOrderingComposer(
            $db: $db,
            $table: $db.emailIdentities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CredentialReferencesTableOrderingComposer get credentialRefId {
    final $$CredentialReferencesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.credentialRefId,
          referencedTable: $db.credentialReferences,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CredentialReferencesTableOrderingComposer(
                $db: $db,
                $table: $db.credentialReferences,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ServiceAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiceAccountsTable> {
  $$ServiceAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get profileUrl => $composableBuilder(
    column: $table.profileUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get purpose =>
      $composableBuilder(column: $table.purpose, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => column,
  );

  GeneratedColumn<String> get plan =>
      $composableBuilder(column: $table.plan, builder: (column) => column);

  GeneratedColumn<String> get billingCycle => $composableBuilder(
    column: $table.billingCycle,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isApiAccount => $composableBuilder(
    column: $table.isApiAccount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastAccessedAt => $composableBuilder(
    column: $table.lastAccessedAt,
    builder: (column) => column,
  );

  $$PlatformsTableAnnotationComposer get platformId {
    final $$PlatformsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.platformId,
      referencedTable: $db.platforms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlatformsTableAnnotationComposer(
            $db: $db,
            $table: $db.platforms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmailIdentitiesTableAnnotationComposer get emailIdentityId {
    final $$EmailIdentitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.emailIdentityId,
      referencedTable: $db.emailIdentities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailIdentitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.emailIdentities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CredentialReferencesTableAnnotationComposer get credentialRefId {
    final $$CredentialReferencesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.credentialRefId,
          referencedTable: $db.credentialReferences,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CredentialReferencesTableAnnotationComposer(
                $db: $db,
                $table: $db.credentialReferences,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> subscriptionsRefs<T extends Object>(
    Expression<T> Function($$SubscriptionsTableAnnotationComposer a) f,
  ) {
    final $$SubscriptionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subscriptions,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableAnnotationComposer(
            $db: $db,
            $table: $db.subscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServiceAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServiceAccountsTable,
          ServiceAccount,
          $$ServiceAccountsTableFilterComposer,
          $$ServiceAccountsTableOrderingComposer,
          $$ServiceAccountsTableAnnotationComposer,
          $$ServiceAccountsTableCreateCompanionBuilder,
          $$ServiceAccountsTableUpdateCompanionBuilder,
          (ServiceAccount, $$ServiceAccountsTableReferences),
          ServiceAccount,
          PrefetchHooks Function({
            bool platformId,
            bool emailIdentityId,
            bool credentialRefId,
            bool subscriptionsRefs,
          })
        > {
  $$ServiceAccountsTableTableManager(
    _$AppDatabase db,
    $ServiceAccountsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiceAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> platformId = const Value.absent(),
                Value<String?> emailIdentityId = const Value.absent(),
                Value<String> accountName = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> profileUrl = const Value.absent(),
                Value<String?> purpose = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> classification = const Value.absent(),
                Value<String?> plan = const Value.absent(),
                Value<String?> billingCycle = const Value.absent(),
                Value<bool> isApiAccount = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime?> lastAccessedAt = const Value.absent(),
                Value<String?> credentialRefId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServiceAccountsCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                id: id,
                platformId: platformId,
                emailIdentityId: emailIdentityId,
                accountName: accountName,
                username: username,
                displayName: displayName,
                profileUrl: profileUrl,
                purpose: purpose,
                status: status,
                classification: classification,
                plan: plan,
                billingCycle: billingCycle,
                isApiAccount: isApiAccount,
                notes: notes,
                isFavorite: isFavorite,
                lastAccessedAt: lastAccessedAt,
                credentialRefId: credentialRefId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                required String id,
                required String platformId,
                Value<String?> emailIdentityId = const Value.absent(),
                required String accountName,
                Value<String?> username = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> profileUrl = const Value.absent(),
                Value<String?> purpose = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> classification = const Value.absent(),
                Value<String?> plan = const Value.absent(),
                Value<String?> billingCycle = const Value.absent(),
                Value<bool> isApiAccount = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime?> lastAccessedAt = const Value.absent(),
                Value<String?> credentialRefId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServiceAccountsCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                id: id,
                platformId: platformId,
                emailIdentityId: emailIdentityId,
                accountName: accountName,
                username: username,
                displayName: displayName,
                profileUrl: profileUrl,
                purpose: purpose,
                status: status,
                classification: classification,
                plan: plan,
                billingCycle: billingCycle,
                isApiAccount: isApiAccount,
                notes: notes,
                isFavorite: isFavorite,
                lastAccessedAt: lastAccessedAt,
                credentialRefId: credentialRefId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ServiceAccountsTable, ServiceAccount>(table),
                  $$ServiceAccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                platformId = false,
                emailIdentityId = false,
                credentialRefId = false,
                subscriptionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (subscriptionsRefs) db.subscriptions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (platformId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.platformId,
                            referencedTable: $$ServiceAccountsTableReferences
                                ._platformIdTable(db),
                            referencedColumn: $$ServiceAccountsTableReferences
                                ._platformIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (emailIdentityId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.emailIdentityId,
                            referencedTable: $$ServiceAccountsTableReferences
                                ._emailIdentityIdTable(db),
                            referencedColumn: $$ServiceAccountsTableReferences
                                ._emailIdentityIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (credentialRefId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.credentialRefId,
                            referencedTable: $$ServiceAccountsTableReferences
                                ._credentialRefIdTable(db),
                            referencedColumn: $$ServiceAccountsTableReferences
                                ._credentialRefIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (subscriptionsRefs)
                        await $_getPrefetchedDataByColumns<
                          ServiceAccount,
                          $ServiceAccountsTable,
                          Subscription,
                          $SubscriptionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ServiceAccountsTableReferences
                              ._subscriptionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ServiceAccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).subscriptionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'account_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ServiceAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServiceAccountsTable,
      ServiceAccount,
      $$ServiceAccountsTableFilterComposer,
      $$ServiceAccountsTableOrderingComposer,
      $$ServiceAccountsTableAnnotationComposer,
      $$ServiceAccountsTableCreateCompanionBuilder,
      $$ServiceAccountsTableUpdateCompanionBuilder,
      (ServiceAccount, $$ServiceAccountsTableReferences),
      ServiceAccount,
      PrefetchHooks Function({
        bool platformId,
        bool emailIdentityId,
        bool credentialRefId,
        bool subscriptionsRefs,
      })
    >;
typedef $$OrganizationsTableCreateCompanionBuilder =
    OrganizationsCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      required String id,
      required String name,
      required String kind,
      Value<String?> description,
      Value<String?> website,
      Value<String?> primaryEmailId,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$OrganizationsTableUpdateCompanionBuilder =
    OrganizationsCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      Value<String> id,
      Value<String> name,
      Value<String> kind,
      Value<String?> description,
      Value<String?> website,
      Value<String?> primaryEmailId,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$OrganizationsTableReferences
    extends BaseReferences<_$AppDatabase, $OrganizationsTable, Organization> {
  $$OrganizationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EmailIdentitiesTable _primaryEmailIdTable(_$AppDatabase db) => db
      .emailIdentities
      .createAlias('organizations__primary_email_id__email_identities__id');

  $$EmailIdentitiesTableProcessedTableManager? get primaryEmailId {
    final $_column = $_itemColumn<String>('primary_email_id');
    if ($_column == null) return null;
    final manager = $$EmailIdentitiesTableTableManager(
      $_db,
      $_db.emailIdentities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_primaryEmailIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ArtistsTable, List<Artist>> _artistsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.artists,
    aliasName: 'organizations__id__artists__label_id',
  );

  $$ArtistsTableProcessedTableManager get artistsRefs {
    final manager = $$ArtistsTableTableManager(
      $_db,
      $_db.artists,
    ).filter((f) => f.labelId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_artistsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$YoutubeChannelsTable, List<YoutubeChannel>>
  _youtubeChannelsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.youtubeChannels,
    aliasName: 'organizations__id__youtube_channels__organization_id',
  );

  $$YoutubeChannelsTableProcessedTableManager get youtubeChannelsRefs {
    final manager = $$YoutubeChannelsTableTableManager(
      $_db,
      $_db.youtubeChannels,
    ).filter((f) => f.organizationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _youtubeChannelsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProjectsTable, List<Project>> _projectsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.projects,
    aliasName: 'organizations__id__projects__organization_id',
  );

  $$ProjectsTableProcessedTableManager get projectsRefs {
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.organizationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_projectsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BankAccountsTable, List<BankAccount>>
  _bankAccountsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bankAccounts,
    aliasName: 'organizations__id__bank_accounts__organization_id',
  );

  $$BankAccountsTableProcessedTableManager get bankAccountsRefs {
    final manager = $$BankAccountsTableTableManager(
      $_db,
      $_db.bankAccounts,
    ).filter((f) => f.organizationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bankAccountsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrganizationsTableFilterComposer
    extends Composer<_$AppDatabase, $OrganizationsTable> {
  $$OrganizationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$EmailIdentitiesTableFilterComposer get primaryEmailId {
    final $$EmailIdentitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.primaryEmailId,
      referencedTable: $db.emailIdentities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailIdentitiesTableFilterComposer(
            $db: $db,
            $table: $db.emailIdentities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> artistsRefs(
    Expression<bool> Function($$ArtistsTableFilterComposer f) f,
  ) {
    final $$ArtistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.artists,
      getReferencedColumn: (t) => t.labelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistsTableFilterComposer(
            $db: $db,
            $table: $db.artists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> youtubeChannelsRefs(
    Expression<bool> Function($$YoutubeChannelsTableFilterComposer f) f,
  ) {
    final $$YoutubeChannelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.youtubeChannels,
      getReferencedColumn: (t) => t.organizationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YoutubeChannelsTableFilterComposer(
            $db: $db,
            $table: $db.youtubeChannels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> projectsRefs(
    Expression<bool> Function($$ProjectsTableFilterComposer f) f,
  ) {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.organizationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bankAccountsRefs(
    Expression<bool> Function($$BankAccountsTableFilterComposer f) f,
  ) {
    final $$BankAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bankAccounts,
      getReferencedColumn: (t) => t.organizationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BankAccountsTableFilterComposer(
            $db: $db,
            $table: $db.bankAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrganizationsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrganizationsTable> {
  $$OrganizationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmailIdentitiesTableOrderingComposer get primaryEmailId {
    final $$EmailIdentitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.primaryEmailId,
      referencedTable: $db.emailIdentities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailIdentitiesTableOrderingComposer(
            $db: $db,
            $table: $db.emailIdentities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrganizationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrganizationsTable> {
  $$OrganizationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get website =>
      $composableBuilder(column: $table.website, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$EmailIdentitiesTableAnnotationComposer get primaryEmailId {
    final $$EmailIdentitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.primaryEmailId,
      referencedTable: $db.emailIdentities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailIdentitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.emailIdentities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> artistsRefs<T extends Object>(
    Expression<T> Function($$ArtistsTableAnnotationComposer a) f,
  ) {
    final $$ArtistsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.artists,
      getReferencedColumn: (t) => t.labelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistsTableAnnotationComposer(
            $db: $db,
            $table: $db.artists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> youtubeChannelsRefs<T extends Object>(
    Expression<T> Function($$YoutubeChannelsTableAnnotationComposer a) f,
  ) {
    final $$YoutubeChannelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.youtubeChannels,
      getReferencedColumn: (t) => t.organizationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YoutubeChannelsTableAnnotationComposer(
            $db: $db,
            $table: $db.youtubeChannels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> projectsRefs<T extends Object>(
    Expression<T> Function($$ProjectsTableAnnotationComposer a) f,
  ) {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.organizationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> bankAccountsRefs<T extends Object>(
    Expression<T> Function($$BankAccountsTableAnnotationComposer a) f,
  ) {
    final $$BankAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bankAccounts,
      getReferencedColumn: (t) => t.organizationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BankAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.bankAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrganizationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrganizationsTable,
          Organization,
          $$OrganizationsTableFilterComposer,
          $$OrganizationsTableOrderingComposer,
          $$OrganizationsTableAnnotationComposer,
          $$OrganizationsTableCreateCompanionBuilder,
          $$OrganizationsTableUpdateCompanionBuilder,
          (Organization, $$OrganizationsTableReferences),
          Organization,
          PrefetchHooks Function({
            bool primaryEmailId,
            bool artistsRefs,
            bool youtubeChannelsRefs,
            bool projectsRefs,
            bool bankAccountsRefs,
          })
        > {
  $$OrganizationsTableTableManager(_$AppDatabase db, $OrganizationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrganizationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrganizationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrganizationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String?> primaryEmailId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrganizationsCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                id: id,
                name: name,
                kind: kind,
                description: description,
                website: website,
                primaryEmailId: primaryEmailId,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                required String id,
                required String name,
                required String kind,
                Value<String?> description = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String?> primaryEmailId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrganizationsCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                id: id,
                name: name,
                kind: kind,
                description: description,
                website: website,
                primaryEmailId: primaryEmailId,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OrganizationsTable, Organization>(table),
                  $$OrganizationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                primaryEmailId = false,
                artistsRefs = false,
                youtubeChannelsRefs = false,
                projectsRefs = false,
                bankAccountsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (artistsRefs) db.artists,
                    if (youtubeChannelsRefs) db.youtubeChannels,
                    if (projectsRefs) db.projects,
                    if (bankAccountsRefs) db.bankAccounts,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (primaryEmailId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.primaryEmailId,
                            referencedTable: $$OrganizationsTableReferences
                                ._primaryEmailIdTable(db),
                            referencedColumn: $$OrganizationsTableReferences
                                ._primaryEmailIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (artistsRefs)
                        await $_getPrefetchedDataByColumns<
                          Organization,
                          $OrganizationsTable,
                          Artist,
                          $ArtistsTable
                        >(
                          currentTable: table,
                          referencedTable: $$OrganizationsTableReferences
                              ._artistsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrganizationsTableReferences(
                                db,
                                table,
                                p0,
                              ).artistsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'label_id',
                          typedResults: items,
                        ),
                      if (youtubeChannelsRefs)
                        await $_getPrefetchedDataByColumns<
                          Organization,
                          $OrganizationsTable,
                          YoutubeChannel,
                          $YoutubeChannelsTable
                        >(
                          currentTable: table,
                          referencedTable: $$OrganizationsTableReferences
                              ._youtubeChannelsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrganizationsTableReferences(
                                db,
                                table,
                                p0,
                              ).youtubeChannelsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'organization_id',
                          typedResults: items,
                        ),
                      if (projectsRefs)
                        await $_getPrefetchedDataByColumns<
                          Organization,
                          $OrganizationsTable,
                          Project,
                          $ProjectsTable
                        >(
                          currentTable: table,
                          referencedTable: $$OrganizationsTableReferences
                              ._projectsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrganizationsTableReferences(
                                db,
                                table,
                                p0,
                              ).projectsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'organization_id',
                          typedResults: items,
                        ),
                      if (bankAccountsRefs)
                        await $_getPrefetchedDataByColumns<
                          Organization,
                          $OrganizationsTable,
                          BankAccount,
                          $BankAccountsTable
                        >(
                          currentTable: table,
                          referencedTable: $$OrganizationsTableReferences
                              ._bankAccountsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrganizationsTableReferences(
                                db,
                                table,
                                p0,
                              ).bankAccountsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'organization_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OrganizationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrganizationsTable,
      Organization,
      $$OrganizationsTableFilterComposer,
      $$OrganizationsTableOrderingComposer,
      $$OrganizationsTableAnnotationComposer,
      $$OrganizationsTableCreateCompanionBuilder,
      $$OrganizationsTableUpdateCompanionBuilder,
      (Organization, $$OrganizationsTableReferences),
      Organization,
      PrefetchHooks Function({
        bool primaryEmailId,
        bool artistsRefs,
        bool youtubeChannelsRefs,
        bool projectsRefs,
        bool bankAccountsRefs,
      })
    >;
typedef $$ArtistsTableCreateCompanionBuilder = ArtistsCompanion Function({
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> archivedAt,
  required String id,
  required String name,
  Value<String?> genre,
  Value<String?> bio,
  Value<String?> labelId,
  Value<String?> primaryEmailId,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$ArtistsTableUpdateCompanionBuilder = ArtistsCompanion Function({
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> archivedAt,
  Value<String> id,
  Value<String> name,
  Value<String?> genre,
  Value<String?> bio,
  Value<String?> labelId,
  Value<String?> primaryEmailId,
  Value<String?> notes,
  Value<int> rowid,
});

final class $$ArtistsTableReferences
    extends BaseReferences<_$AppDatabase, $ArtistsTable, Artist> {
  $$ArtistsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrganizationsTable _labelIdTable(_$AppDatabase db) =>
      db.organizations.createAlias('artists__label_id__organizations__id');

  $$OrganizationsTableProcessedTableManager? get labelId {
    final $_column = $_itemColumn<String>('label_id');
    if ($_column == null) return null;
    final manager = $$OrganizationsTableTableManager(
      $_db,
      $_db.organizations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_labelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EmailIdentitiesTable _primaryEmailIdTable(_$AppDatabase db) => db
      .emailIdentities
      .createAlias('artists__primary_email_id__email_identities__id');

  $$EmailIdentitiesTableProcessedTableManager? get primaryEmailId {
    final $_column = $_itemColumn<String>('primary_email_id');
    if ($_column == null) return null;
    final manager = $$EmailIdentitiesTableTableManager(
      $_db,
      $_db.emailIdentities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_primaryEmailIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$YoutubeChannelsTable, List<YoutubeChannel>>
  _youtubeChannelsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.youtubeChannels,
    aliasName: 'artists__id__youtube_channels__artist_id',
  );

  $$YoutubeChannelsTableProcessedTableManager get youtubeChannelsRefs {
    final manager = $$YoutubeChannelsTableTableManager(
      $_db,
      $_db.youtubeChannels,
    ).filter((f) => f.artistId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _youtubeChannelsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProjectsTable, List<Project>> _projectsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.projects,
    aliasName: 'artists__id__projects__artist_id',
  );

  $$ProjectsTableProcessedTableManager get projectsRefs {
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.artistId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_projectsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ArtistsTableFilterComposer
    extends Composer<_$AppDatabase, $ArtistsTable> {
  $$ArtistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$OrganizationsTableFilterComposer get labelId {
    final $$OrganizationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.labelId,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableFilterComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmailIdentitiesTableFilterComposer get primaryEmailId {
    final $$EmailIdentitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.primaryEmailId,
      referencedTable: $db.emailIdentities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailIdentitiesTableFilterComposer(
            $db: $db,
            $table: $db.emailIdentities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> youtubeChannelsRefs(
    Expression<bool> Function($$YoutubeChannelsTableFilterComposer f) f,
  ) {
    final $$YoutubeChannelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.youtubeChannels,
      getReferencedColumn: (t) => t.artistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YoutubeChannelsTableFilterComposer(
            $db: $db,
            $table: $db.youtubeChannels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> projectsRefs(
    Expression<bool> Function($$ProjectsTableFilterComposer f) f,
  ) {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.artistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ArtistsTableOrderingComposer
    extends Composer<_$AppDatabase, $ArtistsTable> {
  $$ArtistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrganizationsTableOrderingComposer get labelId {
    final $$OrganizationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.labelId,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableOrderingComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmailIdentitiesTableOrderingComposer get primaryEmailId {
    final $$EmailIdentitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.primaryEmailId,
      referencedTable: $db.emailIdentities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailIdentitiesTableOrderingComposer(
            $db: $db,
            $table: $db.emailIdentities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ArtistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ArtistsTable> {
  $$ArtistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => column);

  GeneratedColumn<String> get bio =>
      $composableBuilder(column: $table.bio, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$OrganizationsTableAnnotationComposer get labelId {
    final $$OrganizationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.labelId,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableAnnotationComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmailIdentitiesTableAnnotationComposer get primaryEmailId {
    final $$EmailIdentitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.primaryEmailId,
      referencedTable: $db.emailIdentities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailIdentitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.emailIdentities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> youtubeChannelsRefs<T extends Object>(
    Expression<T> Function($$YoutubeChannelsTableAnnotationComposer a) f,
  ) {
    final $$YoutubeChannelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.youtubeChannels,
      getReferencedColumn: (t) => t.artistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YoutubeChannelsTableAnnotationComposer(
            $db: $db,
            $table: $db.youtubeChannels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> projectsRefs<T extends Object>(
    Expression<T> Function($$ProjectsTableAnnotationComposer a) f,
  ) {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.artistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ArtistsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ArtistsTable,
          Artist,
          $$ArtistsTableFilterComposer,
          $$ArtistsTableOrderingComposer,
          $$ArtistsTableAnnotationComposer,
          $$ArtistsTableCreateCompanionBuilder,
          $$ArtistsTableUpdateCompanionBuilder,
          (Artist, $$ArtistsTableReferences),
          Artist,
          PrefetchHooks Function({
            bool labelId,
            bool primaryEmailId,
            bool youtubeChannelsRefs,
            bool projectsRefs,
          })
        > {
  $$ArtistsTableTableManager(_$AppDatabase db, $ArtistsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArtistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArtistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ArtistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                Value<String?> labelId = const Value.absent(),
                Value<String?> primaryEmailId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArtistsCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                id: id,
                name: name,
                genre: genre,
                bio: bio,
                labelId: labelId,
                primaryEmailId: primaryEmailId,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                required String id,
                required String name,
                Value<String?> genre = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                Value<String?> labelId = const Value.absent(),
                Value<String?> primaryEmailId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArtistsCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                id: id,
                name: name,
                genre: genre,
                bio: bio,
                labelId: labelId,
                primaryEmailId: primaryEmailId,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ArtistsTable, Artist>(table),
                  $$ArtistsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                labelId = false,
                primaryEmailId = false,
                youtubeChannelsRefs = false,
                projectsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (youtubeChannelsRefs) db.youtubeChannels,
                    if (projectsRefs) db.projects,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (labelId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.labelId,
                            referencedTable: $$ArtistsTableReferences
                                ._labelIdTable(db),
                            referencedColumn: $$ArtistsTableReferences
                                ._labelIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (primaryEmailId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.primaryEmailId,
                            referencedTable: $$ArtistsTableReferences
                                ._primaryEmailIdTable(db),
                            referencedColumn: $$ArtistsTableReferences
                                ._primaryEmailIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (youtubeChannelsRefs)
                        await $_getPrefetchedDataByColumns<
                          Artist,
                          $ArtistsTable,
                          YoutubeChannel,
                          $YoutubeChannelsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ArtistsTableReferences
                              ._youtubeChannelsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ArtistsTableReferences(
                                db,
                                table,
                                p0,
                              ).youtubeChannelsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'artist_id',
                          typedResults: items,
                        ),
                      if (projectsRefs)
                        await $_getPrefetchedDataByColumns<
                          Artist,
                          $ArtistsTable,
                          Project,
                          $ProjectsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ArtistsTableReferences
                              ._projectsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ArtistsTableReferences(
                                db,
                                table,
                                p0,
                              ).projectsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'artist_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ArtistsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ArtistsTable,
      Artist,
      $$ArtistsTableFilterComposer,
      $$ArtistsTableOrderingComposer,
      $$ArtistsTableAnnotationComposer,
      $$ArtistsTableCreateCompanionBuilder,
      $$ArtistsTableUpdateCompanionBuilder,
      (Artist, $$ArtistsTableReferences),
      Artist,
      PrefetchHooks Function({
        bool labelId,
        bool primaryEmailId,
        bool youtubeChannelsRefs,
        bool projectsRefs,
      })
    >;
typedef $$YoutubeChannelsTableCreateCompanionBuilder =
    YoutubeChannelsCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      required String id,
      required String name,
      Value<String?> handle,
      Value<String?> channelId,
      Value<String?> url,
      Value<String?> channelType,
      Value<String?> purpose,
      Value<String?> brandingNotes,
      Value<String> status,
      Value<String?> ownerEmailId,
      Value<String?> artistId,
      Value<String?> organizationId,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$YoutubeChannelsTableUpdateCompanionBuilder =
    YoutubeChannelsCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      Value<String> id,
      Value<String> name,
      Value<String?> handle,
      Value<String?> channelId,
      Value<String?> url,
      Value<String?> channelType,
      Value<String?> purpose,
      Value<String?> brandingNotes,
      Value<String> status,
      Value<String?> ownerEmailId,
      Value<String?> artistId,
      Value<String?> organizationId,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$YoutubeChannelsTableReferences
    extends
        BaseReferences<_$AppDatabase, $YoutubeChannelsTable, YoutubeChannel> {
  $$YoutubeChannelsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EmailIdentitiesTable _ownerEmailIdTable(_$AppDatabase db) => db
      .emailIdentities
      .createAlias('youtube_channels__owner_email_id__email_identities__id');

  $$EmailIdentitiesTableProcessedTableManager? get ownerEmailId {
    final $_column = $_itemColumn<String>('owner_email_id');
    if ($_column == null) return null;
    final manager = $$EmailIdentitiesTableTableManager(
      $_db,
      $_db.emailIdentities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerEmailIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ArtistsTable _artistIdTable(_$AppDatabase db) =>
      db.artists.createAlias('youtube_channels__artist_id__artists__id');

  $$ArtistsTableProcessedTableManager? get artistId {
    final $_column = $_itemColumn<String>('artist_id');
    if ($_column == null) return null;
    final manager = $$ArtistsTableTableManager(
      $_db,
      $_db.artists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_artistIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $OrganizationsTable _organizationIdTable(_$AppDatabase db) => db
      .organizations
      .createAlias('youtube_channels__organization_id__organizations__id');

  $$OrganizationsTableProcessedTableManager? get organizationId {
    final $_column = $_itemColumn<String>('organization_id');
    if ($_column == null) return null;
    final manager = $$OrganizationsTableTableManager(
      $_db,
      $_db.organizations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_organizationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ChannelManagersTable, List<ChannelManager>>
  _channelManagersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.channelManagers,
    aliasName: 'youtube_channels__id__channel_managers__channel_id',
  );

  $$ChannelManagersTableProcessedTableManager get channelManagersRefs {
    final manager = $$ChannelManagersTableTableManager(
      $_db,
      $_db.channelManagers,
    ).filter((f) => f.channelId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _channelManagersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$YoutubeChannelsTableFilterComposer
    extends Composer<_$AppDatabase, $YoutubeChannelsTable> {
  $$YoutubeChannelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get handle => $composableBuilder(
    column: $table.handle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get channelType => $composableBuilder(
    column: $table.channelType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandingNotes => $composableBuilder(
    column: $table.brandingNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$EmailIdentitiesTableFilterComposer get ownerEmailId {
    final $$EmailIdentitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerEmailId,
      referencedTable: $db.emailIdentities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailIdentitiesTableFilterComposer(
            $db: $db,
            $table: $db.emailIdentities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ArtistsTableFilterComposer get artistId {
    final $$ArtistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artistId,
      referencedTable: $db.artists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistsTableFilterComposer(
            $db: $db,
            $table: $db.artists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OrganizationsTableFilterComposer get organizationId {
    final $$OrganizationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizationId,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableFilterComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> channelManagersRefs(
    Expression<bool> Function($$ChannelManagersTableFilterComposer f) f,
  ) {
    final $$ChannelManagersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.channelManagers,
      getReferencedColumn: (t) => t.channelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChannelManagersTableFilterComposer(
            $db: $db,
            $table: $db.channelManagers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$YoutubeChannelsTableOrderingComposer
    extends Composer<_$AppDatabase, $YoutubeChannelsTable> {
  $$YoutubeChannelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get handle => $composableBuilder(
    column: $table.handle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channelId => $composableBuilder(
    column: $table.channelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channelType => $composableBuilder(
    column: $table.channelType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandingNotes => $composableBuilder(
    column: $table.brandingNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmailIdentitiesTableOrderingComposer get ownerEmailId {
    final $$EmailIdentitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerEmailId,
      referencedTable: $db.emailIdentities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailIdentitiesTableOrderingComposer(
            $db: $db,
            $table: $db.emailIdentities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ArtistsTableOrderingComposer get artistId {
    final $$ArtistsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artistId,
      referencedTable: $db.artists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistsTableOrderingComposer(
            $db: $db,
            $table: $db.artists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OrganizationsTableOrderingComposer get organizationId {
    final $$OrganizationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizationId,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableOrderingComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$YoutubeChannelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $YoutubeChannelsTable> {
  $$YoutubeChannelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get handle =>
      $composableBuilder(column: $table.handle, builder: (column) => column);

  GeneratedColumn<String> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get channelType => $composableBuilder(
    column: $table.channelType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get purpose =>
      $composableBuilder(column: $table.purpose, builder: (column) => column);

  GeneratedColumn<String> get brandingNotes => $composableBuilder(
    column: $table.brandingNotes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$EmailIdentitiesTableAnnotationComposer get ownerEmailId {
    final $$EmailIdentitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerEmailId,
      referencedTable: $db.emailIdentities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailIdentitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.emailIdentities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ArtistsTableAnnotationComposer get artistId {
    final $$ArtistsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artistId,
      referencedTable: $db.artists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistsTableAnnotationComposer(
            $db: $db,
            $table: $db.artists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OrganizationsTableAnnotationComposer get organizationId {
    final $$OrganizationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizationId,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableAnnotationComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> channelManagersRefs<T extends Object>(
    Expression<T> Function($$ChannelManagersTableAnnotationComposer a) f,
  ) {
    final $$ChannelManagersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.channelManagers,
      getReferencedColumn: (t) => t.channelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChannelManagersTableAnnotationComposer(
            $db: $db,
            $table: $db.channelManagers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$YoutubeChannelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $YoutubeChannelsTable,
          YoutubeChannel,
          $$YoutubeChannelsTableFilterComposer,
          $$YoutubeChannelsTableOrderingComposer,
          $$YoutubeChannelsTableAnnotationComposer,
          $$YoutubeChannelsTableCreateCompanionBuilder,
          $$YoutubeChannelsTableUpdateCompanionBuilder,
          (YoutubeChannel, $$YoutubeChannelsTableReferences),
          YoutubeChannel,
          PrefetchHooks Function({
            bool ownerEmailId,
            bool artistId,
            bool organizationId,
            bool channelManagersRefs,
          })
        > {
  $$YoutubeChannelsTableTableManager(
    _$AppDatabase db,
    $YoutubeChannelsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$YoutubeChannelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$YoutubeChannelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$YoutubeChannelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> handle = const Value.absent(),
                Value<String?> channelId = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> channelType = const Value.absent(),
                Value<String?> purpose = const Value.absent(),
                Value<String?> brandingNotes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> ownerEmailId = const Value.absent(),
                Value<String?> artistId = const Value.absent(),
                Value<String?> organizationId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => YoutubeChannelsCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                id: id,
                name: name,
                handle: handle,
                channelId: channelId,
                url: url,
                channelType: channelType,
                purpose: purpose,
                brandingNotes: brandingNotes,
                status: status,
                ownerEmailId: ownerEmailId,
                artistId: artistId,
                organizationId: organizationId,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                required String id,
                required String name,
                Value<String?> handle = const Value.absent(),
                Value<String?> channelId = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> channelType = const Value.absent(),
                Value<String?> purpose = const Value.absent(),
                Value<String?> brandingNotes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> ownerEmailId = const Value.absent(),
                Value<String?> artistId = const Value.absent(),
                Value<String?> organizationId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => YoutubeChannelsCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                id: id,
                name: name,
                handle: handle,
                channelId: channelId,
                url: url,
                channelType: channelType,
                purpose: purpose,
                brandingNotes: brandingNotes,
                status: status,
                ownerEmailId: ownerEmailId,
                artistId: artistId,
                organizationId: organizationId,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$YoutubeChannelsTable, YoutubeChannel>(table),
                  $$YoutubeChannelsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                ownerEmailId = false,
                artistId = false,
                organizationId = false,
                channelManagersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (channelManagersRefs) db.channelManagers,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (ownerEmailId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.ownerEmailId,
                            referencedTable: $$YoutubeChannelsTableReferences
                                ._ownerEmailIdTable(db),
                            referencedColumn: $$YoutubeChannelsTableReferences
                                ._ownerEmailIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (artistId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.artistId,
                            referencedTable: $$YoutubeChannelsTableReferences
                                ._artistIdTable(db),
                            referencedColumn: $$YoutubeChannelsTableReferences
                                ._artistIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (organizationId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.organizationId,
                            referencedTable: $$YoutubeChannelsTableReferences
                                ._organizationIdTable(db),
                            referencedColumn: $$YoutubeChannelsTableReferences
                                ._organizationIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (channelManagersRefs)
                        await $_getPrefetchedDataByColumns<
                          YoutubeChannel,
                          $YoutubeChannelsTable,
                          ChannelManager,
                          $ChannelManagersTable
                        >(
                          currentTable: table,
                          referencedTable: $$YoutubeChannelsTableReferences
                              ._channelManagersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$YoutubeChannelsTableReferences(
                                db,
                                table,
                                p0,
                              ).channelManagersRefs,
                          currentColumn: 'id',
                          referencedColumn: 'channel_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$YoutubeChannelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $YoutubeChannelsTable,
      YoutubeChannel,
      $$YoutubeChannelsTableFilterComposer,
      $$YoutubeChannelsTableOrderingComposer,
      $$YoutubeChannelsTableAnnotationComposer,
      $$YoutubeChannelsTableCreateCompanionBuilder,
      $$YoutubeChannelsTableUpdateCompanionBuilder,
      (YoutubeChannel, $$YoutubeChannelsTableReferences),
      YoutubeChannel,
      PrefetchHooks Function({
        bool ownerEmailId,
        bool artistId,
        bool organizationId,
        bool channelManagersRefs,
      })
    >;
typedef $$ChannelManagersTableCreateCompanionBuilder =
    ChannelManagersCompanion Function({
      required String channelId,
      required String emailIdentityId,
      Value<String> role,
      Value<int> rowid,
    });
typedef $$ChannelManagersTableUpdateCompanionBuilder =
    ChannelManagersCompanion Function({
      Value<String> channelId,
      Value<String> emailIdentityId,
      Value<String> role,
      Value<int> rowid,
    });

final class $$ChannelManagersTableReferences
    extends
        BaseReferences<_$AppDatabase, $ChannelManagersTable, ChannelManager> {
  $$ChannelManagersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $YoutubeChannelsTable _channelIdTable(_$AppDatabase db) => db
      .youtubeChannels
      .createAlias('channel_managers__channel_id__youtube_channels__id');

  $$YoutubeChannelsTableProcessedTableManager get channelId {
    final $_column = $_itemColumn<String>('channel_id')!;

    final manager = $$YoutubeChannelsTableTableManager(
      $_db,
      $_db.youtubeChannels,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_channelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EmailIdentitiesTable _emailIdentityIdTable(_$AppDatabase db) => db
      .emailIdentities
      .createAlias('channel_managers__email_identity_id__email_identities__id');

  $$EmailIdentitiesTableProcessedTableManager get emailIdentityId {
    final $_column = $_itemColumn<String>('email_identity_id')!;

    final manager = $$EmailIdentitiesTableTableManager(
      $_db,
      $_db.emailIdentities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_emailIdentityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ChannelManagersTableFilterComposer
    extends Composer<_$AppDatabase, $ChannelManagersTable> {
  $$ChannelManagersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  $$YoutubeChannelsTableFilterComposer get channelId {
    final $$YoutubeChannelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.channelId,
      referencedTable: $db.youtubeChannels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YoutubeChannelsTableFilterComposer(
            $db: $db,
            $table: $db.youtubeChannels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmailIdentitiesTableFilterComposer get emailIdentityId {
    final $$EmailIdentitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.emailIdentityId,
      referencedTable: $db.emailIdentities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailIdentitiesTableFilterComposer(
            $db: $db,
            $table: $db.emailIdentities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChannelManagersTableOrderingComposer
    extends Composer<_$AppDatabase, $ChannelManagersTable> {
  $$ChannelManagersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  $$YoutubeChannelsTableOrderingComposer get channelId {
    final $$YoutubeChannelsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.channelId,
      referencedTable: $db.youtubeChannels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YoutubeChannelsTableOrderingComposer(
            $db: $db,
            $table: $db.youtubeChannels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmailIdentitiesTableOrderingComposer get emailIdentityId {
    final $$EmailIdentitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.emailIdentityId,
      referencedTable: $db.emailIdentities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailIdentitiesTableOrderingComposer(
            $db: $db,
            $table: $db.emailIdentities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChannelManagersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChannelManagersTable> {
  $$ChannelManagersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  $$YoutubeChannelsTableAnnotationComposer get channelId {
    final $$YoutubeChannelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.channelId,
      referencedTable: $db.youtubeChannels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YoutubeChannelsTableAnnotationComposer(
            $db: $db,
            $table: $db.youtubeChannels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmailIdentitiesTableAnnotationComposer get emailIdentityId {
    final $$EmailIdentitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.emailIdentityId,
      referencedTable: $db.emailIdentities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailIdentitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.emailIdentities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChannelManagersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChannelManagersTable,
          ChannelManager,
          $$ChannelManagersTableFilterComposer,
          $$ChannelManagersTableOrderingComposer,
          $$ChannelManagersTableAnnotationComposer,
          $$ChannelManagersTableCreateCompanionBuilder,
          $$ChannelManagersTableUpdateCompanionBuilder,
          (ChannelManager, $$ChannelManagersTableReferences),
          ChannelManager,
          PrefetchHooks Function({bool channelId, bool emailIdentityId})
        > {
  $$ChannelManagersTableTableManager(
    _$AppDatabase db,
    $ChannelManagersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChannelManagersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChannelManagersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChannelManagersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> channelId = const Value.absent(),
                Value<String> emailIdentityId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelManagersCompanion(
                channelId: channelId,
                emailIdentityId: emailIdentityId,
                role: role,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String channelId,
                required String emailIdentityId,
                Value<String> role = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelManagersCompanion.insert(
                channelId: channelId,
                emailIdentityId: emailIdentityId,
                role: role,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChannelManagersTable, ChannelManager>(table),
                  $$ChannelManagersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({channelId = false, emailIdentityId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (channelId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.channelId,
                            referencedTable: $$ChannelManagersTableReferences
                                ._channelIdTable(db),
                            referencedColumn: $$ChannelManagersTableReferences
                                ._channelIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (emailIdentityId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.emailIdentityId,
                            referencedTable: $$ChannelManagersTableReferences
                                ._emailIdentityIdTable(db),
                            referencedColumn: $$ChannelManagersTableReferences
                                ._emailIdentityIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ChannelManagersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChannelManagersTable,
      ChannelManager,
      $$ChannelManagersTableFilterComposer,
      $$ChannelManagersTableOrderingComposer,
      $$ChannelManagersTableAnnotationComposer,
      $$ChannelManagersTableCreateCompanionBuilder,
      $$ChannelManagersTableUpdateCompanionBuilder,
      (ChannelManager, $$ChannelManagersTableReferences),
      ChannelManager,
      PrefetchHooks Function({bool channelId, bool emailIdentityId})
    >;
typedef $$ProjectsTableCreateCompanionBuilder = ProjectsCompanion Function({
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> archivedAt,
  required String id,
  required String name,
  required String kind,
  Value<String> status,
  Value<String?> description,
  Value<String?> url,
  Value<String?> organizationId,
  Value<String?> artistId,
  Value<String> classification,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$ProjectsTableUpdateCompanionBuilder = ProjectsCompanion Function({
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> archivedAt,
  Value<String> id,
  Value<String> name,
  Value<String> kind,
  Value<String> status,
  Value<String?> description,
  Value<String?> url,
  Value<String?> organizationId,
  Value<String?> artistId,
  Value<String> classification,
  Value<String?> notes,
  Value<int> rowid,
});

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, Project> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrganizationsTable _organizationIdTable(_$AppDatabase db) => db
      .organizations
      .createAlias('projects__organization_id__organizations__id');

  $$OrganizationsTableProcessedTableManager? get organizationId {
    final $_column = $_itemColumn<String>('organization_id');
    if ($_column == null) return null;
    final manager = $$OrganizationsTableTableManager(
      $_db,
      $_db.organizations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_organizationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ArtistsTable _artistIdTable(_$AppDatabase db) =>
      db.artists.createAlias('projects__artist_id__artists__id');

  $$ArtistsTableProcessedTableManager? get artistId {
    final $_column = $_itemColumn<String>('artist_id');
    if ($_column == null) return null;
    final manager = $$ArtistsTableTableManager(
      $_db,
      $_db.artists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_artistIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$OrganizationsTableFilterComposer get organizationId {
    final $$OrganizationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizationId,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableFilterComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ArtistsTableFilterComposer get artistId {
    final $$ArtistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artistId,
      referencedTable: $db.artists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistsTableFilterComposer(
            $db: $db,
            $table: $db.artists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrganizationsTableOrderingComposer get organizationId {
    final $$OrganizationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizationId,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableOrderingComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ArtistsTableOrderingComposer get artistId {
    final $$ArtistsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artistId,
      referencedTable: $db.artists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistsTableOrderingComposer(
            $db: $db,
            $table: $db.artists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$OrganizationsTableAnnotationComposer get organizationId {
    final $$OrganizationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizationId,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableAnnotationComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ArtistsTableAnnotationComposer get artistId {
    final $$ArtistsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artistId,
      referencedTable: $db.artists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistsTableAnnotationComposer(
            $db: $db,
            $table: $db.artists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          Project,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (Project, $$ProjectsTableReferences),
          Project,
          PrefetchHooks Function({bool organizationId, bool artistId})
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> organizationId = const Value.absent(),
                Value<String?> artistId = const Value.absent(),
                Value<String> classification = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                id: id,
                name: name,
                kind: kind,
                status: status,
                description: description,
                url: url,
                organizationId: organizationId,
                artistId: artistId,
                classification: classification,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                required String id,
                required String name,
                required String kind,
                Value<String> status = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> organizationId = const Value.absent(),
                Value<String?> artistId = const Value.absent(),
                Value<String> classification = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                id: id,
                name: name,
                kind: kind,
                status: status,
                description: description,
                url: url,
                organizationId: organizationId,
                artistId: artistId,
                classification: classification,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProjectsTable, Project>(table),
                  $$ProjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({organizationId = false, artistId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (organizationId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.organizationId,
                        referencedTable: $$ProjectsTableReferences
                            ._organizationIdTable(db),
                        referencedColumn: $$ProjectsTableReferences
                            ._organizationIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (artistId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.artistId,
                        referencedTable: $$ProjectsTableReferences
                            ._artistIdTable(db),
                        referencedColumn: $$ProjectsTableReferences
                            ._artistIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      Project,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (Project, $$ProjectsTableReferences),
      Project,
      PrefetchHooks Function({bool organizationId, bool artistId})
    >;
typedef $$LinksTableCreateCompanionBuilder = LinksCompanion Function({
  required String id,
  required String fromType,
  required String fromId,
  required String toType,
  required String toId,
  Value<String> relation,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$LinksTableUpdateCompanionBuilder = LinksCompanion Function({
  Value<String> id,
  Value<String> fromType,
  Value<String> fromId,
  Value<String> toType,
  Value<String> toId,
  Value<String> relation,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$LinksTableFilterComposer extends Composer<_$AppDatabase, $LinksTable> {
  $$LinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromType => $composableBuilder(
    column: $table.fromType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromId => $composableBuilder(
    column: $table.fromId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toType => $composableBuilder(
    column: $table.toType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toId => $composableBuilder(
    column: $table.toId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relation => $composableBuilder(
    column: $table.relation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LinksTableOrderingComposer
    extends Composer<_$AppDatabase, $LinksTable> {
  $$LinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromType => $composableBuilder(
    column: $table.fromType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromId => $composableBuilder(
    column: $table.fromId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toType => $composableBuilder(
    column: $table.toType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toId => $composableBuilder(
    column: $table.toId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relation => $composableBuilder(
    column: $table.relation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $LinksTable> {
  $$LinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fromType =>
      $composableBuilder(column: $table.fromType, builder: (column) => column);

  GeneratedColumn<String> get fromId =>
      $composableBuilder(column: $table.fromId, builder: (column) => column);

  GeneratedColumn<String> get toType =>
      $composableBuilder(column: $table.toType, builder: (column) => column);

  GeneratedColumn<String> get toId =>
      $composableBuilder(column: $table.toId, builder: (column) => column);

  GeneratedColumn<String> get relation =>
      $composableBuilder(column: $table.relation, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LinksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LinksTable,
          Link,
          $$LinksTableFilterComposer,
          $$LinksTableOrderingComposer,
          $$LinksTableAnnotationComposer,
          $$LinksTableCreateCompanionBuilder,
          $$LinksTableUpdateCompanionBuilder,
          (Link, BaseReferences<_$AppDatabase, $LinksTable, Link>),
          Link,
          PrefetchHooks Function()
        > {
  $$LinksTableTableManager(_$AppDatabase db, $LinksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fromType = const Value.absent(),
                Value<String> fromId = const Value.absent(),
                Value<String> toType = const Value.absent(),
                Value<String> toId = const Value.absent(),
                Value<String> relation = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LinksCompanion(
                id: id,
                fromType: fromType,
                fromId: fromId,
                toType: toType,
                toId: toId,
                relation: relation,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String fromType,
                required String fromId,
                required String toType,
                required String toId,
                Value<String> relation = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LinksCompanion.insert(
                id: id,
                fromType: fromType,
                fromId: fromId,
                toType: toType,
                toId: toId,
                relation: relation,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LinksTable, Link>(table),
                  BaseReferences<_$AppDatabase, $LinksTable, Link>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LinksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LinksTable,
      Link,
      $$LinksTableFilterComposer,
      $$LinksTableOrderingComposer,
      $$LinksTableAnnotationComposer,
      $$LinksTableCreateCompanionBuilder,
      $$LinksTableUpdateCompanionBuilder,
      (Link, BaseReferences<_$AppDatabase, $LinksTable, Link>),
      Link,
      PrefetchHooks Function()
    >;
typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  required String id,
  required String name,
  Value<int?> color,
  Value<int> rowid,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int?> color,
  Value<int> rowid,
});

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, Tag> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TagLinksTable, List<TagLink>> _tagLinksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tagLinks,
    aliasName: 'tags__id__tag_links__tag_id',
  );

  $$TagLinksTableProcessedTableManager get tagLinksRefs {
    final manager = $$TagLinksTableTableManager(
      $_db,
      $_db.tagLinks,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tagLinksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tagLinksRefs(
    Expression<bool> Function($$TagLinksTableFilterComposer f) f,
  ) {
    final $$TagLinksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tagLinks,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagLinksTableFilterComposer(
            $db: $db,
            $table: $db.tagLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  Expression<T> tagLinksRefs<T extends Object>(
    Expression<T> Function($$TagLinksTableAnnotationComposer a) f,
  ) {
    final $$TagLinksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tagLinks,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagLinksTableAnnotationComposer(
            $db: $db,
            $table: $db.tagLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, $$TagsTableReferences),
          Tag,
          PrefetchHooks Function({bool tagLinksRefs})
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int?> color = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => TagsCompanion(id: id, name: name, color: color, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int?> color = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion.insert(
                id: id,
                name: name,
                color: color,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TagsTable, Tag>(table),
                  $$TagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tagLinksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tagLinksRefs) db.tagLinks],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tagLinksRefs)
                    await $_getPrefetchedDataByColumns<
                      Tag,
                      $TagsTable,
                      TagLink,
                      $TagLinksTable
                    >(
                      currentTable: table,
                      referencedTable: $$TagsTableReferences._tagLinksRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$TagsTableReferences(db, table, p0).tagLinksRefs,
                      currentColumn: 'id',
                      referencedColumn: 'tag_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, $$TagsTableReferences),
      Tag,
      PrefetchHooks Function({bool tagLinksRefs})
    >;
typedef $$TagLinksTableCreateCompanionBuilder = TagLinksCompanion Function({
  required String tagId,
  required String entityType,
  required String entityId,
  Value<int> rowid,
});
typedef $$TagLinksTableUpdateCompanionBuilder = TagLinksCompanion Function({
  Value<String> tagId,
  Value<String> entityType,
  Value<String> entityId,
  Value<int> rowid,
});

final class $$TagLinksTableReferences
    extends BaseReferences<_$AppDatabase, $TagLinksTable, TagLink> {
  $$TagLinksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TagsTable _tagIdTable(_$AppDatabase db) =>
      db.tags.createAlias('tag_links__tag_id__tags__id');

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<String>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TagLinksTableFilterComposer
    extends Composer<_$AppDatabase, $TagLinksTable> {
  $$TagLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TagLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $TagLinksTable> {
  $$TagLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TagLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagLinksTable> {
  $$TagLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TagLinksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagLinksTable,
          TagLink,
          $$TagLinksTableFilterComposer,
          $$TagLinksTableOrderingComposer,
          $$TagLinksTableAnnotationComposer,
          $$TagLinksTableCreateCompanionBuilder,
          $$TagLinksTableUpdateCompanionBuilder,
          (TagLink, $$TagLinksTableReferences),
          TagLink,
          PrefetchHooks Function({bool tagId})
        > {
  $$TagLinksTableTableManager(_$AppDatabase db, $TagLinksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagLinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> tagId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TagLinksCompanion(
                tagId: tagId,
                entityType: entityType,
                entityId: entityId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tagId,
                required String entityType,
                required String entityId,
                Value<int> rowid = const Value.absent(),
              }) => TagLinksCompanion.insert(
                tagId: tagId,
                entityType: entityType,
                entityId: entityId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TagLinksTable, TagLink>(table),
                  $$TagLinksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tagId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.tagId,
                        referencedTable: $$TagLinksTableReferences._tagIdTable(
                          db,
                        ),
                        referencedColumn: $$TagLinksTableReferences
                            ._tagIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TagLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagLinksTable,
      TagLink,
      $$TagLinksTableFilterComposer,
      $$TagLinksTableOrderingComposer,
      $$TagLinksTableAnnotationComposer,
      $$TagLinksTableCreateCompanionBuilder,
      $$TagLinksTableUpdateCompanionBuilder,
      (TagLink, $$TagLinksTableReferences),
      TagLink,
      PrefetchHooks Function({bool tagId})
    >;
typedef $$CustomFieldsTableCreateCompanionBuilder =
    CustomFieldsCompanion Function({
      required String id,
      required String entityType,
      required String entityId,
      required String label,
      required String value,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$CustomFieldsTableUpdateCompanionBuilder =
    CustomFieldsCompanion Function({
      Value<String> id,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> label,
      Value<String> value,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$CustomFieldsTableFilterComposer
    extends Composer<_$AppDatabase, $CustomFieldsTable> {
  $$CustomFieldsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomFieldsTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomFieldsTable> {
  $$CustomFieldsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomFieldsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomFieldsTable> {
  $$CustomFieldsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$CustomFieldsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomFieldsTable,
          CustomField,
          $$CustomFieldsTableFilterComposer,
          $$CustomFieldsTableOrderingComposer,
          $$CustomFieldsTableAnnotationComposer,
          $$CustomFieldsTableCreateCompanionBuilder,
          $$CustomFieldsTableUpdateCompanionBuilder,
          (
            CustomField,
            BaseReferences<_$AppDatabase, $CustomFieldsTable, CustomField>,
          ),
          CustomField,
          PrefetchHooks Function()
        > {
  $$CustomFieldsTableTableManager(_$AppDatabase db, $CustomFieldsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomFieldsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomFieldsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomFieldsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomFieldsCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                label: label,
                value: value,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityType,
                required String entityId,
                required String label,
                required String value,
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomFieldsCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                label: label,
                value: value,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CustomFieldsTable, CustomField>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CustomFieldsTable,
                    CustomField
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomFieldsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomFieldsTable,
      CustomField,
      $$CustomFieldsTableFilterComposer,
      $$CustomFieldsTableOrderingComposer,
      $$CustomFieldsTableAnnotationComposer,
      $$CustomFieldsTableCreateCompanionBuilder,
      $$CustomFieldsTableUpdateCompanionBuilder,
      (
        CustomField,
        BaseReferences<_$AppDatabase, $CustomFieldsTable, CustomField>,
      ),
      CustomField,
      PrefetchHooks Function()
    >;
typedef $$BankAccountsTableCreateCompanionBuilder =
    BankAccountsCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      required String id,
      required String bankName,
      Value<String?> platformId,
      required String nickname,
      Value<String?> holderName,
      Value<String?> accountType,
      Value<String?> last4,
      Value<String?> ifsc,
      Value<String?> branch,
      Value<String?> swift,
      Value<String?> routing,
      Value<String?> netbankingUsername,
      Value<String?> website,
      Value<String> currency,
      Value<String?> organizationId,
      Value<String> classification,
      Value<String?> notes,
      Value<String?> fullNumberVaultId,
      Value<int> rowid,
    });
typedef $$BankAccountsTableUpdateCompanionBuilder =
    BankAccountsCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      Value<String> id,
      Value<String> bankName,
      Value<String?> platformId,
      Value<String> nickname,
      Value<String?> holderName,
      Value<String?> accountType,
      Value<String?> last4,
      Value<String?> ifsc,
      Value<String?> branch,
      Value<String?> swift,
      Value<String?> routing,
      Value<String?> netbankingUsername,
      Value<String?> website,
      Value<String> currency,
      Value<String?> organizationId,
      Value<String> classification,
      Value<String?> notes,
      Value<String?> fullNumberVaultId,
      Value<int> rowid,
    });

final class $$BankAccountsTableReferences
    extends BaseReferences<_$AppDatabase, $BankAccountsTable, BankAccount> {
  $$BankAccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlatformsTable _platformIdTable(_$AppDatabase db) =>
      db.platforms.createAlias('bank_accounts__platform_id__platforms__id');

  $$PlatformsTableProcessedTableManager? get platformId {
    final $_column = $_itemColumn<String>('platform_id');
    if ($_column == null) return null;
    final manager = $$PlatformsTableTableManager(
      $_db,
      $_db.platforms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_platformIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $OrganizationsTable _organizationIdTable(_$AppDatabase db) => db
      .organizations
      .createAlias('bank_accounts__organization_id__organizations__id');

  $$OrganizationsTableProcessedTableManager? get organizationId {
    final $_column = $_itemColumn<String>('organization_id');
    if ($_column == null) return null;
    final manager = $$OrganizationsTableTableManager(
      $_db,
      $_db.organizations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_organizationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SecureItemsTable _fullNumberVaultIdTable(_$AppDatabase db) => db
      .secureItems
      .createAlias('bank_accounts__full_number_vault_id__secure_items__id');

  $$SecureItemsTableProcessedTableManager? get fullNumberVaultId {
    final $_column = $_itemColumn<String>('full_number_vault_id');
    if ($_column == null) return null;
    final manager = $$SecureItemsTableTableManager(
      $_db,
      $_db.secureItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fullNumberVaultIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PaymentCardsTable, List<PaymentCard>>
  _paymentCardsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.paymentCards,
    aliasName: 'bank_accounts__id__payment_cards__bank_account_id',
  );

  $$PaymentCardsTableProcessedTableManager get paymentCardsRefs {
    final manager = $$PaymentCardsTableTableManager(
      $_db,
      $_db.paymentCards,
    ).filter((f) => f.bankAccountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentCardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaymentMethodsTable, List<PaymentMethod>>
  _paymentMethodsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.paymentMethods,
    aliasName: 'bank_accounts__id__payment_methods__bank_account_id',
  );

  $$PaymentMethodsTableProcessedTableManager get paymentMethodsRefs {
    final manager = $$PaymentMethodsTableTableManager(
      $_db,
      $_db.paymentMethods,
    ).filter((f) => f.bankAccountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentMethodsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BankAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $BankAccountsTable> {
  $$BankAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get holderName => $composableBuilder(
    column: $table.holderName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get last4 => $composableBuilder(
    column: $table.last4,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ifsc => $composableBuilder(
    column: $table.ifsc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branch => $composableBuilder(
    column: $table.branch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get swift => $composableBuilder(
    column: $table.swift,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get routing => $composableBuilder(
    column: $table.routing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get netbankingUsername => $composableBuilder(
    column: $table.netbankingUsername,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$PlatformsTableFilterComposer get platformId {
    final $$PlatformsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.platformId,
      referencedTable: $db.platforms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlatformsTableFilterComposer(
            $db: $db,
            $table: $db.platforms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OrganizationsTableFilterComposer get organizationId {
    final $$OrganizationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizationId,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableFilterComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SecureItemsTableFilterComposer get fullNumberVaultId {
    final $$SecureItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fullNumberVaultId,
      referencedTable: $db.secureItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SecureItemsTableFilterComposer(
            $db: $db,
            $table: $db.secureItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> paymentCardsRefs(
    Expression<bool> Function($$PaymentCardsTableFilterComposer f) f,
  ) {
    final $$PaymentCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentCards,
      getReferencedColumn: (t) => t.bankAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentCardsTableFilterComposer(
            $db: $db,
            $table: $db.paymentCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paymentMethodsRefs(
    Expression<bool> Function($$PaymentMethodsTableFilterComposer f) f,
  ) {
    final $$PaymentMethodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.bankAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableFilterComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BankAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $BankAccountsTable> {
  $$BankAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get holderName => $composableBuilder(
    column: $table.holderName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get last4 => $composableBuilder(
    column: $table.last4,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ifsc => $composableBuilder(
    column: $table.ifsc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branch => $composableBuilder(
    column: $table.branch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get swift => $composableBuilder(
    column: $table.swift,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get routing => $composableBuilder(
    column: $table.routing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get netbankingUsername => $composableBuilder(
    column: $table.netbankingUsername,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlatformsTableOrderingComposer get platformId {
    final $$PlatformsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.platformId,
      referencedTable: $db.platforms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlatformsTableOrderingComposer(
            $db: $db,
            $table: $db.platforms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OrganizationsTableOrderingComposer get organizationId {
    final $$OrganizationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizationId,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableOrderingComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SecureItemsTableOrderingComposer get fullNumberVaultId {
    final $$SecureItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fullNumberVaultId,
      referencedTable: $db.secureItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SecureItemsTableOrderingComposer(
            $db: $db,
            $table: $db.secureItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BankAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BankAccountsTable> {
  $$BankAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bankName =>
      $composableBuilder(column: $table.bankName, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get holderName => $composableBuilder(
    column: $table.holderName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get last4 =>
      $composableBuilder(column: $table.last4, builder: (column) => column);

  GeneratedColumn<String> get ifsc =>
      $composableBuilder(column: $table.ifsc, builder: (column) => column);

  GeneratedColumn<String> get branch =>
      $composableBuilder(column: $table.branch, builder: (column) => column);

  GeneratedColumn<String> get swift =>
      $composableBuilder(column: $table.swift, builder: (column) => column);

  GeneratedColumn<String> get routing =>
      $composableBuilder(column: $table.routing, builder: (column) => column);

  GeneratedColumn<String> get netbankingUsername => $composableBuilder(
    column: $table.netbankingUsername,
    builder: (column) => column,
  );

  GeneratedColumn<String> get website =>
      $composableBuilder(column: $table.website, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$PlatformsTableAnnotationComposer get platformId {
    final $$PlatformsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.platformId,
      referencedTable: $db.platforms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlatformsTableAnnotationComposer(
            $db: $db,
            $table: $db.platforms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OrganizationsTableAnnotationComposer get organizationId {
    final $$OrganizationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.organizationId,
      referencedTable: $db.organizations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrganizationsTableAnnotationComposer(
            $db: $db,
            $table: $db.organizations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SecureItemsTableAnnotationComposer get fullNumberVaultId {
    final $$SecureItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fullNumberVaultId,
      referencedTable: $db.secureItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SecureItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.secureItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> paymentCardsRefs<T extends Object>(
    Expression<T> Function($$PaymentCardsTableAnnotationComposer a) f,
  ) {
    final $$PaymentCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentCards,
      getReferencedColumn: (t) => t.bankAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.paymentCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> paymentMethodsRefs<T extends Object>(
    Expression<T> Function($$PaymentMethodsTableAnnotationComposer a) f,
  ) {
    final $$PaymentMethodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.bankAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableAnnotationComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BankAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BankAccountsTable,
          BankAccount,
          $$BankAccountsTableFilterComposer,
          $$BankAccountsTableOrderingComposer,
          $$BankAccountsTableAnnotationComposer,
          $$BankAccountsTableCreateCompanionBuilder,
          $$BankAccountsTableUpdateCompanionBuilder,
          (BankAccount, $$BankAccountsTableReferences),
          BankAccount,
          PrefetchHooks Function({
            bool platformId,
            bool organizationId,
            bool fullNumberVaultId,
            bool paymentCardsRefs,
            bool paymentMethodsRefs,
          })
        > {
  $$BankAccountsTableTableManager(_$AppDatabase db, $BankAccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BankAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BankAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BankAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> bankName = const Value.absent(),
                Value<String?> platformId = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<String?> holderName = const Value.absent(),
                Value<String?> accountType = const Value.absent(),
                Value<String?> last4 = const Value.absent(),
                Value<String?> ifsc = const Value.absent(),
                Value<String?> branch = const Value.absent(),
                Value<String?> swift = const Value.absent(),
                Value<String?> routing = const Value.absent(),
                Value<String?> netbankingUsername = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String?> organizationId = const Value.absent(),
                Value<String> classification = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> fullNumberVaultId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BankAccountsCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                id: id,
                bankName: bankName,
                platformId: platformId,
                nickname: nickname,
                holderName: holderName,
                accountType: accountType,
                last4: last4,
                ifsc: ifsc,
                branch: branch,
                swift: swift,
                routing: routing,
                netbankingUsername: netbankingUsername,
                website: website,
                currency: currency,
                organizationId: organizationId,
                classification: classification,
                notes: notes,
                fullNumberVaultId: fullNumberVaultId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                required String id,
                required String bankName,
                Value<String?> platformId = const Value.absent(),
                required String nickname,
                Value<String?> holderName = const Value.absent(),
                Value<String?> accountType = const Value.absent(),
                Value<String?> last4 = const Value.absent(),
                Value<String?> ifsc = const Value.absent(),
                Value<String?> branch = const Value.absent(),
                Value<String?> swift = const Value.absent(),
                Value<String?> routing = const Value.absent(),
                Value<String?> netbankingUsername = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String?> organizationId = const Value.absent(),
                Value<String> classification = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> fullNumberVaultId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BankAccountsCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                id: id,
                bankName: bankName,
                platformId: platformId,
                nickname: nickname,
                holderName: holderName,
                accountType: accountType,
                last4: last4,
                ifsc: ifsc,
                branch: branch,
                swift: swift,
                routing: routing,
                netbankingUsername: netbankingUsername,
                website: website,
                currency: currency,
                organizationId: organizationId,
                classification: classification,
                notes: notes,
                fullNumberVaultId: fullNumberVaultId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BankAccountsTable, BankAccount>(table),
                  $$BankAccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                platformId = false,
                organizationId = false,
                fullNumberVaultId = false,
                paymentCardsRefs = false,
                paymentMethodsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (paymentCardsRefs) db.paymentCards,
                    if (paymentMethodsRefs) db.paymentMethods,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (platformId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.platformId,
                            referencedTable: $$BankAccountsTableReferences
                                ._platformIdTable(db),
                            referencedColumn: $$BankAccountsTableReferences
                                ._platformIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (organizationId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.organizationId,
                            referencedTable: $$BankAccountsTableReferences
                                ._organizationIdTable(db),
                            referencedColumn: $$BankAccountsTableReferences
                                ._organizationIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (fullNumberVaultId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.fullNumberVaultId,
                            referencedTable: $$BankAccountsTableReferences
                                ._fullNumberVaultIdTable(db),
                            referencedColumn: $$BankAccountsTableReferences
                                ._fullNumberVaultIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (paymentCardsRefs)
                        await $_getPrefetchedDataByColumns<
                          BankAccount,
                          $BankAccountsTable,
                          PaymentCard,
                          $PaymentCardsTable
                        >(
                          currentTable: table,
                          referencedTable: $$BankAccountsTableReferences
                              ._paymentCardsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BankAccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentCardsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'bank_account_id',
                          typedResults: items,
                        ),
                      if (paymentMethodsRefs)
                        await $_getPrefetchedDataByColumns<
                          BankAccount,
                          $BankAccountsTable,
                          PaymentMethod,
                          $PaymentMethodsTable
                        >(
                          currentTable: table,
                          referencedTable: $$BankAccountsTableReferences
                              ._paymentMethodsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BankAccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentMethodsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'bank_account_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BankAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BankAccountsTable,
      BankAccount,
      $$BankAccountsTableFilterComposer,
      $$BankAccountsTableOrderingComposer,
      $$BankAccountsTableAnnotationComposer,
      $$BankAccountsTableCreateCompanionBuilder,
      $$BankAccountsTableUpdateCompanionBuilder,
      (BankAccount, $$BankAccountsTableReferences),
      BankAccount,
      PrefetchHooks Function({
        bool platformId,
        bool organizationId,
        bool fullNumberVaultId,
        bool paymentCardsRefs,
        bool paymentMethodsRefs,
      })
    >;
typedef $$PaymentCardsTableCreateCompanionBuilder =
    PaymentCardsCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      required String id,
      required String nickname,
      Value<String?> issuingBank,
      Value<String?> network,
      Value<String> kind,
      Value<String?> last4,
      Value<int?> expMonth,
      Value<int?> expYear,
      Value<String?> bankAccountId,
      Value<String> classification,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$PaymentCardsTableUpdateCompanionBuilder =
    PaymentCardsCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      Value<String> id,
      Value<String> nickname,
      Value<String?> issuingBank,
      Value<String?> network,
      Value<String> kind,
      Value<String?> last4,
      Value<int?> expMonth,
      Value<int?> expYear,
      Value<String?> bankAccountId,
      Value<String> classification,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$PaymentCardsTableReferences
    extends BaseReferences<_$AppDatabase, $PaymentCardsTable, PaymentCard> {
  $$PaymentCardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BankAccountsTable _bankAccountIdTable(_$AppDatabase db) => db
      .bankAccounts
      .createAlias('payment_cards__bank_account_id__bank_accounts__id');

  $$BankAccountsTableProcessedTableManager? get bankAccountId {
    final $_column = $_itemColumn<String>('bank_account_id');
    if ($_column == null) return null;
    final manager = $$BankAccountsTableTableManager(
      $_db,
      $_db.bankAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bankAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PaymentMethodsTable, List<PaymentMethod>>
  _paymentMethodsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.paymentMethods,
    aliasName: 'payment_cards__id__payment_methods__card_id',
  );

  $$PaymentMethodsTableProcessedTableManager get paymentMethodsRefs {
    final manager = $$PaymentMethodsTableTableManager(
      $_db,
      $_db.paymentMethods,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentMethodsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PaymentCardsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentCardsTable> {
  $$PaymentCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get issuingBank => $composableBuilder(
    column: $table.issuingBank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get network => $composableBuilder(
    column: $table.network,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get last4 => $composableBuilder(
    column: $table.last4,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expMonth => $composableBuilder(
    column: $table.expMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expYear => $composableBuilder(
    column: $table.expYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$BankAccountsTableFilterComposer get bankAccountId {
    final $$BankAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankAccountId,
      referencedTable: $db.bankAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BankAccountsTableFilterComposer(
            $db: $db,
            $table: $db.bankAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> paymentMethodsRefs(
    Expression<bool> Function($$PaymentMethodsTableFilterComposer f) f,
  ) {
    final $$PaymentMethodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableFilterComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PaymentCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentCardsTable> {
  $$PaymentCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get issuingBank => $composableBuilder(
    column: $table.issuingBank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get network => $composableBuilder(
    column: $table.network,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get last4 => $composableBuilder(
    column: $table.last4,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expMonth => $composableBuilder(
    column: $table.expMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expYear => $composableBuilder(
    column: $table.expYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$BankAccountsTableOrderingComposer get bankAccountId {
    final $$BankAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankAccountId,
      referencedTable: $db.bankAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BankAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.bankAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentCardsTable> {
  $$PaymentCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get issuingBank => $composableBuilder(
    column: $table.issuingBank,
    builder: (column) => column,
  );

  GeneratedColumn<String> get network =>
      $composableBuilder(column: $table.network, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get last4 =>
      $composableBuilder(column: $table.last4, builder: (column) => column);

  GeneratedColumn<int> get expMonth =>
      $composableBuilder(column: $table.expMonth, builder: (column) => column);

  GeneratedColumn<int> get expYear =>
      $composableBuilder(column: $table.expYear, builder: (column) => column);

  GeneratedColumn<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$BankAccountsTableAnnotationComposer get bankAccountId {
    final $$BankAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankAccountId,
      referencedTable: $db.bankAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BankAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.bankAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> paymentMethodsRefs<T extends Object>(
    Expression<T> Function($$PaymentMethodsTableAnnotationComposer a) f,
  ) {
    final $$PaymentMethodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableAnnotationComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PaymentCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentCardsTable,
          PaymentCard,
          $$PaymentCardsTableFilterComposer,
          $$PaymentCardsTableOrderingComposer,
          $$PaymentCardsTableAnnotationComposer,
          $$PaymentCardsTableCreateCompanionBuilder,
          $$PaymentCardsTableUpdateCompanionBuilder,
          (PaymentCard, $$PaymentCardsTableReferences),
          PaymentCard,
          PrefetchHooks Function({bool bankAccountId, bool paymentMethodsRefs})
        > {
  $$PaymentCardsTableTableManager(_$AppDatabase db, $PaymentCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<String?> issuingBank = const Value.absent(),
                Value<String?> network = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String?> last4 = const Value.absent(),
                Value<int?> expMonth = const Value.absent(),
                Value<int?> expYear = const Value.absent(),
                Value<String?> bankAccountId = const Value.absent(),
                Value<String> classification = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentCardsCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                id: id,
                nickname: nickname,
                issuingBank: issuingBank,
                network: network,
                kind: kind,
                last4: last4,
                expMonth: expMonth,
                expYear: expYear,
                bankAccountId: bankAccountId,
                classification: classification,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                required String id,
                required String nickname,
                Value<String?> issuingBank = const Value.absent(),
                Value<String?> network = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String?> last4 = const Value.absent(),
                Value<int?> expMonth = const Value.absent(),
                Value<int?> expYear = const Value.absent(),
                Value<String?> bankAccountId = const Value.absent(),
                Value<String> classification = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentCardsCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                id: id,
                nickname: nickname,
                issuingBank: issuingBank,
                network: network,
                kind: kind,
                last4: last4,
                expMonth: expMonth,
                expYear: expYear,
                bankAccountId: bankAccountId,
                classification: classification,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PaymentCardsTable, PaymentCard>(table),
                  $$PaymentCardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({bankAccountId = false, paymentMethodsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (paymentMethodsRefs) db.paymentMethods,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (bankAccountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.bankAccountId,
                            referencedTable: $$PaymentCardsTableReferences
                                ._bankAccountIdTable(db),
                            referencedColumn: $$PaymentCardsTableReferences
                                ._bankAccountIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (paymentMethodsRefs)
                        await $_getPrefetchedDataByColumns<
                          PaymentCard,
                          $PaymentCardsTable,
                          PaymentMethod,
                          $PaymentMethodsTable
                        >(
                          currentTable: table,
                          referencedTable: $$PaymentCardsTableReferences
                              ._paymentMethodsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PaymentCardsTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentMethodsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'card_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PaymentCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentCardsTable,
      PaymentCard,
      $$PaymentCardsTableFilterComposer,
      $$PaymentCardsTableOrderingComposer,
      $$PaymentCardsTableAnnotationComposer,
      $$PaymentCardsTableCreateCompanionBuilder,
      $$PaymentCardsTableUpdateCompanionBuilder,
      (PaymentCard, $$PaymentCardsTableReferences),
      PaymentCard,
      PrefetchHooks Function({bool bankAccountId, bool paymentMethodsRefs})
    >;
typedef $$PaymentMethodsTableCreateCompanionBuilder =
    PaymentMethodsCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      required String id,
      required String label,
      required String kind,
      Value<String?> cardId,
      Value<String?> bankAccountId,
      Value<String?> platformId,
      Value<String?> identifierHint,
      Value<bool> isDefault,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$PaymentMethodsTableUpdateCompanionBuilder =
    PaymentMethodsCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      Value<String> id,
      Value<String> label,
      Value<String> kind,
      Value<String?> cardId,
      Value<String?> bankAccountId,
      Value<String?> platformId,
      Value<String?> identifierHint,
      Value<bool> isDefault,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$PaymentMethodsTableReferences
    extends BaseReferences<_$AppDatabase, $PaymentMethodsTable, PaymentMethod> {
  $$PaymentMethodsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PaymentCardsTable _cardIdTable(_$AppDatabase db) => db.paymentCards
      .createAlias('payment_methods__card_id__payment_cards__id');

  $$PaymentCardsTableProcessedTableManager? get cardId {
    final $_column = $_itemColumn<String>('card_id');
    if ($_column == null) return null;
    final manager = $$PaymentCardsTableTableManager(
      $_db,
      $_db.paymentCards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BankAccountsTable _bankAccountIdTable(_$AppDatabase db) => db
      .bankAccounts
      .createAlias('payment_methods__bank_account_id__bank_accounts__id');

  $$BankAccountsTableProcessedTableManager? get bankAccountId {
    final $_column = $_itemColumn<String>('bank_account_id');
    if ($_column == null) return null;
    final manager = $$BankAccountsTableTableManager(
      $_db,
      $_db.bankAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bankAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlatformsTable _platformIdTable(_$AppDatabase db) =>
      db.platforms.createAlias('payment_methods__platform_id__platforms__id');

  $$PlatformsTableProcessedTableManager? get platformId {
    final $_column = $_itemColumn<String>('platform_id');
    if ($_column == null) return null;
    final manager = $$PlatformsTableTableManager(
      $_db,
      $_db.platforms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_platformIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SubscriptionsTable, List<Subscription>>
  _subscriptionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.subscriptions,
    aliasName: 'payment_methods__id__subscriptions__payment_method_id',
  );

  $$SubscriptionsTableProcessedTableManager get subscriptionsRefs {
    final manager = $$SubscriptionsTableTableManager($_db, $_db.subscriptions)
        .filter(
          (f) => f.paymentMethodId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_subscriptionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PaymentMethodsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentMethodsTable> {
  $$PaymentMethodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identifierHint => $composableBuilder(
    column: $table.identifierHint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$PaymentCardsTableFilterComposer get cardId {
    final $$PaymentCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.paymentCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentCardsTableFilterComposer(
            $db: $db,
            $table: $db.paymentCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BankAccountsTableFilterComposer get bankAccountId {
    final $$BankAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankAccountId,
      referencedTable: $db.bankAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BankAccountsTableFilterComposer(
            $db: $db,
            $table: $db.bankAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlatformsTableFilterComposer get platformId {
    final $$PlatformsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.platformId,
      referencedTable: $db.platforms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlatformsTableFilterComposer(
            $db: $db,
            $table: $db.platforms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> subscriptionsRefs(
    Expression<bool> Function($$SubscriptionsTableFilterComposer f) f,
  ) {
    final $$SubscriptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subscriptions,
      getReferencedColumn: (t) => t.paymentMethodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableFilterComposer(
            $db: $db,
            $table: $db.subscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PaymentMethodsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentMethodsTable> {
  $$PaymentMethodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identifierHint => $composableBuilder(
    column: $table.identifierHint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$PaymentCardsTableOrderingComposer get cardId {
    final $$PaymentCardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.paymentCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentCardsTableOrderingComposer(
            $db: $db,
            $table: $db.paymentCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BankAccountsTableOrderingComposer get bankAccountId {
    final $$BankAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankAccountId,
      referencedTable: $db.bankAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BankAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.bankAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlatformsTableOrderingComposer get platformId {
    final $$PlatformsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.platformId,
      referencedTable: $db.platforms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlatformsTableOrderingComposer(
            $db: $db,
            $table: $db.platforms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentMethodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentMethodsTable> {
  $$PaymentMethodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get identifierHint => $composableBuilder(
    column: $table.identifierHint,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$PaymentCardsTableAnnotationComposer get cardId {
    final $$PaymentCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.paymentCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.paymentCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BankAccountsTableAnnotationComposer get bankAccountId {
    final $$BankAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankAccountId,
      referencedTable: $db.bankAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BankAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.bankAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlatformsTableAnnotationComposer get platformId {
    final $$PlatformsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.platformId,
      referencedTable: $db.platforms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlatformsTableAnnotationComposer(
            $db: $db,
            $table: $db.platforms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> subscriptionsRefs<T extends Object>(
    Expression<T> Function($$SubscriptionsTableAnnotationComposer a) f,
  ) {
    final $$SubscriptionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subscriptions,
      getReferencedColumn: (t) => t.paymentMethodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableAnnotationComposer(
            $db: $db,
            $table: $db.subscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PaymentMethodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentMethodsTable,
          PaymentMethod,
          $$PaymentMethodsTableFilterComposer,
          $$PaymentMethodsTableOrderingComposer,
          $$PaymentMethodsTableAnnotationComposer,
          $$PaymentMethodsTableCreateCompanionBuilder,
          $$PaymentMethodsTableUpdateCompanionBuilder,
          (PaymentMethod, $$PaymentMethodsTableReferences),
          PaymentMethod,
          PrefetchHooks Function({
            bool cardId,
            bool bankAccountId,
            bool platformId,
            bool subscriptionsRefs,
          })
        > {
  $$PaymentMethodsTableTableManager(
    _$AppDatabase db,
    $PaymentMethodsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentMethodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentMethodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentMethodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String?> cardId = const Value.absent(),
                Value<String?> bankAccountId = const Value.absent(),
                Value<String?> platformId = const Value.absent(),
                Value<String?> identifierHint = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentMethodsCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                id: id,
                label: label,
                kind: kind,
                cardId: cardId,
                bankAccountId: bankAccountId,
                platformId: platformId,
                identifierHint: identifierHint,
                isDefault: isDefault,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                required String id,
                required String label,
                required String kind,
                Value<String?> cardId = const Value.absent(),
                Value<String?> bankAccountId = const Value.absent(),
                Value<String?> platformId = const Value.absent(),
                Value<String?> identifierHint = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentMethodsCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                id: id,
                label: label,
                kind: kind,
                cardId: cardId,
                bankAccountId: bankAccountId,
                platformId: platformId,
                identifierHint: identifierHint,
                isDefault: isDefault,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PaymentMethodsTable, PaymentMethod>(table),
                  $$PaymentMethodsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                cardId = false,
                bankAccountId = false,
                platformId = false,
                subscriptionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (subscriptionsRefs) db.subscriptions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (cardId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.cardId,
                            referencedTable: $$PaymentMethodsTableReferences
                                ._cardIdTable(db),
                            referencedColumn: $$PaymentMethodsTableReferences
                                ._cardIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (bankAccountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.bankAccountId,
                            referencedTable: $$PaymentMethodsTableReferences
                                ._bankAccountIdTable(db),
                            referencedColumn: $$PaymentMethodsTableReferences
                                ._bankAccountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (platformId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.platformId,
                            referencedTable: $$PaymentMethodsTableReferences
                                ._platformIdTable(db),
                            referencedColumn: $$PaymentMethodsTableReferences
                                ._platformIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (subscriptionsRefs)
                        await $_getPrefetchedDataByColumns<
                          PaymentMethod,
                          $PaymentMethodsTable,
                          Subscription,
                          $SubscriptionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$PaymentMethodsTableReferences
                              ._subscriptionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PaymentMethodsTableReferences(
                                db,
                                table,
                                p0,
                              ).subscriptionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'payment_method_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PaymentMethodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentMethodsTable,
      PaymentMethod,
      $$PaymentMethodsTableFilterComposer,
      $$PaymentMethodsTableOrderingComposer,
      $$PaymentMethodsTableAnnotationComposer,
      $$PaymentMethodsTableCreateCompanionBuilder,
      $$PaymentMethodsTableUpdateCompanionBuilder,
      (PaymentMethod, $$PaymentMethodsTableReferences),
      PaymentMethod,
      PrefetchHooks Function({
        bool cardId,
        bool bankAccountId,
        bool platformId,
        bool subscriptionsRefs,
      })
    >;
typedef $$SubscriptionsTableCreateCompanionBuilder =
    SubscriptionsCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      required String id,
      Value<String?> platformId,
      required String serviceName,
      Value<String?> accountId,
      Value<String?> plan,
      Value<int> priceMinor,
      Value<String> currency,
      Value<String> billingCycle,
      Value<int?> cycleDays,
      Value<DateTime?> startDate,
      Value<DateTime?> nextBillingDate,
      Value<DateTime?> cancellationDate,
      Value<String> status,
      Value<String?> paymentMethodId,
      Value<String> classification,
      Value<String?> renewalUrl,
      Value<bool> remindersEnabled,
      Value<String?> notes,
      Value<String?> purchaseChannel,
      Value<int> rowid,
    });
typedef $$SubscriptionsTableUpdateCompanionBuilder =
    SubscriptionsCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      Value<String> id,
      Value<String?> platformId,
      Value<String> serviceName,
      Value<String?> accountId,
      Value<String?> plan,
      Value<int> priceMinor,
      Value<String> currency,
      Value<String> billingCycle,
      Value<int?> cycleDays,
      Value<DateTime?> startDate,
      Value<DateTime?> nextBillingDate,
      Value<DateTime?> cancellationDate,
      Value<String> status,
      Value<String?> paymentMethodId,
      Value<String> classification,
      Value<String?> renewalUrl,
      Value<bool> remindersEnabled,
      Value<String?> notes,
      Value<String?> purchaseChannel,
      Value<int> rowid,
    });

final class $$SubscriptionsTableReferences
    extends BaseReferences<_$AppDatabase, $SubscriptionsTable, Subscription> {
  $$SubscriptionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PlatformsTable _platformIdTable(_$AppDatabase db) =>
      db.platforms.createAlias('subscriptions__platform_id__platforms__id');

  $$PlatformsTableProcessedTableManager? get platformId {
    final $_column = $_itemColumn<String>('platform_id');
    if ($_column == null) return null;
    final manager = $$PlatformsTableTableManager(
      $_db,
      $_db.platforms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_platformIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ServiceAccountsTable _accountIdTable(_$AppDatabase db) => db
      .serviceAccounts
      .createAlias('subscriptions__account_id__service_accounts__id');

  $$ServiceAccountsTableProcessedTableManager? get accountId {
    final $_column = $_itemColumn<String>('account_id');
    if ($_column == null) return null;
    final manager = $$ServiceAccountsTableTableManager(
      $_db,
      $_db.serviceAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PaymentMethodsTable _paymentMethodIdTable(_$AppDatabase db) => db
      .paymentMethods
      .createAlias('subscriptions__payment_method_id__payment_methods__id');

  $$PaymentMethodsTableProcessedTableManager? get paymentMethodId {
    final $_column = $_itemColumn<String>('payment_method_id');
    if ($_column == null) return null;
    final manager = $$PaymentMethodsTableTableManager(
      $_db,
      $_db.paymentMethods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_paymentMethodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SubscriptionEventsTable, List<SubscriptionEvent>>
  _subscriptionEventsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.subscriptionEvents,
        aliasName: 'subscriptions__id__subscription_events__subscription_id',
      );

  $$SubscriptionEventsTableProcessedTableManager get subscriptionEventsRefs {
    final manager = $$SubscriptionEventsTableTableManager(
      $_db,
      $_db.subscriptionEvents,
    ).filter((f) => f.subscriptionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _subscriptionEventsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SubscriptionsTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serviceName => $composableBuilder(
    column: $table.serviceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plan => $composableBuilder(
    column: $table.plan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceMinor => $composableBuilder(
    column: $table.priceMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get billingCycle => $composableBuilder(
    column: $table.billingCycle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycleDays => $composableBuilder(
    column: $table.cycleDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextBillingDate => $composableBuilder(
    column: $table.nextBillingDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cancellationDate => $composableBuilder(
    column: $table.cancellationDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get renewalUrl => $composableBuilder(
    column: $table.renewalUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get remindersEnabled => $composableBuilder(
    column: $table.remindersEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purchaseChannel => $composableBuilder(
    column: $table.purchaseChannel,
    builder: (column) => ColumnFilters(column),
  );

  $$PlatformsTableFilterComposer get platformId {
    final $$PlatformsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.platformId,
      referencedTable: $db.platforms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlatformsTableFilterComposer(
            $db: $db,
            $table: $db.platforms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServiceAccountsTableFilterComposer get accountId {
    final $$ServiceAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.serviceAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceAccountsTableFilterComposer(
            $db: $db,
            $table: $db.serviceAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaymentMethodsTableFilterComposer get paymentMethodId {
    final $$PaymentMethodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentMethodId,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableFilterComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> subscriptionEventsRefs(
    Expression<bool> Function($$SubscriptionEventsTableFilterComposer f) f,
  ) {
    final $$SubscriptionEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subscriptionEvents,
      getReferencedColumn: (t) => t.subscriptionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionEventsTableFilterComposer(
            $db: $db,
            $table: $db.subscriptionEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubscriptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serviceName => $composableBuilder(
    column: $table.serviceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plan => $composableBuilder(
    column: $table.plan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceMinor => $composableBuilder(
    column: $table.priceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get billingCycle => $composableBuilder(
    column: $table.billingCycle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycleDays => $composableBuilder(
    column: $table.cycleDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextBillingDate => $composableBuilder(
    column: $table.nextBillingDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cancellationDate => $composableBuilder(
    column: $table.cancellationDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get renewalUrl => $composableBuilder(
    column: $table.renewalUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get remindersEnabled => $composableBuilder(
    column: $table.remindersEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purchaseChannel => $composableBuilder(
    column: $table.purchaseChannel,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlatformsTableOrderingComposer get platformId {
    final $$PlatformsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.platformId,
      referencedTable: $db.platforms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlatformsTableOrderingComposer(
            $db: $db,
            $table: $db.platforms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServiceAccountsTableOrderingComposer get accountId {
    final $$ServiceAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.serviceAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.serviceAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaymentMethodsTableOrderingComposer get paymentMethodId {
    final $$PaymentMethodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentMethodId,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableOrderingComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubscriptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serviceName => $composableBuilder(
    column: $table.serviceName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get plan =>
      $composableBuilder(column: $table.plan, builder: (column) => column);

  GeneratedColumn<int> get priceMinor => $composableBuilder(
    column: $table.priceMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get billingCycle => $composableBuilder(
    column: $table.billingCycle,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cycleDays =>
      $composableBuilder(column: $table.cycleDays, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get nextBillingDate => $composableBuilder(
    column: $table.nextBillingDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cancellationDate => $composableBuilder(
    column: $table.cancellationDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => column,
  );

  GeneratedColumn<String> get renewalUrl => $composableBuilder(
    column: $table.renewalUrl,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get remindersEnabled => $composableBuilder(
    column: $table.remindersEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get purchaseChannel => $composableBuilder(
    column: $table.purchaseChannel,
    builder: (column) => column,
  );

  $$PlatformsTableAnnotationComposer get platformId {
    final $$PlatformsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.platformId,
      referencedTable: $db.platforms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlatformsTableAnnotationComposer(
            $db: $db,
            $table: $db.platforms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServiceAccountsTableAnnotationComposer get accountId {
    final $$ServiceAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.serviceAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.serviceAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaymentMethodsTableAnnotationComposer get paymentMethodId {
    final $$PaymentMethodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentMethodId,
      referencedTable: $db.paymentMethods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentMethodsTableAnnotationComposer(
            $db: $db,
            $table: $db.paymentMethods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> subscriptionEventsRefs<T extends Object>(
    Expression<T> Function($$SubscriptionEventsTableAnnotationComposer a) f,
  ) {
    final $$SubscriptionEventsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.subscriptionEvents,
          getReferencedColumn: (t) => t.subscriptionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SubscriptionEventsTableAnnotationComposer(
                $db: $db,
                $table: $db.subscriptionEvents,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SubscriptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubscriptionsTable,
          Subscription,
          $$SubscriptionsTableFilterComposer,
          $$SubscriptionsTableOrderingComposer,
          $$SubscriptionsTableAnnotationComposer,
          $$SubscriptionsTableCreateCompanionBuilder,
          $$SubscriptionsTableUpdateCompanionBuilder,
          (Subscription, $$SubscriptionsTableReferences),
          Subscription,
          PrefetchHooks Function({
            bool platformId,
            bool accountId,
            bool paymentMethodId,
            bool subscriptionEventsRefs,
          })
        > {
  $$SubscriptionsTableTableManager(_$AppDatabase db, $SubscriptionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscriptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String?> platformId = const Value.absent(),
                Value<String> serviceName = const Value.absent(),
                Value<String?> accountId = const Value.absent(),
                Value<String?> plan = const Value.absent(),
                Value<int> priceMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> billingCycle = const Value.absent(),
                Value<int?> cycleDays = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> nextBillingDate = const Value.absent(),
                Value<DateTime?> cancellationDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> paymentMethodId = const Value.absent(),
                Value<String> classification = const Value.absent(),
                Value<String?> renewalUrl = const Value.absent(),
                Value<bool> remindersEnabled = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> purchaseChannel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubscriptionsCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                id: id,
                platformId: platformId,
                serviceName: serviceName,
                accountId: accountId,
                plan: plan,
                priceMinor: priceMinor,
                currency: currency,
                billingCycle: billingCycle,
                cycleDays: cycleDays,
                startDate: startDate,
                nextBillingDate: nextBillingDate,
                cancellationDate: cancellationDate,
                status: status,
                paymentMethodId: paymentMethodId,
                classification: classification,
                renewalUrl: renewalUrl,
                remindersEnabled: remindersEnabled,
                notes: notes,
                purchaseChannel: purchaseChannel,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                required String id,
                Value<String?> platformId = const Value.absent(),
                required String serviceName,
                Value<String?> accountId = const Value.absent(),
                Value<String?> plan = const Value.absent(),
                Value<int> priceMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> billingCycle = const Value.absent(),
                Value<int?> cycleDays = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> nextBillingDate = const Value.absent(),
                Value<DateTime?> cancellationDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> paymentMethodId = const Value.absent(),
                Value<String> classification = const Value.absent(),
                Value<String?> renewalUrl = const Value.absent(),
                Value<bool> remindersEnabled = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> purchaseChannel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubscriptionsCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                id: id,
                platformId: platformId,
                serviceName: serviceName,
                accountId: accountId,
                plan: plan,
                priceMinor: priceMinor,
                currency: currency,
                billingCycle: billingCycle,
                cycleDays: cycleDays,
                startDate: startDate,
                nextBillingDate: nextBillingDate,
                cancellationDate: cancellationDate,
                status: status,
                paymentMethodId: paymentMethodId,
                classification: classification,
                renewalUrl: renewalUrl,
                remindersEnabled: remindersEnabled,
                notes: notes,
                purchaseChannel: purchaseChannel,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SubscriptionsTable, Subscription>(table),
                  $$SubscriptionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                platformId = false,
                accountId = false,
                paymentMethodId = false,
                subscriptionEventsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (subscriptionEventsRefs) db.subscriptionEvents,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (platformId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.platformId,
                            referencedTable: $$SubscriptionsTableReferences
                                ._platformIdTable(db),
                            referencedColumn: $$SubscriptionsTableReferences
                                ._platformIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (accountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.accountId,
                            referencedTable: $$SubscriptionsTableReferences
                                ._accountIdTable(db),
                            referencedColumn: $$SubscriptionsTableReferences
                                ._accountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (paymentMethodId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.paymentMethodId,
                            referencedTable: $$SubscriptionsTableReferences
                                ._paymentMethodIdTable(db),
                            referencedColumn: $$SubscriptionsTableReferences
                                ._paymentMethodIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (subscriptionEventsRefs)
                        await $_getPrefetchedDataByColumns<
                          Subscription,
                          $SubscriptionsTable,
                          SubscriptionEvent,
                          $SubscriptionEventsTable
                        >(
                          currentTable: table,
                          referencedTable: $$SubscriptionsTableReferences
                              ._subscriptionEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubscriptionsTableReferences(
                                db,
                                table,
                                p0,
                              ).subscriptionEventsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'subscription_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SubscriptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubscriptionsTable,
      Subscription,
      $$SubscriptionsTableFilterComposer,
      $$SubscriptionsTableOrderingComposer,
      $$SubscriptionsTableAnnotationComposer,
      $$SubscriptionsTableCreateCompanionBuilder,
      $$SubscriptionsTableUpdateCompanionBuilder,
      (Subscription, $$SubscriptionsTableReferences),
      Subscription,
      PrefetchHooks Function({
        bool platformId,
        bool accountId,
        bool paymentMethodId,
        bool subscriptionEventsRefs,
      })
    >;
typedef $$SubscriptionEventsTableCreateCompanionBuilder =
    SubscriptionEventsCompanion Function({
      required String id,
      required String subscriptionId,
      Value<DateTime> at,
      required String kind,
      Value<String?> details,
      Value<int> rowid,
    });
typedef $$SubscriptionEventsTableUpdateCompanionBuilder =
    SubscriptionEventsCompanion Function({
      Value<String> id,
      Value<String> subscriptionId,
      Value<DateTime> at,
      Value<String> kind,
      Value<String?> details,
      Value<int> rowid,
    });

final class $$SubscriptionEventsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SubscriptionEventsTable,
          SubscriptionEvent
        > {
  $$SubscriptionEventsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SubscriptionsTable _subscriptionIdTable(_$AppDatabase db) => db
      .subscriptions
      .createAlias('subscription_events__subscription_id__subscriptions__id');

  $$SubscriptionsTableProcessedTableManager get subscriptionId {
    final $_column = $_itemColumn<String>('subscription_id')!;

    final manager = $$SubscriptionsTableTableManager(
      $_db,
      $_db.subscriptions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subscriptionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SubscriptionEventsTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionEventsTable> {
  $$SubscriptionEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );

  $$SubscriptionsTableFilterComposer get subscriptionId {
    final $$SubscriptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subscriptionId,
      referencedTable: $db.subscriptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableFilterComposer(
            $db: $db,
            $table: $db.subscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubscriptionEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionEventsTable> {
  $$SubscriptionEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubscriptionsTableOrderingComposer get subscriptionId {
    final $$SubscriptionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subscriptionId,
      referencedTable: $db.subscriptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableOrderingComposer(
            $db: $db,
            $table: $db.subscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubscriptionEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionEventsTable> {
  $$SubscriptionEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  $$SubscriptionsTableAnnotationComposer get subscriptionId {
    final $$SubscriptionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subscriptionId,
      referencedTable: $db.subscriptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableAnnotationComposer(
            $db: $db,
            $table: $db.subscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubscriptionEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubscriptionEventsTable,
          SubscriptionEvent,
          $$SubscriptionEventsTableFilterComposer,
          $$SubscriptionEventsTableOrderingComposer,
          $$SubscriptionEventsTableAnnotationComposer,
          $$SubscriptionEventsTableCreateCompanionBuilder,
          $$SubscriptionEventsTableUpdateCompanionBuilder,
          (SubscriptionEvent, $$SubscriptionEventsTableReferences),
          SubscriptionEvent,
          PrefetchHooks Function({bool subscriptionId})
        > {
  $$SubscriptionEventsTableTableManager(
    _$AppDatabase db,
    $SubscriptionEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriptionEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriptionEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscriptionEventsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> subscriptionId = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String?> details = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubscriptionEventsCompanion(
                id: id,
                subscriptionId: subscriptionId,
                at: at,
                kind: kind,
                details: details,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String subscriptionId,
                Value<DateTime> at = const Value.absent(),
                required String kind,
                Value<String?> details = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubscriptionEventsCompanion.insert(
                id: id,
                subscriptionId: subscriptionId,
                at: at,
                kind: kind,
                details: details,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SubscriptionEventsTable, SubscriptionEvent>(
                    table,
                  ),
                  $$SubscriptionEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({subscriptionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (subscriptionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.subscriptionId,
                        referencedTable: $$SubscriptionEventsTableReferences
                            ._subscriptionIdTable(db),
                        referencedColumn: $$SubscriptionEventsTableReferences
                            ._subscriptionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SubscriptionEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubscriptionEventsTable,
      SubscriptionEvent,
      $$SubscriptionEventsTableFilterComposer,
      $$SubscriptionEventsTableOrderingComposer,
      $$SubscriptionEventsTableAnnotationComposer,
      $$SubscriptionEventsTableCreateCompanionBuilder,
      $$SubscriptionEventsTableUpdateCompanionBuilder,
      (SubscriptionEvent, $$SubscriptionEventsTableReferences),
      SubscriptionEvent,
      PrefetchHooks Function({bool subscriptionId})
    >;
typedef $$DocumentReferencesTableCreateCompanionBuilder =
    DocumentReferencesCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required String id,
      required String title,
      required String locator,
      Value<String?> kind,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$DocumentReferencesTableUpdateCompanionBuilder =
    DocumentReferencesCompanion Function({
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> id,
      Value<String> title,
      Value<String> locator,
      Value<String?> kind,
      Value<String?> notes,
      Value<int> rowid,
    });

class $$DocumentReferencesTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentReferencesTable> {
  $$DocumentReferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locator => $composableBuilder(
    column: $table.locator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DocumentReferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentReferencesTable> {
  $$DocumentReferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locator => $composableBuilder(
    column: $table.locator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DocumentReferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentReferencesTable> {
  $$DocumentReferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get locator =>
      $composableBuilder(column: $table.locator, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$DocumentReferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentReferencesTable,
          DocumentReference,
          $$DocumentReferencesTableFilterComposer,
          $$DocumentReferencesTableOrderingComposer,
          $$DocumentReferencesTableAnnotationComposer,
          $$DocumentReferencesTableCreateCompanionBuilder,
          $$DocumentReferencesTableUpdateCompanionBuilder,
          (
            DocumentReference,
            BaseReferences<
              _$AppDatabase,
              $DocumentReferencesTable,
              DocumentReference
            >,
          ),
          DocumentReference,
          PrefetchHooks Function()
        > {
  $$DocumentReferencesTableTableManager(
    _$AppDatabase db,
    $DocumentReferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentReferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentReferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentReferencesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> locator = const Value.absent(),
                Value<String?> kind = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentReferencesCompanion(
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                title: title,
                locator: locator,
                kind: kind,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required String id,
                required String title,
                required String locator,
                Value<String?> kind = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentReferencesCompanion.insert(
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                title: title,
                locator: locator,
                kind: kind,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DocumentReferencesTable, DocumentReference>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $DocumentReferencesTable,
                    DocumentReference
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DocumentReferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentReferencesTable,
      DocumentReference,
      $$DocumentReferencesTableFilterComposer,
      $$DocumentReferencesTableOrderingComposer,
      $$DocumentReferencesTableAnnotationComposer,
      $$DocumentReferencesTableCreateCompanionBuilder,
      $$DocumentReferencesTableUpdateCompanionBuilder,
      (
        DocumentReference,
        BaseReferences<
          _$AppDatabase,
          $DocumentReferencesTable,
          DocumentReference
        >,
      ),
      DocumentReference,
      PrefetchHooks Function()
    >;
typedef $$AuditEventsTableCreateCompanionBuilder =
    AuditEventsCompanion Function({
      Value<int> id,
      Value<DateTime> at,
      required String action,
      Value<String?> entityType,
      Value<String?> entityId,
      required String summary,
    });
typedef $$AuditEventsTableUpdateCompanionBuilder =
    AuditEventsCompanion Function({
      Value<int> id,
      Value<DateTime> at,
      Value<String> action,
      Value<String?> entityType,
      Value<String?> entityId,
      Value<String> summary,
    });

class $$AuditEventsTableFilterComposer
    extends Composer<_$AppDatabase, $AuditEventsTable> {
  $$AuditEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuditEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditEventsTable> {
  $$AuditEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuditEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditEventsTable> {
  $$AuditEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);
}

class $$AuditEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditEventsTable,
          AuditEvent,
          $$AuditEventsTableFilterComposer,
          $$AuditEventsTableOrderingComposer,
          $$AuditEventsTableAnnotationComposer,
          $$AuditEventsTableCreateCompanionBuilder,
          $$AuditEventsTableUpdateCompanionBuilder,
          (
            AuditEvent,
            BaseReferences<_$AppDatabase, $AuditEventsTable, AuditEvent>,
          ),
          AuditEvent,
          PrefetchHooks Function()
        > {
  $$AuditEventsTableTableManager(_$AppDatabase db, $AuditEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String?> entityType = const Value.absent(),
                Value<String?> entityId = const Value.absent(),
                Value<String> summary = const Value.absent(),
              }) => AuditEventsCompanion(
                id: id,
                at: at,
                action: action,
                entityType: entityType,
                entityId: entityId,
                summary: summary,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                required String action,
                Value<String?> entityType = const Value.absent(),
                Value<String?> entityId = const Value.absent(),
                required String summary,
              }) => AuditEventsCompanion.insert(
                id: id,
                at: at,
                action: action,
                entityType: entityType,
                entityId: entityId,
                summary: summary,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AuditEventsTable, AuditEvent>(table),
                  BaseReferences<_$AppDatabase, $AuditEventsTable, AuditEvent>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuditEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditEventsTable,
      AuditEvent,
      $$AuditEventsTableFilterComposer,
      $$AuditEventsTableOrderingComposer,
      $$AuditEventsTableAnnotationComposer,
      $$AuditEventsTableCreateCompanionBuilder,
      $$AuditEventsTableUpdateCompanionBuilder,
      (
        AuditEvent,
        BaseReferences<_$AppDatabase, $AuditEventsTable, AuditEvent>,
      ),
      AuditEvent,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, Setting>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, Setting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PlatformsTableTableManager get platforms =>
      $$PlatformsTableTableManager(_db, _db.platforms);
  $$EmailIdentitiesTableTableManager get emailIdentities =>
      $$EmailIdentitiesTableTableManager(_db, _db.emailIdentities);
  $$SecureItemsTableTableManager get secureItems =>
      $$SecureItemsTableTableManager(_db, _db.secureItems);
  $$CredentialReferencesTableTableManager get credentialReferences =>
      $$CredentialReferencesTableTableManager(_db, _db.credentialReferences);
  $$ServiceAccountsTableTableManager get serviceAccounts =>
      $$ServiceAccountsTableTableManager(_db, _db.serviceAccounts);
  $$OrganizationsTableTableManager get organizations =>
      $$OrganizationsTableTableManager(_db, _db.organizations);
  $$ArtistsTableTableManager get artists =>
      $$ArtistsTableTableManager(_db, _db.artists);
  $$YoutubeChannelsTableTableManager get youtubeChannels =>
      $$YoutubeChannelsTableTableManager(_db, _db.youtubeChannels);
  $$ChannelManagersTableTableManager get channelManagers =>
      $$ChannelManagersTableTableManager(_db, _db.channelManagers);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$LinksTableTableManager get links =>
      $$LinksTableTableManager(_db, _db.links);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$TagLinksTableTableManager get tagLinks =>
      $$TagLinksTableTableManager(_db, _db.tagLinks);
  $$CustomFieldsTableTableManager get customFields =>
      $$CustomFieldsTableTableManager(_db, _db.customFields);
  $$BankAccountsTableTableManager get bankAccounts =>
      $$BankAccountsTableTableManager(_db, _db.bankAccounts);
  $$PaymentCardsTableTableManager get paymentCards =>
      $$PaymentCardsTableTableManager(_db, _db.paymentCards);
  $$PaymentMethodsTableTableManager get paymentMethods =>
      $$PaymentMethodsTableTableManager(_db, _db.paymentMethods);
  $$SubscriptionsTableTableManager get subscriptions =>
      $$SubscriptionsTableTableManager(_db, _db.subscriptions);
  $$SubscriptionEventsTableTableManager get subscriptionEvents =>
      $$SubscriptionEventsTableTableManager(_db, _db.subscriptionEvents);
  $$DocumentReferencesTableTableManager get documentReferences =>
      $$DocumentReferencesTableTableManager(_db, _db.documentReferences);
  $$AuditEventsTableTableManager get auditEvents =>
      $$AuditEventsTableTableManager(_db, _db.auditEvents);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
