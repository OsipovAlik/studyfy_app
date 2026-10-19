/// `material` (a teacher's file, can be on many assignments) or
/// `submission` (a student's own file, on their own assignments only,
/// until the task is graded).
enum AttachmentKind {
  material,
  submission,
  unknown;

  static AttachmentKind fromJson(String? value) => switch (value) {
    'material' => AttachmentKind.material,
    'submission' => AttachmentKind.submission,
    _ => AttachmentKind.unknown,
  };
}

/// A row of `GET /assignment/{id}/attachments`: one homework file.
class HomeworkAttachment {
  const HomeworkAttachment({
    required this.id,
    required this.assignmentId,
    required this.kind,
    required this.fileName,
    this.uploadedBy,
    this.contentType,
    this.sizeBytes,
    this.downloadUrl,
  });

  factory HomeworkAttachment.fromJson(Map<String, dynamic> json) =>
      HomeworkAttachment(
        id: (json['ID'] as num?)?.toInt() ?? 0,
        assignmentId: (json['assignmentId'] as num?)?.toInt() ?? 0,
        kind: AttachmentKind.fromJson(json['kind'] as String?),
        fileName: json['fileName'] as String? ?? '',
        uploadedBy: (json['uploadedBy'] as num?)?.toInt(),
        contentType: json['contentType'] as String?,
        sizeBytes: (json['sizeBytes'] as num?)?.toInt(),
        downloadUrl: json['downloadUrl'] as String?,
      );

  final int id;
  final int assignmentId;
  final AttachmentKind kind;
  final String fileName;

  /// Null if the uploader's account was deleted.
  final int? uploadedBy;
  final String? contentType;
  final int? sizeBytes;

  /// Expires after a while — re-fetch the list rather than caching this.
  final String? downloadUrl;
}
