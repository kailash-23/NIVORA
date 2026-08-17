import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/nivora_user_profile.dart';
import '../../repositories/nivora_user_repository.dart';
import '../../services/haptics.dart';
import '../../widgets/section_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.onSignOut,
    required this.userRepository,
  });

  final VoidCallback onSignOut;
  final NivoraUserRepository userRepository;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _hapticsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        bottom: false,
        child: FutureBuilder<NivoraUserProfile?>(
          future: widget.userRepository.getCurrentUserProfile(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const _StatusView(message: 'Unable to load profile.');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const _StatusView(message: 'Loading profile...');
            }

            final profile = snapshot.data;
            final name = profile?.displayName ?? 'NIVORA User';
            final email = profile?.email ?? 'user@example.com';
            final uid = profile?.uid ?? 'N/A';

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
              children: [
                // HEADER TITLE
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.darkText,
                    letterSpacing: -1.0,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Account settings and system preferences',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.mutedText,
                  ),
                ),

                const SizedBox(height: 20),

                // USER PROFILE HEADER CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppTheme.borderLight),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryPurple.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppTheme.primaryPurple, Color(0xFFB59BF2)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryPurple.withValues(
                                alpha: 0.25,
                              ),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.darkText,
                                letterSpacing: -0.4,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              email,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.mutedText,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.lavenderTint,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.verified_rounded,
                                    size: 13,
                                    color: AppTheme.primaryPurple,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Google Authenticated',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.primaryPurple,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // USER INFORMATION
                const SectionHeader(
                  title: 'User information',
                  subtitle: 'Personal details and credentials',
                ),
                const SizedBox(height: 10),
                _SettingsGroupCard(
                  children: [
                    _SettingsRow(
                      icon: Icons.person_outline_rounded,
                      title: 'Display Name',
                      value: name,
                    ),
                    const Divider(height: 1, color: AppTheme.borderLight),
                    _SettingsRow(
                      icon: Icons.email_outlined,
                      title: 'Email Address',
                      value: email,
                    ),
                    const Divider(height: 1, color: AppTheme.borderLight),
                    _SettingsRow(
                      icon: Icons.fingerprint_rounded,
                      title: 'Account ID',
                      value: uid.length > 16
                          ? '${uid.substring(0, 16)}...'
                          : uid,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // PREFERENCES
                const SectionHeader(
                  title: 'Preferences',
                  subtitle: 'App behavior and notification settings',
                ),
                const SizedBox(height: 10),
                _SettingsGroupCard(
                  children: [
                    _SettingsSwitchRow(
                      icon: Icons.notifications_none_rounded,
                      title: 'Push Notifications',
                      subtitle: 'Habit reminders and daily rhythm resets',
                      value: _notificationsEnabled,
                      onChanged: (val) {
                        Haptics.selection();
                        setState(() {
                          _notificationsEnabled = val;
                        });
                      },
                    ),
                    const Divider(height: 1, color: AppTheme.borderLight),
                    _SettingsSwitchRow(
                      icon: Icons.vibration_rounded,
                      title: 'Haptic Feedback',
                      subtitle: 'Tactile interaction on complete and selection',
                      value: _hapticsEnabled,
                      onChanged: (val) {
                        Haptics.selection();
                        setState(() {
                          _hapticsEnabled = val;
                        });
                      },
                    ),
                    const Divider(height: 1, color: AppTheme.borderLight),
                    const _SettingsRow(
                      icon: Icons.palette_outlined,
                      title: 'Appearance',
                      value: 'Soft Lavender (Light)',
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ABOUT & LEGAL
                const SectionHeader(
                  title: 'About',
                  subtitle: 'Version and legal disclosures',
                ),
                const SizedBox(height: 10),
                _SettingsGroupCard(
                  children: [
                    const _SettingsRow(
                      icon: Icons.info_outline_rounded,
                      title: 'Application Version',
                      value: 'v1.0.0 (Build 1)',
                    ),
                    const Divider(height: 1, color: AppTheme.borderLight),
                    _SettingsRow(
                      icon: Icons.shield_outlined,
                      title: 'Privacy Policy',
                      value: 'Protected',
                      onTap: () => Haptics.light(),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // LOGOUT BUTTON
                GestureDetector(
                  onTap: () {
                    Haptics.selection();
                    widget.onSignOut();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.coralTint,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: AppTheme.coralRed.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.logout_rounded,
                          size: 20,
                          color: AppTheme.coralRed,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Sign Out of Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.coralRed,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SettingsGroupCard extends StatelessWidget {
  const _SettingsGroupCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.surfaceSubtle,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: AppTheme.primaryPurple),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppTheme.darkText,
        ),
      ),
      trailing: Text(
        value,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppTheme.mutedText,
        ),
      ),
    );
  }
}

class _SettingsSwitchRow extends StatelessWidget {
  const _SettingsSwitchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.surfaceSubtle,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: AppTheme.primaryPurple),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppTheme.darkText,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 11, color: AppTheme.mutedText),
      ),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppTheme.primaryPurple,
      ),
    );
  }
}

class _StatusView extends StatelessWidget {
  const _StatusView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppTheme.primaryPurple,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.mutedText,
            ),
          ),
        ],
      ),
    );
  }
}
