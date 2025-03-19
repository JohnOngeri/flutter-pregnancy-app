import "dart:convert";
import "package:frontend/domain/profile/profile_form.dart";
import "package:frontend/infrastructure/profile/profile_dto.dart";
import "package:frontend/infrastructure/profile/profile_form_dto.dart";
import "package:frontend/util/jj_http_client.dart";
import "package:frontend/util/jj_http_exception.dart";
import "package:frontend/util/jj_timeout_exception.dart";

class ProfileApi {
  JJHttpClient _customHttpClient = JJHttpClient();

  Future<ProfileDto> updateProfile(
      ProfileFormDto profileForm, String profileId) async {
    try {
      print("🔵 [UPDATE PROFILE] Sending request to: profile/$profileId");
      print("📤 Request body: ${json.encode(profileForm.toJson())}");

      var updatedProfile = await _customHttpClient.put(
        "profile/$profileId",
        body: json.encode(profileForm.toJson()),
      );

      print("✅ [UPDATE PROFILE] Response received: ${updatedProfile.statusCode}");

      if (updatedProfile.statusCode >= 200 && updatedProfile.statusCode < 300) {
        print("🟢 Profile updated successfully!");
        return ProfileDto.fromJson(jsonDecode(updatedProfile.body));
      } else {
        print("❌ [ERROR] Failed to update profile: ${updatedProfile.body}");
        throw JJHttpException(
            json.decode(updatedProfile.body)['message'] ?? "Unknown error",
            updatedProfile.statusCode);
      }
    } catch (e) {
      print("🔥 [EXCEPTION] Update profile error: $e");
      rethrow;
    }
  }

  Future<ProfileDto> getProfile(String profileId) async {
    try {
      print("🔵 [GET PROFILE] Fetching profile for ID: $profileId");

      var response =
          await _customHttpClient.get("profile/$profileId").timeout(jjTimeout);

      print("✅ [GET PROFILE] Response received: ${response.statusCode}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print("🟢 Profile data: ${response.body}");
        return ProfileDto.fromJson(json.decode(response.body));
      } else {
        print("❌ [ERROR] Failed to fetch profile: ${response.body}");
        throw JJHttpException(
            json.decode(response.body)['message'] ?? "Unknown error",
            response.statusCode);
      }
    } catch (e) {
      print("🔥 [EXCEPTION] Get profile error: $e");
      throw JJTimeoutException();
    }
  }

  Future<void> deleteAccount(String id) async {
    try {
      print("🔵 [DELETE ACCOUNT] Deleting profile with ID: $id");

      var response = await _customHttpClient.delete("profile/$id");

      print("✅ [DELETE ACCOUNT] Response status: ${response.statusCode}");

      if (response.statusCode != 204) {
        print("❌ [ERROR] Failed to delete profile.");
        throw Exception("Unknown error");
      } else {
        print("🟢 Profile deleted successfully!");
      }
    } catch (e) {
      print("🔥 [EXCEPTION] Delete account error: $e");
      rethrow;
    }
  }
}
