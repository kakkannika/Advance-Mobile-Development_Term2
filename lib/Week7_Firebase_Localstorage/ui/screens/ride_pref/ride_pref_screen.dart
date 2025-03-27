import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/Week7_Firebase_Localstorage/ui/provider/async_value.dart';
import 'package:week_3_blabla_project/Week7_Firebase_Localstorage/ui/provider/ride_preference_provider.dart';
import '../../../model/ride/ride_pref.dart';
import '../../theme/theme.dart';

import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});
  
  Future<void> onRidePrefSelected(BuildContext context, RidePreference newPreference) async {
    final provider = Provider.of<RidesPreferencesProvider>(context, listen: false);
    provider.setCurrentPreference(newPreference);

    await Navigator.of(context)
        .push(AnimationUtils.createBottomToTopRoute(RidesScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RidesPreferencesProvider>(context);
    final RidePreference? currentPreference = provider.currentPreference;

    // Handle different AsyncValue states
    switch (provider.pastPreferences.state) {
      case AsyncValueState.loading:
        return Scaffold(
          body: Center(
            child: BlaError(message: 'Loading...'),
          ),
        );

      case AsyncValueState.error:
        return Scaffold(
          body: Center(
            child: BlaError(message: 'No connection. Try later'),
          ),
        );

      case AsyncValueState.success:
        final List<RidePreference> pastPreferences = provider.preferencesHistory;
        
        return Stack(
          children: [
            // 1 - Background Image
            BlaBackground(),

            // 2 - Foreground content
            Column(
              children: [
                SizedBox(height: BlaSpacings.m),
                Text(
                  "Your pick of rides at low price",
                  style: BlaTextStyles.heading.copyWith(color: Colors.white),
                ),
                SizedBox(height: 100),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 2.1 Display the Form to input the ride preferences
                      RidePrefForm(
                        initialPreference: currentPreference,
                        onSubmit: (newPreference) =>
                            onRidePrefSelected(context, newPreference)
                      ),
                      SizedBox(height: BlaSpacings.m),

                      // 2.2 Optionally display a list of past preferences
                      SizedBox(
                        height: 200,
                        child: pastPreferences.isEmpty
                            ? Center(child: Text('No past preferences'))
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: AlwaysScrollableScrollPhysics(),
                                itemCount: pastPreferences.length,
                                itemBuilder: (ctx, index) => RidePrefHistoryTile(
                                  ridePref: pastPreferences[index],
                                  onPressed: () =>
                                      onRidePrefSelected(context, pastPreferences[index]),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
    }
  }
}

class BlaError extends StatelessWidget {
  const BlaError({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(left: BlaSpacings.m, right: BlaSpacings.m, top: BlaSpacings.s),
      child: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/blabla_wifi.png', 
              fit: BoxFit.none, 
            ),
            Text(
              message,
              style: BlaTextStyles.heading.copyWith(color: BlaColors.textNormal),
            ),
          ],
        ),
      ),
    ));
  }
}

class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover,
      ),
    );
  }
}
