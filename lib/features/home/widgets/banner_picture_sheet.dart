import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/core/theme/app_colors.dart';
import 'package:studify/core/theme/app_theme.dart';
import 'package:studify/features/home/home_banner_controller.dart';
import 'package:studify/features/subjects/domain/subject.dart';
import 'package:studify/l10n/app_localizations.dart';

/// Opens the teacher-only "Banner picture" sheet: pick a subject, then
/// set or remove its home banner picture.
Future<void> showBannerPictureSheet(
  BuildContext context, {
  required HomeBannerController controller,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => _BannerPictureSheet(controller: controller),
  );
}

/// Below this, the picture would be upscaled and look blurry.
const _minWidth = 1200;
const _minHeight = 300;

/// Below this width:height ratio, a meaningful part of a 4:1 banner
/// slot would have to crop the picture's top and bottom.
const _minAspectRatio = 2;

class _BannerPictureSheet extends StatefulWidget {
  const _BannerPictureSheet({required this.controller});

  final HomeBannerController controller;

  @override
  State<_BannerPictureSheet> createState() => _BannerPictureSheetState();
}

class _BannerPictureSheetState extends State<_BannerPictureSheet> {
  late int? _selectedSubjectId = _defaultSubjectId();
  XFile? _pickedImage;
  Uint8List? _pickedBytes;
  ui.Size? _pickedSize;
  bool _submitting = false;
  bool _removing = false;
  String? _error;

  int? _defaultSubjectId() {
    final subjects = widget.controller.subjects;
    final withImage = subjects.where((s) => s.mainImageUrl.isNotEmpty).firstOrNull;
    return (withImage ?? subjects.firstOrNull)?.id;
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleChange);
  }

  void _handleChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleChange);
    super.dispose();
  }

  Subject? get _selectedSubject => widget.controller.subjects.where((s) => s.id == _selectedSubjectId).firstOrNull;

  Future<void> _pickImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    final size = await _decodeSize(bytes);
    if (!mounted) return;
    setState(() {
      _pickedImage = file;
      _pickedBytes = bytes;
      _pickedSize = size;
    });
  }

  Future<ui.Size?> _decodeSize(Uint8List bytes) async {
    try {
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      return ui.Size(
        frame.image.width.toDouble(),
        frame.image.height.toDouble(),
      );
    } on Exception {
      return null;
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final subjectId = _selectedSubjectId;
    final image = _pickedImage;
    if (subjectId == null || image == null) return;

    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await widget.controller.setMainImage(subjectId, image);
      if (mounted) Navigator.of(context).pop();
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = (error.isNetworkError || error.isServerError) ? l10n.subjectsServerUnavailable : error.message ?? l10n.homeBannerUploadError;
      });
    }
  }

  Future<void> _remove() async {
    final l10n = AppLocalizations.of(context);
    final subjectId = _selectedSubjectId;
    if (subjectId == null) return;

    setState(() {
      _removing = true;
      _error = null;
    });
    try {
      await widget.controller.removeMainImage(subjectId);
      if (mounted) {
        setState(() {
          _removing = false;
          _pickedImage = null;
          _pickedBytes = null;
          _pickedSize = null;
        });
      }
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _removing = false;
        _error = (error.isNetworkError || error.isServerError) ? l10n.subjectsServerUnavailable : error.message ?? l10n.homeBannerRemoveError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final subjects = widget.controller.subjects;
    final selected = _selectedSubject;
    final busy = _submitting || _removing;

    final size = _pickedSize;
    final tooSmall = size != null && (size.width < _minWidth || size.height < _minHeight);
    final tooTall = size != null && (size.width / size.height) < _minAspectRatio;

    InputDecoration decoration() => InputDecoration(
      filled: true,
      fillColor: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
    );

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.homeBannerDialogTitle,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.homeBannerDialogSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              if (subjects.isEmpty)
                Text(
                  l10n.homeBannerNoSubjects,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                )
              else ...[
                Text(
                  l10n.homeBannerSubjectLabel,
                  style: theme.textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  key: const ValueKey('banner-subject-dropdown'),
                  initialValue: _selectedSubjectId,
                  decoration: decoration(),
                  items: [
                    for (final subject in subjects)
                      DropdownMenuItem(
                        value: subject.id,
                        child: Text(subject.name),
                      ),
                  ],
                  onChanged: (value) => setState(() {
                    _selectedSubjectId = value;
                    _pickedImage = null;
                    _pickedBytes = null;
                    _pickedSize = null;
                  }),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.homeBannerPreviewLabel,
                  style: theme.textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                _BannerPreview(
                  imageBytes: _pickedBytes,
                  imageUrl: _pickedBytes == null ? selected?.mainImageUrl : null,
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                    border: Border.all(
                      color: scheme.outlineVariant,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            OutlinedButton.icon(
                              onPressed: busy ? null : _pickImage,
                              icon: const Icon(CupertinoIcons.photo, size: 16),
                              label: Text(l10n.homeBannerChoosePicture),
                            ),
                            if (_pickedImage case final picked?) ...[
                              const SizedBox(height: 8),
                              Text(
                                picked.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.homeBannerSizeHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  l10n.homeBannerFormatHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                if (tooSmall) ...[
                  const SizedBox(height: 10),
                  _Warning(
                    text: l10n.homeBannerTooSmallWarning(
                      size.width.round(),
                      size.height.round(),
                    ),
                  ),
                ],
                if (tooTall) ...[
                  const SizedBox(height: 10),
                  _Warning(text: l10n.homeBannerTooTallWarning),
                ],
                if (_error case final error?) ...[
                  const SizedBox(height: 16),
                  Text(error, style: TextStyle(color: scheme.error)),
                ],
                const SizedBox(height: 24),
                // Two rows, not one: "Remove picture" plus "Cancel" and
                // "Save picture" rarely fit on one line together once
                // the labels are localized, so each gets its own row
                // rather than risking an overflow.
                if ((selected?.mainImageUrl ?? '').isNotEmpty) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: busy ? null : _remove,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.red500,
                      ),
                      child: _removing
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.red500,
                              ),
                            )
                          : Text(l10n.homeBannerRemovePicture),
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: busy ? null : () => Navigator.of(context).pop(),
                      child: Text(l10n.cancel),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: busy || _pickedImage == null ? null : _save,
                      child: _submitting
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: scheme.onPrimary,
                              ),
                            )
                          : Text(l10n.homeBannerSavePicture),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BannerPreview extends StatelessWidget {
  const _BannerPreview({this.imageBytes, this.imageUrl});

  final Uint8List? imageBytes;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final background = isDark ? AppColors.indigo950 : AppColors.indigo200;
    final hasImage = imageBytes != null || (imageUrl ?? '').isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      child: SizedBox(
        height: 90,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: background),
            if (imageBytes != null)
              Image.memory(
                imageBytes!,
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
              )
            else if (imageUrl case final url? when url.isNotEmpty)
              CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
              ),
            if (hasImage)
              Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.65,
                  heightFactor: 1,
                  child: ColoredBox(color: background),
                ),
              ),
            const Padding(
              padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _TextBar(width: 0.55, height: 10, opacity: 0.85),
                  SizedBox(height: 6),
                  _TextBar(width: 0.38, height: 7, opacity: 0.5),
                  SizedBox(height: 10),
                  _TextBar(width: 0.22, height: 12, opacity: 0.3, pill: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextBar extends StatelessWidget {
  const _TextBar({
    required this.width,
    required this.height,
    required this.opacity,
    this.pill = false,
  });

  final double width;
  final double height;
  final double opacity;
  final bool pill;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: width,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: opacity),
          borderRadius: BorderRadius.circular(pill ? 999 : 4),
        ),
      ),
    );
  }
}

class _Warning extends StatelessWidget {
  const _Warning({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.amber500.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.amber500.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            CupertinoIcons.exclamationmark_circle,
            size: 16,
            color: AppColors.amber500,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.amber500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
