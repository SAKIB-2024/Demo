import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';
import 'models.dart';
import 'my_list.dart';
import 'my_collection.dart';
import 'homepage.dart';

// ─────────────────────────────────────────────────────────────
// LoginScreen  (standalone – used from SplashScreen if not logged in)
// ─────────────────────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const Color primaryColor = Color(0xFF381932);
  static const Color backgroundColor = Color(0xFFF0EDE9);

  bool _isLogin = true;
  bool _loading = false;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePass = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      if (_isLogin) {
        final res = await SupabaseService.signIn(_emailCtrl.text.trim(), _passCtrl.text);
        if (res.user != null && mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
        }
      } else {
        final res = await SupabaseService.signUp(
          _emailCtrl.text.trim(),
          _passCtrl.text,
          fullName: _nameCtrl.text.trim(),
        );
        if (res.user != null && mounted) {
          // Create profile row
          await SupabaseService.upsertProfile({
            'id': res.user!.id,
            'full_name': _nameCtrl.text.trim(),
            'email': _emailCtrl.text.trim(),
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created! Please check your email to confirm, then log in.'),
              backgroundColor: Colors.green,
            ),
          );
          setState(() => _isLogin = true);
        }
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message), backgroundColor: Colors.red));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), shape: BoxShape.circle),
                    child: Icon(Icons.home_work, size: 44, color: primaryColor),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    _isLogin ? 'Welcome Back' : 'Create Account',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    _isLogin ? 'Sign in to your account' : 'Join RentalApp today',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  ),
                ),
                const SizedBox(height: 40),

                if (!_isLogin) ...[
                  _label('Full Name'),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: _inputDec('Enter your full name', Icons.person_outline),
                    validator: (v) => (v == null || v.isEmpty) ? 'Name is required' : null,
                  ),
                  const SizedBox(height: 16),
                ],

                _label('Email Address'),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDec('Enter your email', Icons.email_outlined),
                  validator: (v) => (v == null || !v.contains('@')) ? 'Valid email required' : null,
                ),
                const SizedBox(height: 16),

                _label('Password'),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscurePass,
                  decoration: _inputDec('Enter password', Icons.lock_outline).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePass ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePass = !_obscurePass),
                    ),
                  ),
                  validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null,
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _loading
                        ? const SizedBox(height: 22, width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)))
                        : Text(_isLogin ? 'Log In' : 'Create Account',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),

                Center(
                  child: GestureDetector(
                    onTap: () => setState(() => _isLogin = !_isLogin),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 15, color: Colors.black87),
                        children: [
                          TextSpan(text: _isLogin ? "Don't have an account? " : 'Already have an account? '),
                          TextSpan(
                            text: _isLogin ? 'Register' : 'Log In',
                            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
  );

  InputDecoration _inputDec(String hint, IconData icon) => InputDecoration(
    hintText: hint,
    prefixIcon: Icon(icon, color: Colors.grey),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF381932), width: 1.5)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
  );
}

// ─────────────────────────────────────────────────────────────
// ProfileWrapper – decides between login / profile based on auth state
// ─────────────────────────────────────────────────────────────
class ProfileWrapper extends StatelessWidget {
  const ProfileWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return user != null ? const ProfileScreen() : const LoginScreen();
  }
}

// ─────────────────────────────────────────────────────────────
// ProfileScreen
// ─────────────────────────────────────────────────────────────
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color primaryColor = Color(0xFF381932);
  static const Color backgroundColor = Color(0xFFF0EDE9);

  AppUser? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final uid = SupabaseService.currentUserId;
    final email = SupabaseService.currentUser?.email ?? '';
    if (uid == null) return;
    try {
      final profile = await SupabaseService.fetchProfile(uid);
      if (profile != null && mounted) {
        setState(() {
          _user = AppUser.fromMap(uid, email, profile);
          _loading = false;
        });
      } else {
        // Profile row might not exist yet
        setState(() {
          _user = AppUser(id: uid, email: email, fullName: email.split('@')[0]);
          _loading = false;
        });
      }
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    await SupabaseService.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Profile'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout, tooltip: 'Logout'),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: (_user?.avatarUrl != null && _user!.avatarUrl!.isNotEmpty)
                        ? NetworkImage(_user!.avatarUrl!)
                        : null,
                    backgroundColor: primaryColor.withOpacity(0.2),
                    child: (_user?.avatarUrl == null || _user!.avatarUrl!.isEmpty)
                        ? const Icon(Icons.person, size: 60, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(_user?.fullName ?? 'User',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(_user?.email ?? '',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                  const SizedBox(height: 16),

                  // Wallet + Points row
                  Row(
                    children: [
                      _statCard('Wallet', '৳${_user?.walletBalance.toStringAsFixed(0) ?? '0'}', Icons.account_balance_wallet, Colors.green),
                      const SizedBox(width: 12),
                      _statCard('Points', '${_user?.rewardPoints ?? 0}', Icons.star, Colors.amber),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // My List & My Collections
                  Row(
                    children: [
                      Expanded(child: _ProfileCard(
                        title: 'My Listings',
                        subtitle: 'Items you offer for rent',
                        icon: Icons.list_alt,
                        color: Colors.blue,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyListPage())),
                      )),
                      const SizedBox(width: 16),
                      Expanded(child: _ProfileCard(
                        title: 'My Rentals',
                        subtitle: 'Items you rented',
                        icon: Icons.favorite,
                        color: Colors.pink,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyCollectionPage())),
                      )),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _MenuItem(icon: Icons.settings, title: 'Settings', onTap: () {}),
                  const Divider(),
                  _MenuItem(icon: Icons.account_box, title: 'Account', onTap: () {}),
                  const Divider(),
                  _MenuItem(
                    icon: Icons.logout,
                    title: 'Log Out',
                    onTap: _logout,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          ]),
        ]),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ProfileCard({required this.title, required this.subtitle, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ]),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;
  const _MenuItem({required this.icon, required this.title, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
