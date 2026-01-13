import 'package:aura/features/profile/data/model/user_profile_model.dart';
import 'package:aura/features/profile/data/service/profile_service.dart';

class ProfileRepository {
  final ProfileApiService _apiService;

  ProfileRepository(this._apiService);

  Future<UserProfileModel> getCurrentUserProfile() async {
    final response = await _apiService.findCurrentUserProfile();
    return UserProfileModel.fromJson(response.data);
  }
}
