import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/Week7_Firebase_Localstorage/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/Week7_Firebase_Localstorage/repository/ride_preferences_repository.dart';
import 'package:week_3_blabla_project/Week7_Firebase_Localstorage/ui/provider/async_value.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  AsyncValue<List<RidePreference>> _pastPreferences = AsyncValue.loading();
  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
    // Fetch past preferences during initialization
    fetchPastPreferences();
  }

  // Getter for past preferences
  AsyncValue<List<RidePreference>> get pastPreferences => _pastPreferences;

  RidePreference? get currentPreference => _currentPreference;

  Future<void> fetchPastPreferences() async {
    try {
      // Set loading state
      _pastPreferences = AsyncValue.loading();
      notifyListeners();

      // Fetch preferences
      final prefs = await repository.getPastPreferences();
      
      // Set success state
      _pastPreferences = AsyncValue.success(prefs);
      notifyListeners();
    } catch (error) {
      // Set error state
      _pastPreferences = AsyncValue.error(error);
      notifyListeners();
    }
  }

  void setCurrentPreference(RidePreference pref) {
    // 1. Process only if the new preference is not equal to the current one
    if (_currentPreference == pref) return;

    // 2. Update the current preference
    _currentPreference = pref;

    // 3. Update the history (ensure all preferences in history are unique)
    if (_pastPreferences.state == AsyncValueState.success) {
      final currentPrefs = _pastPreferences.data!;
      if (!currentPrefs.contains(pref)) {
        final updatedPrefs = List<RidePreference>.from(currentPrefs)..add(pref);
        _pastPreferences = AsyncValue.success(updatedPrefs);
      }
    }

    // 4. Notify the listeners
    notifyListeners();
  }

  Future<void> addPreference(RidePreference preference) async {
    try {
      // Add preference to repository
      await repository.addPreference(preference);

      // Update local cache if successful
      if (_pastPreferences.state == AsyncValueState.success) {
        final currentPrefs = _pastPreferences.data!;
        if (!currentPrefs.contains(preference)) {
          final updatedPrefs = List<RidePreference>.from(currentPrefs)..add(preference);
          _pastPreferences = AsyncValue.success(updatedPrefs);
          notifyListeners();
        }
      }
    } catch (error) {
      print('Error adding preference: $error');
    }
  }

  // History is returned from newest to oldest preference
  List<RidePreference> get preferencesHistory {
    if (_pastPreferences.state == AsyncValueState.success) {
      return _pastPreferences.data!.reversed.toList();
    }
    return [];
  }
}