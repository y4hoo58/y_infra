import 'package:firebase_database/firebase_database.dart';

import '../handlers/i_event_handler.dart';
import '../objects/db_reference_path.dart';

abstract class IFirebaseRealtimeDatabaseService {
  const IFirebaseRealtimeDatabaseService();

  FirebaseDatabase get db => FirebaseDatabase.instance;

  void init();

  void set(
    IFirebaseDbReferencePath path,
    IFirebaseDatabaseEventHandler eventHandler,
  );
}
