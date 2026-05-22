/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<LanguageCubit>(),
      child: const _LanguageSelectionView(),
    );
  }
}

class _LanguageSelectionView extends StatelessWidget {
  const _LanguageSelectionView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<LanguageCubit>();
    final currentLang = cubit.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор языка'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _LanguageOption(
            title: 'Кыргызча',
            subtitle: 'Кыргыз тили',
            code: 'ky',
            isSelected: currentLang == 'ky',
            onTap: () => cubit.changeLanguage('ky'),
          ),
          const SizedBox(height: 8),
          _LanguageOption(
            title: 'Русский',
            subtitle: 'Русский язык',
            code: 'ru',
            isSelected: currentLang == 'ru',
            onTap: () => cubit.changeLanguage('ru'),
          ),
          const SizedBox(height: 8),
          _LanguageOption(
            title: 'English',
            subtitle: 'English language',
            code: 'en',
            isSelected: currentLang == 'en',
            onTap: () => cubit.changeLanguage('en'),
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final String code;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.title,
    required this.subtitle,
    required this.code,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? Colors.blue.shade50 : null,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Text(
          code.toUpperCase(),
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        subtitle: Text(subtitle),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: Colors.green, size: 28)
            : null,
        onTap: onTap,
      ),
    );
  }
}*/