import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/features/homework/data/homework_repository.dart';
import 'package:studify/features/homework/domain/homework_attachment.dart';
import 'package:studify/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// One assignment's files of one [kind] (the teacher's materials, or
/// the student's own submission) — list, upload and delete. Attachments
/// are scoped to a single assignment detail page, so this owns its own
/// loading state rather than going through a shared controller.
class AttachmentsSection extends StatefulWidget {
  const AttachmentsSection({
    required this.assignmentId,
    required this.kind,
    required this.title,
    required this.canUpload,
    required this.canDelete,
    super.key,
  });

  final int assignmentId;
  final AttachmentKind kind;
  final String title;
  final bool canUpload;
  final bool canDelete;

  @override
  State<AttachmentsSection> createState() => _AttachmentsSectionState();
}

class _AttachmentsSectionState extends State<AttachmentsSection> {
  late Future<List<HomeworkAttachment>> _future;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<HomeworkAttachment>> _load() async {
    final all = await context.read<HomeworkRepository>().listAttachments(
      widget.assignmentId,
    );
    return [for (final a in all) if (a.kind == widget.kind) a];
  }

  Future<void> _reload() async {
    final future = _load();
    setState(() {
      _future = future;
      _error = null;
    });
    await future;
  }

  Future<void> _upload() async {
    final l10n = AppLocalizations.of(context);
    final repository = context.read<HomeworkRepository>();
    final file = await FilePicker.pickFile();
    if (file == null) return;

    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await repository.uploadAttachment(
        assignmentIds: [widget.assignmentId],
        file: file,
      );
      if (!mounted) return;
      await _reload();
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(
        () => _error = (error.isNetworkError || error.isServerError)
            ? l10n.homeworkServerUnavailable
            : error.message ?? l10n.homeworkUploadError,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete(HomeworkAttachment attachment) async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await context.read<HomeworkRepository>().deleteAttachment(attachment.id);
      if (!mounted) return;
      await _reload();
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(
        () => _error = (error.isNetworkError || error.isServerError)
            ? l10n.homeworkServerUnavailable
            : error.message ?? l10n.homeworkDeleteFileError,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _open(HomeworkAttachment attachment) async {
    final url = attachment.downloadUrl;
    if (url == null) return;
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return FutureBuilder<List<HomeworkAttachment>>(
      future: _future,
      builder: (context, snapshot) {
        final attachments = snapshot.data ?? const [];
        final loading = snapshot.connectionState != ConnectionState.done;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(widget.title, style: theme.textTheme.labelMedium),
                const Spacer(),
                if (widget.canUpload)
                  TextButton.icon(
                    onPressed: _busy ? null : () => unawaited(_upload()),
                    icon: const Icon(CupertinoIcons.paperclip, size: 16),
                    label: Text(l10n.homeworkUploadFile),
                  ),
              ],
            ),
            if (loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else if (snapshot.hasError)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  l10n.homeworkLoadFilesError,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              )
            else if (attachments.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  l10n.homeworkNoFiles,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < attachments.length; i++) ...[
                      if (i > 0) Divider(height: 1, color: scheme.outlineVariant),
                      ListTile(
                        dense: true,
                        leading: Icon(
                          CupertinoIcons.doc_fill,
                          color: scheme.primary,
                          size: 20,
                        ),
                        title: Text(
                          attachments[i].fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => unawaited(_open(attachments[i])),
                        trailing: widget.canDelete
                            ? IconButton(
                                icon: Icon(
                                  CupertinoIcons.trash,
                                  color: scheme.error,
                                  size: 18,
                                ),
                                onPressed: _busy
                                    ? null
                                    : () => unawaited(_delete(attachments[i])),
                              )
                            : null,
                      ),
                    ],
                  ],
                ),
              ),
            if (_error case final error?) ...[
              const SizedBox(height: 4),
              Text(error, style: TextStyle(color: scheme.error, fontSize: 12)),
            ],
          ],
        );
      },
    );
  }
}
