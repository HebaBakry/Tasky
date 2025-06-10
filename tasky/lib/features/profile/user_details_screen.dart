import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/storage_key.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/widgets/custom_text_form_field.dart';
import 'package:tasky/features/profile/user_details_controller.dart';

class UserDetailsScreen extends StatelessWidget {
  UserDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserDetailsController>(
      create: (context) => UserDetailsController()..init(),
      child: Builder(
        builder: (context) {
          final controller = context.read<UserDetailsController>();
          return Scaffold(
            appBar: AppBar(title: Text('User Details')),
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.manual,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                            key: controller.key,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextFormField(
                                  controller: controller.userNameController,
                                  hintText: 'Usama Elgendy',
                                  title: "User Name",
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                      ? "Enter User Name"
                                      : null,
                                ),
                                SizedBox(height: 20),
                                CustomTextFormField(
                                  controller:
                                      controller.motivationQuoteController,
                                  hintText:
                                      'One task at a time. One step closer.',
                                  title: "Motivation Quote",
                                  maxLines: 5,
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                      ? "Enter Motivation Quote"
                                      : null,
                                ),
                                Spacer(), // Optional: you may use SizedBox if Spacer causes overflow
                                ElevatedButton(
                                  onPressed: () async {
                                    if (controller.key.currentState!
                                        .validate()) {
                                      await PreferencesManager().setString(
                                        StorageKey.username,
                                        controller
                                            .userNameController
                                            .value
                                            .text,
                                      );
                                      await PreferencesManager().setString(
                                        StorageKey.motivationQuote,
                                        controller
                                            .motivationQuoteController
                                            .value
                                            .text,
                                      );

                                      Navigator.pop(context, true);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(
                                      MediaQuery.of(context).size.width,
                                      40,
                                    ),
                                  ),
                                  child: Text('Save Changes'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
