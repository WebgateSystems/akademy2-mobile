import 'dart:io';
import 'dart:typed_data';

import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/circular_progress_widget.dart';
import 'package:academy_2_app/core/services/student_api_service.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class SubjectTile extends StatelessWidget {
  final DashboardSubject subject;
  final VoidCallback? onTap;

  const SubjectTile({
    super.key,
    required this.subject,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final completed = subject.completionRate > 0 && subject.averageScore > 0;
    final cardColor = AppColors.subjectCardColor(context, subject, completed);
    final rezultCardColor = AppColors.subjectCardColor(context, subject, false);

    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.w),
            child: Card(
              elevation: 0,
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _SubjectIcon(url: subject.iconUrl),
                    SizedBox(height: 12.h),
                    Center(
                      child: Text(
                        subject.title,
                        style: AppTextStyles.h4(context),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (completed)
            Positioned(
              left: 16.r,
              top: 0,
              child: ResultQuizWidget(
                bgColor: rezultCardColor,
                bestScore: subject.completionRate,
              ),
            ),
        ],
      ),
    );
  }
}

class ResultQuizWidget extends StatelessWidget {
  const ResultQuizWidget({
    super.key,
    required this.bgColor,
    required int bestScore,
  }) : _bestScore = bestScore;

  final int _bestScore;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        AppLocalizations.of(context)!.quizScoreLabel(_bestScore),
        style: AppTextStyles.h5(context).copyWith(
          color: AppColors.contentPrimary(context),
        ),
      ),
    );
  }
}

class _SubjectIcon extends StatelessWidget {
  const _SubjectIcon({
    this.url,
  });

  final String? url;

  @override
  Widget build(BuildContext context) {
    final size = 56.w;
    final bg = AppColors.surfaceIcon(context);
    final fullUrl = (url == null || url!.isEmpty) ? null : url;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: fullUrl == null
                ? Icon(
                    Icons.book,
                    size: size * 0.5,
                    color: AppColors.contentSecondary(context),
                  )
                : Padding(
                    padding: EdgeInsets.only(top: size * 0.2),
                    child: _NetworkSvg(
                      url: fullUrl,
                      placeholder: const CircularProgressWidget(),
                      size: size,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _NetworkSvg extends StatelessWidget {
  const _NetworkSvg({
    required this.url,
    required this.placeholder,
    required this.size,
  });

  final String url;
  final Widget placeholder;
  final double size;

  static final _memoryCache = <String, Uint8List?>{};

  Future<Uint8List?> _loadBytes() async {
    if (_memoryCache.containsKey(url)) return _memoryCache[url];
    try {
      final file = await _localFileForUrl(url);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        _memoryCache[url] = bytes;
        return bytes;
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        _memoryCache[url] = response.bodyBytes;
        try {
          await file.parent.create(recursive: true);
          await file.writeAsBytes(response.bodyBytes, flush: true);
        } catch (_) {
          // Swallow file cache errors; we can still use in-memory bytes.
        }
        return response.bodyBytes;
      }
    } catch (_) {
      // ignore and fallback to placeholder
    }
    return null;
  }

  Future<File> _localFileForUrl(String url) async {
    final dir = await getApplicationDocumentsDirectory();
    final safeName = url
        .split('/')
        .where((segment) => segment.isNotEmpty)
        .last
        .replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final fileName = safeName.isEmpty ? 'subject_icon.svg' : safeName;
    return File('${dir.path}/subject_icons/$fileName');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: FutureBuilder<Uint8List?>(
        future: _loadBytes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:
                    SizedBox.square(dimension: size * 0.5, child: placeholder));
          }
          final bytes = snapshot.data;
          if (bytes == null) {
            return Center(
              child: Icon(
                Icons.book,
                size: size * 0.6,
                color: AppColors.contentSecondary(context),
              ),
            );
          }
          return SvgPicture.memory(
            bytes,
            fit: BoxFit.contain,
            alignment: Alignment.center,
          );
        },
      ),
    );
  }
}
