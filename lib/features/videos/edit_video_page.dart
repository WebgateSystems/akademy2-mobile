import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/app/view/base_page_with_toolbar.dart';
import 'package:academy_2_app/app/view/edit_text_widget.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'video_models.dart';
import 'video_service.dart';

class EditVideoPage extends StatefulWidget {
  const EditVideoPage({
    super.key,
    required this.video,
  });

  final SchoolVideo video;

  @override
  State<EditVideoPage> createState() => _EditVideoPageState();
}

class _EditVideoPageState extends State<EditVideoPage> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.video.title);
    _descCtrl = TextEditingController(text: widget.video.description);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_titleCtrl.text.trim().isEmpty) return;

    setState(() => _saving = true);
    try {
      await VideoService().updateVideo(
        id: widget.video.id,
        title: _titleCtrl.text.trim(),
        description:
            _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.schoolVideosError('$e'))),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canSubmit = _titleCtrl.text.trim().isNotEmpty;

    return Scaffold(
      body: BasePageWithToolbar(
        title: l10n.editVideoTitle,
        showBackButton: true,
        stickChildrenToBottom: true,
        children: [
          SizedBox(height: 16.h),
          EditTextWidget(
            controller: _titleCtrl,
            label: l10n.editVideoTitleLabel,
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: 8.h),
          EditTextWidget(
            controller: _descCtrl,
            maxLines: 3,
            label: l10n.editVideoDescriptionLabel,
          ),
          const Spacer(),
          ActionButtonWidget(
            onPressed: canSubmit && !_saving ? _submit : null,
            loading: _saving,
            text: l10n.editVideoSaveButton,
          ),
        ],
      ),
    );
  }
}
