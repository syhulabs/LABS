import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../data/repositories/account_repository.dart';

/// Live view of a single account (joined with platform and email).
final accountByIdProvider = StreamProvider.family<AccountView?, String>((ref, id) => ref.watch(accountRepositoryProvider).watchById(id));
