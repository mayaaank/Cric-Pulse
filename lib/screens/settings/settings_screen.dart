import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/glass_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Consumer2<SettingsProvider, AuthProvider>(
      builder: (context, prov, auth, _) {
        final profile = auth.profile;
        final displayName = profile?.displayName ?? profile?.username ?? 'Cricket Fan';
        final xpText = profile != null
            ? 'Level ${profile.level} • ${profile.totalXp} XP'
            : 'Level 12 • 6,800 XP';

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: const Text('Settings')),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Profile section
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: cs.primaryContainer,
                      child: Text(
                        displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                        style: tt.headlineMedium!.copyWith(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(displayName, style: tt.titleMedium),
                          const SizedBox(height: 4),
                          Text(xpText, style: tt.bodySmall),
                        ],
                      ),
                    ),
                    if (auth.isLoggedIn)
                      IconButton(
                        onPressed: () => _confirmSignOut(context, auth),
                        icon: Icon(Icons.logout, color: cs.error),
                        tooltip: 'Sign Out',
                      )
                    else
                      Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text('Appearance', style: tt.headlineSmall),
              const SizedBox(height: 12),
              GlassCard(
                padding: const EdgeInsets.all(4),
                child: SwitchListTile(
                  title: Text('Dark Mode', style: tt.titleSmall),
                  subtitle: Text('Optimized for OLED displays', style: tt.labelSmall),
                  value: prov.darkMode,
                  onChanged: (_) => prov.toggleDarkMode(),
                  secondary: Icon(Icons.dark_mode, color: cs.primary),
                ),
              ),
              const SizedBox(height: 24),

              Text('Notifications', style: tt.headlineSmall),
              const SizedBox(height: 12),
              GlassCard(
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text('Live Score Alerts', style: tt.titleSmall),
                      subtitle: Text('Ball-by-ball notifications', style: tt.labelSmall),
                      value: prov.liveNotif,
                      onChanged: (_) => prov.toggleLiveNotif(),
                      secondary: Icon(Icons.notifications_active, color: cs.secondary),
                    ),
                    Divider(height: 1, color: cs.outlineVariant.withValues(alpha: 0.2)),
                    SwitchListTile(
                      title: Text('Match Start Alerts', style: tt.titleSmall),
                      subtitle: Text('Notify when matches begin', style: tt.labelSmall),
                      value: prov.scoreNotif,
                      onChanged: (_) => prov.toggleScoreNotif(),
                      secondary: Icon(Icons.sports_cricket, color: cs.tertiary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text('Language', style: tt.headlineSmall),
              const SizedBox(height: 12),
              GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: Icon(Icons.language, color: cs.primaryContainer),
                  title: Text('Language', style: tt.titleSmall),
                  trailing: DropdownButton<String>(
                    value: prov.language,
                    dropdownColor: cs.surfaceContainerHigh,
                    underline: const SizedBox(),
                    style: tt.labelLarge!.copyWith(color: cs.primary),
                    items: SettingsProvider.languages
                        .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) prov.setLanguage(v);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // App info
              Center(
                child: Column(
                  children: [
                    Text('CricPulse', style: tt.titleMedium!.copyWith(color: cs.primary)),
                    const SizedBox(height: 4),
                    Text('Version 1.0.0', style: tt.labelSmall),
                    const SizedBox(height: 2),
                    Text('High-Octane Cricket Experience', style: tt.labelSmall!.copyWith(color: cs.onSurfaceVariant)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  void _confirmSignOut(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              auth.signOut();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
