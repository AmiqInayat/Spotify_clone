import 'package:client/feature/core/models/user_model.dart';
import 'package:client/feature/auth/repositories/auth_local_repository.dart';
import 'package:client/feature/auth/repositories/auth_remote_repository.dart';
import 'package:client/feature/core/providers/current_user_notifier.dart';
// import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_viewmodel.g.dart';

// @riverpod
// class AuthViewModel extends _$AuthViewModel {
//   late AuthRemoteRepository _authRemoteRepository;
//   late AuthLocalRepository _authLocalRepository;
//   late CurrentUserNotifier _currentUserNotifier;
//   @override
//   AsyncValue<UserModel> build() {
//     _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
//     _authLocalRepository = ref.watch(authLocalRepositoryProvider);
//     _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
//     return const AsyncValue.loading();
//   }

//   Future<void> initSharedPreferences() async {
//     await _authLocalRepository.init();
//   }

//   Future<void> signUpUser({
//     required String name,
//     required String email,
//     required String password,
//   }) async {
//     state = AsyncValue.loading();
//     final res = await _authRemoteRepository.signup(
//       name: name,
//       email: email,
//       password: password,
//     );
//     final val = switch (res) {
//       Left(value: final l) => state = AsyncValue.error(
//         l.message,
//         StackTrace.current,
//       ),
//       Right(value: final r) => state = AsyncValue.data(r),
//     };
//     print(val);
//   }

//   Future<void> loginUser({
//     required String email,
//     required String password,
//   }) async {
//     state = AsyncValue.loading();
//     final res = await _authRemoteRepository.login(
//       email: email,
//       password: password,
//     );
//     final val = switch (res) {
//       Left(value: final l) => state = AsyncValue.error(
//         l.message,
//         StackTrace.current,
//       ),
//       Right(value: final r) => _loginSuccess(r),
//     };
//     print(val);
//   }

//   AsyncValue<UserModel>? _loginSuccess(UserModel user) {
//     _authLocalRepository.setToken(user.token);
// _currentUserNotifier.addUser(user);
//     return state = AsyncValue.data(user);
//   }

//   Future<UserModel?> getData() async {
//     state = const AsyncValue.loading();
//     final token = _authLocalRepository.getToken();
//     if (token != null) {
//       final res = await _authRemoteRepository.getCurrentUserData(token);
//       final val = switch (res) {
//         Left(value: final l) => state = AsyncValue.error(
//           l.message,
//           StackTrace.current,
//         ),
//         Right(value: final r) => _getDataSuccess(r),
//       };
//       return val.value;
//     }
//     return null;
//   }

//   AsyncValue<UserModel> _getDataSuccess(UserModel user) {
//     _currentUserNotifier.addUser(user);
//     return state = AsyncValue.data(user);
//   }
// }

@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  AsyncValue<UserModel> build() {
    return AsyncValue.loading();
  }

  Future<void> initSharedPreferences() async {
    await ref.read(authLocalRepositoryProvider).init();
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    // print(state);
    final res = await ref
        .read(authRemoteRepositoryProvider)
        .signup(name: name, email: email, password: password);

    res.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = AsyncValue.data(r),
    );
    // print(res);
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await ref
        .read(authRemoteRepositoryProvider)
        .login(email: email, password: password);

    res.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => _loginSuccess(r),
    );
    // print(res);
  }

  AsyncValue<UserModel>? _loginSuccess(UserModel user) {
    ref.read(authLocalRepositoryProvider).setToken(user.token);
    ref.read(currentUserNotifierProvider.notifier).addUser(user);
    state = AsyncValue.data(user);
    // print(state);
    return state;
  }

  Future<UserModel?> getData() async {
    state = const AsyncValue.loading();
    final token = ref.read(authLocalRepositoryProvider).getToken();
    // print(token);

    if (token != null) {
      final res = await ref
          .read(authRemoteRepositoryProvider)
          .getCurrentUserData(token);

      return res.fold(
        (l) {
          state = AsyncValue.error(l.message, StackTrace.current);
          return null;
        },
        (r) {
          _getDataSuccess(r);
          // print(r);
          return r;
        },
      );
    }
    return null;
  }

  AsyncValue<UserModel>? _getDataSuccess(UserModel user) {
    ref.read(currentUserNotifierProvider.notifier).addUser(user);
    state = AsyncValue.data(user);
    // print(state);
    return state;
  }
}
