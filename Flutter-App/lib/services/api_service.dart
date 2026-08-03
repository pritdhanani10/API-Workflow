import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';
import '../models/api_log.dart';

class ApiService {
  String baseUrl = 'http://localhost:5000/api/students';

  final List<ApiLog> logs = [];

  void clearLogs() {
    logs.clear();
  }

  // GET: /api/students
  Future<List<Student>> getStudents() async {
    final stopwatch = Stopwatch()..start();
    final uri = Uri.parse(baseUrl);
    final headers = {'Accept': 'application/json'};

    try {
      final response = await http.get(uri, headers: headers);
      stopwatch.stop();

      final sqlExecuted = response.headers['x-sql-executed'];

      logs.insert(
        0,
        ApiLog(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          timestamp: DateTime.now(),
          method: 'GET',
          url: uri.toString(),
          requestHeaders: headers,
          statusCode: response.statusCode,
          responseHeaders: Map<String, String>.from(response.headers),
          responseBody: response.body,
          sqlExecuted: sqlExecuted,
          durationMs: stopwatch.elapsedMilliseconds,
          isSuccess: response.statusCode >= 200 && response.statusCode < 300,
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Student.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load students (Status ${response.statusCode})');
      }
    } catch (e) {
      stopwatch.stop();
      logs.insert(
        0,
        ApiLog(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          timestamp: DateTime.now(),
          method: 'GET',
          url: uri.toString(),
          requestHeaders: headers,
          statusCode: 0,
          responseHeaders: {},
          responseBody: 'Error: ${e.toString()}',
          durationMs: stopwatch.elapsedMilliseconds,
          isSuccess: false,
        ),
      );
      rethrow;
    }
  }

  // POST: /api/students
  Future<Student> createStudent(Student student) async {
    final stopwatch = Stopwatch()..start();
    final uri = Uri.parse(baseUrl);
    final headers = {'Content-Type': 'application/json'};
    final bodyJson = jsonEncode(student.toJson());

    try {
      final response = await http.post(uri, headers: headers, body: bodyJson);
      stopwatch.stop();

      final sqlExecuted = response.headers['x-sql-executed'];

      logs.insert(
        0,
        ApiLog(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          timestamp: DateTime.now(),
          method: 'POST',
          url: uri.toString(),
          requestHeaders: headers,
          requestBody: bodyJson,
          statusCode: response.statusCode,
          responseHeaders: Map<String, String>.from(response.headers),
          responseBody: response.body,
          sqlExecuted: sqlExecuted,
          durationMs: stopwatch.elapsedMilliseconds,
          isSuccess: response.statusCode == 201 || response.statusCode == 200,
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Student.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create student (Status ${response.statusCode})');
      }
    } catch (e) {
      stopwatch.stop();
      logs.insert(
        0,
        ApiLog(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          timestamp: DateTime.now(),
          method: 'POST',
          url: uri.toString(),
          requestHeaders: headers,
          requestBody: bodyJson,
          statusCode: 0,
          responseHeaders: {},
          responseBody: 'Error: ${e.toString()}',
          durationMs: stopwatch.elapsedMilliseconds,
          isSuccess: false,
        ),
      );
      rethrow;
    }
  }

  // PUT: /api/students/{id}
  Future<Student> updateStudent(int id, Student student) async {
    final stopwatch = Stopwatch()..start();
    final uri = Uri.parse('$baseUrl/$id');
    final headers = {'Content-Type': 'application/json'};
    final bodyJson = jsonEncode(student.toJson());

    try {
      final response = await http.put(uri, headers: headers, body: bodyJson);
      stopwatch.stop();

      final sqlExecuted = response.headers['x-sql-executed'];

      logs.insert(
        0,
        ApiLog(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          timestamp: DateTime.now(),
          method: 'PUT',
          url: uri.toString(),
          requestHeaders: headers,
          requestBody: bodyJson,
          statusCode: response.statusCode,
          responseHeaders: Map<String, String>.from(response.headers),
          responseBody: response.body,
          sqlExecuted: sqlExecuted,
          durationMs: stopwatch.elapsedMilliseconds,
          isSuccess: response.statusCode >= 200 && response.statusCode < 300,
        ),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Student.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update student (Status ${response.statusCode})');
      }
    } catch (e) {
      stopwatch.stop();
      logs.insert(
        0,
        ApiLog(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          timestamp: DateTime.now(),
          method: 'PUT',
          url: uri.toString(),
          requestHeaders: headers,
          requestBody: bodyJson,
          statusCode: 0,
          responseHeaders: {},
          responseBody: 'Error: ${e.toString()}',
          durationMs: stopwatch.elapsedMilliseconds,
          isSuccess: false,
        ),
      );
      rethrow;
    }
  }

  // DELETE: /api/students/{id}
  Future<void> deleteStudent(int id) async {
    final stopwatch = Stopwatch()..start();
    final uri = Uri.parse('$baseUrl/$id');
    final headers = {'Accept': 'application/json'};

    try {
      final response = await http.delete(uri, headers: headers);
      stopwatch.stop();

      final sqlExecuted = response.headers['x-sql-executed'];

      logs.insert(
        0,
        ApiLog(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          timestamp: DateTime.now(),
          method: 'DELETE',
          url: uri.toString(),
          requestHeaders: headers,
          statusCode: response.statusCode,
          responseHeaders: Map<String, String>.from(response.headers),
          responseBody: response.body,
          sqlExecuted: sqlExecuted,
          durationMs: stopwatch.elapsedMilliseconds,
          isSuccess: response.statusCode >= 200 && response.statusCode < 300,
        ),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Failed to delete student (Status ${response.statusCode})');
      }
    } catch (e) {
      stopwatch.stop();
      logs.insert(
        0,
        ApiLog(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          timestamp: DateTime.now(),
          method: 'DELETE',
          url: uri.toString(),
          requestHeaders: headers,
          statusCode: 0,
          responseHeaders: {},
          responseBody: 'Error: ${e.toString()}',
          durationMs: stopwatch.elapsedMilliseconds,
          isSuccess: false,
        ),
      );
      rethrow;
    }
  }
}
