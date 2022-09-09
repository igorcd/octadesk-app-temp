import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

MediaType? getMediaType(String filePath) {
  var fileName = path.basename(filePath);
  var extension = fileName.split(".")[1];

  if (["png", "jpg", "jpeg"].contains(extension)) {
    return MediaType("image", extension == 'jpg' ? 'jpeg' : extension);
  }

  if (["mp4"].contains(extension)) {
    return MediaType("video", extension);
  }

  if (["mp3", "opus", "wav", "m4a", "ogg", "aac"].contains(extension)) {
    return MediaType("audio", extension);
  }
  return null;
}
