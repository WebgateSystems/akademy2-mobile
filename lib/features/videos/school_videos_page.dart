import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/isar_service.dart';
import '../../core/db/entities/subject_entity.dart';
import '../../core/sync/sync_manager.dart';
import 'video_models.dart';
import 'video_service.dart';

final _subjectFilterProvider = StateProvider<String?>((ref) => null);
final _searchProvider = StateProvider<String>((ref) => '');

final videosProvider = FutureProvider<List<SchoolVideo>>((ref) async {
  final subjectId = ref.watch(_subjectFilterProvider);
  final query = ref.watch(_searchProvider);
  final service = VideoService();
  return service.fetchVideos(subjectId: subjectId, query: query.isEmpty ? null : query);
});

final subjectsListProvider = FutureProvider<List<SubjectEntity>>((ref) async {
  final service = IsarService();
  var subjects = await service.getSubjects();
  if (subjects.isEmpty) {
    await ref.read(syncManagerProvider).bootstrap();
    subjects = await service.getSubjects();
  }
  return subjects;
});

class SchoolVideosPage extends ConsumerWidget {
  const SchoolVideosPage({super.key});

  Future<void> _ensurePermissions() async {
    await [Permission.camera, Permission.photos, Permission.storage].request();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videos = ref.watch(videosProvider);
    final subjects = ref.watch(subjectsListProvider);
    final selectedSubject = ref.watch(_subjectFilterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('School videos')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Watch videos created by pupils and upload your own.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          subjects.when(
            data: (list) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text('All'),
                      selected: selectedSubject == null,
                      onSelected: (_) => ref.read(_subjectFilterProvider.notifier).state = null,
                    ),
                    ...list.map((s) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(s.title),
                            selected: selectedSubject == s.id,
                            onSelected: (_) => ref.read(_subjectFilterProvider.notifier).state = s.id,
                          ),
                        )),
                  ],
                ),
              );
            },
            loading: () => const SizedBox(height: 48, child: Center(child: CircularProgressIndicator())),
            error: (_, __) => const SizedBox.shrink(),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search videos',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => ref.read(_searchProvider.notifier).state = value,
            ),
          ),
          Expanded(
            child: videos.when(
              data: (list) {
                if (list.isEmpty) {
                  return const Center(child: Text('No videos yet.'));
                }
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final video = list[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(video.title),
                        subtitle: Text('${video.description}\nStatus: ${video.status}'),
                        onTap: () {
                          if (video.status == 'pending') {
                            showDialog(
                              context: context,
                              builder: (context) => const _PendingDialog(),
                            );
                          }
                        },
                        trailing: video.status == 'pending'
                            ? IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () async {
                                  await VideoService().deleteVideo(video.id);
                                  ref.invalidate(videosProvider);
                                },
                              )
                            : null,
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _ensurePermissions();
          if (!context.mounted) return;
          final result = await context.push('/videos/add');
          if (result == true) {
            ref.invalidate(videosProvider);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _PendingDialog extends StatelessWidget {
  const _PendingDialog();

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text("Wait for teacher's approval"),
      content: Text('Your teacher will review your request soon - hang tight!'),
    );
  }
}
