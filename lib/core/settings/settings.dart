import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:frosty/core/auth/auth_store.dart';
import 'package:frosty/core/settings/profile_card.dart';
import 'package:frosty/core/settings/settings_store.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  final SettingsStore settingsStore;

  const Settings({Key? key, required this.settingsStore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Observer(
        builder: (_) {
          return ListView(
            children: [
              ProfileCard(authStore: context.read<AuthStore>()),
              SwitchListTile.adaptive(
                title: const Text('Enable Video'),
                value: settingsStore.videoEnabled,
                onChanged: (newValue) => settingsStore.videoEnabled = newValue,
              ),
              ListTile(
                title: Text('Chat Message Limit: ${settingsStore.messageLimit}'),
                subtitle: Slider.adaptive(
                  value: settingsStore.messageLimit,
                  onChanged: (newValue) => settingsStore.messageLimit = newValue,
                  min: 200,
                  max: 1000,
                  divisions: 4,
                  label: settingsStore.messageLimit == 1000 ? 'Unlimited' : '${settingsStore.messageLimit}',
                ),
              )
            ],
          );
        },
      ),
    );
  }
}