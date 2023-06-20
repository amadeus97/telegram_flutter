import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:telegram_flutter/main.dart';
import 'package:telegram_flutter/logic/data/country.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  late FocusScopeNode _focusScope;

  final _countryController = TextEditingController();
  final _numberController = TextEditingController();

  Country country = Country('USA', '+1', '🇺🇸');

  void initialize() {
    _numberController.text = '';
    _countryController.text = country.name;
    setState(() => _focusScope = FocusScope.of(context));
  }

  @override
  void initState() {
    super.initState();
    scheduleMicrotask(initialize);
  }

  @override
  void dispose() {
    _countryController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void selectCountry() async {
      final response = await app.navigateTo(context, 'country_selection');
      if (response != null) {
        country = response;
        initialize();
      }
      _focusScope.nextFocus();
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          settings.authenticated.value = true;
          app.navigateTo(context, '/');
        },
        child: const Icon(Icons.arrow_forward),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Your phone number',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const Gap(8),
            Text(
              'Please confirm your country code\nand enter your phone number.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Gap(24),
            TextField(
              controller: _countryController,
              onTap: selectCountry,
              readOnly: true,
              decoration: InputDecoration(
                isDense: true,
                label: const Text('Country'),
                prefix: Container(
                  margin: const EdgeInsets.only(right: 14),
                  child: Text(country.flag),
                ),
                suffixIcon: const Icon(
                  Icons.chevron_right,
                  size: 28,
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const Gap(24),
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                isDense: true,
                label: const Text('Phone number'),
                prefix: Container(
                  margin: const EdgeInsets.only(right: 12),
                  constraints: const BoxConstraints(
                    minWidth: 58,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        width: 1.5,
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                  child: Text(country.code),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
