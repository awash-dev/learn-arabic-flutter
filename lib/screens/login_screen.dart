import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/storage.dart';
import 'home_screen.dart';

// Default password set in the app
const String _defaultPassword = 'hamazuka@kalid2025';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final password = _passwordController.text.trim();

    if (password.isEmpty) {
      setState(() {
        _loading = false;
        _errorMessage = 'Please enter your password.';
      });
      return;
    }

    if (password != _defaultPassword) {
      setState(() {
        _loading = false;
        _errorMessage = 'Incorrect password. Please try again.';
      });
      return;
    }

    // Phone number is optional — no validation needed
    await Storage.setLoggedIn(true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFF0a1912),
      resizeToAvoidBottomInset: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Full-screen background image ──────────────────────────
            Positioned.fill(
              child: Image.asset(
                'assets/images/login.jpg',
                fit: BoxFit.cover,
                alignment: Alignment.center,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFF0a1912),
                  child: const Center(
                    child: Icon(Icons.menu_book_rounded,
                        color: Color(0xFFD4AF37), size: 80),
                  ),
                ),
              ),
            ),

            // ── Gradient overlay ──────────────────────────────────────
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.55, 1.0],
                    colors: [
                      Color(0x00000000),
                      Color(0x22000000),
                      Color(0xBB000000),
                    ],
                  ),
                ),
              ),
            ),

            // ── Scrollable form ───────────────────────────────────────
            Positioned.fill(
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: bottomInset + 16),
                  child: SizedBox(
                    height: size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(height: 8),
                        const SizedBox(height: 28),


                        // ── Form card ─────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 48),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                            decoration: BoxDecoration(
                              color: const Color(0xCC000000),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: const Color(0xAAD4AF37),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // ── Phone number (optional) ──
                                _buildLabel('Phone Number (Optional)'),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                  decoration: _inputDecoration(
                                    hint: 'Enter any phone number',
                                    icon: Icons.phone_outlined,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // ── Password (required) ──
                                _buildLabel('Password'),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  onSubmitted: (_) => _handleLogin(),
                                  decoration: _inputDecoration(
                                    hint: 'Enter password',
                                    icon: Icons.lock_outline_rounded,
                                  ).copyWith(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: const Color(0x99D4AF37),
                                        size: 20,
                                      ),
                                      onPressed: () => setState(() =>
                                          _obscurePassword = !_obscurePassword),
                                    ),
                                  ),
                                ),

                                // ── Error message ──
                                if (_errorMessage != null) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    _errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFFFF6B6B),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],

                                const SizedBox(height: 16),

                                // ── Login button ──
                                SizedBox(
                                  height: 52,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFFD4AF37),
                                      foregroundColor:
                                          const Color(0xFF0a1912),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                      elevation: 4,
                                      shadowColor: const Color(0x60D4AF37),
                                    ),
                                    onPressed: _loading ? null : _handleLogin,
                                    child: _loading
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              color: Color(0xFF0a1912),
                                            ),
                                          )
                                        : const Text(
                                            'Login',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.8,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xCCD4AF37),
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0x55FFFFFF), fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0x99D4AF37), size: 20),
      filled: true,
      fillColor: const Color(0xFF1a1a1a),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0x33D4AF37), width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0x44D4AF37), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 1.6),
      ),
    );
  }
}