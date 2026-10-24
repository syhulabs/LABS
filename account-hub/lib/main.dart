import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/bootstrap.dart';
import 'app/providers.dart';
import 'data/db/database_connection.dart';
import 'data/secure/key_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer(overrides: [
    databaseProvider.overrideWithValue(openAppDatabase()),
    keyStoreProvider.overrideWithValue(SecureKeyStore()),
  ]);
  await bootstrap(container);
  runApp(UncontrolledProviderScope(container: container, child: const AccountHubApp()));
}
