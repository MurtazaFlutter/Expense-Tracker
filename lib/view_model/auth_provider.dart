// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:voice_of_customer/domain/entities/user.dart';
// import 'package:voice_of_customer/domain/usecases/auth_usecase.dart';

// final authProvider =
//     StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
//   return AuthNotifier(ref.read(authUseCaseProvider));
// });

// class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
//   final AuthUseCase _authUseCase;

//   AuthNotifier(this._authUseCase) : super(AsyncValue.loading()) {
//     _init();
//   }

//   Future<void> _init() async {
//     state = await AsyncValue.guard(() => _authUseCase.getCurrentUser());
//   }

//   Future<void> signIn(String email, String password) async {
//     state = AsyncValue.loading();
//     state = await AsyncValue.guard(() => _authUseCase.signIn(email, password));
//   }

//   Future<void> signOut() async {
//     await _authUseCase.signOut();
//     state = AsyncValue.data(null);
//   }
// }
