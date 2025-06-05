import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.login)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(decoration: InputDecoration(labelText: l10n.email)),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: l10n.password),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Handle login
              },
              child: Text(l10n.login),
            ),
            TextButton(
              onPressed: () {
                // Navigate to register
              },
              child: Text(l10n.register),
            ),
          ],
        ),
      ),
    );
  }
}
