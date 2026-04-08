import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'theme_mode_controller.dart';

void main() {
  runApp(const ThemeArchitectureApp());
}

class ThemeArchitectureApp extends StatefulWidget {
  const ThemeArchitectureApp({super.key});

  @override
  State<ThemeArchitectureApp> createState() => _ThemeArchitectureAppState();
}

class _ThemeArchitectureAppState extends State<ThemeArchitectureApp> {
  final ThemeModeController _controller = ThemeModeController();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Theme Architecture Example',
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: _controller.themeMode,
          home: ThemeExampleScreen(controller: _controller),
        );
      },
    );
  }
}

class ThemeExampleScreen extends StatelessWidget {
  const ThemeExampleScreen({
    super.key,
    required this.controller,
  });

  final ThemeModeController controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Architecture'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'A simple pattern for centralized theme control.',
              style: textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              'The app theme is defined in one place and switched through a dedicated controller instead of scattering theme logic across widgets.',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Card(
              color: colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme mode',
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _ThemeChip(
                          label: 'System',
                          selected: controller.themeMode == ThemeMode.system,
                          onTap: () => controller.setThemeMode(ThemeMode.system),
                        ),
                        _ThemeChip(
                          label: 'Light',
                          selected: controller.themeMode == ThemeMode.light,
                          onTap: () => controller.setThemeMode(ThemeMode.light),
                        ),
                        _ThemeChip(
                          label: 'Dark',
                          selected: controller.themeMode == ThemeMode.dark,
                          onTap: () => controller.setThemeMode(ThemeMode.dark),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeChip extends StatelessWidget {
  const _ThemeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
