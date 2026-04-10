// ============================================================
// File     : lib/features/profile/screens/settings_screen.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:navaveda/design/theme_provider.dart';
import 'package:navaveda/design/language_provider.dart';
import 'package:navaveda/generated/app_localizations.dart';
import 'package:navaveda/services/notification_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false;
  bool _loadingNotif = true;
  final Uri privacyUrl = Uri.parse(
      "https://aaderaviraj.github.io/Navaveda_term_condition/privacy.html"
  );

  final Uri termsUrl = Uri.parse(
      "https://aaderaviraj.github.io/Navaveda_term_condition/terms.html"
  );

  Future<void> _openUrl(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
  @override
  void initState() {
    super.initState();
    _loadNotificationState();
  }

  Future<void> _loadNotificationState() async {
    final enabled = await NotificationService().isEnabled();
    if (mounted) setState(() {
      _notificationsEnabled = enabled;
      _loadingNotif = false;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() => _notificationsEnabled = value);
    await NotificationService().toggle(value);
    if (mounted) {
      final loc = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(value ? loc.notificationsEnabled : loc.notificationsDisabled),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();
    final languageProvider = context.watch<LanguageProvider>();
    final currentLocale = languageProvider.locale;
    final loc = AppLocalizations.of(context);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded,
              color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(loc.settings,
            style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 22)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ── Appearance ──────────────────────────────────────
          _SectionLabel(loc.appearance),
          _Card(children: [
            _SwitchTile(
              icon: Icons.dark_mode_rounded,
              iconColor: const Color(0xFF8E54E9),
              title: loc.darkMode,
              subtitle: loc.darkModeSubtitle,
              value: themeProvider.isDarkMode,
              onChanged: themeProvider.toggleTheme,
            ),
          ]),
          const SizedBox(height: 20),

          // ── Notifications ───────────────────────────────────
          // _SectionLabel(loc.notifications),
          // _Card(children: [
          //   _loadingNotif
          //       ? const ListTile(leading: CircularProgressIndicator(), title: Text('Loading...'))
          //       : _SwitchTile(
          //           icon: Icons.notifications_rounded,
          //           iconColor: const Color(0xFF4776E6),
          //           title: loc.notifications,
          //           subtitle: loc.notificationsSubtitle,
          //           value: _notificationsEnabled,
          //           onChanged: _toggleNotifications,
          //         ),
          // ]),
          const SizedBox(height: 20),

          // ── Language ────────────────────────────────────────
          // _SectionLabel(loc.language),
          // _Card(children: [
          //   Padding(
          //     padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          //     child: Row(children: [
          //       Container(
          //         width: 40, height: 40,
          //         decoration: BoxDecoration(
          //           color: const Color(0xFF11998E).withOpacity(0.12),
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //         child: const Icon(Icons.language_rounded, color: Color(0xFF11998E), size: 20),
          //       ),
          //       const SizedBox(width: 14),
          //       Text(loc.changeLanguage,
          //           style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          //     ]),
          //   ),
          //   _LangOption(label: loc.english, flag: '🇬🇧', locale: const Locale('en'), current: currentLocale, onSelect: languageProvider.setLocale),
          //   _LangOption(label: loc.marathi, flag: '🇮🇳', locale: const Locale('mr'), current: currentLocale, onSelect: languageProvider.setLocale),
          //   _LangOption(label: loc.hindi, flag: '🇮🇳', locale: const Locale('hi'), current: currentLocale, onSelect: languageProvider.setLocale),
          //   const SizedBox(height: 8),
          // ]),
          const SizedBox(height: 20),

          // ── More ────────────────────────────────────────────
          _SectionLabel(loc.more),
          _Card(children: [
            _ArrowTile(
              icon: Icons.privacy_tip_rounded,
              iconColor: const Color(0xFF4776E6),
              title: loc.privacyPolicy,
              subtitle: loc.privacyPolicySubtitle,
              // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen())),
              onTap: () => _openUrl(privacyUrl),
            ),
            const Divider(height: 1, indent: 70),
            _ArrowTile(
              icon: Icons.description_rounded,
              iconColor: const Color(0xFF11998E),
              title: loc.termsConditions,
              subtitle: loc.termsConditionsSubtitle,
              onTap: () => _openUrl(termsUrl),
            ),
            const Divider(height: 1, indent: 70),
            // _ArrowTile(
            //   icon: Icons.security_rounded,
            //   iconColor: const Color(0xFFED213A),
            //   title: loc.privacySecurity,
            //   subtitle: loc.privacySecuritySubtitle,
            //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen())),
            // ),
            // const Divider(height: 1, indent: 70),
            _ArrowTile(
              icon: Icons.help_rounded,
              iconColor: const Color(0xFFF7971E),
              title: loc.helpSupport,
              subtitle: loc.helpSupportSubtitle,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportScreen())),
            ),
            const Divider(height: 1, indent: 70),
            _ArrowTile(
              icon: Icons.star_rate_rounded,
              iconColor: Colors.amber,
              title: loc.rateUs,
              subtitle: loc.rateUsSubtitle,
              onTap: () => _showRateUs(context),
            ),
          ]),

          const SizedBox(height: 30),
          Center(child: Column(children: [
            Text('Navaveda', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey.shade500)),
            const SizedBox(height: 4),
            Text('${loc.version} 1.0.0', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
          ])),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showRateUs(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Icon(Icons.star, color: Colors.amber, size: 28),
          SizedBox(width: 10),
          Text('Rate Navaveda'),
        ]),
        content: const Text('Enjoying the app? Please rate us on the Play Store — it helps us a lot!'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Later')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: launch store URL with url_launcher
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thank you for your support! 🙏')),
              );
            },
            child: const Text('Rate Now ⭐'),
          ),
        ],
      ),
    );
  }
}

// ── Reusable Widgets ───────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 8),
    child: Text(text.toUpperCase(),
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.4, color: Colors.grey.shade500)),
  );
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Column(children: children),
      ),
    );
  }
}



class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchTile({required this.icon, required this.iconColor, required this.title, required this.subtitle, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    leading: Container(width: 40, height: 40, decoration: BoxDecoration(color: iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: iconColor, size: 20)),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
    subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
    trailing: Switch.adaptive(value: value, onChanged: onChanged),
  );
}

class _ArrowTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title, subtitle;
  final VoidCallback onTap;
  const _ArrowTile({required this.icon, required this.iconColor, required this.title, required this.subtitle, required this.onTap});
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    onTap: onTap,
    leading: Container(width: 40, height: 40, decoration: BoxDecoration(color: iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: iconColor, size: 20)),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
    subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
    trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade400),
  );
}

class _LangOption extends StatelessWidget {
  final String label, flag;
  final Locale locale;
  final Locale? current;
  final ValueChanged<Locale> onSelect;
  const _LangOption({required this.label, required this.flag, required this.locale, required this.current, required this.onSelect});
  @override
  Widget build(BuildContext context) {
    final isSelected = current?.languageCode == locale.languageCode;
    final primary = Theme.of(context).colorScheme.primary;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      onTap: () => onSelect(locale),
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(label, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? primary : null)),
      trailing: isSelected ? Icon(Icons.check_circle_rounded, color: primary, size: 22) : Icon(Icons.radio_button_unchecked, color: Colors.grey.shade400, size: 22),
    );
  }
}

// ── Privacy Policy Screen ──────────────────────────────────────
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) => _LegalScreen(
    title: AppLocalizations.of(context).privacyPolicy,
    icon: Icons.privacy_tip_rounded,
    iconColor: const Color(0xFF4776E6),
    sections: const [
      _LegalSection('Information We Collect', 'We collect information you provide directly to us, such as when you create an account, including your name, email address, and profile photo. We also collect information about your app usage, study sessions, and quiz attempts to provide personalized learning experiences.'),
      _LegalSection('How We Use Your Information', 'We use the information we collect to: provide, maintain, and improve our services; personalize your learning experience; track your study progress and streaks; send you notifications (if enabled); and improve our AI features.'),
      _LegalSection('Data Storage', 'Your data is securely stored using Firebase (Google) and Supabase. Profile images are stored on Cloudinary. We implement industry-standard security measures to protect your personal information.'),
      _LegalSection('Third-Party Services', 'We use Firebase Authentication, Firebase Realtime Database, Supabase (PostgreSQL), and Cloudinary for image storage. These services have their own privacy policies.'),
      _LegalSection('Data Retention', 'We retain your data as long as your account is active. You can request deletion of your account and associated data at any time by contacting us.'),
      _LegalSection('Contact Us', 'If you have any questions about this Privacy Policy, please contact us at raviraj.s.aade@gmail.com'),
    ],
  );
}

// ── Terms & Conditions Screen ──────────────────────────────────
class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) => _LegalScreen(
    title: AppLocalizations.of(context).termsConditions,
    icon: Icons.description_rounded,
    iconColor: const Color(0xFF11998E),
    sections: const [
      _LegalSection('Acceptance of Terms', 'By accessing or using the Navaveda application, you agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use our app.'),
      _LegalSection('Use of Service', 'Navaveda is an educational platform designed to help users prepare for technical interviews and improve their coding skills. You may use the service only for lawful purposes and in accordance with these Terms.'),
      _LegalSection('User Accounts', 'You are responsible for maintaining the confidentiality of your account credentials. You agree to notify us immediately of any unauthorized use of your account.'),
      _LegalSection('Content', 'All study materials, questions, and notes provided through Navaveda are for educational purposes only. The content is owned by Navaveda and may not be reproduced without permission.'),
      _LegalSection('Subscriptions', 'Some features require a paid subscription. Subscription fees are charged in advance. Refunds are subject to our refund policy.'),
      _LegalSection('Limitation of Liability', 'Navaveda shall not be liable for any indirect, incidental, special, or consequential damages resulting from your use of or inability to use the service.'),
      _LegalSection('Changes to Terms', 'We reserve the right to modify these terms at any time. Continued use of the app after changes constitutes acceptance of the new terms.'),
      _LegalSection('Contact', 'For questions about these Terms, contact us at raviraj.s.aade@gmail.com'),
    ],
  );
}

// ── Help & Support Screen ──────────────────────────────────────
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);

    final faqs = [
      _FAQ('How do I change my profile photo?', 'Go to Profile → Settings tab → Edit Profile. Tap on the avatar to select a new photo from your gallery (max 1MB).'),
      _FAQ('How does the study streak work?', 'Your streak increases by 1 for every day you complete at least one study session (minimum 40 seconds). Missing a day resets your streak.'),
      _FAQ('Why is the Quiz button not showing?', 'You need to read the notes for at least 40 seconds before the Quiz button unlocks. This ensures better retention.'),
      // _FAQ('How do I switch the app language?', 'Go to Profile → Settings tab → Settings → Language section. Select English, Marathi, or Hindi.'),
      _FAQ('How is my accuracy percentage calculated?', 'Accuracy = (Correct quiz answers / Total quiz attempts) × 100. It updates after every quiz submission.'),
      // _FAQ('I forgot my password. What do I do?', 'On the Sign In screen, tap "Forgot Password?" and enter your email to receive a reset link.'),
      // _FAQ('How do I enable notifications?', 'Go to Profile → Settings tab → Settings → Notifications toggle. Make sure you allow notification permissions when prompted.'),
    ];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_rounded, color: isDark ? Colors.white : Colors.black87),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: Text(loc.helpSupport, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Contact card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(colors: [Color(0xFF4776E6), Color(0xFF8E54E9)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.support_agent, color: Colors.white, size: 32),
              const SizedBox(height: 10),
              const Text('Need Help?', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('Our support team is here for you.', style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                child: const Text('raviraj.s.aade@gmail.com', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ]),
          ),
          const SizedBox(height: 24),
          Text('Frequently Asked Questions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...faqs.map((faq) => _FAQCard(faq: faq, isDark: isDark)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _FAQ {
  final String question, answer;
  const _FAQ(this.question, this.answer);
}

class _FAQCard extends StatefulWidget {
  final _FAQ faq;
  final bool isDark;
  const _FAQCard({required this.faq, required this.isDark});
  @override
  State<_FAQCard> createState() => _FAQCardState();
}

class _FAQCardState extends State<_FAQCard> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(widget.faq.question, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
              Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey.shade500),
            ]),
            if (_expanded) ...[
              const SizedBox(height: 10),
              Text(widget.faq.answer, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.5)),
            ],
          ]),
        ),
      ),
    );
  }
}

// ── Reusable Legal Screen ──────────────────────────────────────
class _LegalSection {
  final String title, body;
  const _LegalSection(this.title, this.body);
}

class _LegalScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<_LegalSection> sections;
  const _LegalScreen({required this.title, required this.icon, required this.iconColor, required this.sections});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(title, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: iconColor.withOpacity(0.2)),
            ),
            child: Row(children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: iconColor)),
                const SizedBox(height: 2),
                Text('Last updated: March 2025', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ])),
            ]),
          ),
          const SizedBox(height: 20),
          ...sections.map((s) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 8),
              Text(s.body, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.6)),
            ]),
          )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}












//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import 'package:navaveda/design/theme_provider.dart';
// import 'package:navaveda/generated/app_localizations.dart';
//
// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }
//
// class _SettingsScreenState extends State<SettingsScreen> {
//   final Uri privacyUrl = Uri.parse(
//     "https://aaderaviraj.github.io/Navaveda_term_condition/privacy.html",
//   );
//
//   final Uri termsUrl = Uri.parse(
//     "https://aaderaviraj.github.io/Navaveda_term_condition/terms.html",
//   );
//
//   Future<void> _openUrl(Uri url) async {
//     if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
//       throw Exception('Could not launch $url');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final themeProvider = context.watch<ThemeProvider>();
//     final loc = AppLocalizations.of(context);
//
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness:
//       isDark ? Brightness.light : Brightness.dark,
//     ));
//
//     return Scaffold(
//       backgroundColor:
//       isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_rounded,
//               color: isDark ? Colors.white : Colors.black87),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           loc.settings,
//           style: TextStyle(
//             color: isDark ? Colors.white : Colors.black87,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           // ── Appearance ─────────────────────────────
//           _SectionLabel(loc.appearance),
//           _Card(children: [
//             ListTile(
//               leading: const Icon(Icons.dark_mode_rounded),
//               title: Text(loc.darkMode),
//               subtitle: Text(loc.darkModeSubtitle),
//               trailing: Switch(
//                 value: themeProvider.isDarkMode,
//                 onChanged: themeProvider.toggleTheme,
//               ),
//             ),
//           ]),
//
//           const SizedBox(height: 20),
//
//           // ── More ─────────────────────────────
//           _SectionLabel(loc.more),
//           _Card(children: [
//             _ArrowTile(
//               icon: Icons.privacy_tip_rounded,
//               title: loc.privacyPolicy,
//               subtitle: loc.privacyPolicySubtitle,
//               onTap: () => _openUrl(privacyUrl),
//             ),
//             const Divider(height: 1),
//             _ArrowTile(
//               icon: Icons.description_rounded,
//               title: loc.termsConditions,
//               subtitle: loc.termsConditionsSubtitle,
//               onTap: () => _openUrl(termsUrl),
//             ),
//           ]),
//
//           const SizedBox(height: 40),
//
//           Center(
//             child: Text(
//               "Navaveda v1.0.0",
//               style: TextStyle(color: Colors.grey.shade500),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ── UI Helpers ─────────────────────────────
//
// class _SectionLabel extends StatelessWidget {
//   final String text;
//   const _SectionLabel(this.text);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Text(
//         text.toUpperCase(),
//         style: TextStyle(
//           fontSize: 11,
//           fontWeight: FontWeight.bold,
//           color: Colors.grey.shade500,
//         ),
//       ),
//     );
//   }
// }
//
// class _Card extends StatelessWidget {
//   final List<Widget> children;
//   const _Card({required this.children});
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return Container(
//       decoration: BoxDecoration(
//         color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(children: children),
//     );
//   }
// }
//
// class _ArrowTile extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final VoidCallback onTap;
//
//   const _ArrowTile({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Icon(icon),
//       title: Text(title),
//       subtitle: Text(subtitle),
//       trailing: const Icon(Icons.arrow_forward_ios, size: 14),
//       onTap: onTap,
//     );
//   }
// }
