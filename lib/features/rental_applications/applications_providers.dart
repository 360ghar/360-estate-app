import 'package:estate_app/core/pagination/paged_list_controller.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/rental_applications/data/applications_repository.dart';
import 'package:estate_app/features/rental_applications/models/application_form.dart';
import 'package:estate_app/features/rental_applications/models/application_submission.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final applicationsRepositoryProvider = Provider<ApplicationsRepository>((ref) {
  return ApplicationsRepository(ref.read(apiClientProvider));
});

final applicationFormsPagedProvider = StateNotifierProvider<
    PagedListController<ApplicationForm>,
    PagedListState<ApplicationForm>>(
  (ref) => PagedListController<ApplicationForm>(
    fetchPage: ({required page, required limit}) {
      return ref.read(applicationsRepositoryProvider).listFormsPage(
            page: page,
            limit: limit,
          );
    },
  ),
);

final applicationInboxPagedProvider = StateNotifierProvider<
    PagedListController<ApplicationSubmission>,
    PagedListState<ApplicationSubmission>>(
  (ref) => PagedListController<ApplicationSubmission>(
    fetchPage: ({required page, required limit}) {
      return ref.read(applicationsRepositoryProvider).listApplicationsPage(
            page: page,
            limit: limit,
          );
    },
  ),
);

final applicationFormDetailProvider =
    FutureProvider.family<ApplicationForm, String>(
  (ref, id) => ref.read(applicationsRepositoryProvider).fetchForm(id),
);

final applicationDetailProvider =
    FutureProvider.family<ApplicationSubmission, String>(
  (ref, id) => ref.read(applicationsRepositoryProvider).fetchApplication(id),
);

final publicApplicationFormProvider =
    FutureProvider.family<ApplicationForm, String>(
  (ref, slug) => ref.read(applicationsRepositoryProvider).fetchPublicForm(slug),
);
