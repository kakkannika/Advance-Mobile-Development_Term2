import 'package:week_3_blabla_project/Week7_Firebase_Localstorage/dummy_data/dummy_data.dart';
import 'package:week_3_blabla_project/Week7_Firebase_Localstorage/model/ride/ride_pref.dart';

import '../ride_preferences_repository.dart';


class MockRidePreferencesRepository extends RidePreferencesRepository {
  final List<RidePreference> _pastPreferences = fakeRidePrefs;

  @override
  // List<RidePreference> getPastPreferences() {
  //   return _pastPreferences;
  // }

  // @override
  // void addPreference(RidePreference preference) {
  //   _pastPreferences.add(preference);
  // }
  Future<List<RidePreference>> getPastPreferences() async {
    // wait 2 seconds as specified  
    await Future.delayed(Duration(seconds: 2));
    return _pastPreferences;
  }
  @override
  Future<void> addPreference(RidePreference preference) async {
    // wait 2 seconds as specified  
    await Future.delayed(Duration(seconds: 2));
    _pastPreferences.add(preference);
  }
}