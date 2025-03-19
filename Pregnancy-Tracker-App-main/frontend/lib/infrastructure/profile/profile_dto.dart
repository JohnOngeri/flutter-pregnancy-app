class ProfileDto {
  final String? id;
  final String userName;
  final String firstName;
  final String lastName;
  final String profilePicture;
  final String bio;
  final List<String> followers;
  final List<String> following;
  final List<String> posts; // Changed back to List<String>
  final List<String> comments; // Changed back to List<String>
  final List<String> socialMedia; // Changed back to List<String>

  ProfileDto({
    this.id,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
    required this.bio,
    required this.followers,
    required this.following,
    required this.posts,
    required this.comments,
    required this.socialMedia,
  });

 factory ProfileDto.fromJson(Map<String, dynamic> json) {
  print("🔍 Parsing ProfileDto JSON: $json"); // Debugging log

  return ProfileDto(
    id: json['_id'] as String?,
    userName: json['username'] ?? 'Unknown',
    firstName: json['firstname'] ?? '',
    lastName: json['lastname'] ?? '',
    profilePicture: json['image'] ?? 'default.png',
    bio: json['bio'] ?? '',
    followers: (json['followers'] as List<dynamic>?)?.whereType<String>().toList() ?? [],
    following: (json['following'] as List<dynamic>?)?.whereType<String>().toList() ?? [],
    posts: (json['posts'] as List<dynamic>?)?.whereType<String>().toList() ?? [], // ✅ Removes nulls
    comments: (json['comments'] as List<dynamic>?)?.whereType<String>().toList() ?? [],
    socialMedia: (json['socialMedia'] as List<dynamic>?)?.whereType<String>().toList() ?? [],
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': userName,
      'firstname': firstName,
      'lastname': lastName,
      'image': profilePicture,
      'bio': bio,
      'followers': followers,
      'following': following,
      'posts': posts,
      'comments': comments,
      'socialMedia': socialMedia,
    };
  }
}
