abstract class Validator {
  String? validate(String? value);
}

class RequiredValidator implements Validator {
  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vous devez remplir ce champs';
    }

    return null;
  }
}

class IsNumberValidator implements Validator {
  bool isNumber(String texte) {
    return num.tryParse(texte) != null;
  }

  @override
  String? validate(String? value) {
    if (!isNumber(value ?? 'a')) {
      return 'Ce champs doit contenir un chiffre';
    }

    return null;
  }
}
