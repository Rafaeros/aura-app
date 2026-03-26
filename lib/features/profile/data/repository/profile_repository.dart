import 'package:aura/core/client/api_response.dart';
import 'package:aura/features/profile/data/model/user_profile_model.dart';
import 'package:aura/features/profile/data/service/profile_service.dart';

class ProfileRepository {
  final ProfileApiService _apiService;

  ProfileRepository(this._apiService);

  Future<UserProfileModel> getCurrentUserProfile() async {
    final response = await _apiService.findCurrentUserProfile();
    final apiResponse = ApiResponse<UserProfileModel>.fromJson(
      response.data,
      (json) => UserProfileModel.fromJson(json as Map<String, dynamic>),
    );
    return apiResponse.data!;
  }
}
