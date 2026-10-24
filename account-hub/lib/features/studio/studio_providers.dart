import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../data/db/app_database.dart';

final projectByIdProvider = StreamProvider.family<Project?, String>((ref, id) => ref.watch(projectRepositoryProvider).watchProject(id));

final organizationByIdProvider = StreamProvider.family<Organization?, String>(
  (ref, id) => ref.watch(projectRepositoryProvider).watchOrganizations(includeArchived: true).map((l) => l.where((o) => o.id == id).firstOrNull),
);

final allProjectsProvider = StreamProvider<List<Project>>((ref) => ref.watch(projectRepositoryProvider).watchProjects(includeArchived: true));

const documentKinds = <String>['Contract', 'Invoice', 'Design', 'Script', 'Brand asset', 'Legal', 'Other'];
