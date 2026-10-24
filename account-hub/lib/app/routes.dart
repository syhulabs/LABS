import 'package:flutter/material.dart';

import '../domain/enums.dart';

/// Route paths and sidebar structure for the 22 primary sections.
class Routes {
  static const home = '/home';
  static const myWorld = '/my-world';
  static const explore = '/explore';
  static const accounts = '/accounts';
  static const youtube = '/youtube';
  static const ai = '/ai';
  static const social = '/social';
  static const music = '/music';
  static const studio = '/studio';
  static const gaming = '/gaming';
  static const engines = '/game-engines';
  static const developer = '/developer';
  static const google = '/google';
  static const apple = '/apple';
  static const microsoft = '/microsoft';
  static const cloud = '/cloud';
  static const banking = '/banking';
  static const subscriptions = '/subscriptions';
  static const personal = '/personal';
  static const business = '/business';
  static const vault = '/vault';
  static const settings = '/settings';

  static String platform(String id) => '/platform/$id';
  static String account(String id) => '/accounts/account/$id';
  static String email(String id) => '/accounts/email/$id';
  static String channel(String id) => '/youtube/$id';
  static String project(String id) => '/studio/project/$id';
  static String organization(String id) => '/studio/organization/$id';
  static String artist(String id) => '/music/artist/$id';
  static String subscription(String id) => '/subscriptions/$id';
  static String bank(String id) => '/banking/account/$id';
}

String routeForEntity(EntityType type, String id) => switch (type) {
      EntityType.platform => Routes.platform(id),
      EntityType.emailIdentity => Routes.email(id),
      EntityType.serviceAccount => Routes.account(id),
      EntityType.youtubeChannel => Routes.channel(id),
      EntityType.project => Routes.project(id),
      EntityType.organization => Routes.organization(id),
      EntityType.artist => Routes.artist(id),
      EntityType.subscription => Routes.subscription(id),
      EntityType.bankAccount => Routes.bank(id),
      EntityType.paymentCard => Routes.banking,
      EntityType.paymentMethod => Routes.banking,
      EntityType.credentialReference => Routes.vault,
      EntityType.documentReference => Routes.studio,
      EntityType.secureItem => Routes.vault,
    };

class NavItem {
  const NavItem(this.label, this.icon, this.path, {this.color});
  final String label;
  final IconData icon;
  final String path;
  final Color? color;
}

class NavGroup {
  const NavGroup(this.id, this.label, this.items);
  final String id;
  final String label;
  final List<NavItem> items;
}

const navGroups = <NavGroup>[
  NavGroup('overview', 'Overview', [
    NavItem('Home', Icons.home_rounded, Routes.home),
    NavItem('My World', Icons.public_rounded, Routes.myWorld),
    NavItem('Explore', Icons.explore_rounded, Routes.explore),
  ]),
  NavGroup('identity', 'Identity', [
    NavItem('Accounts & Emails', Icons.alternate_email_rounded, Routes.accounts),
    NavItem('Secure Vault', Icons.lock_rounded, Routes.vault),
  ]),
  NavGroup('creator', 'Creator', [
    NavItem('YouTube', Icons.play_circle_fill_rounded, Routes.youtube, color: Color(0xFFFF0033)),
    NavItem('Social Media', Icons.forum_rounded, Routes.social, color: Color(0xFFEC4899)),
    NavItem('Music, Artist & Label', Icons.music_note_rounded, Routes.music, color: Color(0xFF1DB954)),
    NavItem('Studio & Projects', Icons.movie_creation_rounded, Routes.studio, color: Color(0xFFF59E0B)),
  ]),
  NavGroup('tech', 'Technology', [
    NavItem('AI Platforms', Icons.auto_awesome_rounded, Routes.ai, color: Color(0xFF8B5CF6)),
    NavItem('Developer Tools', Icons.code_rounded, Routes.developer, color: Color(0xFF3B82F6)),
    NavItem('Game Engines', Icons.view_in_ar_rounded, Routes.engines, color: Color(0xFF06B6D4)),
    NavItem('Gaming', Icons.sports_esports_rounded, Routes.gaming, color: Color(0xFF10B981)),
    NavItem('Cloud & Storage', Icons.cloud_rounded, Routes.cloud, color: Color(0xFF0EA5E9)),
  ]),
  NavGroup('ecosystems', 'Ecosystems', [
    NavItem('Google', Icons.g_mobiledata_rounded, Routes.google, color: Color(0xFF4285F4)),
    NavItem('Apple', Icons.phone_iphone_rounded, Routes.apple, color: Color(0xFFA3AAAE)),
    NavItem('Microsoft', Icons.window_rounded, Routes.microsoft, color: Color(0xFF00A4EF)),
  ]),
  NavGroup('money', 'Money', [
    NavItem('Banking & Payments', Icons.account_balance_rounded, Routes.banking, color: Color(0xFF22C55E)),
    NavItem('Subscriptions', Icons.autorenew_rounded, Routes.subscriptions, color: Color(0xFFA855F7)),
  ]),
  NavGroup('life', 'Life', [
    NavItem('Personal', Icons.person_rounded, Routes.personal),
    NavItem('Business', Icons.business_center_rounded, Routes.business),
  ]),
  NavGroup('system', 'System', [
    NavItem('Settings', Icons.settings_rounded, Routes.settings),
  ]),
];

NavItem? navItemForPath(String location) {
  NavItem? best;
  for (final g in navGroups) {
    for (final i in g.items) {
      if (location == i.path || location.startsWith('${i.path}/')) {
        if (best == null || i.path.length > best.path.length) best = i;
      }
    }
  }
  return best;
}
