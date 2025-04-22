// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Staff _$StaffFromJson(Map<String, dynamic> json) {
  return Staff(
    id: json['id'] as int? ?? 0,
    firstName: json['firstName'] as String? ?? '',
    lastName: json['lastName'] as String? ?? '',
    name: json['name'] as String? ?? '',
    dateOfBirth: json['dateOfBirth'] as String? ?? '',
    nationality: json['nationality'] as String? ?? '',
    contract: Contract.fromJson(
      json['contract'] as Map<String, dynamic>? ?? <String, dynamic>{},
    ),
  );
}
