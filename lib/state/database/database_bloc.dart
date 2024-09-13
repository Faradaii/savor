import 'package:bloc/bloc.dart';
import 'package:savor/data/db/database_helper.dart';
import 'package:savor/data/model/restaurant.dart';

part 'database_event.dart';
part 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  final DatabaseHelper databaseHelper;

  DatabaseBloc({required this.databaseHelper}) : super(DatabaseInitial()) {
    on<LoadBookmarks>((event, emit) async {
      emit(DatabaseLoading());
      try {
        final bookmarks = await databaseHelper.getBookmarks();
        emit(DatabaseLoaded(bookmarks));
      } catch (e) {
        emit(DatabaseError('Failed to load bookmarks: ${e.toString()}'));
      }
    });

    on<AddBookmark>((event, emit) async {
      try {
        final message = await databaseHelper.insertBookmark(event.restaurant);
        emit(BookmarkMessage(message: message));
        add(CheckBookmarked(event.restaurant.id.toString()));
      } catch (e) {
        emit(BookmarkMessage(message: 'Failed to add bookmark'));
      }
    });

    on<RemoveBookmark>((event, emit) async {
      try {
        final message =
            await databaseHelper.removeBookmark(event.restaurant.id);
        emit(BookmarkMessage(message: message));
        add(CheckBookmarked(event.restaurant.id.toString()));
      } catch (e) {
        emit(BookmarkMessage(message: 'Failed to remove bookmark'));
      }
    });

    on<CheckBookmarked>((event, emit) async {
      try {
        final isBookmarked = await databaseHelper.isBookmarked(event.id);
        emit(BookmarkChecked(isBookmarked));
      } catch (e) {
        emit(BookmarkMessage(message: 'Failed to check bookmark'));
      }
    });
  }
}
