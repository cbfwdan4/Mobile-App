import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/glass_card.dart';
import '../viewmodels/quote_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/theme_viewmodel.dart';
import '../theme/app_theme.dart';
import 'event_list_screen.dart';
import 'profile_screen.dart';
import 'add_event_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final quoteVm = Provider.of<QuoteViewModel>(context);
    final authVm = Provider.of<AuthViewModel>(context);
    final themeVm = Provider.of<ThemeViewModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark 
                  ? [AppTheme.darkBg, AppTheme.darkSurface]
                  : [AppTheme.lightBg, Colors.white],
              ),
            ),
          ),
          
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // Modern App Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, Student 👋',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Campus Connect',
                              style: GoogleFonts.outfit(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : AppTheme.darkBg,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                              onPressed: () => themeVm.toggleTheme(!isDark),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen())),
                              child: CircleAvatar(
                                radius: 24,
                                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                                child: const FaIcon(FontAwesomeIcons.user, color: AppTheme.primaryColor, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn().slideY(begin: -0.2),
                ),

                // Featured Quote Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: _buildQuoteCard(quoteVm, isDark),
                  ).animate().fadeIn(delay: 200.ms).scale(curve: Curves.easeOutBack),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),

                // Quick Actions Title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Quick Actions',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppTheme.darkBg,
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Grid Actions
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  sliver: SliverGrid.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      _buildActionCard(
                        'Events',
                        FontAwesomeIcons.calendarDay,
                        AppTheme.primaryColor,
                        () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventListScreen())),
                        isDark,
                      ),
                      _buildActionCard(
                        'New Event',
                        FontAwesomeIcons.plus,
                        AppTheme.secondaryColor,
                        () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddEventScreen())),
                        isDark,
                      ),
                      _buildActionCard(
                        'Profile',
                        FontAwesomeIcons.userGraduate,
                        Colors.orange,
                        () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen())),
                        isDark,
                      ),
                      _buildActionCard(
                        'Explore',
                        FontAwesomeIcons.compass,
                        Colors.teal,
                        () {},
                        isDark,
                      ),
                    ],
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(isDark),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddEventScreen())),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ).animate().scale(delay: 1.seconds),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildQuoteCard(QuoteViewModel quoteVm, bool isDark) {
    return GlassCard(
      height: 200,
      width: double.infinity,
      borderRadius: 32,
      opacity: 0.1,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.quoteLeft, color: AppTheme.primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'DAILY INSPIRATION',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 18),
                  onPressed: () => quoteVm.loadRandomQuote(),
                ),
              ],
            ),
            const Spacer(),
            if (quoteVm.isLoading)
              const CircularProgressIndicator()
            else if (quoteVm.errorMessage != null)
              const Text('Failed to load quote')
            else
              Text(
                '"${quoteVm.currentQuote?.text ?? ''}"',
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  color: isDark ? Colors.white : AppTheme.darkBg,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              '- ${quoteVm.currentQuote?.author ?? 'Unknown'}',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: FaIcon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppTheme.darkBg,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(bool isDark) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(FontAwesomeIcons.house, 0),
            _navItem(FontAwesomeIcons.calendarDay, 1),
            const SizedBox(width: 40),
            _navItem(FontAwesomeIcons.magnifyingGlass, 2),
            _navItem(FontAwesomeIcons.user, 3),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    return IconButton(
      icon: FaIcon(
        icon,
        color: isSelected ? AppTheme.primaryColor : Colors.grey,
        size: 20,
      ),
      onPressed: () => setState(() => _currentIndex = index),
    );
  }
}
