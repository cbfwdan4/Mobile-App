import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/glass_card.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthViewModel>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark 
                  ? [AppTheme.darkBg, AppTheme.primaryColor.withOpacity(0.2)]
                  : [AppTheme.lightBg, AppTheme.primaryColor.withOpacity(0.1)],
              ),
            ),
          ),
          
          // Floating bubbles for dynamic background
          Positioned(
            top: -100,
            right: -100,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            ).animate(onPlay: (controller) => controller.repeat())
             .scale(duration: 5.seconds, curve: Curves.easeInOut)
             .move(duration: 5.seconds, begin: const Offset(0, 0), end: const Offset(-20, 20)),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo and Title
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.graduationCap,
                        size: 60,
                        color: AppTheme.primaryColor,
                      ),
                    ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),
                    
                    const SizedBox(height: 16),
                    Text(
                      'Campus Connect',
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppTheme.darkBg,
                      ),
                    ).animate().slideY(begin: 0.3, duration: 600.ms).fadeIn(),
                    
                    const SizedBox(height: 8),
                    Text(
                      _isSignUp ? 'Join our community today' : 'Welcome back, student!',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ).animate().fadeIn(delay: 400.ms),
                    
                    const SizedBox(height: 48),

                    // Glassmorphic Form
                    GlassCard(
                      height: _isSignUp ? 440 : 380,
                      width: double.infinity,
                      borderRadius: 32,
                      opacity: 0.1,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            _buildInputField(
                              controller: _emailController,
                              label: 'Email Address',
                              icon: FontAwesomeIcons.envelope,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 20),
                            _buildInputField(
                              controller: _passwordController,
                              label: 'Password',
                              icon: FontAwesomeIcons.lock,
                              isDark: isDark,
                              isPassword: true,
                              isPasswordVisible: _isPasswordVisible,
                              onToggleVisibility: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                            ),
                            const SizedBox(height: 32),
                            
                            if (authVm.isLoading)
                              const CircularProgressIndicator()
                            else
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 18),
                                    backgroundColor: AppTheme.primaryColor,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    elevation: 8,
                                    shadowColor: AppTheme.primaryColor.withOpacity(0.4),
                                  ),
                                  onPressed: () async {
                                    bool success = _isSignUp
                                        ? await authVm.signUp(_emailController.text, _passwordController.text)
                                        : await authVm.signIn(_emailController.text, _passwordController.text);
                                    if (success && context.mounted) {
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                                    } else if (authVm.errorMessage != null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.redAccent,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          content: Text(authVm.errorMessage!),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    _isSignUp ? 'Create Account' : 'Sign In',
                                    style: GoogleFonts.outfit(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ).animate().shimmer(delay: 1.seconds, duration: 1.5.seconds),
                              
                            const Spacer(),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _isSignUp ? 'Joined already?' : 'New here?',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                TextButton(
                                  onPressed: () => setState(() => _isSignUp = !_isSignUp),
                                  child: Text(
                                    _isSignUp ? 'Sign In' : 'Create Account',
                                    style: const TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),
                    
                    const SizedBox(height: 24),
                    
                    // Social Login Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.withOpacity(0.3))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('OR CONNECT WITH', style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                        ),
                        Expanded(child: Divider(color: Colors.grey.withOpacity(0.3))),
                      ],
                    ).animate().fadeIn(delay: 800.ms),
                    
                    const SizedBox(height: 24),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _socialButton(FontAwesomeIcons.google, Colors.redAccent),
                        _socialButton(FontAwesomeIcons.apple, isDark ? Colors.white : Colors.black),
                        _socialButton(FontAwesomeIcons.facebook, Colors.blueAccent),
                      ],
                    ).animate().fadeIn(delay: 1.seconds),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword && !isPasswordVisible,
          style: TextStyle(color: isDark ? Colors.white : AppTheme.darkBg),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: AppTheme.primaryColor),
            suffixIcon: isPassword 
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                    size: 18,
                    color: Colors.grey,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
            filled: true,
            fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
            hintText: 'Enter your ${label.toLowerCase()}',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _socialButton(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark 
          ? Colors.white.withOpacity(0.05) 
          : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: FaIcon(icon, color: color, size: 24),
    );
  }
}
