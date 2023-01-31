import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class Pet {
  Uuid id = Uuid();
  String name = "";
  DateTime birthDate = DateTime.now();
  List<WeightMeasure> measuredWeights = List.empty(growable: true);
  List<FoodPortion> fedTimes = List.empty(growable: true);
  int dailyFood = 0;
  Pet(this.name, this.birthDate, {this.dailyFood = 0});

  double getWeight() {
    if (measuredWeights.isEmpty) return 0;
    return measuredWeights.last.weight;
  }

  int getAge() {
    return (DateTime.now().difference(birthDate).inDays / 365).floor();
  }
}

class FoodPortion {
  DateTime date = DateTime.now();
  int weight = 0;
  FoodPortion(this.weight, {DateTime? date}) {
    if (date != null) {
      this.date = date;
    }
  }
}

class WeightMeasure {
  DateTime date = DateTime.now();
  double weight = 0;
}
