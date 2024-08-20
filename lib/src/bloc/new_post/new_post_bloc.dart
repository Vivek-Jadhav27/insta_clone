import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/post_repository.dart';
import 'new_post_event.dart';
import 'new_post_state.dart';

class NewPostBloc extends Bloc<NewPostEvent, NewPostState> {
  final PostRepository postRepository = PostRepository();

  NewPostBloc() : super(NewPostInitialState()) {
    on<SubmitPostEvent>(_submitPost);
    on<CaptionChangedEvent>(_captionChanged);
  }

  void _submitPost(
    SubmitPostEvent event,
    Emitter<NewPostState> emit,
  ) {
    emit(NewPostLoadingState());

    try {
      if (event.selectedFiles.isEmpty) {
        emit(NewPostErrorState(message: 'Please select at least one image'));
        return;
      }
      postRepository.addPost(event.caption, event.selectedFiles);
      emit(NewPostSuccessState());
    } catch (e) {
      emit(NewPostErrorState(message: 'Error submitting post: $e'));
    }
  }

  void _captionChanged(
    CaptionChangedEvent event,
    Emitter<NewPostState> emit,
  ) {
    emit(CaptionUpdated(caption: event.caption));
  }
}
