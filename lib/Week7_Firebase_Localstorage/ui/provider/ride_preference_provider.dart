import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/Week7_Firebase_Localstorage/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/Week7_Firebase_Localstorage/repository/ride_preferences_repository.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  List<RidePreference> _pastPreferences = [];
  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
    // Fetch past preferences only once during initialization
    _pastPreferences = repository.getPastPreferences();
  }

  RidePreference? get currentPreference => _currentPreference;

  void setCurrentPreference(RidePreference pref) {
    // 1. Process only if the new preference is not equal to the current one
    if (_currentPreference == pref) return;

    // 2. Update the current preference
    _currentPreference = pref;

    // 3. Update the history (ensure all preferences in history are unique)
    if (!_pastPreferences.contains(pref)) {
      _pastPreferences.add(pref);
    }

    // 4. Notify the listeners
    notifyListeners();
  }

  void _addPreference(RidePreference preference) {
    // Add preference to history if it doesn't already exist
    if (!_pastPreferences.contains(preference)) {
      _pastPreferences.add(preference);
    }
  }

  // History is returned from newest to oldest preference
  List<RidePreference> get preferencesHistory => _pastPreferences.reversed.toList();
}