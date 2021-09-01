class ReportModel {
  final String docID;
  final String userID;
  final String status;
  final bool fever;
  final bool tiredness;
  final bool dryCough;
  final bool difficultyBreathing;
  final bool soreThroat;
  final bool pains;
  final bool nasalCongestion;
  final bool runnyNose;
  final bool diarrhea;
  final bool smellTasteLoss;
  final bool modelResult;
  final bool labResult;
  final DateTime dateCreated;
  final DateTime dateConfirmed;
  final double longitude;
  final double latitude;

  ReportModel({
    this.docID,
    this.userID,
    this.status,
    this.fever,
    this.tiredness,
    this.dryCough,
    this.difficultyBreathing,
    this.soreThroat,
    this.pains,
    this.nasalCongestion,
    this.runnyNose,
    this.diarrhea,
    this.smellTasteLoss,
    this.modelResult,
    this.labResult,
    this.dateCreated,
    this.dateConfirmed,
    this.longitude,
    this.latitude,
  });
}
