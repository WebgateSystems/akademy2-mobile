class FakeBackend {
  /// Mock login response: { accessToken, refreshToken, user: { id, email } }
  static Map<String, dynamic> mockLogin(String email, String password) {
    return {
      'accessToken': 'access_token_${DateTime.now().millisecondsSinceEpoch}',
      'refreshToken': 'refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      'user': {
        'id': 'user-${DateTime.now().millisecondsSinceEpoch}',
        'email': email,
      },
    };
  }

  /// Mock refresh response: { accessToken, refreshToken }
  static Map<String, dynamic> mockRefresh(String oldRefreshToken) {
    return {
      'accessToken': 'access_token_${DateTime.now().millisecondsSinceEpoch}',
      'refreshToken': 'refresh_token_${DateTime.now().millisecondsSinceEpoch}',
    };
  }

  static final List<Map<String, dynamic>> _subjects = List.generate(
    7,
    (i) => {
      'id': 'subject-${i + 1}',
      'title': 'Subject ${i + 1}',
      'description': 'Description for subject ${i + 1}',
      'order': i,
      'moduleCount': 0,
      'updatedAt': DateTime.now().toIso8601String(),
    },
  );

  static final Map<String, List<Map<String, dynamic>>> _modulesBySubject = {};
  static final Map<String, List<Map<String, dynamic>>> _contentsByModule = {};

  /// Mock subjects list
  static Map<String, dynamic> mockSubjects({String? updatedSince}) {
    final subjects = _subjects.map((subject) {
      final modules = mockModules(subject['id'] as String)['modules'] as List;
      return {
        ...subject,
        'moduleCount': modules.length,
      };
    }).toList();

    // TODO: handle updatedSince filter
    return {'subjects': subjects};
  }

  /// Mock modules list for a subject
  static Map<String, dynamic> mockModules(String subjectId) {
    final modules = _modulesBySubject.putIfAbsent(
      subjectId,
      () {
        final isSingleFlow = subjectId.endsWith('1');
        final count = isSingleFlow ? 1 : 3;
        return List.generate(
          count,
          (i) => {
            'id': 'module-$subjectId-${i + 1}',
            'subjectId': subjectId,
            'title': 'Module ${i + 1} for $subjectId',
            'order': i,
            'singleFlow': i == 0 && isSingleFlow,
            'updatedAt': DateTime.now().toIso8601String(),
          },
        );
      },
    );
    return {'modules': modules};
  }

  /// Mock contents (video, infographic, quiz) for a module
  static Map<String, dynamic> mockContents(String moduleId) {
    final contents = _contentsByModule.putIfAbsent(
      moduleId,
      () {
        const types = ['video', 'infographic', 'quiz'];
        return List.generate(
          types.length,
          (i) => {
            'id': 'content-$moduleId-${i + 1}',
            'moduleId': moduleId,
            'type': types[i],
            'title': '${types[i].toUpperCase()} ${i + 1}',
            'durationSec': 600 + (i * 60),
            'order': i,
            'updatedAt': DateTime.now().toIso8601String(),
          },
        );
      },
    );
    return {'contents': contents};
  }

  /// Mock logout response
  static Map<String, dynamic> mockLogout() {
    return {'success': true};
  }

  static Map<String, dynamic> mockAccountUpdate() {
    return {'success': true};
  }

  static Map<String, dynamic> mockAccountDelete() {
    return {'success': true};
  }

  static final List<Map<String, dynamic>> _videos = List.generate(4, (i) {
    return {
      'id': 'video-$i',
      'title': 'School video ${i + 1}',
      'description': 'Awesome project ${i + 1}',
      'subjectId': 'subject-${(i % 3) + 1}',
      'status': i % 2 == 0 ? 'approved' : 'pending',
      'url': 'https://example.com/video$i.mp4',
    };
  });

  static Map<String, dynamic> mockVideos({String? subjectId, String? query}) {
    Iterable<Map<String, dynamic>> list = _videos;
    if (subjectId != null && subjectId.isNotEmpty) {
      list = list.where((v) => v['subjectId'] == subjectId);
    }
    if (query != null && query.isNotEmpty) {
      list = list.where((v) =>
          v['title'].toString().toLowerCase().contains(query.toLowerCase()));
    }
    return {'videos': list.toList()};
  }

  static Map<String, dynamic> mockAddVideo(Map<String, dynamic> body) {
    final id = 'video-${DateTime.now().millisecondsSinceEpoch}';
    final video = {
      'id': id,
      'title': body['title'] ?? 'New video',
      'description': body['description'] ?? '',
      'subjectId': body['subjectId'] ?? '',
      'status': 'pending',
      'url': body['filePath'] ?? '',
    };
    _videos.add(video);
    return {'video': video};
  }

  static Map<String, dynamic> mockDeleteVideo(String id) {
    _videos.removeWhere((v) => v['id'] == id);
    return {'success': true};
  }

  static final Map<String, _JoinRequest> _joinRequests = {};

  static Map<String, dynamic> mockJoin(String code) {
    final id = 'join-${DateTime.now().millisecondsSinceEpoch}';
    _joinRequests[id] = _JoinRequest(code: code, createdAt: DateTime.now());
    return {
      'requestId': id,
      'status': 'pending',
    };
  }

  static Map<String, dynamic> mockJoinStatus(String id) {
    final req = _joinRequests[id];
    if (req == null) return {'status': 'rejected'};
    final elapsed = DateTime.now().difference(req.createdAt).inSeconds;
    if (elapsed > 12) {
      return {
        'status': 'approved',
        'accessToken': 'access_$id',
        'refreshToken': 'refresh_$id',
      };
    }
    if (elapsed > 8) {
      return {'status': 'rejected'};
    }
    return {'status': 'pending'};
  }
}

class _JoinRequest {
  _JoinRequest({required this.code, required this.createdAt});
  final String code;
  final DateTime createdAt;
}
