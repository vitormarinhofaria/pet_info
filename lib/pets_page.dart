import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:pet_info/pets_provider.dart';
import 'package:pet_info/utils.dart';

import 'Pet.dart';

class PetsPage extends StatefulWidget {
  const PetsPage({super.key});
  static const String title = "Pets";

  @override
  State<PetsPage> createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  List<Pet> pets = List.empty();

  @override
  void initState() {
    super.initState();
    PetsProvider petsProvider = Get.find();
    pets = List.from(petsProvider.getAll().values);
    petsProvider.addListener("PetsPageUpdateList", (pm) {
      setState(() {
        pets = List.from(pm.values);
      });
    });
  }

  @override
  void dispose() {
    PetsProvider petsProvider = Get.find();
    petsProvider.removeListener("PetsPageUpdateList");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
          itemCount: pets.length + 1,
          itemBuilder: (ctx, index) {
            if (index >= pets.length) {
              return ElevatedButton(
                child: Text(
                  "add_new_pet".tr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                onPressed: () async {
                  Pet nPet = await showModalAddNewPet(
                      context, Pet("", DateTime.now()));
                  if (nPet.name.isNotEmpty) {
                    PetsProvider petsProv = Get.find();
                    petsProv.put(nPet);
                  }
                },
              );
            }
            var pet = pets[index];
            return PetCard(pet: pet);
          }),
    );
  }
}

Future<dynamic> showModalAddNewPet(BuildContext context, Pet mPet) async {
  TextEditingController petNameControl = TextEditingController();
  TextEditingController petDailyFoodControl = TextEditingController();
  petNameControl.text = mPet.name;
  petDailyFoodControl.text = mPet.dailyFood.toString();

  await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      //enableDrag: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 16,
              right: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "add_new_pet".tr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextFormField(
                controller: petNameControl,
                decoration: InputDecoration(
                    labelText: "name".tr,
                    labelStyle: const TextStyle(),
                    border: const UnderlineInputBorder()),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border(
                    bottom: const UnderlineInputBorder().borderSide,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("birthdate".tr),
                      OutlinedButton(
                        onPressed: () async {
                          var date = await showDatePicker(
                              context: ctx,
                              initialDate: mPet.birthDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now());
                          if (date != null) {
                            mPet.birthDate = date;
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.date_range),
                            Text(dateToDisplayString(mPet.birthDate))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextFormField(
                  controller: petDailyFoodControl,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  decoration: InputDecoration(
                      labelText: "dayly_ammount_in_grams".tr,
                      labelStyle: const TextStyle(),
                      border: const UnderlineInputBorder())),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: Text("cancel".tr),
                    ),
                    FilledButton(
                      onPressed: () {
                        mPet.name = petNameControl.text;
                        mPet.dailyFood = int.parse(petDailyFoodControl.text);
                        Navigator.pop(ctx);
                      },
                      child: Text(
                        "confirm".tr,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      });
  return mPet;
}

bool isSameDay(DateTime a, DateTime b) {
  if (a.year == b.year) {
    if (a.month == b.month) {
      if (a.day == b.day) {
        return true;
      }
    }
  }
  return false;
}

class PetCard extends StatefulWidget {
  const PetCard({super.key, required this.pet});
  final Pet pet;
  @override
  State<PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {
  int fedToday = 0;
  @override
  void initState() {
    super.initState();
    fedToday = calculateFedToday();
  }

  int calculateFedToday() {
    int fedAmount = 0;
    for (var e in widget.pet.fedTimes) {
      if (isSameDay(e.date, DateTime.now())) {
        fedAmount += e.weight;
      }
    }
    return fedAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Column(
        children: [
          // Text(widget.pet
          //     .name), //, ${widget.pet.getAge()} ${"years_old".tr} - ${widget.pet.getWeight()} Kg"),
          Text(
              "${widget.pet.name}, ${widget.pet.getAge()} ${"years_old".tr} - ${widget.pet.getWeight()} Kg"),
          Text(widget.pet.birthDate.toString()),
          Text("${fedToday}g / ${widget.pet.dailyFood}g"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 4),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: LinearProgressIndicator(
                minHeight: 20,
                value: widget.pet.dailyFood != 0
                    ? fedToday / widget.pet.dailyFood
                    : 0,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  showPortionSelectModal(context);
                },
                icon: const Icon(Icons.add_reaction),
              ),
              IconButton(
                onPressed: () async {
                  Pet nPet = await showModalAddNewPet(context, widget.pet);
                  if (nPet.name.isNotEmpty) {
                    PetsProvider pets = Get.find();
                    pets.put(nPet);
                  }
                },
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<dynamic> showPortionSelectModal(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (ctx) {
          //TODO: Allow for custom portion sizes
          var portions = [50, 100, 150, 200];
          return SizedBox(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Escolha a porção"),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: portions.length,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: ElevatedButton(
                        onPressed: () {
                          widget.pet.fedTimes.add(FoodPortion(portions[index]));
                          int fedAmmount = calculateFedToday();
                          setState(() {
                            fedToday = fedAmmount;
                          });
                          Navigator.pop(context);
                        },
                        child: Text("${portions[index]} gramas"),
                      ),
                    );
                  }),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.0,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
