import 'package:clean_architecture_tdd/src/authentication/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.createdAt,
    required super.name,
    required super.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      createdAt: json['createdAt'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'name': name,
      'avatar': avatar,
    };
  }

  UserModel copyWith({
    String? id,
    String? createdAt,
    String? name,
    String? avatar,
  }) {
    return UserModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
    );
  }

  // factory UserModel.fromJson(String source) => UserModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  // UserModel.fromMap(Map<String, dynamic> map)
  //     : super(
  //         id: map['id'] as String,
  //         createdAt: map['createdAt'] as String,
  //         name: map['name']   as String,
  //         avatar: map['avatar'] as String,
  //       );

//  DataMap toMap() => {
//     'id': id,
//     'createdAt': createdAt,
//     'name': name,
//     'avatar': avatar,
//   };

//   String toJson() => jsonEncode(toMap());
}
