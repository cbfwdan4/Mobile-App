import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/event.dart';
import '../viewmodels/event_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../theme/app_theme.dart';
import 'dart:io';

class AddEventScreen extends StatefulWidget {
  final Event? event;
  AddEventScreen({this.event});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  File? _image;
  Position? _currentLocation;

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _titleController.text = widget.event!.title;
      _descriptionController.text = widget.event!.description;
      _selectedDate = widget.event!.date;
      if (widget.event!.imageUrl.isNotEmpty && !widget.event!.imageUrl.startsWith('http')) {
        _image = File(widget.event!.imageUrl);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventVm = Provider.of<EventViewModel>(context, listen: false);
    final userId = Provider.of<AuthViewModel>(context, listen: false).user?.uid ?? '';
    final bool isEditing = widget.event != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Event' : 'Create New Event',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('EVENT DETAILS', isDark),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _titleController,
              label: 'Event Title',
              icon: FontAwesomeIcons.heading,
              isDark: isDark,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _descriptionController,
              label: 'Description',
              icon: FontAwesomeIcons.alignLeft,
              isDark: isDark,
              maxLines: 4,
            ),
            const SizedBox(height: 32),
            
            _buildSectionTitle('DATE & LOCATION', isDark),
            const SizedBox(height: 16),
            _buildPickerTile(
              label: 'Event Date',
              value: _formatDate(_selectedDate),
              icon: FontAwesomeIcons.calendarDay,
              isDark: isDark,
              onTap: _pickDate,
            ),
            const SizedBox(height: 12),
            _buildPickerTile(
              label: 'Location',
              value: _currentLocation != null 
                ? 'Location Captured' 
                : (widget.event?.latitude != null ? 'Location Saved' : 'No Location Set'),
              icon: FontAwesomeIcons.locationDot,
              isDark: isDark,
              onTap: _getCurrentLocation,
            ),
            
            const SizedBox(height: 32),
            _buildSectionTitle('ATTACH MEDIA', isDark),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  image: _image != null 
                    ? DecorationImage(image: FileImage(_image!), fit: BoxFit.cover) 
                    : null,
                ),
                child: _image == null 
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FaIcon(FontAwesomeIcons.camera, size: 40, color: AppTheme.primaryColor),
                        const SizedBox(height: 12),
                        Text('Tap to take or pick photo', style: GoogleFonts.outfit(color: Colors.grey)),
                      ],
                    )
                  : const SizedBox.shrink(),
              ),
            ),
            
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 5,
                  shadowColor: AppTheme.primaryColor.withOpacity(0.4),
                ),
                onPressed: () async {
                  if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
                    _showSnackBar('Please fill all required fields');
                    return;
                  }

                  final updatedEvent = Event(
                    id: isEditing ? widget.event!.id : DateTime.now().millisecondsSinceEpoch.toString(),
                    title: _titleController.text,
                    description: _descriptionController.text,
                    date: _selectedDate,
                    imageUrl: _image?.path ?? (isEditing ? widget.event!.imageUrl : ''),
                    latitude: _currentLocation?.latitude ?? (isEditing ? widget.event!.latitude : null),
                    longitude: _currentLocation?.longitude ?? (isEditing ? widget.event!.longitude : null),
                    createdBy: userId,
                    likes: isEditing ? widget.event!.likes : [],
                    comments: isEditing ? widget.event!.comments : [],
                  );

                  if (isEditing) {
                    await eventVm.updateEvent(updatedEvent);
                  } else {
                    await eventVm.addEvent(updatedEvent);
                  }
                  if (mounted) Navigator.pop(context);
                },
                child: Text(
                  isEditing ? 'Update Changes' : 'Publish Event',
                  style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ).animate().shimmer(delay: 1.seconds),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.outfit(color: isDark ? Colors.white : AppTheme.darkBg),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.outfit(color: Colors.grey),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FaIcon(icon, size: 18, color: AppTheme.primaryColor),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.transparent,
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.05);
  }

  Widget _buildPickerTile({
    required String label,
    required String value,
    required IconData icon,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: FaIcon(icon, size: 16, color: AppTheme.primaryColor),
        ),
        title: Text(label, style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
        subtitle: Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppTheme.darkBg,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    ).animate().fadeIn().slideX(begin: 0.05);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      final position = await Geolocator.getCurrentPosition();
      setState(() => _currentLocation = position);
      _showSnackBar('Location Captured Successfully!');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.outfit()),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppTheme.primaryColor,
      )
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}
