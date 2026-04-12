import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:path_provider/path_provider.dart';

// A special client to attach the Google Auth token to our requests
class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

class GoogleDriveService {
  // Requesting permission to read/write files the app creates
  final _googleSignIn = GoogleSignIn(scopes: [drive.DriveApi.driveFileScope]);
  static const String _backupFileName = 'Hazel_Journal_Backup.csv';

  // 1. Sign In
  Future<drive.DriveApi?> _getDriveApi() async {
    try {
      final account =
          await _googleSignIn.signInSilently() ?? await _googleSignIn.signIn();
      if (account == null) return null;

      final authHeaders = await account.authHeaders;
      final authenticateClient = GoogleAuthClient(authHeaders);
      return drive.DriveApi(authenticateClient);
    } catch (e) {
      print("Sign in error: $e");
      return null;
    }
  }

  // 2. Upload / Sync the File
  Future<bool> syncBackupToDrive() async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) return false;

    try {
      // Find our local CSV file
      final directory = await getApplicationDocumentsDirectory();
      final localFile = File('${directory.path}/health_logs.csv');

      if (!await localFile.exists()) return false; // Nothing to backup

      // Search Drive to see if we already have a backup file
      final fileList = await driveApi.files.list(
        q: "name = '$_backupFileName'",
      );
      final driveFile = drive.File()..name = _backupFileName;

      // Convert our local file into an uploadable stream
      final media = drive.Media(localFile.openRead(), localFile.lengthSync());

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        // UPDATE: File exists, overwrite it
        final existingFileId = fileList.files!.first.id!;
        await driveApi.files.update(
          driveFile,
          existingFileId,
          uploadMedia: media,
        );
      } else {
        // CREATE: First time backing up
        await driveApi.files.create(driveFile, uploadMedia: media);
      }
      return true; // Success!
    } catch (e) {
      print("Drive Sync Error: $e");
      return false;
    }
  }

  // 3. Sign Out (Optional)
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
