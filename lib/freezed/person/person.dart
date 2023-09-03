/// We have the following [Person] freezed class, and [Gender] enum
/// Our backend sends the gender as raw value 0 for females and 1 for male
/// we want to be able to change [Person] model such that the `age` field
/// is typed as [Gender] instead of int, so how can we achieve this mapping
/// while keeping the same interface the backend expects
/// For example we want to consume [Person].age as an enum in our app
/// but when we update a person value on the backend we want this age
/// to transform itself into the correct int value.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'person.freezed.dart';
part 'person.g.dart';

/// Put this code in main function body for testing
// Person person = Person.fromJson({'age': 1});
// print(person.gender);
// Map<String, dynamic> serialized = person.toJson();
// Person deserialized = Person.fromJson(serialized);
//
// print(person);
// print(serialized);
// print(deserialized);

@freezed
class Person with _$Person {
  const factory Person({
    @JsonKey(name: 'age') @GenderConverter() required Gender gender,
  }) = _Person;

  factory Person.fromJson(Map<String, Object?> json) => _$PersonFromJson(json);
}

enum Gender {
  @JsonValue(0)
  female,
  @JsonValue(1)
  male,
}

class GenderConverter implements JsonConverter<Gender, int> {
  const GenderConverter();

  @override
  Gender fromJson(int json) {
    return Gender.values.firstWhere((gender) => gender.index == json);
  }

  @override
  int toJson(Gender gender) {
    return gender.index;
  }
}
