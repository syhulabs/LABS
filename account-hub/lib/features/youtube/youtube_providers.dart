import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../data/repositories/youtube_repository.dart';

/// Channels including archived ones (for the "show archived" toggle).
final allChannelsProvider = StreamProvider<List<ChannelView>>((ref) => ref.watch(youtubeRepositoryProvider).watchAll(includeArchived: true));

/// One channel by id (archived included) for the detail screen.
final channelByIdProvider = StreamProvider.family<ChannelView?, String>((ref, id) => ref.watch(youtubeRepositoryProvider).watchById(id));

const channelTypes = <String>['Main', 'Gaming', 'Music', 'Studio', 'Stories', 'Vlog', 'Shorts', 'Podcast', 'Education', 'Business', 'Other'];
