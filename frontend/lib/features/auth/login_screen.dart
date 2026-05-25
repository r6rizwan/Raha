import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/auth_service.dart';

enum LoginMode { signIn, signUp }

class LoginState {
  const LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.mode = LoginMode.signIn,
  });
  final bool isLoading;
  final String? errorMessage;
  final LoginMode mode;
  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    LoginMode? mode,
  }) => LoginState(
    isLoading: isLoading ?? this.isLoading,
    errorMessage: errorMessage,
    mode: mode ?? this.mode,
  );
}

final loginNotifierProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();
  Future<void> signInWithGoogle() =>
      _run(() => ref.read(authServiceProvider).signInWithGoogle());
  Future<void> signInWithEmail(String e, String p) =>
      _run(() => ref.read(authServiceProvider).signInWithEmail(e, p));
  Future<void> signUpWithEmail(String e, String p, String n) =>
      _run(() => ref.read(authServiceProvider).createUserWithEmail(e, p, n));
  void toggle() => state = state.copyWith(
    mode: state.mode == LoginMode.signIn ? LoginMode.signUp : LoginMode.signIn,
    errorMessage: null,
  );
  Future<void> _run(Future<void> Function() task) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await task();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginNotifierProvider);
    final notifier = ref.read(loginNotifierProvider.notifier);
    final signUp = state.mode == LoginMode.signUp;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Raha',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Text('Your home away from home'),
                  const SizedBox(height: 32),
                  OutlinedButton.icon(
                    onPressed: state.isLoading
                        ? null
                        : notifier.signInWithGoogle,
                    icon: const Icon(Icons.g_mobiledata),
                    label: const Text('Continue with Google'),
                  ),
                  const Padding(padding: EdgeInsets.all(16), child: Text('or')),
                  if (signUp)
                    TextField(
                      controller: name,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                  TextField(
                    controller: email,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: state.isLoading
                        ? null
                        : () => signUp
                              ? notifier.signUpWithEmail(
                                  email.text,
                                  password.text,
                                  name.text,
                                )
                              : notifier.signInWithEmail(
                                  email.text,
                                  password.text,
                                ),
                    child: Text(signUp ? 'Sign Up' : 'Sign In'),
                  ),
                  TextButton(
                    onPressed: state.isLoading ? null : notifier.toggle,
                    child: Text(
                      signUp
                          ? 'Already have an account? Sign In'
                          : "Don't have an account? Sign Up",
                    ),
                  ),
                  if (state.errorMessage != null)
                    Text(
                      state.errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (state.isLoading)
            const ColoredBox(
              color: Color(0x33000000),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
