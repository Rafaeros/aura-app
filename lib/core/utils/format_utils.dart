class FormatUtils {
  static String formatCNPJ(String? cnpj) {
    if (cnpj == null || cnpj.isEmpty) return "-";

    final cleaned = cnpj.replaceAll(RegExp(r'[^\d]'), '');

    if (cleaned.length != 14) return cnpj;

    return "${cleaned.substring(0, 2)}.${cleaned.substring(2, 5)}.${cleaned.substring(5, 8)}/${cleaned.substring(8, 12)}-${cleaned.substring(12, 14)}";
  }

  static String formatCEP(String? cep) {
    if (cep == null || cep.isEmpty) return "-";

    final cleaned = cep.replaceAll(RegExp(r'[^\d]'), '');

    if (cleaned.length != 8) return cep;

    return "${cleaned.substring(0, 2)}.${cleaned.substring(2, 5)}-${cleaned.substring(5, 8)}";
  }

  static String formatCPF(String? cpf) {
    if (cpf == null || cpf.isEmpty) return "-";

    final cleaned = cpf.replaceAll(RegExp(r'[^\d]'), '');

    if (cleaned.length != 11) return cpf;

    return "${cleaned.substring(0, 3)}.${cleaned.substring(3, 6)}.${cleaned.substring(6, 9)}-${cleaned.substring(9, 11)}";
  }
}
