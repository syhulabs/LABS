import 'package:flutter/material.dart';

import '../../domain/enums.dart';

/// Declarative description of a category / ecosystem / classification hub.
class HubConfig {
  const HubConfig({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.categories = const [],
    this.vendor,
    this.classification,
    this.spotlight = const [],
    this.tips = const [],
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  /// Catalog categories this hub covers (OR). Empty = all categories.
  final List<String> categories;
  /// Ecosystem vendor filter (google | apple | microsoft).
  final String? vendor;
  /// Personal / Business hubs filter by classification instead of category.
  final Classification? classification;
  /// Catalog ids to suggest when the hub is empty.
  final List<String> spotlight;
  final List<String> tips;

  bool matchesCategory(List<String> ids) => categories.isEmpty || ids.any(categories.contains);
}

class HubConfigs {
  static const ai = HubConfig(
    id: 'ai', title: 'AI Platforms', subtitle: 'Assistants, creative AI and coding tools; several accounts per platform, API accounts flagged.',
    icon: Icons.auto_awesome_rounded, color: Color(0xFF8B5CF6), categories: ['ai_assistants', 'ai_creative', 'ai_dev'],
    spotlight: ['chatgpt', 'claude', 'gemini', 'grok', 'deepseek', 'perplexity', 'meshy', 'midjourney', 'runway', 'suno', 'elevenlabs', 'cursor', 'codex', 'github-copilot'],
    tips: ['API keys belong in the Secure Vault, not in account fields.', 'Add the paid plan under Subscriptions to see it in your monthly total.'],
  );
  static const social = HubConfig(
    id: 'social', title: 'Social Media', subtitle: 'Profiles, pages and communities across networks.',
    icon: Icons.forum_rounded, color: Color(0xFFEC4899), categories: ['social', 'communication'],
    spotlight: ['instagram', 'x', 'tiktok', 'threads', 'facebook', 'linkedin', 'reddit', 'discord', 'telegram', 'pinterest'],
  );
  static const gaming = HubConfig(
    id: 'gaming', title: 'Gaming', subtitle: 'Player accounts, stores, publishing portals and creator programs.',
    icon: Icons.sports_esports_rounded, color: Color(0xFF10B981), categories: ['gaming', 'game_stores'],
    spotlight: ['steam', 'steamworks', 'epic-games', 'itch-io', 'playstation-network', 'xbox', 'nintendo-account', 'twitch', 'discord', 'roblox'],
  );
  static const engines = HubConfig(
    id: 'engines', title: 'Game Engines', subtitle: 'Engine licences, asset stores and tooling accounts.',
    icon: Icons.view_in_ar_rounded, color: Color(0xFF06B6D4), categories: ['game_engines'],
    spotlight: ['godot-engine', 'unity', 'unreal-engine', 'gamemaker', 'construct', 'defold', 'fab', 'unity-asset-store'],
    tips: ['Link an engine account to a game project from Studio & Projects.'],
  );
  static const developer = HubConfig(
    id: 'developer', title: 'Developer Tools', subtitle: 'Code hosting, CI, registries, IDEs and collaboration.',
    icon: Icons.code_rounded, color: Color(0xFF3B82F6), categories: ['developer'],
    spotlight: ['github', 'gitlab', 'slack', 'discord', 'vercel', 'cloudflare', 'supabase', 'firebase', 'npm', 'docker-hub'],
  );
  static const cloud = HubConfig(
    id: 'cloud', title: 'Cloud & Storage', subtitle: 'Hosting, backends, object storage and file sync.',
    icon: Icons.cloud_rounded, color: Color(0xFF0EA5E9), categories: ['cloud_hosting', 'storage'],
    spotlight: ['google-drive', 'icloud', 'dropbox', 'onedrive', 'aws', 'google-cloud', 'cloudflare', 'vercel', 'supabase', 'backblaze'],
  );
  static const google = HubConfig(
    id: 'google', title: 'Google Ecosystem', subtitle: 'Everything tied to your Google identities: YouTube, Drive, Play Console, Ads, Cloud.',
    icon: Icons.g_mobiledata_rounded, color: Color(0xFF4285F4), vendor: 'google',
    spotlight: ['google-account', 'gmail', 'youtube', 'google-drive', 'google-play-console', 'google-adsense', 'google-cloud-console', 'google-ads', 'firebase', 'google-one'],
    tips: ['One Google account can control many YouTube channels: manage them under YouTube.'],
  );
  static const apple = HubConfig(
    id: 'apple', title: 'Apple Ecosystem', subtitle: 'Apple Account, iCloud, App Store Connect, Developer Program, Music for Artists.',
    icon: Icons.phone_iphone_rounded, color: Color(0xFFA3AAAE), vendor: 'apple',
    spotlight: ['apple-account', 'icloud', 'app-store-connect', 'apple-developer-program', 'testflight', 'apple-music-for-artists', 'apple-podcasts-connect', 'apple-one'],
  );
  static const microsoft = HubConfig(
    id: 'microsoft', title: 'Microsoft Ecosystem', subtitle: 'Microsoft Account, Microsoft 365, Xbox, Azure, Partner Center.',
    icon: Icons.window_rounded, color: Color(0xFF00A4EF), vendor: 'microsoft',
    spotlight: ['microsoft-account', 'outlook', 'microsoft-365', 'onedrive', 'xbox', 'microsoft-azure', 'microsoft-partner-center', 'visual-studio-code'],
  );
  static const personal = HubConfig(
    id: 'personal', title: 'Personal', subtitle: 'Accounts, emails, subscriptions and projects you marked as personal.',
    icon: Icons.person_rounded, color: Color(0xFF3B82F6), classification: Classification.personal,
  );
  static const business = HubConfig(
    id: 'business', title: 'Business', subtitle: 'Everything classified as business: accounts, business emails, subscriptions, organizations.',
    icon: Icons.business_center_rounded, color: Color(0xFFEC4899), classification: Classification.business,
  );
}
