import '../../core/streams.dart';
import '../../domain/enums.dart';
import '../../domain/money.dart';
import '../../domain/subscription_math.dart';
import '../db/app_database.dart';
import 'subscription_repository.dart';

/// Dashboard numbers computed from live local data. Empty database = zeros.
class DashboardStats {
  const DashboardStats({
    required this.emailCount,
    required this.platformCount,
    required this.accountCount,
    required this.channelCount,
    required this.activeSubscriptions,
    required this.pausedSubscriptions,
    required this.upcomingRenewals,
    required this.monthlyCost,
    required this.annualCost,
    required this.vaultItems,
    required this.bankAccounts,
    required this.projectCount,
  });

  static const empty = DashboardStats(
    emailCount: 0, platformCount: 0, accountCount: 0, channelCount: 0, activeSubscriptions: 0, pausedSubscriptions: 0,
    upcomingRenewals: 0, monthlyCost: null, annualCost: null, vaultItems: 0, bankAccounts: 0, projectCount: 0,
  );

  final int emailCount;
  final int platformCount; // platforms in My World
  final int accountCount;
  final int channelCount;
  final int activeSubscriptions;
  final int pausedSubscriptions;
  final int upcomingRenewals;
  final MoneyTotals? monthlyCost;
  final MoneyTotals? annualCost;
  final int vaultItems;
  final int bankAccounts;
  final int projectCount;
}

class StatsRepository {
  StatsRepository(this.db, this.subscriptions);
  final AppDatabase db;
  final SubscriptionRepository subscriptions;

  Stream<DashboardStats> watch({DateTime Function()? clock}) {
    final emails = (db.select(db.emailIdentities)..where((e) => e.archivedAt.isNull())).watch();
    final platforms = (db.select(db.platforms)..where((p) => p.inMyWorld.equals(true))).watch();
    final accounts = (db.select(db.serviceAccounts)..where((a) => a.archivedAt.isNull())).watch();
    final channels = (db.select(db.youtubeChannels)..where((c) => c.archivedAt.isNull())).watch();
    final subs = subscriptions.watchAll();
    final vault = db.select(db.secureItems).watch();
    final banks = (db.select(db.bankAccounts)..where((b) => b.archivedAt.isNull())).watch();
    final projects = (db.select(db.projects)..where((p) => p.archivedAt.isNull())).watch();

    return combineLatestList<List<Object>>([emails, platforms, accounts, channels, subs, vault, banks, projects]).map((l) {
      final subViews = l[4].cast<SubscriptionView>();
      final likes = subViews.map((s) => s.like).toList();
      final now = (clock ?? DateTime.now)();
      return DashboardStats(
        emailCount: l[0].length,
        platformCount: l[1].length,
        accountCount: l[2].length,
        channelCount: l[3].length,
        activeSubscriptions: subViews.where((s) => s.status == SubscriptionStatus.active || s.status == SubscriptionStatus.trial).length,
        pausedSubscriptions: subViews.where((s) => s.status == SubscriptionStatus.paused).length,
        upcomingRenewals: SubscriptionMath.upcoming(likes, now: now, days: 30).length,
        monthlyCost: SubscriptionMath.monthlyTotals(likes),
        annualCost: SubscriptionMath.annualTotals(likes),
        vaultItems: l[5].length,
        bankAccounts: l[6].length,
        projectCount: l[7].length,
      );
    });
  }
}
