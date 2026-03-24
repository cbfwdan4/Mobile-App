import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/event.dart';
import '../viewmodels/event_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../theme/app_theme.dart';

class CommentScreen extends StatefulWidget {
  final Event event;
  CommentScreen({required this.event});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final eventVm = Provider.of<EventViewModel>(context);
    final user = Provider.of<AuthViewModel>(context).user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final currentEvent = eventVm.events.firstWhere((e) => e.id == widget.event.id, orElse: () => widget.event);

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: AppBar(
        title: Column(
          children: [
            Text('Discussion', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            Text(currentEvent.title, style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: currentEvent.comments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FaIcon(FontAwesomeIcons.comments, size: 60, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text('Be the first to comment!', style: GoogleFonts.outfit(color: Colors.grey, fontSize: 18)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: currentEvent.comments.length,
                    itemBuilder: (context, index) {
                      final comment = currentEvent.comments[index];
                      final isMe = comment.userId == user?.uid;
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isMe ? AppTheme.primaryColor.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: FaIcon(
                                isMe ? FontAwesomeIcons.userLarge : FontAwesomeIcons.user,
                                size: 20,
                                color: isMe ? AppTheme.primaryColor : Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        comment.userName.split('@')[0],
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: isDark ? Colors.white : AppTheme.darkBg,
                                        ),
                                      ),
                                      Text(
                                        _formatTime(comment.timestamp),
                                        style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppTheme.darkSurface : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5)),
                                      ],
                                    ),
                                    child: Text(
                                      comment.text,
                                      style: GoogleFonts.outfit(
                                        fontSize: 15,
                                        color: isDark ? Colors.white70 : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn().slideY(begin: 0.1);
                    },
                  ),
          ),
          
          // Custom Bottom Input Bar
          Container(
            padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkSurface : Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5)),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _commentController,
                      style: GoogleFonts.outfit(fontSize: 15),
                      decoration: InputDecoration(
                        hintText: 'Share your thoughts...',
                        hintStyle: GoogleFonts.outfit(color: Colors.grey, fontSize: 15),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () async {
                    if (_commentController.text.isEmpty) return;
                    final comment = Comment(
                      userId: user!.uid,
                      userName: user.email ?? 'Student',
                      text: _commentController.text,
                      timestamp: DateTime.now(),
                    );
                    await eventVm.addComment(currentEvent.id, comment);
                    _commentController.clear();
                    if (mounted) FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: FaIcon(FontAwesomeIcons.paperPlane, color: Colors.white, size: 18),
                    ),
                  ),
                ).animate().scale(delay: 200.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'just now';
  }
}
