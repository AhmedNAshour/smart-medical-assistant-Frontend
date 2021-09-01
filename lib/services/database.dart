import 'package:chatbot/models/report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatbot/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection references
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference reportsCollection =
      FirebaseFirestore.instance.collection('reports');

  UserModel _userDataFromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data();
    return UserModel(
      uid: uid,
      fName: data['fName'],
      lName: data['lName'],
      gender: data['gender'],
      password: data['password'],
      email: data['email'],
    );
  }

  Stream<UserModel> get userData {
    return usersCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // create or update user
  Future updateUserData({
    String fName,
    String lName,
    int age,
    String gender,
    String password,
    String email,
  }) async {
    return await usersCollection.doc(uid).set({
      'fName': fName,
      'lName': lName,
      'gender': gender,
      'password': password,
      'email': email,
      'age': age,
    });
  }

  Future<ReportModel> getReport() async {
    DocumentSnapshot doc = await reportsCollection.doc(uid).get();
    ReportModel report = ReportModel(
      userID: doc['userID'] ?? '',
      status: doc['status'] ?? '',
      fever: doc['fever'] ?? '',
      tiredness: doc['tiredness'] ?? '',
      dryCough: doc['dryCough'] ?? '',
      difficultyBreathing: doc['difficultyBreathing'] ?? '',
      soreThroat: doc['soreThroat'] ?? '',
      pains: doc['pains'] ?? '',
      nasalCongestion: doc['nasalCongestion'] ?? '',
      runnyNose: doc['runnyNose'] ?? '',
      diarrhea: doc['diarrhea'] ?? '',
      smellTasteLoss: doc['smellTasteLoss'] ?? '',
      modelResult: doc['modelResult'] ?? '',
      labResult: doc['labResult'] ?? '',
      longitude: doc['long'] ?? 0,
      latitude: doc['lat'] ?? 0,
      dateConfirmed:
          DateTime.parse(doc['dateConfirmed'].toDate().toString()) ?? '' ?? '',
      dateCreated:
          DateTime.parse(doc['dateCreated'].toDate().toString()) ?? '' ?? '',
    );
    return report;
  }

  List<ReportModel> _reportsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ReportModel(
        docID: doc.id,
        userID: doc['userID'] ?? '',
        status: doc['status'] ?? '',
        fever: doc['fever'] ?? '',
        tiredness: doc['tiredness'] ?? '',
        dryCough: doc['dryCough'] ?? '',
        difficultyBreathing: doc['difficultyBreathing'] ?? '',
        soreThroat: doc['soreThroat'] ?? '',
        pains: doc['pains'] ?? '',
        nasalCongestion: doc['nasalCongestion'] ?? '',
        runnyNose: doc['runnyNose'] ?? '',
        diarrhea: doc['diarrhea'] ?? '',
        smellTasteLoss: doc['smellTasteLoss'] ?? '',
        modelResult: doc['modelResult'] ?? '',
        labResult: doc['labResult'] ?? '',
        longitude: doc['long'] ?? 0,
        latitude: doc['lat'] ?? 0,
        dateConfirmed:
            DateTime.parse(doc['dateConfirmed'].toDate().toString()) ??
                '' ??
                '',
        dateCreated:
            DateTime.parse(doc['dateCreated'].toDate().toString()) ?? '' ?? '',
      );
    }).toList();
  }

  Stream<List<ReportModel>> getReports({String userID, String status}) {
    Query query = reportsCollection;
    if (userID != '') {
      query = query.where('userID', isEqualTo: userID);
    }
    if (status != '') {
      query = query.where('status', isEqualTo: status);
    }

    return query.snapshots().map(_reportsListFromSnapshot);
  }

  // create or update report
  Future addReport({
    String userID,
    String status,
    bool fever,
    bool tiredness,
    bool dryCough,
    bool difficultyBreathing,
    bool soreThroat,
    bool pains,
    bool nasalCongestion,
    bool runnyNose,
    bool diarrhea,
    bool smellTasteLoss,
    bool modelResult,
    bool labResult,
    double long,
    double lat,
  }) async {
    return await reportsCollection.doc(userID).set({
      'userID': userID,
      'status': status,
      'fever': fever,
      'tiredness': tiredness,
      'dryCough': dryCough,
      'difficultyBreathing': difficultyBreathing,
      'soreThroat': soreThroat,
      'pains': pains,
      'nasalCongestion': nasalCongestion,
      'runnyNose': runnyNose,
      'diarrhea': diarrhea,
      'smellTasteLoss': smellTasteLoss,
      'modelResult': modelResult,
      'labResult': labResult,
      'dateCreated': FieldValue.serverTimestamp(),
      'dateConfirmed': FieldValue.serverTimestamp(),
      'long': long,
      'lat': lat,
    });
  }

  Future updateReport({
    String docID,
    String userID,
    String status,
    bool fever,
    bool tiredness,
    bool dryCough,
    bool difficultyBreathing,
    bool soreThroat,
    bool pains,
    bool nasalCongestion,
    bool runnyNose,
    bool diarrhea,
    bool smellTasteLoss,
    bool modelResult,
    bool labResult,
  }) async {
    try {
      await reportsCollection.doc(userID).update({
        'status': status,
        'fever': fever,
        'tiredness': tiredness,
        'dryCough': dryCough,
        'difficultyBreathing': difficultyBreathing,
        'soreThroat': soreThroat,
        'pains': pains,
        'nasalCongestion': nasalCongestion,
        'runnyNose': runnyNose,
        'diarrhea': diarrhea,
        'smellTasteLoss': smellTasteLoss,
        'modelResult': modelResult,
        'labResult': labResult,
        'dateConfirmed': FieldValue.serverTimestamp(),
      });
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
