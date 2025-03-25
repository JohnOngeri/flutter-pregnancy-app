import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/application/profile/bloc/profile_bloc.dart';
import 'package:frontend/application/profile/bloc/profile_event.dart';
import 'package:frontend/application/profile/bloc/profile_state.dart';
import 'package:frontend/domain/profile/profile.dart';
import 'package:frontend/presentation/core/constants/assets.dart';
import 'package:frontend/presentation/profile/components/textfield.dart';
import 'package:frontend/presentation/profile/components/profileavatar.dart';
import 'dart:convert';

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // Add functionality to upload a new profile picture
                print('Upload profile picture');
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/images/placeholder_person.png'),
                child:
                    const Icon(Icons.camera_alt, size: 30, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Tap to change profile picture'),
          ],
        ),
      ),
    );
  }
}

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      Future.microtask(() {
        setState(() {
          _image = File(pickedImage.path);
        });
      });
    }
  }

  late ProfileBloc profileBloc;

  late String firstName = '';
  late String lastName = '';
  late String imageUrl = '';
  late String bio = '';
  late String username = '';

  @override
  void initState() {
    super.initState();
    profileBloc = BlocProvider.of<ProfileBloc>(context);
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    profileBloc
        .add(ProfileEventGetProfile(profileId: '64773ac7ba6d773eeec4120e'));
  }

  Future<String> convertImageToBase64(File imageFile) async {
    return compute(_encodeImageToBase64, imageFile);
  }

  static String _encodeImageToBase64(File imageFile) {
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileStateLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProfileStateSuccess) {
            final profile = state.profile;
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 44),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          "Edit Profile",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 210,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(Assets.assetsImagesFancyBack),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned(
                        height: 250,
                        right: MediaQuery.of(context).size.width / 2 - 60,
                        child: ProfileWidget(
                          imagePath: imageUrl != ''
                              ? imageUrl
                              : profile.profilePicture,
                          onClicked: () {
                            _pickImage(ImageSource.gallery);
                          },
                          isEdit: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFieldWidget(
                      label: 'Username',
                      text: profile.userName,
                      onChanged: (name) {
                        setState(() {
                          username = name != '' ? name : profile.userName;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFieldWidget(
                      label: 'Password',
                      text: "*********",
                      onChanged: (password) {
                        setState(() {
                          // Handle password change logic here
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: 250,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 226, 89, 89),
                      ),
                      onPressed: () async {
                        if (_image != null) {
                          String base64Image =
                              await convertImageToBase64(_image!);
                          setState(() {
                            imageUrl = base64Image;
                          });
                        }

                        ProfileForm profileForm = ProfileForm(
                          firstName: profile.firstName,
                          lastName: profile.lastName,
                          followers: profile.followers,
                          following: profile.following,
                          profilePicture: imageUrl != ''
                              ? imageUrl
                              : profile.profilePicture,
                          socialMedia: profile.socialMedia,
                          bio: profile.bio,
                          userName: username != ''
                              ? username
                              : profile.userName, // Pass userName here
                        );

                        profileBloc.add(ProfileEventUpdate(
                            profileId: profile.id ?? '',
                            profileForm: profileForm));

                        Navigator.pop(context);
                      },
                      child: Text(
                        "Done",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: 250,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                            color: Color.fromARGB(255, 226, 89, 89),
                            fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          } else if (state is _EditProfileState) {
            fetchProfile();
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(child: Text('Failed to load profile'));
          }
        },
      ),
    );
  }
}
