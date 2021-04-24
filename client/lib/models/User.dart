/*
* Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// ignore_for_file: public_member_api_docs

import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:flutter/foundation.dart';

/** This is an auto generated class representing the User type in your schema. */
@immutable
class User extends Model {
  static const classType = const _UserModelType();
  final String id;
  final bool onboarding_completed;
  final String name;
  final String email;

  @override
  getInstanceType() => classType;

  @override
  String getId() {
    return id;
  }

  const User._internal(
      {@required this.id,
      @required this.onboarding_completed,
      @required this.name,
      @required this.email});

  factory User(
      {String id,
      @required bool onboarding_completed,
      @required String name,
      @required String email}) {
    return User._internal(
        id: id == null ? UUID.getUUID() : id,
        onboarding_completed: onboarding_completed,
        name: name,
        email: email);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
        id == other.id &&
        onboarding_completed == other.onboarding_completed &&
        name == other.name &&
        email == other.email;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("User {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("onboarding_completed=" +
        (onboarding_completed != null
            ? onboarding_completed.toString()
            : "null") +
        ", ");
    buffer.write("name=" + "$name" + ", ");
    buffer.write("email=" + "$email");
    buffer.write("}");

    return buffer.toString();
  }

  User copyWith(
      {String id, bool onboarding_completed, String name, String email}) {
    return User(
        id: id ?? this.id,
        onboarding_completed: onboarding_completed ?? this.onboarding_completed,
        name: name ?? this.name,
        email: email ?? this.email);
  }

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        onboarding_completed = json['onboarding_completed'],
        name = json['name'],
        email = json['email'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'onboarding_completed': onboarding_completed,
        'name': name,
        'email': email
      };

  static final QueryField ID = QueryField(fieldName: "user.id");
  static final QueryField ONBOARDING_COMPLETED =
      QueryField(fieldName: "onboarding_completed");
  static final QueryField NAME = QueryField(fieldName: "name");
  static final QueryField EMAIL = QueryField(fieldName: "email");
  static var schema =
      Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "User";
    modelSchemaDefinition.pluralName = "Users";

    modelSchemaDefinition.authRules = [
      AuthRule(
          authStrategy: AuthStrategy.OWNER,
          ownerField: "owner",
          identityClaim: "cognito:username",
          operations: [
            ModelOperation.READ,
            ModelOperation.CREATE,
            ModelOperation.DELETE,
            ModelOperation.UPDATE
          ]),
      AuthRule(
          authStrategy: AuthStrategy.PRIVATE, operations: [ModelOperation.READ])
    ];

    modelSchemaDefinition.addField(ModelFieldDefinition.id());

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: User.ONBOARDING_COMPLETED,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: User.NAME,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: User.EMAIL,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));
  });
}

class _UserModelType extends ModelType<User> {
  const _UserModelType();

  @override
  User fromJson(Map<String, dynamic> jsonData) {
    return User.fromJson(jsonData);
  }
}
