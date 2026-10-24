import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../data/db/app_database.dart';

final artistByIdProvider = StreamProvider.family<Artist?, String>(
  (ref, id) => ref.watch(projectRepositoryProvider).watchArtists(includeArchived: true).map((l) => l.where((a) => a.id == id).firstOrNull),
);

const musicCategories = <String>['artist', 'music_distribution', 'studio', 'streaming'];

const musicSpotlight = <String>[
  'spotify-for-artists', 'apple-music-for-artists', 'distrokid', 'tunecore', 'cd-baby', 'soundcloud', 'bandcamp', 'youtube-music', 'amuse', 'landr', 'splice', 'ableton',
];
