import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_transit/components/avatar.dart';
import 'package:smart_transit/components/badge.dart';
import 'package:smart_transit/components/button.dart';
import 'package:smart_transit/components/card.dart';
import 'package:smart_transit/theme/theme_provider.dart';

// --- Data Models for this screen ---

class Stat {
  final IconData icon;
  final String title;
  final String value;
  final String description;
  final MaterialColor color;
  Stat({
    required this.icon,
    required this.title,
    required this.value,
    required this.description,
    required this.color,
  });
}

class Achievement {
  final IconData icon;
  final String label;
  final MaterialColor color;
  Achievement({
    required this.icon,
    required this.label,
    required this.color,
  });
}

class MenuItem {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;
  MenuItem({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
  });
}

// --- Main Widget ---

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        // --- Mock Data ---
        final List<Stat> userStats = [
          Stat(
            icon: Icons.map_outlined,
            title: 'Distance',
            value: '1,247 km',
            description: 'Total Distance Traveled',
            color: Colors.blue,
          ),
          Stat(
            icon: Icons.eco_outlined,
            title: 'Impact',
            value: '342 kg',
            description: 'CO₂ Emissions Saved',
            color: Colors.green,
          ),
          Stat(
            icon: Icons.history,
            title: 'History',
            value: '156',
            description: 'Previous Tickets',
            color: Colors.purple,
          ),
          Stat(
            icon: Icons.directions_bus,
            title: 'Trips',
            value: '89',
            description: 'Trips Taken',
            color: Colors.orange,
          ),
        ];

        final List<Achievement> achievements = [
          Achievement(
            icon: Icons.shield_outlined,
            label: 'Eco Warrior',
            color: Colors.yellow,
          ),
          Achievement(
            icon: Icons.eco_outlined,
            label: 'Green Commuter',
            color: Colors.green,
          ),
          Achievement(
            icon: Icons.explore_outlined,
            label: 'Explorer',
            color: Colors.blue,
          ),
        ];

        final List<MenuItem> menuItems = [
          MenuItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            description: 'App preferences & notifications',
            onTap: () => debugPrint('Tapped Settings'),
          ),
          MenuItem(
            icon: Icons.help_outline,
            label: 'Help & Support',
            description: 'FAQs, contact us',
            onTap: () => debugPrint('Tapped Help'),
          ),
          MenuItem(
            icon: Icons.receipt_long_outlined,
            label: 'Previous Tickets',
            description: 'View your travel history',
            onTap: () => debugPrint('Tapped History'),
          ),
        ];

        final bottomSafe = MediaQuery.of(context).padding.bottom;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: CustomScrollView(
            slivers: [
              _ProfileHeader(
                isDarkMode: themeProvider.isDarkMode,
                onToggleDarkMode: themeProvider.toggleTheme,
              ),

              // Add bottom padding so the Log Out button clears the bottom nav
              SliverPadding(
                padding: EdgeInsets.only(
                  bottom: bottomSafe + kBottomNavigationBarHeight + 12,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(
                        height: 8), // Top spacing for the first section
                    _EfficiencyStats(stats: userStats),
                    const SizedBox(height: 8), // Spacing between sections
                    _RecentAchievements(achievements: achievements),
                    const SizedBox(height: 8), // Spacing between sections
                    _MenuItems(items: menuItems),
                    const SizedBox(height: 8), // Spacing before Logout Button
                    _LogoutButton(),
                    const SizedBox(height: 32), // Spacing before App Version
                    _AppVersion(),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// --- Smaller, Self-Contained Widgets ---

class _ProfileHeader extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const _ProfileHeader({
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140, // compact expanded state
      toolbarHeight: 64, // compact toolbar
      collapsedHeight: 64, // equals toolbarHeight => no extra gap when pinned
      pinned: true,
      backgroundColor:
          isDarkMode ? const Color(0xFF1E293B) : const Color(0xFF003366),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [
                      const Color(0xFF1E293B),
                      const Color(0xFF0F172A),
                      const Color(0xFF1E3A8A),
                    ]
                  : [
                      const Color(0xFF003366),
                      const Color(0xFF004080),
                      const Color(0xFF003366),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            // tighter padding to reduce header height perception
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const AppAvatar(imageUrl: '', fallbackText: 'JD', radius: 28),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white),
                    ),
                    Text(
                      'UID: 9876-5432',
                      style: TextStyle(
                        color: isDarkMode
                            ? Colors.blueGrey.shade300
                            : Colors.blue.shade200,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const AppBadge(
                      text: 'Regular Commuter',
                      icon: Icons.workspace_premium_outlined,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: AppButton(
            onPressed: onToggleDarkMode,
            variant: ButtonVariant.outline,
            size: ButtonSize.sm,
            icon: isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          ),
        ),
      ],
    );
  }
}

class _EfficiencyStats extends StatelessWidget {
  final List<Stat> stats;
  const _EfficiencyStats({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Only handle horizontal padding, vertical is handled by SizedBox
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.bar_chart, color: Colors.green.shade400),
            const SizedBox(width: 8),
            Text('Efficiency Stats',
                style: Theme.of(context).textTheme.titleLarge),
          ]),
          const SizedBox(height: 8),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.28, // slightly shorter cards
            ),
            itemCount: stats.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => _StatCard(stat: stats[index]),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final Stat stat;
  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return AppCard(
      child: Container(
        padding: const EdgeInsets.all(10), // tighter padding
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: isDarkMode
                ? [stat.color.withOpacity(0.2), stat.color.withOpacity(0.3)]
                : [stat.color.withOpacity(0.1), stat.color.withOpacity(0.2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  stat.icon,
                  color: isDarkMode ? stat.color.shade300 : stat.color.shade600,
                ),
                Text(
                  stat.title,
                  style: TextStyle(
                    color:
                        isDarkMode ? stat.color.shade300 : stat.color.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      stat.value,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                height: 1.0,
                                color: isDarkMode
                                    ? stat.color.shade200
                                    : stat.color.shade800,
                              ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    stat.description,
                    style: TextStyle(
                      color: isDarkMode
                          ? stat.color.shade300
                          : stat.color.shade600,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentAchievements extends StatelessWidget {
  final List<Achievement> achievements;
  const _RecentAchievements({required this.achievements});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Only handle horizontal padding
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Achievements',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: achievements
                .map((ach) => _AchievementItem(achievement: ach))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _AchievementItem extends StatelessWidget {
  final Achievement achievement;
  const _AchievementItem({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDarkMode
                ? achievement.color.withOpacity(0.25)
                : achievement.color.withOpacity(0.15),
          ),
          child: Icon(
            achievement.icon,
            color: isDarkMode
                ? achievement.color.shade300
                : achievement.color.shade600,
            size: 26,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 90,
          child: Text(
            achievement.label,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _MenuItems extends StatelessWidget {
  final List<MenuItem> items;
  const _MenuItems({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        return ListTile(
          dense: true,
          visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          minLeadingWidth: 24,
          leading: Icon(item.icon),
          title: Text(item.label),
          subtitle: Text(item.description),
          onTap: item.onTap,
        );
      }).toList(),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      // Only handle horizontal padding
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AppButton(
        variant: ButtonVariant.destructive,
        onPressed: () => debugPrint('Logging out...'),
        label: 'Log Out',
        icon: Icons.logout,
      ),
    );
  }
}

class _AppVersion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).dividerColor.withOpacity(0.08),
      alignment: Alignment.center,
      child: Text(
        'TransitApp v2.4.1',
        style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12),
      ),
    );
  }
}
