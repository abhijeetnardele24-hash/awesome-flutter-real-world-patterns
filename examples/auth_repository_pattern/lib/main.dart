import 'package:flutter/material.dart';

import 'application/auth_controller.dart';
import 'data/auth_repository.dart';
import 'data/token_store.dart';

void main() {
  final controller = AuthController(
    FakeAuthRepository(InMemoryTokenStore()),
  );

  runApp(AuthRepositoryPatternApp(controller: controller));
}

class AuthRepositoryPatternApp extends StatefulWidget {
  const AuthRepositoryPatternApp({
    super.key,
    required this.controller,
  });

  final AuthController controller;

  @override
  State<AuthRepositoryPatternApp> createState() =>
      _AuthRepositoryPatternAppState();
}

class _AuthRepositoryPatternAppState extends State<AuthRepositoryPatternApp> {
  @override
  void initState() {
    super.initState();
    widget.controller.restoreSession();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auth Repository Pattern',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
        ),
        useMaterial3: true,
      ),
      home: AuthExampleScreen(controller: widget.controller),
    );
  }
}

class AuthExampleScreen extends StatefulWidget {
  const AuthExampleScreen({
    super.key,
    required this.controller,
  });

  final AuthController controller;

  @override
  State<AuthExampleScreen> createState() => _AuthExampleScreenState();
}

class _AuthExampleScreenState extends State<AuthExampleScreen> {
  final _emailController = TextEditingController(text: 'hello@example.com');
  final _passwordController = TextEditingController(text: 'password123');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final state = widget.controller.state;
        final isLoading = state.status == AuthStatus.loading;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Auth Repository Pattern'),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: state.status == AuthStatus.signedIn
                        ? _SignedInView(
                            userId: state.session!.userId,
                            onSignOut: isLoading
                                ? null
                                : () => widget.controller.signOut(),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sign in flow',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'The widget only handles input and rendering. Repository and token persistence live outside the UI.',
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                ),
                              ),
                              if (state.errorMessage != null) ...[
                                const SizedBox(height: 12),
                                Text(
                                  state.errorMessage!,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 20),
                              FilledButton(
                                onPressed: isLoading
                                    ? null
                                    : () => widget.controller.signIn(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        ),
                                child: Text(
                                  isLoading ? 'Signing in...' : 'Sign in',
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SignedInView extends StatelessWidget {
  const _SignedInView({
    required this.userId,
    required this.onSignOut,
  });

  final String userId;
  final VoidCallback? onSignOut;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Session restored',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        Text('Signed in user: $userId'),
        const SizedBox(height: 16),
        FilledButton.tonal(
          onPressed: onSignOut,
          child: const Text('Sign out'),
        ),
      ],
    );
  }
}
