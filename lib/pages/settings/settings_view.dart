import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../../core/provider/app_provider.dart';
import '../../core/services/snackbar_service.dart';
import '../../pages/login_view/login_view.dart';
import '../../pages/settings/settings_view_model.dart';
import '../../pages/settings/widgets/custom_elevated_button.dart';
import '../../pages/settings/widgets/settings_item.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late SettingsViewModel settingsViewModel;

  @override
  void initState() {
    super.initState();
    settingsViewModel = SettingsViewModel();
  }

  @override
  Widget build(BuildContext context) {
    var appProvider = Provider.of<AppProvider>(context);
    var mediaQuery = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (context) => settingsViewModel,
      builder: (context, child) {
        return Consumer<SettingsViewModel>(
          builder: (context, vm, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: mediaQuery.width,
                  height: 150,
                  padding: const EdgeInsets.only(
                    top: 100,
                    left: 30,
                  ),
                  color: theme.primaryColor,
                  child: Text(
                    'Settings',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 25, width: 100,),
                SettingsItem(
                  settingOptionTitle: 'Theme',
                  selectedOption: appProvider.isDarkMode() ? 'Dark' : 'Light',
                  
                  onClicked: () {
                    vm.showThemeBottomSheet(context);
                  },
                ),
                const SizedBox(height: 25),
                Divider(
                  color: theme.colorScheme.primary,
                  thickness: 2,
                  indent: 100,
                  endIndent: 100,
                ),
                
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Text(
                    "Account settings",
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 30, left: 56.0, bottom: 17),
                  child: Column(
                    children: [
              
                      CustomELevatedButton(
                        text: 'Delete account',
                        textStyle: theme.textTheme.bodyLarge!.copyWith(
                          color: const Color(0xffEE0E0E),
                        ),
                        borderColor: const Color(0xffEE0E0E),
                        foregroundColor: const Color(0xffEE0E0E),
                        onTap: () {
                          showAlertDialog(
                            context,
                            'Delete account',
                            'Are you sure you want to delete your account?\nAll your data will be lost.',
                            'Delete',
                            () async {
                              EasyLoading.show();
                              await vm.deleteAccount();
                              EasyLoading.dismiss();
                              Navigator.of(context).pop();

                              if (vm.deleteAccountStatus == "success") {
                                SnackBarService.showSuccessMessage(
                                    'Your account has been deleted');
                                Timer(const Duration(seconds: 5), () {
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      LoginView.routeName, (route) => false);
                                });
                              } else {
                                SnackBarService.showErrorMessage(
                                    '${vm.deleteAccountStatus}');
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25, width: 100,),
                // Logout Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      appProvider.logOut();
                      Navigator.pushReplacementNamed(
                          context, LoginView.routeName);
                    },
                    child: Text('Logout'),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

showAlertDialog(
  BuildContext context,
  final String title,
  final String content,
  final String actionText,
  final Function action,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        content: Text(content),
        actions: [
          TextButton(
            child: Text('Cancel',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            onPressed: () {
              action();
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xffEE0E0E),
            ),
            child:
                Text(actionText, style: const TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
