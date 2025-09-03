enum Gender {
  male,
  female,
  other
}
extension GenderExtension on Gender {
  String get displayGender {
    switch (this) {
      case Gender.male:
        return 'male';
      case Gender.female:
        return 'female';
      case Gender.other:
        return 'other';
    }
  }
  static fromString(String str) {
  switch (str.toLowerCase()) {
    case 'male':
      return Gender.male;
    case 'female':
      return Gender.female;
    case 'other':
      return Gender.other;
    default:
      throw ArgumentError('Unknown gender: $str');
  }
}
}
