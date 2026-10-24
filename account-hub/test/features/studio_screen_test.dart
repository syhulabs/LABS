import 'package:flutter_test/flutter_test.dart';
import 'package:syhu_account_hub/app/providers.dart';
import 'package:syhu_account_hub/domain/enums.dart';
import 'package:syhu_account_hub/features/music/music_screen.dart';
import 'package:syhu_account_hub/features/studio/organization_detail_screen.dart';
import 'package:syhu_account_hub/features/studio/project_detail_screen.dart';
import 'package:syhu_account_hub/features/studio/studio_screen.dart';

import '../support/pump_app.dart';

void main() {
  testWidgets('Studio screen shows empty state and zero stats', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    await pumpScreen(tester, c, const StudioScreen());
    await settle(tester);
    expect(find.text('No projects yet'), findsOneWidget);
    expect(find.text('Documents'), findsWidgets);
  });

  testWidgets('projects appear as cards with kind and status', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    await data(tester, () async {
      final repo = c.read(projectRepositoryProvider);
      await repo.upsertProject(name: 'Game A', kind: ProjectKind.game, status: ProjectStatus.inProgress);
      await repo.upsertProject(name: 'Album B', kind: ProjectKind.release, status: ProjectStatus.released, classification: Classification.business);
    });
    await pumpScreen(tester, c, const StudioScreen());
    await settle(tester);
    expect(find.text('Game A'), findsOneWidget);
    expect(find.text('Album B'), findsOneWidget);
    expect(find.text('No projects yet'), findsNothing);
  });

  testWidgets('project detail shows a linked account after link()', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    final projectId = await data(tester, () async {
      final email = await c.read(emailRepositoryProvider).upsert(address: 'dev@studio.com');
      final acc = await c.read(accountRepositoryProvider).upsert(platformId: 'github', emailIdentityId: email.id, accountName: 'Studio');
      final repo = c.read(projectRepositoryProvider);
      final p = await repo.upsertProject(name: 'Game A', kind: ProjectKind.game);
      await repo.link(EntityType.project, p.id, EntityType.serviceAccount, acc.id);
      return p.id;
    });
    await pumpScreen(tester, c, ProjectDetailScreen(projectId: projectId));
    await settle(tester, 10);
    expect(find.text('Game A'), findsWidgets);
    expect(find.textContaining('GitHub · Studio'), findsOneWidget);
    expect(find.text('Link account'), findsOneWidget);
  });

  testWidgets('organization detail lists its projects and signed artists', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    final orgId = await data(tester, () async {
      final repo = c.read(projectRepositoryProvider);
      final label = await repo.upsertOrganization(name: 'My Label', kind: OrganizationKind.recordLabel);
      await repo.upsertProject(name: 'Single One', kind: ProjectKind.song, organizationId: label.id);
      await repo.upsertProject(name: 'EP Two', kind: ProjectKind.release, organizationId: label.id, status: ProjectStatus.released);
      await repo.upsertArtist(name: 'Artist X', labelId: label.id);
      return label.id;
    });
    await pumpScreen(tester, c, OrganizationDetailScreen(organizationId: orgId));
    await settle(tester);
    expect(find.text('My Label'), findsWidgets);
    expect(find.textContaining('Single One'), findsOneWidget);
    expect(find.textContaining('EP Two'), findsOneWidget);
    expect(find.text('Artist X'), findsOneWidget);
    expect(find.text('Record label'), findsOneWidget);
  });

  testWidgets('Music screen lists artists with label and counts', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    await data(tester, () async {
      final repo = c.read(projectRepositoryProvider);
      final label = await repo.upsertOrganization(name: 'SYHU Records', kind: OrganizationKind.recordLabel);
      await repo.upsertArtist(name: 'Artist X', genre: 'Ambient', labelId: label.id);
      await repo.upsertArtist(name: 'Artist Y');
    });
    await pumpScreen(tester, c, const MusicScreen());
    await settle(tester);
    expect(find.text('Artist X'), findsOneWidget);
    expect(find.text('Artist Y'), findsOneWidget);
    expect(find.textContaining('SYHU Records'), findsOneWidget);
    expect(find.textContaining('Independent'), findsOneWidget);
    expect(find.text('No artist identities yet'), findsNothing);
  });
}
