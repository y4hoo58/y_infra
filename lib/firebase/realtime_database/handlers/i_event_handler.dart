import 'package:firebase_database/firebase_database.dart';

abstract class IFirebaseDatabaseEventHandler {
  const IFirebaseDatabaseEventHandler();

  void handle(DatabaseEvent event);
}
