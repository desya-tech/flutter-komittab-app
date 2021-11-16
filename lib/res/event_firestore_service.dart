import 'package:firebase_helpers/firebase_helpers.dart';
import '../model/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

DatabaseService<EventModel> eventDBS = DatabaseService<EventModel>("events",
    fromDS: (id, data) => EventModel.fromDS(id, data),
    toMap: (event) => event.toMap());

class DatabaseServices {
  static CollectionReference categoryCollection =
      // ignore: deprecated_member_use
      Firestore.instance.collection('category');
  static Future<DocumentSnapshot> getCategory() async {
    // ignore: deprecated_member_use
    return await categoryCollection.document().get();
  }

  static CollectionReference listEventCollection =
      Firestore.instance.collection('events');
  static Future<DocumentSnapshot> getListEvent() async {
    // ignore: deprecated_member_use
    return await listEventCollection.document().get();
  }
}
