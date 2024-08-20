import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/src/bloc/profile/profile_event.dart';
import 'package:instagram/src/bloc/profile/profile_state.dart';
import 'package:instagram/src/repository/profile_repository.dart';

import '../../repository/post_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository = ProfileRepository();
  final PostRepository postRepository = PostRepository();

  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileFetchingEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        final userModel = await profileRepository.fetchProfile(event.uid);
        final userPostsFuture = postRepository.fetchUserPosts(event.uid);

        emit(ProfileLoaded(userModel: userModel ,userPosts: userPostsFuture ));
        print(userModel.toJson());
      } catch (e) {
        emit(ProfileError(message: e.toString()));
      }
    });

    on<ProfileUpdatingEvent>((event, emit) async {
      emit(ProfileUpdating());
      try {
        final isUpdated =
            await profileRepository.updateProfile(event.userModel);
        if (isUpdated) {
          emit(ProfileUpdated());
        } else {
          emit(ProfileError(message: 'Update failed'));
        }
      } catch (e) {
        emit(ProfileError(message: e.toString()));
      }
    });
  }
}
