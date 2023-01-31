import 'package:uuid/uuid.dart';

import 'Pet.dart';

class PetsProvider {
  final Map<Uuid, Pet> _pets = {};
  Map<String, void Function(Map<Uuid, Pet>)> changeListeners = {};

  void put(Pet pet) {
    _pets[pet.id] = pet;
    for (var f in changeListeners.values) {
      f(_pets);
    }
  }

  Pet get(Uuid id) {
    return _pets[id]!;
  }

  Map<Uuid, Pet> getAll() {
    return _pets;
  }

  ///ref must be a unique string and must be saved to be used to remove the listener
  void addListener(String ref, void Function(Map<Uuid, Pet>) fn) {
    changeListeners[ref] = fn;
  }

  void removeListener(String ref) {
    changeListeners.remove(ref);
  }
}
