class CompanyModel {
  final int id;
  final String name;
  final String cnpj;

  CompanyModel({required this.id, required this.name, required this.cnpj});

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(id: json['id'], name: json['name'], cnpj: json['cnpj']);
  }
}
