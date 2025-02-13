class DailyJournal {
  int? id; 
  DateTime dayOfEntry; 
  String journal; 

  DailyJournal(this.id, this.dayOfEntry, this.journal); 

  DailyJournal.appGen(this.dayOfEntry, this.journal); 

  Map<String, Object?> toDB() {

    Map<String, Object?> map = {
      'dayOfEntry': dayOfEntry.toIso8601String(), 
      'journal': journal,
    }; 

    if (id != null) {
      map['id'] = id; 
    }

    return map; 
  }

}