import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:frontend/domain/profile/profile.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import 'package:frontend/infrastructure/profile/profile_form_mapper.dart';
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepositoryInterface profileRepositoryInterface;

  ProfileBloc({required this.profileRepositoryInterface}) : super(const ProfileStateInitial()) {
    // Log when the ProfileBloc is created
    print("[DEBUG] ProfileBloc initialized");

    // Handle ProfileEventGetProfile
    on<ProfileEventGetProfile>((event, emit) async {
      print("[DEBUG] ProfileEventGetProfile triggered for profileId: ${event.profileId}");
      emit(const ProfileStateLoading());
      print("[DEBUG] Emitted ProfileStateLoading");

      // Fetch profile from repository
      print("[DEBUG] Fetching profile from repository for profileId: ${event.profileId}");
      Either<ProfileFailure, ProfileDomain> result = await profileRepositoryInterface.getProfile(event.profileId);

      // Handle result
      result.fold(
        (failure) {
          print("[DEBUG] Profile fetch failed: ${failure.toString()}");
          emit(ProfileStateFailure(failure: failure));
          print("[DEBUG] Emitted ProfileStateFailure");
        },
        (profile) {
          print("[DEBUG] Profile fetch successful: ${profile.toString()}");
          emit(ProfileStateSuccess(profile: profile));
          print("[DEBUG] Emitted ProfileStateSuccess");
        },
      );
    });

    // Handle ProfileEventUpdate
    on<ProfileEventUpdate>((event, emit) async {
      print("[DEBUG] ProfileEventUpdate triggered for profileId: ${event.profileId}");
      emit(const ProfileStateLoading());
      print("[DEBUG] Emitted ProfileStateLoading");

      // Log the ProfileForm data being sent
      print("[DEBUG] Updating profile with data: ${event.profileForm.toDto().toJson()}");

            try {
              // Update profile in repository
              print("[DEBUG] Updating profile in repository for profileId: ${event.profileId}");
              Either<ProfileFailure, ProfileDomain> result = 
                  await profileRepositoryInterface.updateProfile(profileForm: event.profileForm, profileId: event.profileId);
      
              // Handle result
              result.fold(
                (failure) {
                  print("[DEBUG] Profile update failed: ${failure.toString()}");
                  if (failure is ProfileFailure && failure == ProfileFailure.serverError()) {
                    print("[DEBUG] Server error details: ${failure.toString()}");
                  }
                  emit(ProfileStateFailure(failure: failure));
                  print("[DEBUG] Emitted ProfileStateFailure");
                },
                (updatedProfile) {
                  print("[DEBUG] Profile update successful: ${updatedProfile.toString()}");
                  emit(ProfileStateSuccess(profile: updatedProfile));
                  print("[DEBUG] Emitted ProfileStateSuccess");
                },
        );
     } catch (e) {
       print("[DEBUG] Unexpected error during profile update: ${e.toString()}");
       if (e is Error) {
         print("[DEBUG] Stack trace: ${e.stackTrace}");
       } else {
         print("[DEBUG] No stack trace available");
       }
       emit(ProfileStateFailure(failure: ProfileFailure.customError(e.toString())));
       print("[DEBUG] Emitted ProfileStateFailure");
     }
    });
  }
}