// ============================================================
// File     : lib/features/profile/widgets/settings_tab.dart
// ============================================================

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:realeyes/features/profile/providers/profile_provider.dart';
import 'package:realeyes/features/profile/screens/settings_screen.dart';
import 'package:realeyes/features/profile/screens/subscription_screen.dart';
import 'package:realeyes/screens/signin_screen.dart';
import 'package:realeyes/screens/about_us_screen.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel('Account'),
          const SizedBox(height: 12),
          _SettingsListTile(
            icon: Icons.edit_rounded,
            iconColor: const Color(0xFF4776E6),
            label: 'Edit Profile',
            subtitle: 'Change name & photo',
            onTap: () => _showEditProfileSheet(context),
          ),
          // _SettingsListTile(
          //   icon: Icons.workspace_premium_rounded,
          //   iconColor: const Color(0xFFF7971E),
          //   label: 'Subscription',
          //   subtitle: 'Manage your plan',
          //   onTap: () => Navigator.push(context,
          //        MaterialPageRoute(builder: (_) => const SubscriptionScreen())),
          // ),
          const SizedBox(height: 24),
          _SectionLabel('App'),
          const SizedBox(height: 12),
          _SettingsListTile(
            icon: Icons.settings_rounded,
            iconColor: const Color(0xFF11998E),
            label: 'Settings',
            subtitle: 'Theme, language & more',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
          _SettingsListTile(
            icon: Icons.people_rounded,
            iconColor: const Color(0xFF8E54E9),
            label: 'About Us',
            subtitle: 'Meet the dream team',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AboutUsScreen())),
          ),
          _SettingsListTile(
            icon: Icons.share_rounded,
            iconColor: const Color(0xFF0466C8),
            label: 'Share App',
            subtitle: 'Invite friends to Realeye',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share feature coming soon!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          _SectionLabel('Danger Zone'),
          const SizedBox(height: 12),
          _SettingsListTile(
            icon: Icons.logout_rounded,
            iconColor: const Color(0xFFE53E3E),
            label: 'Log Out',
            subtitle: 'Sign out of your account',
            onTap: () => _confirmLogout(context),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<ProfileProvider>(),
        child: _EditProfileSheet(),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => SignInScreen()),
                  (_) => false,
                );
              }
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ── Section Label ──────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }
}

// ── Settings List Tile ─────────────────────────────────────────
class _SettingsListTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsListTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        onTap: onTap,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Text(subtitle,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
        trailing: Icon(Icons.arrow_forward_ios_rounded,
            size: 14, color: Colors.grey.shade400),
      ),
    );
  }
}

// ── Edit Profile Bottom Sheet ──────────────────────────────────
class _EditProfileSheet extends StatefulWidget {
  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  final _picker = ImagePicker();
  File? _imageFile;
  late TextEditingController _nameController;
  bool _isUploading = false;
  bool _isModified = false;

  @override
  void initState() {
    super.initState();
    final provider = context.read<ProfileProvider>();
    _nameController = TextEditingController(text: provider.userName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    if (bytes.length / (1024 * 1024) > 1) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image must be under 1MB')));
      }
      return;
    }
    setState(() {
      _imageFile = File(picked.path);
      _isModified = true;
    });
  }

  Future<void> _save() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    setState(() => _isUploading = true);
    try {
      String? imageUrl;
      if (_imageFile != null) {
        final uri = Uri.parse('https://realeye.onrender.com/api/upload-profile');
        final request = http.MultipartRequest('POST', uri)
          ..files.add(await http.MultipartFile.fromPath('image', _imageFile!.path))
          ..fields['user_id'] = user.uid;
        final response = await request.send();
        final respStr = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          final data = jsonDecode(respStr);
          imageUrl = data['secure_url'];
        }
      }
      final updates = <String, dynamic>{};
      final name = _nameController.text.trim();
      if (name.isNotEmpty) updates['full_name'] = name;
      if (imageUrl != null) updates['profile_image'] = imageUrl;
      await FirebaseDatabase.instance.ref().child('users').child(user.uid).update(updates);
      if (mounted) {
        final provider = context.read<ProfileProvider>();
        if (name.isNotEmpty) provider.updateName(name);
        if (imageUrl != null) provider.updateProfileImage(imageUrl);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<ProfileProvider>();
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Edit Profile',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!) as ImageProvider
                        : (provider.profileImageUrl != null
                            ? NetworkImage(provider.profileImageUrl!)
                            : const AssetImage('assets/images/angryp_cricle.png')),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onChanged: (_) => setState(() => _isModified = true),
          ),
          const SizedBox(height: 24),
          _isUploading
              ? const Center(child: CircularProgressIndicator())
              : Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isModified ? _save : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Save Changes'),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

// ── About Us Screen ────────────────────────────────────────────
// class AboutUsScreen extends StatelessWidget {
//   const AboutUsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: isDark
//                 ? [Colors.indigo.shade900, Colors.purple.shade900]
//                 : [Colors.blue.shade50, Colors.purple.shade50],
//           ),
//         ),
//         child: CustomScrollView(
//           slivers: [
//             SliverAppBar(
//               title: const Text('Dream Team'),
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               pinned: true,
//             ),
//             SliverList(
//               delegate: SliverChildListDelegate([
//                 _TeamCard(name: 'Pooja Borgavi', role: 'AI / ML Engineer', image: 'assets/images/pooja2.jpg', color: Colors.pink, info: 'Training Models • Creative Visionary • ML', quote: '"Design is intelligence made visible"'),
//                 _TeamCard(name: 'Vikaskumar Chaurasiya', role: 'Python Developer & QA Analyst', image: 'assets/images/vikas.jpg', color: Colors.blueAccent, info: 'Bug Hunter Extraordinaire • Quality Guardian • Testing Maestro', quote: '"Quality is not an act, it\'s a habit"'),
//                 _TeamCard(name: 'Raviraj Aade', role: 'Flutter Developer', image: 'assets/images/raviraj2.png', color: Colors.purple, info: 'Code Architect • Server Wizard • Database', quote: '"First solve the problem, then write the code"'),
//                 const SizedBox(height: 30),
//               ]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class _TeamCard extends StatelessWidget {
  final String name, role, image, info, quote;
  final Color color;
  const _TeamCard({required this.name, required this.role, required this.image, required this.color, required this.info, required this.quote});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
            colors: [color.withOpacity(0.15), color.withOpacity(0.3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 20, spreadRadius: 4)],
      ),
      child: Column(
        children: [
          CircleAvatar(radius: 48, backgroundImage: AssetImage(image), backgroundColor: Colors.white),
          const SizedBox(height: 14),
          Text(name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          Text(role, style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyMedium?.color, fontStyle: FontStyle.italic)),
          const SizedBox(height: 12),
          Divider(color: color.withOpacity(0.3)),
          const SizedBox(height: 12),
          Text(info, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyLarge?.color, height: 1.6)),
          const SizedBox(height: 10),
          Text(quote, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: color, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}
