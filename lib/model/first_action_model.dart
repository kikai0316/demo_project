import 'dart:convert';

class FirstActionsType {
  bool startup;
  bool editStory;
  bool notificationRequestPermission;
  bool photoRequestPermission;
  bool locationRequestPermission;
  FirstActionsType({
    this.startup = true,
    this.editStory = true,
    this.notificationRequestPermission = true,
    this.photoRequestPermission = true,
    this.locationRequestPermission = true,
  });

  factory FirstActionsType.fromJson(String jsonData) {
    final data = jsonDecode(jsonData) as Map<String, dynamic>;
    return FirstActionsType(
      startup: data["startup"] as bool,
      editStory: data["edit_story"] as bool,
      notificationRequestPermission: data["notification_permission"] as bool,
      photoRequestPermission: data["photo_permission"] as bool,
      locationRequestPermission: data["location_permission"] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "startup": startup,
      "edit_story": editStory,
      "notification_permission": notificationRequestPermission,
      "photo_permission": photoRequestPermission,
      "location_permission": locationRequestPermission,
    };
  }

  FirstActionsType update(
    bool? newStartup,
    bool? newEditStory,
    bool? newNotification,
    bool? newPhoto,
    bool? newlocation,
  ) {
    final notification = newNotification ?? notificationRequestPermission;
    return FirstActionsType(
      startup: newStartup ?? startup,
      editStory: newEditStory ?? editStory,
      notificationRequestPermission: notification,
      photoRequestPermission: newPhoto ?? photoRequestPermission,
      locationRequestPermission: newlocation ?? locationRequestPermission,
    );
  }
}
