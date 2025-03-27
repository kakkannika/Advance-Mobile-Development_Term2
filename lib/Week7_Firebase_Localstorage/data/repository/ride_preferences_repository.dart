import 'package:week_3_blabla_project/Week7_Firebase_Localstorage/model/ride/ride_pref.dart';


// abstract class RidePreferencesRepository {
//   List<RidePreference> getPastPreferences();

//   void addPreference(RidePreference preference);
// }

abstract class RidePreferencesRepository {
  Future<List<RidePreference>> getPastPreferences();

  Future<void> addPreference(RidePreference preference);
}