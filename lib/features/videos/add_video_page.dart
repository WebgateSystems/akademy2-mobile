import 'dart:async';
import 'dart:io';

import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/app/view/base_page_with_toolbar.dart';
import 'package:academy_2_app/app/view/base_wait_approval_page.dart';
import 'package:academy_2_app/app/view/edit_text_widget.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import 'video_models.dart';
import 'video_service.dart';

class AddVideoPage extends StatefulWidget {
  const AddVideoPage({super.key});

  @override
  State<AddVideoPage> createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  PlatformFile? _file;
  VideoPlayerController? _controller;
  String? _subjectId;
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _saving = false;
  List<VideoSubjectFilter> _subjects = [];

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadSubjects() async {
    try {
      final service = VideoService();
      final subjects = await service.fetchSubjects();
      debugPrint('Loaded ${subjects.length} subjects');
      setState(() {
        _subjects = subjects;
        if (_subjects.isNotEmpty) _subjectId = _subjects.first.id;
      });
    } catch (e) {
      debugPrint('Error loading subjects: $e');
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null && result.files.isNotEmpty) {
      _file = result.files.first;
      _controller?.dispose();
      final file = File(_file!.path!);
      _controller = VideoPlayerController.file(file);
      await _controller!.initialize();
      setState(() {});
    }
  }

  Future<void> _submit() async {
    if (_file == null || _subjectId == null || _titleCtrl.text.trim().isEmpty) {
      return;
    }
    setState(() => _saving = true);
    try {
      await VideoService().addVideo(
        title: _titleCtrl.text.trim(),
        subjectId: _subjectId!,
        filePath: _file!.path!,
        description:
            _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      );
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (context) => const _PendingDialog(),
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.addVideoUploadFailed(e.toString())),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _file != null &&
        _subjectId != null &&
        _titleCtrl.text.trim().isNotEmpty;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: BasePageWithToolbar(
        title: l10n.addVideoPageTitle,
        showBackButton: true,
        stickChildrenToBottom: true,
        children: [
          SizedBox(height: 16.h),
          _PreviewPicker(
            controller: _controller,
            onPick: _pickFile,
            onTogglePlayback: () {
              setState(() {
                if (_controller?.value.isPlaying ?? false) {
                  _controller?.pause();
                } else {
                  _controller?.play();
                }
              });
            },
          ),
          SizedBox(height: 16.h),
          _dropdown<String>(
            label: l10n.addVideoPageTopicLabel,
            value: _subjectId,
            items: _subjects
                .map((s) => DropdownMenuItem(value: s.id, child: Text(s.title)))
                .toList(),
            onChanged: (v) => setState(() => _subjectId = v),
          ),
          SizedBox(height: 8.h),
          EditTextWidget(
            controller: _titleCtrl,
            label: l10n.addVideoPageTitleFieldLabel,
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: 8.h),
          EditTextWidget(
            controller: _descCtrl,
            maxLines: 3,
            label: l10n.addVideoPageDescriptionFieldLabel,
          ),
          Spacer(),
          ActionButtonWidget(
            onPressed: canSubmit && !_saving ? _submit : null,
            loading: _saving,
            text: l10n.addVideoPageSubmitButton,
          ),
        ],
      ),
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    String? hint,
    String? errorText,
    bool enabled = true,
    EdgeInsetsGeometry? contentPadding,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.b2(context).copyWith(
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
          SizedBox(height: 4.h),
          DropdownButtonFormField<T>(
            initialValue: value,
            items: items,
            onChanged: enabled ? onChanged : null,
            isExpanded: true,
            style: AppTextStyles.b2(context),
            icon: Image.asset(
              'assets/images/ic_chevron_down.png',
              color: AppColors.contentPlaceholder(context),
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfacePrimary(context),
              hintText: hint,
              hintStyle: AppTextStyles.b2(context).copyWith(
                color: AppColors.contentPlaceholder(context),
              ),
              errorText: errorText,
              errorStyle: AppTextStyles.b3(context).copyWith(
                color: AppColors.contentError(context),
              ),
              contentPadding: contentPadding,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.r),
                borderSide: BorderSide(
                  color: AppColors.borderPrimary(context),
                  width: 1.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.r),
                borderSide: BorderSide(
                  color: AppColors.borderFocused(context),
                  width: 1.w,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.r),
                borderSide: BorderSide(
                  color: AppColors.borderError(context),
                  width: 1.w,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.r),
                borderSide: BorderSide(
                  color: AppColors.borderError(context),
                  width: 1.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewPicker extends StatelessWidget {
  const _PreviewPicker({
    required this.controller,
    required this.onPick,
    required this.onTogglePlayback,
  });

  final VideoPlayerController? controller;
  final VoidCallback onPick;
  final VoidCallback onTogglePlayback;

  @override
  Widget build(BuildContext context) {
    final hasVideo = controller != null && controller!.value.isInitialized;
    return GestureDetector(
      onTap: onPick,
      child: Container(
        height: 192.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          image: const DecorationImage(
            image: AssetImage('assets/images/placeholder.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            if (hasVideo)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: GestureDetector(
                    onTap: onTogglePlayback,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: controller!.value.size.width,
                        height: controller!.value.size.height,
                        child: VideoPlayer(controller!),
                      ),
                    ),
                  ),
                ),
              )
            else
              Center(
                child: CircleAvatar(
                  radius: 48.w / 2,
                  backgroundColor: AppColors.surfaceIcon(context),
                  child: Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? 'assets/images/ic_upload_dark.png'
                        : 'assets/images/ic_upload.png',
                    width: 48.w,
                    height: 48.w,
                  ),
                ),
              ),
            if (hasVideo)
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.black26,
                    borderRadius: BorderRadius.circular(16.r),
                    onTap: onTogglePlayback,
                  ),
                ),
              ),
            if (hasVideo)
              Positioned(
                bottom: 80.h,
                right: MediaQuery.of(context).size.width / 2 - 40.w,
                child: _PlayPauseButton(
                  isPlaying: controller!.value.isPlaying,
                  onPressed: onTogglePlayback,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  const _PlayPauseButton({
    required this.isPlaying,
    required this.onPressed,
  });

  final bool isPlaying;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 20.w,
          ),
        ),
      ),
    );
  }
}

class _PendingDialog extends StatefulWidget {
  const _PendingDialog();

  @override
  State<_PendingDialog> createState() => _PendingDialogState();
}

class _PendingDialogState extends State<_PendingDialog> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BaseWaitApprovalPage(
      title: l10n.schoolVideosPendingTitle,
      subtitle: l10n.schoolVideosPendingMessage,
    );
  }
}
