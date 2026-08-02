import 'package:swift_core/swift_core.dart';
import 'dart:async';
import 'dart:typed_data';

/// Mock SmileID service for testing without backend
/// Simulates the verification flow with delays and random results
class MockSmileIdService {
  /// Submit verification to mock backend
  Future<String> submitVerification({
    required Uint8List selfie,
    required List<Uint8List> livenessFrames,
    required Uint8List documentFront,
    Uint8List? documentBack,
    required String givenNames,
    required String lastName,
    required String email,
    String idType = 'IDENTITY_CARD',
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Generate mock job_id
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'mock_job_$timestamp';
  }
  
  /// Watch verification status (returns a stream of status updates)
  Stream<VerificationStatus> watchVerificationStatus(String jobId) async* {
    // Uploading
    yield VerificationStatus.uploading();
    await Future.delayed(const Duration(seconds: 2));
    
    // Processing
    yield VerificationStatus.processing();
    await Future.delayed(const Duration(seconds: 5));
    
    // Random result for testing
    final results = [
      VerificationStatus.clear(
        firstName: 'Kwame',
        lastName: 'Mensah',
        idNumber: 'GHA-123456789-0',
        dateOfBirth: '1995-03-15',
      ),
      VerificationStatus.underReview(
        reason: 'Image quality needs manual review',
      ),
    ];
    
    // Return clear result most of the time for easier testing
    yield results[0];
  }
}

/// Verification status model
class VerificationStatus {
  final VerificationState state;
  final String? firstName;
  final String? lastName;
  final String? idNumber;
  final String? dateOfBirth;
  final String? reason;
  final String? message;
  
  VerificationStatus._({
    required this.state,
    this.firstName,
    this.lastName,
    this.idNumber,
    this.dateOfBirth,
    this.reason,
    this.message,
  });
  
  factory VerificationStatus.uploading() {
    return VerificationStatus._(
      state: VerificationState.uploading,
      message: 'Uploading documents...',
    );
  }
  
  factory VerificationStatus.processing() {
    return VerificationStatus._(
      state: VerificationState.processing,
      message: 'SmileID is verifying your identity...',
    );
  }
  
  factory VerificationStatus.clear({
    required String firstName,
    required String lastName,
    required String idNumber,
    String? dateOfBirth,
  }) {
    return VerificationStatus._(
      state: VerificationState.clear,
      firstName: firstName,
      lastName: lastName,
      idNumber: idNumber,
      dateOfBirth: dateOfBirth,
      message: 'Verification successful! Your identity has been verified.',
    );
  }
  
  factory VerificationStatus.block({String? reason}) {
    return VerificationStatus._(
      state: VerificationState.block,
      reason: reason ?? 'Verification failed',
      message: 'The information provided does not match our records.',
    );
  }
  
  factory VerificationStatus.underReview({String? reason}) {
    return VerificationStatus._(
      state: VerificationState.underReview,
      reason: reason ?? 'Manual review required',
      message: 'Your documents are under review. We\'ll notify you within 24 hours.',
    );
  }
  
  factory VerificationStatus.error({String? message}) {
    return VerificationStatus._(
      state: VerificationState.error,
      message: message ?? 'An error occurred during verification',
    );
  }
}

enum VerificationState {
  uploading,
  processing,
  clear,
  block,
  underReview,
  error,
}
