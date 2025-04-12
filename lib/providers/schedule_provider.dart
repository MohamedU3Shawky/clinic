import 'package:flutter/material.dart';
import '../screens/schedule/model/schedule_model.dart';

class ScheduleProvider extends ChangeNotifier {
  List<ScheduleModel> _schedules = [];
  bool _isLoading = false;
  String? _error;

  List<ScheduleModel> get schedules => _schedules;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSchedules() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement API call to fetch schedules
      // For now, using dummy data
      await Future.delayed(const Duration(seconds: 1));
      _schedules = [
        ScheduleModel(
          id: '1',
          title: 'Morning Shift',
          description: 'Regular morning shift',
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 8)),
          days: ['Monday', 'Wednesday', 'Friday'],
          type: 'shift',
          status: 'active',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ScheduleModel(
          id: '2',
          title: 'Annual Leave',
          description: 'Annual vacation leave',
          startTime: DateTime.now().add(const Duration(days: 7)),
          endTime: DateTime.now().add(const Duration(days: 14)),
          days: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
          type: 'leave',
          status: 'pending',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addSchedule(ScheduleModel schedule) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement API call to add schedule
      await Future.delayed(const Duration(seconds: 1));
      _schedules.add(schedule);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSchedule(ScheduleModel schedule) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement API call to update schedule
      await Future.delayed(const Duration(seconds: 1));
      final index = _schedules.indexWhere((s) => s.id == schedule.id);
      if (index != -1) {
        _schedules[index] = schedule;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteSchedule(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement API call to delete schedule
      await Future.delayed(const Duration(seconds: 1));
      _schedules.removeWhere((schedule) => schedule.id == id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
