import 'package:devlearn/data/models/user.dart';
import 'package:devlearn/data/repositories/auth_repository.dart';
import 'package:devlearn/main.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback onLogout;

  const ProfilePage({super.key, required this.onLogout});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = authRepository.getProfile();
  }

  Future<void> _logout() async {
    // TODO: Show confirmation dialog before logging out
    await authRepository.logout();
    widget.onLogout();
  }

  Future<void> _refreshProfile() async {
    setState(() {
      _userFuture = authRepository.getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.grey.shade100,
      body: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Không thể tải hồ sơ.'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _refreshProfile,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Thử lại'),
                  )
                ],
              ),
            );
          }

          final user = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refreshProfile,
            child: CustomScrollView(
              slivers: [
                _buildHeader(context, user),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildStatsSection(context, user),
                        const SizedBox(height: 24),
                        _buildOptionsSection(context),
                        const SizedBox(height: 24),
                        _buildLogoutButton(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, User user) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return SliverAppBar(
      expandedHeight: 240.0,
      pinned: true,
      backgroundColor: theme.primaryColor,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Cover Image
            Container(
              color: theme.primaryColor.withOpacity(0.8),
              // TODO: Add a real cover image
            ),
            // Profile Info
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                    child: user.avatarUrl == null
                        ? Icon(Icons.person, size: 45, color: theme.primaryColor)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.username,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(user.email, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: Colors.white),
          onPressed: () {
            // TODO: Navigate to Edit Profile Screen
          },
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context, User user) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200, width: 1),
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(label: 'Đã giải', value: user.solvedCount.toString()),
              const VerticalDivider(),
              _StatItem(label: 'Bài viết', value: user.postCount.toString()),
              const VerticalDivider(),
              _StatItem(label: 'Theo dõi', value: user.followerCount.toString()),
            ],
          ),
        ));
  }

  Widget _buildOptionsSection(BuildContext context) {
    return _buildSectionCard(
      context,
      [
        _OptionItem(icon: Icons.article_outlined, title: 'Bài viết của tôi', onTap: () {}),
        _OptionItem(icon: Icons.bookmark_border_rounded, title: 'Đã lưu', onTap: () {}),
        _OptionItem(icon: Icons.settings_outlined, title: 'Cài đặt', onTap: () {}),
        _OptionItem(icon: Icons.info_outline_rounded, title: 'Về chúng tôi', onTap: () {}),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _logout,
      icon: const Icon(Icons.logout_rounded),
      label: const Text('Đăng xuất'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.red,
        backgroundColor: Colors.red.withOpacity(0.1),
        elevation: 0,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, List<Widget> children) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200, width: 1),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
      ],
    );
  }
}

class _OptionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _OptionItem({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey.shade600, size: 22),
              const SizedBox(width: 16),
              Expanded(child: Text(title, style: const TextStyle(fontSize: 15))),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
