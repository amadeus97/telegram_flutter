import 'dart:async' show Future;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';
import 'package:telegram_flutter/logic/data/country.dart';

class CountrySelectionPage extends StatefulWidget {
  const CountrySelectionPage({super.key});

  @override
  State<CountrySelectionPage> createState() => _CountrySelectionPageState();
}

class _CountrySelectionPageState extends State<CountrySelectionPage> {
  final controller = TextEditingController();

  List<Country> countries = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(() => setState(() {}));
    loadJsonData().then((value) => setState(() => countries = value));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<List<Country>> loadJsonData() async {
    var jsonText = await rootBundle.loadString('assets/countries.json');
    final decodedJson = json.decode(jsonText) as List<dynamic>;

    return decodedJson.map((e) => Country.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isSearching) {
          setState(() => isSearching = false);
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            if (!isSearching)
              IconButton(
                onPressed: () => setState(() => isSearching = true),
                icon: const Icon(Icons.search),
              ),
          ],
          title: Builder(builder: (context) {
            if (isSearching) {
              return TextField(
                autofocus: true,
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
              );
            }
            return const Text('Choose a country');
          }),
        ),
        body: ListView(
          children: countries
              .where(
                (country) {
                  if (isSearching && controller.text.isEmpty) {
                    return true;
                  }
                  return country.name
                      .toLowerCase()
                      .contains(controller.text.toLowerCase());
                },
              )
              .map(_CountryListTile.new)
              .toList(),
        ),
      ),
    );
  }
}

class _CountryListTile extends StatelessWidget {
  const _CountryListTile(this.country, {Key? key}) : super(key: key);
  final Country country;

  @override
  Widget build(BuildContext context) {
    void handleTap() {
      Navigator.of(context).pop(country);
    }

    return ListTile(
        onTap: handleTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 32),
        minLeadingWidth: 18,
        title: Text(country.name),
        leading: Text(country.flag),
        trailing: Text(
          country.code,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ));
  }
}
