import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/storage_key.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/core/widgets/custom_svg_picture.dart';
import 'package:tasky/features/login/login_screen.dart';
import 'package:tasky/features/profile/profile_controller.dart';
import 'package:tasky/features/profile/user_details_screen.dart';
import 'package:flutter/foundation.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileController>(
      create: (context) => ProfileController()..init(),

      child: Selector<ProfileController, bool>(
        selector: (context, ProfileController controller) =>
            controller.isLoading,
        builder: (BuildContext context, bool isLoading, Widget? child) {
          return isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'My Profile',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: Column(
                          children: [
                            Selector<ProfileController, String?>(
                              selector: (_, controller) =>
                                  controller.userImagePath,
                              builder: (_, userImagePath, __) {
                                return Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: userImagePath == null
                                          ? const AssetImage(
                                              'assets/images/person2.jpg',
                                            )
                                          : kIsWeb
                                          ? NetworkImage(userImagePath)
                                          : FileImage(File(userImagePath))
                                                as ImageProvider,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        final controller = context
                                            .read<ProfileController>();

                                        controller.showImageSourceDialog(
                                          context,
                                          (XFile file) {
                                            controller.saveImage(file);
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: 45,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primaryContainer,
                                        ),
                                        child: Icon(Icons.camera_alt, size: 26),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: 6),
                            Selector<ProfileController, String>(
                              selector: (_, controller) => controller.username,
                              builder: (_, username, __) {
                                return Text(
                                  username,
                                  style: Theme.of(context).textTheme.labelSmall,
                                );
                              },
                            ),
                            Selector<ProfileController, String>(
                              selector: (_, controller) =>
                                  controller.motivationQuote,
                              builder: (_, motivationQuote, __) {
                                return Text(
                                  motivationQuote,
                                  style: Theme.of(context).textTheme.titleSmall,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Profile Info',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      SizedBox(height: 24),
                      ListTile(
                        onTap: () async {
                          final controller = context.read<ProfileController>();
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return UserDetailsScreen();
                              },
                            ),
                          );
                          if (result != null && result) {
                            controller.loadData();
                          }
                        },
                        contentPadding: EdgeInsets.zero,
                        title: Text('User Details'),
                        leading: CustomSvgPicture(
                          path: 'assets/images2/profile_icon.svg',
                        ),
                        trailing: CustomSvgPicture(
                          path: 'assets/images2/arrow_right.svg',
                        ),
                      ),
                      Divider(thickness: 1),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Dark Mode'),
                        leading: CustomSvgPicture(
                          path: 'assets/images2/dark_icon.svg',
                        ),
                        trailing: ValueListenableBuilder(
                          valueListenable: ThemeController.themeNotifier,
                          builder:
                              (BuildContext context, value, Widget? child) {
                                return Switch(
                                  value: value == ThemeMode.dark,
                                  onChanged: (bool value) async {
                                    ThemeController.toggleTheme();
                                  },
                                );
                              },
                        ),
                      ),
                      Divider(thickness: 1),
                      ListTile(
                        onTap: () async {
                          PreferencesManager().remove(StorageKey.username);
                          PreferencesManager().remove(
                            StorageKey.motivationQuote,
                          );
                          PreferencesManager().remove(StorageKey.tasks);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return LoginScreen();
                              },
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                        contentPadding: EdgeInsets.zero,
                        title: Text('Log Out'),
                        leading: CustomSvgPicture(
                          path: 'assets/images2/logout_icon.svg',
                        ),
                        trailing: CustomSvgPicture(
                          path: 'assets/images2/arrow_right.svg',
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
