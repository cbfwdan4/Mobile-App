import 'package:flutter/material.dart';
import '../services/event_service.dart';
import '../models/event.dart';

class EventViewModel extends ChangeNotifier {
  final EventService _eventService = EventService();
  List<Event> _events = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void listenToEvents() {
    _eventService.getEvents().listen((eventList) {
      if (eventList.isEmpty) {
        // Fallback fake events for a rich experience
        _events = [
          Event(
            id: '1',
            title: '🎓 Welcome to Campus Connect!',
            description: 'Start by exploring with your student community.',
            date: DateTime.now(),
            createdBy: 'system',
          ),
          Event(
            id: '2',
            title: '📢 Graduation Gala 2026',
            description: 'Celebrate the journey with the Class of 2026.',
            date: DateTime.now().add(const Duration(days: 30)),
            createdBy: 'system',
          ),
          Event(
            id: '3',
            title: '🏀 Inter-House Sports Competition',
            description: 'Major sports meet at the university main field.',
            date: DateTime.now().add(const Duration(days: 15)),
            createdBy: 'system',
          ),
        ];
      } else {
        _events = eventList;
      }
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    }, onError: (error) {
      _isLoading = false;
      _errorMessage = error.toString();
      notifyListeners();
    });
  }

  Future<void> addEvent(Event event) async {
    try {
      await _eventService.addEvent(event);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleLike(String eventId, String userId) async {
    await _eventService.toggleLike(eventId, userId);
  }

  Future<void> addComment(String eventId, Comment comment) async {
    await _eventService.addComment(eventId, comment);
  }

  // Enhancement: Update/Delete logic in ViewModel
  Future<void> updateEvent(Event event) async {
    try {
      await _eventService.updateEvent(event);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _eventService.deleteEvent(eventId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
