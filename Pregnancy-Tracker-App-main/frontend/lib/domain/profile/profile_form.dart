class ProfileForm {
  final String? firstName;
  final String? lastName;
  final List<String>? followers; // Ensure this is List<String>
  final List<String>? following; // Ensure this is List<String>
  final String? profilePicture;
  final List<String>? socialMedia; // Ensure this is List<String>
  final String? bio;
  final String? userName;

  ProfileForm({
    this.firstName,
    this.lastName,
    this.followers,
    this.following,
    this.profilePicture,
    this.socialMedia,
    this.bio,
    this.userName,
  });
}
