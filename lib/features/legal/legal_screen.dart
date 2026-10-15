import 'package:flutter/material.dart';
import 'package:studify/features/shell/sub_page.dart';

/// A text page: the privacy policy or the terms of use.
class LegalScreen extends StatelessWidget {
  const LegalScreen({required this.title, this.text = '', super.key});

  final String title;

  /// Empty until the documents are written.
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SubPage(
      title: title,
      children: [
        SelectableText(
          text,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
