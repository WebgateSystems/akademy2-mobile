import 'package:flutter/material.dart';

class SubjectTile extends StatelessWidget {
  final String id;
  final String title;
  final int moduleCount;
  final VoidCallback? onTap;

  const SubjectTile({
    super.key,
    required this.id,
    required this.title,
    required this.moduleCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                '$moduleCount module${moduleCount == 1 ? '' : 's'}',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: const [
                  Icon(Icons.video_library, size: 16),
                  SizedBox(width: 8),
                  Icon(Icons.picture_as_pdf, size: 16),
                  SizedBox(width: 8),
                  Icon(Icons.quiz, size: 16),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
