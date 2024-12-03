import 'package:get/get.dart';
import 'package:together_travel/utils/constants/strings.dart';

class CPlatformExceptions implements Exception {
  final String code;
  CPlatformExceptions(this.code);
  String get message {
    switch (code) {
      case 'INVALID_LOGIN_CREDENTIALS':
        return AppStrings.invalidLoginCredentials.tr;
      case 'too-many-requests':
        return AppStrings.tooManyRequest.tr;
      case 'invalid-argument':
        return AppStrings.invalidArgument.tr;
      case 'invalid-password':
        return AppStrings.invalidPassword.tr;
      case 'session-cookie-expired':
        return AppStrings.sessionCookieExpired.tr;
      case 'uid-already-exists':
        return AppStrings.uidAlreadyExists.tr;
      case 'sign_in_failed':
        return AppStrings.signInFailed.tr;
      case 'network-request-failed':
        return AppStrings.networkRequestFailed.tr;
      case 'internal-error':
        return AppStrings.internalError.tr;
      case 'quota-exceeded':
        return AppStrings.quotaExceeded.tr;
      default:
        return AppStrings.unexpectedError.tr;
    }
  }
}

class CFirebaseExceptions implements Exception {
  final String code;

  CFirebaseExceptions(this.code);

  String get message {
    switch (code) {
      case 'invalid-email':
        return AppStrings.invalidEmail.tr;
      case 'user-not-found':
        return AppStrings.userNotFound.tr;
      case 'wrong-password':
        return AppStrings.wrongPassword.tr;
      case 'email-already-in-use':
        return AppStrings.emailAlreadInUse.tr;
      case 'invalid-credential':
        return AppStrings.invalidCredentials.tr;
      case 'too-many-requests':
        return AppStrings.tooManyRequest.tr;
      case 'network-request-failed':
        return AppStrings.networkRequestFailed.tr;
      case 'requires-recent-login':
        return AppStrings.requiresRecentLogin.tr;
      case 'invalid-action-code':
        return AppStrings.invalidActionCode.tr;
      case 'credential-already-in-use':
        return AppStrings.credentialAlreadyInUse.tr;
      case 'session-cookie-expired':
        return AppStrings.sessionCookieExpired.tr;
      case 'quota-exceeded':
        return AppStrings.quotaExceeded.tr;
      case 'internal-error':
        return AppStrings.internalError.tr;
      case 'invalid-recipient-email':
        return AppStrings.invalidRecipientEmail.tr;
      default:
        return AppStrings.unexpectedError.tr;
    }
  }
}
