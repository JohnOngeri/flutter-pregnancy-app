import 'dart:async';

import 'package:frontend/domain/appointment/appointment_domain.dart';
import 'package:frontend/domain/appointment/local/appointment_entity.dart';
import 'package:frontend/domain/appointment/local/appointment_entity_mapper.dart';
import 'package:frontend/domain/comment/comment_domain.dart';
import 'package:frontend/domain/comment/local/comment_entity.dart';
import 'package:frontend/domain/comment/local/comment_entity_mapper.dart';
import 'package:frontend/domain/note/local/note_entity.dart';
import 'package:frontend/domain/note/local/note_entity_mapper.dart';
import 'package:frontend/domain/note/note_domain.dart';
import 'package:frontend/domain/post/local/post_entity.dart';
import 'package:frontend/domain/post/local/post_entity_mapper.dart';
import 'package:frontend/domain/post/post_domain.dart';
import 'package:frontend/domain/profile/local/profile_entity.dart';
import 'package:frontend/domain/profile/profile.dart';
import 'package:frontend/domain/tip/local/tip_entity.dart';
import 'package:frontend/domain/tip/local/tip_entity_mapper.dart';
import 'package:frontend/domain/tip/tip_domain.dart';
import 'package:frontend/infrastructure/appointment/appointment_dto.dart';
import 'package:frontend/infrastructure/appointment/appointment_mapper.dart';
import 'package:frontend/infrastructure/comment/comment_dto.dart';
import 'package:frontend/infrastructure/comment/comment_mapper.dart';
import 'package:frontend/infrastructure/note/note_dto.dart';
import 'package:frontend/infrastructure/note/note_mapper.dart';
import 'package:frontend/infrastructure/post/post_dto.dart';
import 'package:frontend/infrastructure/post/post_mapper.dart';
import 'package:frontend/infrastructure/profile/profile_dto.dart';
import 'package:frontend/infrastructure/profile/profile_mapper.dart';
import 'package:frontend/infrastructure/tip/tip_dto.dart';
import 'package:frontend/infrastructure/tip/tip_mapper.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'
 show databaseFactory, databaseFactoryFfi;
 import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // for web factory
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  // Initialization
  DatabaseHelper._privateConstructor();
  static DatabaseHelper get instance => _instance;

Future<Database> get database async {
  print('Getting database...'); // Debugging print statement
  print('_database is currently: $_database'); // Debugging print statement
  if (_database == null) {
    _database = await _initDatabase();
  }
  return _database?? await _initDatabase();
}

  // Initialize database
  // Initialize database
Future<Database> _initDatabase() async {
  try {
    // ... (rest of the method remains the same)

    final path = kIsWeb 
      ? 'pregnancy_tracker.db' 
      : join(await getDatabasesPath(), 'pregnancy_tracker.db');

    print('Database path: $path'); // Add this line to print the database path

    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 3,
        onCreate: _onCreate,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
      ),
    );
  } catch (e) {
    print('Error opening database: $e'); // Add this line to print the error
    rethrow;
  }
}

  // On database creation
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE appointment (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        author TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE comment (
        id TEXT PRIMARY KEY,
        body TEXT NOT NULL,
        postId TEXT NOT NULL,
        author TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE note (
        id TEXT PRIMARY KEY,
        body TEXT NOT NULL,
        title TEXT NOT NULL,
        author TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE post (
        id TEXT PRIMARY KEY,
        body TEXT NOT NULL,
        author TEXT NOT NULL,
        comments TEXT NOT NULL,
        likes TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE profile (
        id TEXT PRIMARY KEY,
        userName TEXT NOT NULL,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        bio TEXT NOT NULL,
        profilePicture TEXT NOT NULL,
        followers TEXT NOT NULL,
        following TEXT NOT NULL,
        posts TEXT NOT NULL,
        comments TEXT NOT NULL,
        socialMedia TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE tip (
        id TEXT PRIMARY KEY,
        body TEXT NOT NULL,
        title TEXT NOT NULL,
        type TEXT NOT NULL
      )
    ''');
  }

  // get all requests
  Future<List<PostDomain>> getPosts() async {
    final Database db = await database;
    final List<Map<String, dynamic>> postsList = await db.query("post");
    List<PostEntity> postEntityList = postsList.isEmpty
        ? []
        : postsList.map((post) => PostEntity.fromSqlJson(post)).toList();

    List<PostDomain> postDomainList = postEntityList.isEmpty
        ? []
        : postEntityList.map((post) => post.toPostDomain()).toList();

    return postDomainList;
  }

  Future<List<CommentDomain>> getComments() async {
    final Database db = await database;
    final List<Map<String, dynamic>> commentsList = await db.query("comment");
    List<CommentEntity> commentEntityList = commentsList.isEmpty
        ? []
        : commentsList
            .map((comment) => CommentEntity.fromJson(comment))
            .toList();

    List<CommentDomain> commentDomainList = commentEntityList.isEmpty
        ? []
        : commentEntityList
            .map((comment) => comment.toCommentDomain())
            .toList();

    return commentDomainList;
  }

  Future<List<TipDomain>> getTips() async {
    final Database db = await database;
    final List<Map<String, dynamic>> tipsList = await db.query("tip");
    List<TipEntity> tipEntityList = tipsList.isEmpty
        ? []
        : tipsList.map((tip) => TipEntity.fromJson(tip)).toList();

    List<TipDomain> tipDomainList = tipEntityList.isEmpty
        ? []
        : tipEntityList.map((tip) => tip.toTipDomain()).toList();

    return tipDomainList;
  }

  // get by id requests
  Future<List<AppointmentDomain>> getAppointmentsByUser(String author, 
    {bool forceRefresh = false}) async {
  try {
    final Database db = await database;
    
    // Clear cache if forcing refresh (optional)
    if (forceRefresh) {
      await db.execute('PRAGMA wal_checkpoint(FULL)');
    }

    final List<Map<String, dynamic>> appointmentList =
        await db.query(
          "appointment", 
          where: "author = ?", 
          whereArgs: [author],
          // Ensure we get fresh data
          
        );

    // Convert to domain objects
    return appointmentList
        .map((appointment) => AppointmentEntity.fromJson(appointment).toAppointmentDomain())
        .toList();
        
  } catch (e) {
    debugPrint('Error fetching appointments: $e');
    rethrow;
  }
}

// Add this companion method to handle updates
Future<List<AppointmentDomain>> updateAndRefreshAppointments(
    String author, 
    Future<void> Function() updateOperation) async {
  try {
    await updateOperation(); // Perform the update
    return await getAppointmentsByUser(author, forceRefresh: true);
  } catch (e) {
    debugPrint('Refresh failed: $e');
    rethrow;
  }
}
  Future<List<CommentDomain>> getCommentsByUser(String author) async {
    final Database db = await database;
    final List<Map<String, dynamic>> commentList =
        await db.query("comment", where: "author = ?", whereArgs: [author]);
    List<CommentEntity> commentEntityList = commentList.isEmpty
        ? []
        : commentList
            .map((comment) => CommentEntity.fromJson(comment))
            .toList();

    List<CommentDomain> commentDomainList = commentEntityList.isEmpty
        ? []
        : commentEntityList
            .map((comment) => comment.toCommentDomain())
            .toList();

    return commentDomainList;
  }

  Future<List<CommentDomain>> getCommentsByPost(String postId) async {
    final Database db = await database;
    final List<Map<String, dynamic>> commentList =
        await db.query("comment", where: "postId = ?", whereArgs: [postId]);
    List<CommentEntity> commentEntityList = commentList.isEmpty
        ? []
        : commentList
            .map((comment) => CommentEntity.fromJson(comment))
            .toList();

    List<CommentDomain> commentDomainList = commentEntityList.isEmpty
        ? []
        : commentEntityList
            .map((comment) => comment.toCommentDomain())
            .toList();

    return commentDomainList;
  }

  Future<List<NoteDomain>> getNotesByUser(String author) async {
    final Database db = await database;
    final List<Map<String, dynamic>> noteList =
        await db.query("note", where: "author = ?", whereArgs: [author]);
    List<NoteEntity> noteEntityList = noteList.isEmpty
        ? []
        : noteList.map((note) => NoteEntity.fromJson(note)).toList();

    List<NoteDomain> noteDomainList = noteEntityList.isEmpty
        ? []
        : noteEntityList.map((note) => note.toNoteDomain()).toList();

    return noteDomainList;
  }

  Future<List<PostDomain>> getPostsByUser(String author) async {
    final Database db = await database;
    final List<Map<String, dynamic>> postList =
        await db.query("post", where: "author = ?", whereArgs: [author]);
    List<PostEntity> postEntityList = postList.isEmpty
        ? []
        : postList.map((post) => PostEntity.fromJson(post)).toList();

    List<PostDomain> postDomainList = postEntityList.isEmpty
        ? []
        : postEntityList.map((post) => post.toPostDomain()).toList();

    return postDomainList;
  }

  Future<List<TipDomain>> getTipsByType(String type) async {
    final Database db = await database;
    final List<Map<String, dynamic>> tipList =
        await db.query("tip", where: "type = ?", whereArgs: [type]);
    List<TipEntity> tipEntityList = tipList.isEmpty
        ? []
        : tipList.map((tip) => TipEntity.fromJson(tip)).toList();

    List<TipDomain> tipDomainList = tipEntityList.isEmpty
        ? []
        : tipEntityList.map((tip) => tip.toTipDomain()).toList();

    return tipDomainList;
  }

  Future<ProfileDomain> getProfile(String id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> profileList =
        await db.query("profile", where: "id = ?", whereArgs: [id]);

    ProfileEntity profileEntity = ProfileEntity.fromSqlJson(profileList.first);
    return profileEntity.toProfileDomain();
  }

  // remove requests
  Future<void> removeAppointment(String id) async {
    final Database db = await database;
    await db.delete("appointment", where: "id = ?", whereArgs: [id]);
  }

  Future<void> removeComment(String id) async {
    final Database db = await database;
    await db.delete("comment", where: "id = ?", whereArgs: [id]);
  }

  Future<void> removeNote(String id) async {
    final Database db = await database;
    await db.delete("note", where: "id = ?", whereArgs: [id]);
  }

  Future<void> removePost(String id) async {
    final Database db = await database;
    await db.delete("post", where: "id = ?", whereArgs: [id]);
  }

  Future<void> removeProfile(String id) async {
    final Database db = await database;
    await db.delete("profile", where: "id = ?", whereArgs: [id]);
  }

  Future<void> removeTip(String id) async {
    final Database db = await database;
    await db.delete("tip", where: "id = ?", whereArgs: [id]);
  }

  Future<void> removeAll() async {
    final Database db = await database;
    final batch = db.batch();
    batch.delete("appointment");
    batch.delete("comment");
    batch.delete("note");
    batch.delete("post");
    batch.delete("profile");
    batch.delete("tip");
    await batch.commit(noResult: true);
  }

  // add requests
 Future<void> addAppointments(List<AppointmentDto> appointmentDtoList) async {
  final Database db = await database;
  await db.transaction((transac) async {
    final batch = transac.batch();

    for (AppointmentDto appointmentDto in appointmentDtoList) {
      try {
        final appointmentEntity = appointmentDto.toAppointmentEntity();
        if (appointmentEntity != null) {
          batch.insert(
            "appointment",
            appointmentEntity.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        } else {
          print("Warning: appointmentDto.toAppointmentEntity() returned null for ${appointmentDto.id}");
        }
      } catch (e, stacktrace) {
        print("Error converting appointmentDto to entity: $e");
        print(stacktrace);
      }
    }
    await batch.commit(noResult: true);
  });
}


  Future<void> addComments(List<CommentDto> commentDtoList) async {
    final Database db = await database;
    await db.transaction((transac) async {
      final batch = transac.batch();

      for (CommentDto commentDto in commentDtoList) {
        batch.insert("comment", commentDto.toCommentEntity().toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
  }

 Future<void> addNotes(List<NoteDto> noteDtoList) async {
  final Database db = await database;
  await db.transaction((transac) async {
    final batch = transac.batch();

    for (NoteDto noteDto in noteDtoList) {
      try {
        final noteEntity = noteDto.toNoteEntity();
        if (noteEntity != null) {
          batch.insert("note", noteEntity.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        } else {
          print("Warning: noteDto.toNoteEntity() returned null for ${noteDto.id}");
        }
      } catch (e, stacktrace) {
        print("Error converting noteDto to entity: $e");
        print(stacktrace);
      }
    }
    await batch.commit(noResult: true);
  });
}

  Future<void> addPosts(List<PostDto> postDtoList) async {
    final Database db = await database;
    await db.transaction((transac) async {
      final batch = transac.batch();

      for (PostDto postDto in postDtoList) {
        batch.insert("post", postDto.toPostEntity().toSqlJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
  }

  Future<void> addProfiles(List<ProfileDto> profileDtoList) async {
    final Database db = await database;
    await db.transaction((transac) async {
      final batch = transac.batch();

      for (ProfileDto profileDto in profileDtoList) {
        batch.insert("profile", profileDto.toProfileEntity().toSqlJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
  }

  Future<void> addTips(List<TipDto> tipDtoList) async {
    final Database db = await database;
    await db.transaction((transac) async {
      final batch = transac.batch();

      for (TipDto tipDto in tipDtoList) {
        batch.insert("tip", tipDto.toTipEntity().toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
  }

  // Update requests
  Future<void> updateAppointment(AppointmentEntity appointmentEntity) async {
    final Database db = await database;
    await db.insert("appointment", appointmentEntity.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateComment(CommentEntity commentEntity) async {
    final Database db = await database;
    await db.insert("comment", commentEntity.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateNote(NoteEntity noteEntity) async {
    final Database db = await database;
    await db.insert("note", noteEntity.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updatePost(PostEntity postEntity) async {
    final Database db = await database;
    await db.insert("post", postEntity.toSqlJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateProfile(ProfileEntity profileEntity) async {
    final Database db = await database;
    await db.insert("profile", profileEntity.toSqlJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateTip(TipEntity tipEntity) async {
    final Database db = await database;
    await db.insert("tip", tipEntity.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // update a user
  // Future<void> updateUser(UserDto userDto) async {
  //   final Database db = await database;
  //   await db.insert("user", userDto.toUserEntity().toJson(),
  //       conflictAlgorithm: ConflictAlgorithm.replace);
  // }

  // // update a profile
  // Future<void> putProfile(ProfileEntity profileDto) async {
  //   final Database db = await database;
  //   await db.insert("user", profileDto.toJson(),
  //       conflictAlgorithm: ConflictAlgorithm.replace);
  // }
}