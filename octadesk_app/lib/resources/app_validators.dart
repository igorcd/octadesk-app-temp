import 'package:flutter/cupertino.dart';
import 'package:octadesk_app/utils/country_seed.dart' as country_seed;
import 'package:collection/collection.dart';

class AppValidators {
  /// Verificar se é um CPF válido
  static bool _validCpf(String cpf) {
    String noMaskCpf = cpf.replaceAll(RegExp(r'[.-]'), '');
    int soma;
    int resto;
    soma = 0;
    if (noMaskCpf == "00000000000") return false;

    for (var i = 1; i <= 9; i++) {
      soma = soma + int.parse(noMaskCpf.substring(i - 1, i)) * (11 - i);
    }
    resto = (soma * 10) % 11;

    if ((resto == 10) || (resto == 11)) resto = 0;
    if (resto != int.parse(noMaskCpf.substring(9, 10))) return false;

    soma = 0;
    for (var i = 1; i <= 10; i++) {
      soma = soma + int.parse(noMaskCpf.substring(i - 1, i)) * (12 - i);
    }
    resto = (soma * 10) % 11;

    if ((resto == 10) || (resto == 11)) resto = 0;
    if (resto != int.parse(noMaskCpf.substring(10, 11))) return false;
    return true;
  }

  /// Verificar se o campo não está vazio
  static String? notEmpty(String value) {
    return value.trim().isEmpty ? "Este campo é obrigatório" : null;
  }

  /// Verificar se é um CPF válido
  static String? cpf(String value) {
    bool validCpf = false;
    var regex = RegExp(r"^\d{3}\.\d{3}\.\d{3}-\d{2}$");
    if (regex.hasMatch(value)) {
      validCpf = _validCpf(value);
    }

    return !validCpf ? "Insira um CPF válido" : null;
  }

  /// Verificar se é um e-mail válido
  static String? email(String value) {
    if (value.isEmpty) {
      return null;
    }
    var regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return !regex.hasMatch(value.trim()) ? "Insira um e-mail válido" : null;
  }

  /// Verificar se é um telefone válido
  static String? phone(String value) {
    var regex = RegExp(r"^\([1-9]{2}\) [0-9]{5}-[0-9]{4}");
    return !regex.hasMatch(value) ? "Insira um telefone válido" : null;
  }

  /// Verificar se o valor é igual a outro
  static Function match(TextEditingController valueToCompare) {
    return (String value) {
      return valueToCompare.text != value ? "Os campos não coincidem" : null;
    };
  }

  static String? contryCode(String contryCode) {
    var validCountryCode = country_seed.countriesSeed.firstWhereOrNull((element) => element.phoneCode.replaceAll("+", "") == contryCode.replaceAll("+", "")) != null;
    if (!validCountryCode) {
      return "Insira um código de páis válido";
    }
    return null;
  }
}
