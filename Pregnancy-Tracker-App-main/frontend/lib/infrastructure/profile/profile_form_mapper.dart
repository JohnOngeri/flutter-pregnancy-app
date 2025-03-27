import 'package:frontend/domain/profile/profile_form.dart';
import 'package:frontend/infrastructure/profile/profile_form_dto.dart';

extension PFMapper on ProfileForm {
  ProfileFormDto toDto() {
    return ProfileFormDto(
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      profilePicture: profilePicture ?? '',
      bio: bio ?? '',
      followers: followers ?? [],
      following: following ?? [],
      socialMedia: socialMedia ?? [],
    );
  }
}

class ProfileFormMapper {
  static ProfileForm fromJson(Map<String, dynamic> json) {
    return ProfileForm(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      followers: (json['followers'] as List<dynamic>?)
          ?.cast<String>(), // Convert to List<String>
      following: (json['following'] as List<dynamic>?)
          ?.cast<String>(), // Convert to List<String>
      profilePicture: json['profilePicture'] as String?,
      socialMedia: (json['socialMedia'] as List<dynamic>?)
          ?.cast<String>(), // Convert to List<String>
      bio: json['bio'] as String?,
      userName: json['userName'] as String?,
    );
  }

  static Map<String, dynamic> toJson(ProfileForm profileForm) {
    return {
      'firstName': profileForm.firstName,
      'lastName': profileForm.lastName,
      'followers': profileForm.followers,
      'following': profileForm.following,
      'profilePicture': profileForm.profilePicture,
      'socialMedia': profileForm.socialMedia,
      'bio': profileForm.bio,
      'userName': profileForm.userName,
    };
  }
}
