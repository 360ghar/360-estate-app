import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/paged_list_view.dart';
import 'package:estate_app/features/rental_applications/applications_providers.dart';
import 'package:estate_app/features/rental_applications/models/application_form.dart';
import 'package:estate_app/features/rental_applications/models/application_submission.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ApplicationsPage extends StatelessWidget {
  const ApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: AppScaffold(
        appBar: AppBar(
          title: const Text('Applications'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Forms'),
              Tab(text: 'Inbox'),
            ],
          ),
        ),
        padding: EdgeInsets.zero,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.go('/more/applications/forms/new'),
          icon: const Icon(Icons.add),
          label: const Text('New form'),
        ),
        body: const TabBarView(
          children: [
            _FormsTab(),
            _InboxTab(),
          ],
        ),
      ),
    );
  }
}

class _FormsTab extends ConsumerWidget {
  const _FormsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(applicationFormsPagedProvider);
    final controller = ref.read(applicationFormsPagedProvider.notifier);

    return PagedListView<ApplicationForm>(
      state: state,
      emptyTitle: 'No forms yet',
      emptyMessage: 'Create a rental application form to get started.',
      onLoadMore: controller.loadMore,
      onRefresh: controller.refresh,
      onRetry: controller.loadInitial,
      itemBuilder: (context, form) => _FormTile(form: form),
    );
  }
}

class _FormTile extends StatelessWidget {
  const _FormTile({required this.form});

  final ApplicationForm form;

  String _formatDate(DateTime? date) {
    if (date == null) return 'No expiry';
    return DateFormat('d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final slug = form.slug ?? 'draft';
    final status = form.isActive == true ? 'Active' : 'Inactive';

    return Card(
      child: ListTile(
        title: Text(form.title ?? form.propertyName ?? 'Application form'),
        subtitle: Text('$status | $slug | ${_formatDate(form.expiresAt)}'),
        trailing: IconButton(
          icon: const Icon(Icons.link),
          onPressed: slug.isEmpty
              ? null
              : () async {
                  final link = '/public/applications/$slug';
                  await Clipboard.setData(ClipboardData(text: link));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Public link copied.')),
                  );
                },
        ),
        onTap: () => context.go('/more/applications/forms/${form.id}'),
      ),
    );
  }
}

class _InboxTab extends ConsumerWidget {
  const _InboxTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(applicationInboxPagedProvider);
    final controller = ref.read(applicationInboxPagedProvider.notifier);

    return PagedListView<ApplicationSubmission>(
      state: state,
      emptyTitle: 'No applications yet',
      emptyMessage: 'Applications submitted by tenants will show here.',
      onLoadMore: controller.loadMore,
      onRefresh: controller.refresh,
      onRetry: controller.loadInitial,
      itemBuilder: (context, submission) =>
          _SubmissionTile(submission: submission),
    );
  }
}

class _SubmissionTile extends StatelessWidget {
  const _SubmissionTile({required this.submission});

  final ApplicationSubmission submission;

  String _formatDate(DateTime? date) {
    if (date == null) return 'New';
    return DateFormat('d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final status = submission.status ?? 'pending';
    final applicant = submission.applicantName ?? 'Applicant';

    return Card(
      child: ListTile(
        title: Text(applicant),
        subtitle: Text(
          '${submission.propertyName ?? 'Property'} | ${_formatDate(submission.submittedAt)}',
        ),
        trailing: Text(status),
        onTap: () => context.go('/more/applications/inbox/${submission.id}'),
      ),
    );
  }
}
