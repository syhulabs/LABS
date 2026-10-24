import 'package:flutter_test/flutter_test.dart';
import 'package:syhu_account_hub/app/providers.dart';
import 'package:syhu_account_hub/domain/enums.dart';
import 'package:syhu_account_hub/features/youtube/channel_detail_screen.dart';
import 'package:syhu_account_hub/features/youtube/youtube_screen.dart';

import '../support/pump_app.dart';

void main() {
  testWidgets('YouTube screen shows the empty state when there are no channels', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    await pumpScreen(tester, c, const YoutubeScreen());
    await settle(tester);
    expect(find.text('No YouTube channels yet'), findsOneWidget);
    expect(find.text('Channels without owner'), findsOneWidget);
  });

  testWidgets('channels are grouped under their owning Google identity', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    await data(tester, () async {
      final emails = c.read(emailRepositoryProvider);
      final yt = c.read(youtubeRepositoryProvider);
      final a = await emails.upsert(address: 'a@gmail.com');
      final b = await emails.upsert(address: 'b@gmail.com');
      await yt.upsert(name: 'Main Channel', ownerEmailId: a.id, handle: 'main', channelType: 'Main');
      await yt.upsert(name: 'Gaming Channel', ownerEmailId: a.id, channelType: 'Gaming');
      await yt.upsert(name: 'Studio Channel', ownerEmailId: b.id);
      await yt.upsert(name: 'Orphan Channel');
    });
    await pumpScreen(tester, c, const YoutubeScreen());
    await settle(tester);
    expect(find.text('a@gmail.com'), findsOneWidget);
    expect(find.text('2 channels'), findsOneWidget);
    expect(find.text('b@gmail.com'), findsOneWidget);
    expect(find.text('Main Channel'), findsOneWidget);
    expect(find.text('Gaming Channel'), findsOneWidget);
    expect(find.text('No owner set'), findsWidgets);
    expect(find.text('Orphan Channel'), findsOneWidget);
    expect(find.text('No YouTube channels yet'), findsNothing);
  });

  testWidgets('channel detail lists owner and both managers with roles', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    final channelId = await data(tester, () async {
      final emails = c.read(emailRepositoryProvider);
      final owner = await emails.upsert(address: 'owner@gmail.com');
      final m1 = await emails.upsert(address: 'editor@studio.com');
      final m2 = await emails.upsert(address: 'manager@label.com');
      final ch = await c.read(youtubeRepositoryProvider).upsert(
            name: 'Music Channel',
            ownerEmailId: owner.id,
            managers: [(m1.id, ChannelRole.editor), (m2.id, ChannelRole.manager)],
          );
      return ch.id;
    });
    await pumpScreen(tester, c, ChannelDetailScreen(channelId: channelId));
    await settle(tester);
    expect(find.text('Music Channel'), findsWidgets);
    expect(find.text('owner@gmail.com'), findsOneWidget);
    expect(find.text('editor@studio.com'), findsOneWidget);
    expect(find.text('manager@label.com'), findsOneWidget);
    expect(find.text('Editor'), findsOneWidget);
    expect(find.text('Manager'), findsOneWidget);
  });
}
