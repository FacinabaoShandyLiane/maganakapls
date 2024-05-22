class ExtractDate {

  static DateTime extractDate(DateTime date) {
    var newDate =  DateTime(
      date.month,
      date.year,
      date.day,
    );
    return newDate;
  }
}
