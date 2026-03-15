import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // В реальном приложении данные приходят из Firebase / Riverpod / Provider
    final user = {
      'photoUrl': 'https://example.com/user.jpg',
      'name': 'Бермет',
      'age': 27,
      'gender': 'female',
      'rating': 4.92,
      'reviewsCount': 124,
      'tripsAsDriver': 68,
      'tripsAsPassenger': 41,
      'phone_number': '+996 223 444 333',
      'phoneVerified': true,
      'idVerified': true,
      'licenseVerified': true,
      'about':
      'Люблю путешествовать, аккуратный водитель. Не курю, предпочитаю спокойную музыку и тишину в машине, если никто не хочет разговаривать :)',
      'preferences': {
        'smoking': false,
        'animals': 'только мелкие в переноске',
        'chatty': 'Bla',
        'music': 'любая, но не громко',
      },
      'car': 'Toyota Corolla 2019 • белая',
      'carPhotoUrl': null,
      'carYear': 2019,
      'carColor': 'белый',
      'carSteering': 'левый',
      'isDriver': true,
    };

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          // Иконка для открытия меню справа
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.more_vert_rounded), // три точки (или Icons.menu)
              tooltip: 'Меню',
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
          // Если хочешь — можно оставить и кнопку редактирования
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Редактировать профиль',
            onPressed: () {
              // Navigator.push → экран редактирования
            },
          ),
        ],
      ),

      // ← Вот здесь выдвигающееся меню СПРАВА
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Шапка меню (опционально)
            DrawerHeader(
              decoration: BoxDecoration(
                color: colorScheme.primary,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.settings_rounded,
                    size: 48,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Настройки',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Пункт 1 — Правила безопасности
            ListTile(
              leading: const Icon(Icons.security_rounded),
              title: const Text('Правила безопасности'),
              onTap: () {
                Navigator.pop(context); // закрываем меню
                // Здесь можно перейти на экран с правилами
                // Navigator.push(context, MaterialPageRoute(builder: (_) => SafetyRulesScreen()));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Открываются правила безопасности...')),
                );
              },
            ),

            // Пункт 2 — Выбор языка
            ListTile(
              leading: const Icon(Icons.language_rounded),
              title: const Text('Выбор языка'),
              onTap: () {
                Navigator.pop(context);
                // Логика выбора языка (можно открыть bottom sheet или новый экран)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Выбор языка (в разработке)')),
                );
              },
            ),

            // Разделитель и дополнительные пункты (по желанию)
            const Divider(),
            ListTile(
              leading: const Icon(Icons.help_outline_rounded),
              title: const Text('Помощь и поддержка'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: const Text('О приложении'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
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
                foregroundImage: user['photoUrl'] != null &&
                    (user['photoUrl'] as String).trim().isNotEmpty
                    ? NetworkImage(user['photoUrl'] as String)
                    : null,
                onForegroundImageError: (exception, stackTrace) {
                  debugPrint('Ошибка загрузки фото профиля: $exception');
                },
                child: const Icon(Icons.person_rounded, size: 64),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              '${user['name']} • ${user['age']} ${user['gender'] == 'female' ? '♀' : '♂'}',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
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
                  '${user['rating']}  (${user['reviewsCount']} отзывов)',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Телефон
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.phone_rounded,
                    color: colorScheme.primary, size: 22),
                const SizedBox(width: 8),
                Text(
                  user['phone_number'] as String,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Поездки
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _StatChip(
                    label: 'Водитель: ${user['tripsAsDriver']}',
                    icon: Icons.drive_eta_rounded,
                  ),
                  const SizedBox(width: 16),
                  _StatChip(
                    label: 'Пассажир: ${user['tripsAsPassenger']}',
                    icon: Icons.emoji_people_rounded,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            const Divider(height: 1, indent: 24, endIndent: 24),
            const SizedBox(height: 24),

            // Верификации
            _VerificationTile(
              icon: Icons.phone_rounded,
              label: 'Номер телефона',
              verified: user['phoneVerified'] as bool,
            ),
            _VerificationTile(
              icon: Icons.badge_rounded,
              label: 'Паспорт / ID',
              verified: user['idVerified'] as bool,
            ),
            _VerificationTile(
              icon: Icons.card_membership_rounded,
              label: 'Водительское удостоверение',
              verified: user['licenseVerified'] as bool,
            ),

            const SizedBox(height: 32),

            // Блок автомобиля
            if (user['isDriver'] == true) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Автомобиль',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: user['carPhotoUrl'] != null &&
                          (user['carPhotoUrl'] as String).trim().isNotEmpty
                          ? Image.network(
                        user['carPhotoUrl'] as String,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _CarPlaceholder(),
                      )
                          : _CarPlaceholder(),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      user['car'] as String? ?? 'Не указан',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Цвет: ${user['carColor'] ?? '—'} • Год: ${user['carYear'] ?? '—'}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Руль: ${user['carSteering'] ?? '—'}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
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
                  Text(
                    'О себе',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user['about'] as String,
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // Выход
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: FilledButton.tonal(
                style: FilledButton.styleFrom(
                  foregroundColor: Colors.red,
                  minimumSize: const Size.fromHeight(52),
                ),
                onPressed: () {
                  // Логика выхода
                },
                child: const Text('Выйти из аккаунта'),
              ),
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _StatChip({required String label, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _VerificationTile({
    required IconData icon,
    required String label,
    required bool verified,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: verified ? Colors.green : Colors.grey.shade500,
      ),
      title: Text(label),
      trailing: Icon(
        verified ? Icons.check_circle_rounded : Icons.cancel_rounded,
        color: verified ? Colors.green : Colors.red.shade400,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }

  Widget _CarPlaceholder() {
    return Container(
      height: 180,
      color: Colors.grey.shade200,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car_filled_rounded,
                size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text('Фото автомобиля отсутствует',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}