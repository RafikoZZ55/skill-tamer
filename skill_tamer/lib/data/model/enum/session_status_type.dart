enum SessionStatusType {
  completed,
  abandoned,
  fullyCompleted;


  static SessionStatusType get({required String sessionStatusType}){
    return SessionStatusType.values.firstWhere((e) => e.name == sessionStatusType);
  }
}