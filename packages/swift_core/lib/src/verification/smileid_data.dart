import 'package:swift_core/swift_core.dart';
import 'dart:typed_data';

/// Data model for SmileID verification flow
class SmileIdData {
  final String givenNames;
  final String lastName;
  final String email;
  final String idType;
  final Uint8List documentFront;
  final Uint8List? documentBack;
  final Uint8List selfie;
  final List<Uint8List> livenessFrames;

  SmileIdData({
    required this.givenNames,
    required this.lastName,
    required this.email,
    required this.idType,
    required this.documentFront,
    this.documentBack,
    required this.selfie,
    required this.livenessFrames,
  });

  SmileIdData copyWith({
    String? givenNames,
    String? lastName,
    String? email,
    String? idType,
    Uint8List? documentFront,
    Uint8List? documentBack,
    Uint8List? selfie,
    List<Uint8List>? livenessFrames,
  }) {
    return SmileIdData(
      givenNames: givenNames ?? this.givenNames,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      idType: idType ?? this.idType,
      documentFront: documentFront ?? this.documentFront,
      documentBack: documentBack ?? this.documentBack,
      selfie: selfie ?? this.selfie,
      livenessFrames: livenessFrames ?? this.livenessFrames,
    );
  }
}

/// Callback for when verification completes
typedef SmileIdCompleteCallback = void Function(
  String firstName,
  String lastName,
  String idNumber,
);
