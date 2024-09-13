part of 'database_bloc.dart';

sealed class DatabaseEvent {}

class LoadBookmarks extends DatabaseEvent {}

class AddBookmark extends DatabaseEvent {
  final Restaurant restaurant;

  AddBookmark(this.restaurant);
}

class RemoveBookmark extends DatabaseEvent {
  final Restaurant restaurant;

  RemoveBookmark(this.restaurant);
}

class CheckBookmarked extends DatabaseEvent {
  final String id;

  CheckBookmarked(this.id);
}