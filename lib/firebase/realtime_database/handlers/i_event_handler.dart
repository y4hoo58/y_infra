import 'package:firebase_database/firebase_database.dart';

/// Interface for handling a Firebase Realtime Database event.
abstract class IFirebaseDatabaseEventHandler {
  const IFirebaseDatabaseEventHandler();

  void handle(DatabaseEvent event);
}
