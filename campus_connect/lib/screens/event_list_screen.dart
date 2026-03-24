import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../viewmodels/event_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../theme/app_theme.dart';
import 'add_event_screen.dart';
import 'comment_screen.dart';

class EventListScreen extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<EventViewModel>(context, listen: false).listenToEvents();
  }

  @override
  Widget build(BuildContext context) {
    final eventVm = Provider.of<EventViewModel>(context);
    final userId = Provider.of<AuthViewModel>(context, listen: false).user?.uid ?? '';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredEvents = eventVm.events
        .where((event) => event.title.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                          event.description.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with Search Integration
          SliverAppBar(
            expandedHeight: 180,
            floating: true,
            pinned: true,
            backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Explore Events',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.darkBg,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.1),
                      isDark ? AppTheme.darkBg : AppTheme.lightBg,
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.circlePlus, size: 20),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddEventScreen())),
              ),
            ],
          ),

          // Search Bar Sliver
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search campus events...',
                    hintStyle: GoogleFonts.outfit(color: Colors.grey, fontSize: 16),
                    prefixIcon: const Icon(Icons.search, color: AppTheme.primaryColor),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ).animate().fadeIn().slideY(begin: 0.2),
            ),
          ),

          // Event List
          if (eventVm.isLoading)
            const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
          else if (eventVm.errorMessage != null)
            SliverFillRemaining(child: Center(child: Text(eventVm.errorMessage!)))
          else if (filteredEvents.isEmpty)
            SliverFillRemaining(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 60, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('No events found', style: GoogleFonts.outfit(fontSize: 20, color: Colors.grey)),
                ],
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final event = filteredEvents[index];
                    final isCreator = event.createdBy == userId;
                    final hasLiked = event.likes.contains(userId);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.darkSurface : Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        border: Border.all(
                          color: isDark ? Colors.white.withOpacity(0.05) : Colors.transparent,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'UPCOMING',
                                  style: GoogleFonts.outfit(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              if (isCreator)
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const FaIcon(FontAwesomeIcons.penToSquare, size: 16, color: Colors.blue),
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => AddEventScreen(event: event)),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const FaIcon(FontAwesomeIcons.trash, size: 16, color: Colors.red),
                                      onPressed: () => _confirmDelete(context, eventVm, event.id),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            event.title,
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppTheme.darkBg,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            event.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const FaIcon(FontAwesomeIcons.clock, size: 14, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                _formatDate(event.date),
                                style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Divider(height: 1),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _interactionButton(
                                icon: hasLiked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                                label: '${event.likes.length}',
                                color: hasLiked ? Colors.red : Colors.grey,
                                onTap: () => eventVm.toggleLike(event.id, userId),
                              ),
                              _interactionButton(
                                icon: FontAwesomeIcons.commentDots,
                                label: '${event.comments.length}',
                                color: Colors.blueAccent,
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CommentScreen(event: event))),
                              ),
                              _interactionButton(
                                icon: FontAwesomeIcons.shareFromSquare,
                                label: 'Share',
                                color: Colors.teal,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ).animate().fadeIn().slideY(begin: 0.1);
                  },
                  childCount: filteredEvents.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddEventScreen())),
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Post Event', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white)),
      ).animate().scale(delay: 500.ms),
    );
  }

  Widget _interactionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            FaIcon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, EventViewModel eventVm, String eventId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text('Delete Event', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete this event?', style: GoogleFonts.outfit()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: GoogleFonts.outfit(color: Colors.grey))),
          TextButton(
            onPressed: () async {
              await eventVm.deleteEvent(eventId);
              Navigator.pop(context);
            },
            child: Text('Delete', style: GoogleFonts.outfit(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}nd ${[
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ][date.month - 1]} ${date.year}';
}
