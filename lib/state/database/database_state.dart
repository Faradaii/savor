part of 'database_bloc.dart';

sealed class DatabaseState {}

final class DatabaseInitial extends DatabaseState {}

class DatabaseLoading extends DatabaseState {}

class DatabaseLoaded extends DatabaseState {
  final List<Restaurant> bookmarks;

  DatabaseLoaded(this.bookmarks);
}

class DatabaseError extends DatabaseState {
  final String message;

  DatabaseError(this.message);
}


class BookmarkMessage extends DatabaseState {
  final String message;

  BookmarkMessage({required this.message});
}

class BookmarkChecked extends DatabaseState {
  final bool isBookmarked;

  BookmarkChecked(this.isBookmarked);
}