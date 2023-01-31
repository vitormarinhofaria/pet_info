import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:pet_info/pets_page.dart';
import 'package:pet_info/pets_provider.dart';

import 'Pet.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const List<Widget> navWidgets = [
    PetsPage(),
    Text("Page 2"),
    Text("Page 3"),
  ];
  int navigationIndex = 0;

  @override
  void initState() {
    super.initState();
    PetsProvider petsProvider = PetsProvider();
    petsProvider
        .put(Pet("Duque", DateTime.parse("2017-12-23"), dailyFood: 600));
    petsProvider
        .put(Pet("Pretinha", DateTime.parse("2011-02-02"), dailyFood: 250));
    petsProvider.put(Pet("Rex", DateTime.parse("2020-02-10"), dailyFood: 400));
    Get.put(petsProvider);
  }

  _MainPageState() {
    //Get.changeThemeMode(ThemeMode.system);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("Pet Info"),
            IconButton(
              onPressed: () {
                setState(() {
                  Get.changeThemeMode(
                      Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                });
              },
              icon: const Icon(Icons.dark_mode),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: navWidgets.elementAt(navigationIndex),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => setState(() => navigationIndex = value),
        currentIndex: navigationIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.pets), label: PetsPage.title),
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant), label: "Refeições"),
          BottomNavigationBarItem(icon: Icon(Icons.food_bank), label: "k")
        ],
      ),
    );
  }
}
