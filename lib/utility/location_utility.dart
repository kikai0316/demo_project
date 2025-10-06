import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/utility/path_provider_utility.dart';

Future<LocationData> getLocation() async {
  final json = {'latitude': 34.985849, 'longitude': 135.758766};
  final tokyoLocation = LocationData.fromMap(json);
  try {
    final fastAction = await localGetFirstActions();
    final isLocNotRequest = fastAction.locationRequestPermission;
    if (isLocNotRequest) return tokyoLocation;
    const timer = Duration(seconds: 5);
    final lo = Location();
    return await lo.getLocation().timeout(timer);
  } catch (_) {
    return tokyoLocation;
  }
}

//位置情報から国と権を取得する
Future<String> getLocationString(
  BuildContext context,
  List<double> coords,
) async {
  try {
    final ln = AppLocalizations.of(context)!;
    await geo.setLocaleIdentifier(ln.dateLocaleName);
    final placemarks = await geo.placemarkFromCoordinates(coords[1], coords[0]);
    final p = placemarks.first;

    final prefecture = p.administrativeArea ?? '';
    final city = p.locality ?? '';

    if (ln.lang == "jp") return "$prefecture,$city";
    return "$city,$prefecture";
  } catch (_) {
    return "取得エラー";
  }
}
