import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'pt_BR': {
          "cancel": "Cancelar",
          "confirm": "Confirmar",
          "save": "Salvar",
          "add_new_pet": "Adicionar novo Pet",
          "weight": "Peso",
          "birthdate": "Data de nascimento",
          "dayly_ammount_in_grams": "Alimentação diaria (em gramas)",
          "name": "Nome",
          "years_old": "anos"
        },
        "en_US": {
          "cancel": "Cancel",
          "confirm": "Confirm",
          "save": "Save",
          "add_new_pet": "Add new Pet",
          "weight": "Weight",
          "birthdate": "Birthdate",
          "dayly_ammount_in_grams": "Daily food (grams)",
          "name": "Name",
          "years_old": "years old",
        }
      };
}
