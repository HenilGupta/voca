/// A utility class for chunked logging to avoid Flutter's console truncation limits.
/// 
/// When a log message exceeds 800 characters, it automatically splits the message
/// into smaller chunks to ensure complete visibility in the console output.
class AppLogger {
  /// Maximum characters per log chunk to avoid console truncation
  static const int _maxChunkSize = 800;

  /// Logs a message to the console with chunked output for long messages.
  /// 
  /// If [message] length exceeds 800 characters, it splits the message into
  /// multiple chunks and prints each with a [LOG] prefix.
  /// 
  /// Example:
  /// ```dart
  /// AppLogger.log('Short message'); // Single output
  /// AppLogger.log('Very long message...'); // Multiple chunks if needed
  /// ```
  static void log(String message) {
    if (message.length <= _maxChunkSize) {
      print('[LOG] $message');
      return;
    }

    // Split long messages into chunks
    final chunks = _splitIntoChunks(message, _maxChunkSize);
    for (int i = 0; i < chunks.length; i++) {
      print('[LOG] (${i + 1}/${chunks.length}) ${chunks[i]}');
    }
  }

  /// Logs API error messages with error-specific prefix.
  /// 
  /// Used primarily by the API interceptor for request/response errors.
  static void logError(String message) {
    if (message.length <= _maxChunkSize) {
      print('[API ERROR] $message');
      return;
    }

    final chunks = _splitIntoChunks(message, _maxChunkSize);
    for (int i = 0; i < chunks.length; i++) {
      print('[API ERROR] (${i + 1}/${chunks.length}) ${chunks[i]}');
    }
  }

  /// Logs API data with data-specific prefix.
  /// 
  /// Used primarily by the API interceptor for request/response data logging.
  static void logData(String message) {
    if (message.length <= _maxChunkSize) {
      print('[API DATA] $message');
      return;
    }

    final chunks = _splitIntoChunks(message, _maxChunkSize);
    for (int i = 0; i < chunks.length; i++) {
      print('[API DATA] (${i + 1}/${chunks.length}) ${chunks[i]}');
    }
  }

  /// Splits a string into chunks of specified maximum size.
  /// 
  /// Ensures each chunk doesn't exceed [maxSize] characters.
  /// Returns a list of string chunks.
  static List<String> _splitIntoChunks(String text, int maxSize) {
    final chunks = <String>[];
    for (int i = 0; i < text.length; i += maxSize) {
      final end = (i + maxSize < text.length) ? i + maxSize : text.length;
      chunks.add(text.substring(i, end));
    }
    return chunks;
  }
}