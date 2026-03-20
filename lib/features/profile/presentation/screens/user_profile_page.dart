import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_2/features/widgets/safety_rules.dart';
import 'package:get_it/get_it.dart';
import '../../../widgets/_CarPlaceholder.dart';
import '../bloc/profile_bloc.dart';
import '../../../../core/entities/UserEntity.dart';
import '../../../../features/widgets/StatChip.dart';
import '../../../../features/widgets/_VerificationTile.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<ProfileBloc>()..add(LoadProfile()),
      child: const _UserProfileView(),
    );
  }
}

class _UserProfileView extends StatelessWidget {
  const _UserProfileView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          // Три точки (меню) — используем Builder для правильного context
          Builder(
            builder: (BuildContext buttonContext) {
              return IconButton(
                icon: const Icon(Icons.more_vert_rounded),
                tooltip: 'Меню',
                onPressed: () {
                  Scaffold.of(buttonContext).openEndDrawer();
                },
              );
            },
          ),

          // Карандаш (редактировать)
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Редактировать',
            onPressed: () {
              // Если экрана редактирования пока нет → можно пока показать SnackBar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Редактирование профиля в разработке')),
              );

              // Или переход, когда экран будет готов:
              // Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfileScreen()));
            },
          ),
        ],
      ),
      endDrawer: _buildEndDrawer(context),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => context.read<ProfileBloc>().add(LoadProfile()),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          if (state is ProfileLoaded) {
            return _buildProfileContent(context, state.user, theme, colorScheme);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEndDrawer(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: colorScheme.primary),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.settings_rounded, size: 48, color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'Настройки',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.security_rounded),
            title: const Text('Правила безопасности'),
            onTap: () {
              Navigator.pop(context); // закрыть drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SafetyRules(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.language_rounded),
            title: const Text('Выбор языка'),
            onTap: () => Navigator.pop(context),
          ),
          const Divider(),
          ListTile(leading: const Icon(Icons.help_outline_rounded), title: const Text('Помощь и поддержка'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.info_outline_rounded), title: const Text('О приложении'), onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserEntity user, ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),

          // Аватар
          Hero(
            tag: 'user-avatar',
            child: CircleAvatar(
              radius: 64,
              backgroundColor: colorScheme.primaryContainer,
              child: user.photoUrl != null && user.photoUrl!.trim().isNotEmpty
                  ? ClipOval(
                child: Image.network(
                  user.photoUrl!,
                  width: 128,
                  height: 128,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person_rounded, size: 64);
                  },
                ),
              )
                  : const Icon(Icons.person_rounded, size: 64),
            ),
          ),

          const SizedBox(height: 12),

          // Рейтинг
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 24),
              const SizedBox(width: 6),
              Text(
                '${user.rating.toStringAsFixed(2)} (${user.reviewsCount} отзывов)',
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Телефон
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.phone_rounded, color: colorScheme.primary, size: 22),
              const SizedBox(width: 8),
              Text(
                user.phoneNumber ?? 'Не указан',
                style: theme.textTheme.titleMedium,
              ),
              if (user.phoneVerified) ...[
                const SizedBox(width: 4),
                const Icon(Icons.verified, color: Colors.green, size: 18),
              ],
            ],
          ),

          const SizedBox(height: 24),

          // Статистика поездок
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StatChip(
                  label: 'Водитель: ${user.tripsAsDriver}',
                  icon: Icons.drive_eta_rounded,
                ),
                const SizedBox(width: 16),
                StatChip(
                  label: 'Пассажир: ${user.tripsAsPassenger}',
                  icon: Icons.emoji_people_rounded,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          const Divider(height: 1, indent: 24, endIndent: 24),
          const SizedBox(height: 24),

          // Верификации
          VerificationTile(icon: Icons.phone_rounded, label: 'Номер телефона', verified: user.phoneVerified),
          VerificationTile(icon: Icons.badge_rounded, label: 'Паспорт / ID', verified: user.idVerified),
          VerificationTile(icon: Icons.card_membership_rounded, label: 'Водительское удостоверение', verified: user.licenseVerified),

          const SizedBox(height: 32),

          // Блок автомобиля (только если водитель)
          if (user.isDriver) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Автомобиль', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: user.carPhotoUrl != null && user.carPhotoUrl!.isNotEmpty
                        ? Image.network(
                      user.carPhotoUrl!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const CarPlaceholder(),
                    )
                        : const CarPlaceholder(),
                  ),
                  const SizedBox(height: 16),
                  Text(user.car ?? 'Не указан', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Цвет: ${user.carColor ?? '—'} • Год: ${user.carYear ?? '—'}',
                    style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  Text(
                    'Руль: ${user.carSteering ?? '—'}',
                    style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Divider(height: 1, indent: 24, endIndent: 24),
          ],

          const SizedBox(height: 32),

          // О себе
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('О себе', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(
                  user.about ?? 'Нет информации',
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),

          const SizedBox(height: 48),

          // Кнопка выхода
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: FilledButton.tonal(
              style: FilledButton.styleFrom(
                foregroundColor: Colors.red,
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: () {
                //FirebaseAuth.instance.signOut(); //навигация на логин
                Navigator.pushNamed(context, '/login');
                },
              child: const Text('Выйти из аккаунта'),
            ),
          ),

          const SizedBox(height: 60),
        ],
      ),
    );
  }
}