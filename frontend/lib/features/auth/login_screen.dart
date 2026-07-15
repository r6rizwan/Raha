import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/l10n.dart';
import '../../core/theme/app_theme.dart';
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
      state = state.copyWith(
        isLoading: false,
        errorMessage: authErrorMessage(e),
      );
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
  bool _showPassword = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginNotifierProvider);
    final notifier = ref.read(loginNotifierProvider.notifier);
    final signUp = state.mode == LoginMode.signUp;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 34, 24, 34),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RAHA',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.6,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Your home away\nfrom home',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          height: 1.05,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            signUp
                                ? l10n.loginCreateAccount
                                : l10n.loginWelcomeBack,
                            style: const TextStyle(
                              color: AppColors.text,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.loginDescription,
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 13,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 22),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(52),
                              foregroundColor: AppColors.text,
                              backgroundColor: AppColors.card,
                              side: const BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            onPressed: state.isLoading
                                ? null
                                : notifier.signInWithGoogle,
                            icon: const Icon(Icons.g_mobiledata, size: 28),
                            label: Text(l10n.continueWithGoogle),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 18),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(color: AppColors.border),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    l10n.or,
                                    style: const TextStyle(
                                      color: AppColors.muted,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(color: AppColors.border),
                                ),
                              ],
                            ),
                          ),
                          if (signUp) ...[
                            TextField(
                              controller: name,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                labelText: l10n.name,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                          TextField(
                            controller: email,
                            decoration: InputDecoration(
                              labelText: l10n.email,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: password,
                            obscureText: !_showPassword,
                            decoration: InputDecoration(
                              labelText: l10n.password,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                                tooltip: _showPassword
                                    ? l10n.hidePassword
                                    : l10n.showPassword,
                                icon: Icon(
                                  _showPassword
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
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
                            child: Text(signUp ? l10n.signUp : l10n.signIn),
                          ),
                          TextButton(
                            onPressed: state.isLoading ? null : notifier.toggle,
                            child: Text(
                              signUp
                                  ? l10n.alreadyHaveAccount
                                  : l10n.dontHaveAccount,
                            ),
                          ),
                          if (state.errorMessage != null)
                            Text(
                              state.errorMessage!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
