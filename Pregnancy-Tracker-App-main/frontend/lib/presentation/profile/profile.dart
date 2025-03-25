import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/application/comment/bloc/comment_bloc.dart';
import 'package:frontend/application/comment/bloc/comment_event.dart';
import 'package:frontend/application/comment/bloc/comment_state.dart';
import 'package:frontend/application/post/post_list/bloc/post_list_bloc.dart';
import 'package:frontend/application/post/post_list/bloc/post_list_events.dart';
import 'package:frontend/application/post/post_list/bloc/post_list_state.dart';
import 'package:frontend/application/profile/bloc/profile_event.dart';
import 'package:frontend/domain/auth/user_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/local_data/shared_preferences/jj_shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../application/profile/bloc/profile_bloc.dart';
import '../../application/profile/bloc/profile_state.dart';
import '../core/constants/assets.dart';
import 'components/commentcard.dart';
import 'components/editprofile.dart';
import 'components/links.dart';
import 'components/postcard.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PostListBloc _postListBloc;
  late CommentBloc _commentBloc;
  late ProfileBloc _profileBloc;
  Uint8List? _decodedImage;
  String? profileId; // Dynamic profileId
  String? username; // Dynamic username

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _postListBloc = BlocProvider.of<PostListBloc>(context);
    _commentBloc = BlocProvider.of<CommentBloc>(context);
    _profileBloc = BlocProvider.of<ProfileBloc>(context);

    // Fetch the profileId and username dynamically
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    final prefs = SharedPreferenceService();
    final id = await prefs.getProfileId();
    final user = await prefs.getAuthenticatedUser();

    if (id != null && user != null) {
      setState(() {
        profileId = id;
        username =
            user.userName; // Assuming userName is part of the user object
      });
      _fetchProfileData(id);
    } else {
      print("Profile ID or username not found in shared preferences.");
    }
  }

  Future<void> _fetchProfileData(String userId) async {
    _postListBloc.add(PostListEventLoadByAuthor(userId));
    _commentBloc.add(CommentEventGetUserComments(userId));
    _profileBloc.add(ProfileEventGetProfile(profileId: userId));
  }

  Future<void> _decodeImage(String profilePicture) async {
    if (profilePicture.startsWith('http')) {
      setState(() => _decodedImage = null);
    } else if (_isValidBase64(profilePicture)) {
      try {
        final bytes = base64Decode(profilePicture);
        setState(() => _decodedImage = bytes);
      } on FormatException catch (e) {
        print("Error decoding image: $e");
        setState(() => _decodedImage = null);
      }
    } else {
      setState(() => _decodedImage = null);
    }
  }

  bool _isValidBase64(String str) {
    try {
      base64Decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (profileId == null || username == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileStateSuccess) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _decodeImage(state.profile.profilePicture);
              });

              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  _buildProfileHeader(state.profile),
                  _buildTabBar(),
                ],
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPostsTab(),
                    _buildCommentsTab(),
                    _buildLinksTab(),
                  ],
                ),
              );
            } else if (state is ProfileStateLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text('Failed to load profile'));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditProfile()),
        ),
        child: const Icon(Icons.edit),
      ),
    );
  }

  SliverAppBar _buildProfileHeader(profile) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3), // Light grey background
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: 12.0, vertical: 4.0), // Padding around the text
          child: Text(
            '@${username ?? "Unknown"}', // Dynamically display the username
            style: const TextStyle(
              color: Colors.white, // White text color
              fontWeight: FontWeight.w800,
              fontSize: 20.0,
            ),
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.blue, Colors.blueAccent],
            ),
            image: DecorationImage(
              image: _getProfileImageProvider(profile.profilePicture),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      leading: GestureDetector(
        onTap: () {
          context.go('/landingpage');
        },
        child: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1), // Circular background
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8.0),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white, // Arrow color
          ),
        ),
      ),
    );
  }

  ImageProvider _getProfileImageProvider(String profilePicture) {
    if (_decodedImage != null) {
      return MemoryImage(_decodedImage!);
    } else if (profilePicture.startsWith('http')) {
      return NetworkImage(profilePicture);
    } else {
      return AssetImage(Assets.assetsImagesWomanProfile);
    }
  }

  // Other methods (_buildTabBar, _buildPostsTab, _buildCommentsTab, _buildLinksTab) remain the same
}

SliverPersistentHeader _buildTabBar() {
  return SliverPersistentHeader(
    delegate: _SliverAppBarDelegate(
      TabBar(
        tabs: const [
          Tab(text: 'Posts'),
          Tab(text: 'Comments'),
          Tab(text: 'Likes'),
        ],
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black.withOpacity(0.3),
      ),
    ),
  );
}

Widget _buildPostsTab() {
  return BlocBuilder<PostListBloc, PostListState>(
    builder: (context, state) {
      if (state is PostListStateLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is PostListStateSuccess) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 7.0),
          itemCount: state.post.length,
          itemBuilder: (context, index) {
            final post = state.post[index];
            return BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, profileState) {
                if (profileState is ProfileStateSuccess) {
                  return PostCard(
                    author: profileState.profile.userName,
                    description: post.body,
                    likeCount: post.likes.length,
                    commentCount: post.comments.length,
                    imageUrl: profileState.profile.profilePicture,
                  );
                } else {
                  return const Center(child: Text('Failed to load profile'));
                }
              },
            );
          },
        );
      } else {
        return const Center(child: Text('Failed to load posts'));
      }
    },
  );
}

Widget _buildCommentsTab() {
  return BlocBuilder<CommentBloc, CommentState>(
    builder: (context, state) {
      if (state is CommentStateLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is CommentStateSuccessMultiple) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 7.0),
          itemCount: state.comments.length,
          itemBuilder: (context, index) {
            final comment = state.comments[index];
            return CommentCard(description: comment.body);
          },
        );
      } else {
        return const Center(child: Text('Failed to load comments'));
      }
    },
  );
}

Widget _buildLinksTab() {
  return GridView.count(
    crossAxisCount: 2,
    children: List.generate(4, (index) {
      return Linkcard(icon: 'path/to/icon$index.png');
    }),
  );
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.transparent,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) => false;
}

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: const Center(
        child: Text('Edit Profile Page'),
      ),
    );
  }
}

Future<String?> getProfileId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('profileId');
}

Future<UserDomain?> getAuthenticatedUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final userJson = prefs.getString('authenticatedUser');
  if (userJson != null) {
    return UserDomain.fromJson(jsonDecode(userJson));
  }
  return null;
}
