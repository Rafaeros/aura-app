import 'package:aura/features/company/data/model/company_settings_model.dart';
import 'package:aura/features/company/data/service/company_settings_service.dart';

class CompanySettingsRepository {
  final CompanySettingsApiService _apiService;

  CompanySettingsRepository(this._apiService);

  Future<CompanySettingsModel> saveMyCompanySettings(
    CompanySettingsModel settings,
  ) async {
    final response = await _apiService.saveMySettings(settings.toJson());
    return CompanySettingsModel.fromJson(response.data);
  }
}
