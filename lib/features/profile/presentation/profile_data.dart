import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Здесь в реальном приложении данные придут из Firebase / Provider / Riverpod
    final user = {
      'photoUrl': 'https://example.com/user.jpg',
      'name': 'Бермет',
      'age': 27,
      'gender': 'female',
      'rating': 4.92,
      'reviewsCount': 124,
      'tripsAsDriver': 68,
      'tripsAsPassenger': 41,
      'phone_number': '+996223444333',
      'phoneVerified': true,
      'idVerified': true,

      'about': 'Люблю путешествовать, аккуратный водитель. Не курю, предпочитаю спокойную музыку и тишину в машине, если никто не хочет разговаривать :)',
      'preferences': {
        'smoking': false,
        'animals': 'только мелкие в переноске',
        'chatty': 'Bla', // или 'BlaBlaBla'
        'music': 'любая, но не громко',
      },
      'car': 'Toyota Corolla 2019 • белая',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {

              // → экран редактирования профиля
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // Фото + имя + возраст + пол
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(user['photoUrl'] as String),
            ),
            const SizedBox(height: 16),
            Text(
              '${user['name']} • ${user['age']} ${user['gender'] == 'female' ? '♀' : '♂'}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Рейтинг
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 22),
                const SizedBox(width: 4),
                Text(
                  '${user['rating']}  (${user['reviewsCount']} отзывов)',
                  style: const TextStyle(fontSize: 18),
                ),

              ],
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.phone, color: Colors.blue, size: 22),
                const SizedBox(width: 4),
                Text(
                  '${user['phone_number']} ',
                  style: const TextStyle(fontSize: 18),

                )
              ],
            ),

            const SizedBox(height: 12),

            // Поездки
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StatChip('был водителем: ${user['tripsAsDriver']}'),
                const SizedBox(width: 16),
                _StatChip('был пассажиром: ${user['tripsAsPassenger']}'),
              ],
            ),

            const SizedBox(height: 24),

            // Верификации
            _VerificationRow(
              icon: Icons.phone,
              label: 'Телефон подтверждён',
              verified: user['phoneVerified'] as bool,
            ),
            _VerificationRow(
              icon: Icons.badge,
              label: 'Паспорт / ID проверен',
              verified: user['idVerified'] as bool,
            ),
            _VerificationRow(
              icon: Icons.car_repair,
              label: 'Водительское удостоверение /  проверен',
              verified: user['idVerified'] as bool,
            ),


            const SizedBox(height: 32),

// Блок "Автомобиль" — показываем только если есть данные об авто
            if (user['isDriver'] == true || user['car'] != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Автомобиль',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    // Фото машины (если есть URL)
                    if (user['carPhotoUrl'] != null && (user['carPhotoUrl'] as String).isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          user['carPhotoUrl'] as String,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 180,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.directions_car, size: 60, color: Colors.grey),
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.directions_car, size: 60, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Фото машины не добавлено'),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Информация об авто
                    Text(
                      user['car'] as String? ?? 'Марка и модель не указаны',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Цвет: ${user['carColor'] ?? 'не указан'} • Год: ${user['carYear'] ?? '?'}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    Text(
                      'Руль: ${user['carColor'] ?? 'правый'} ',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    Text(
                      'Руль: ${user['carColor'] ?? 'правый'} ',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
            ],

            const SizedBox(height: 32),

            // Предпочтения (можно сделать в виде карточек или чипов)
            // ...

            const SizedBox(height: 40),

            // Кнопка выхода
            Padding(
              padding: const EdgeInsets.all(20),
              child: OutlinedButton(
                onPressed: () {
                  // logout logic
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
                child: const Text('Выйти из аккаунта'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _StatChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text),
    );
  }

  Widget _VerificationRow({
    required IconData icon,
    required String label,
    required bool verified,
  }) {
    return ListTile(
      leading: Icon(icon, color: verified ? Colors.green : Colors.grey),
      title: Text(label),
      trailing: verified
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.cancel, color: Colors.red),
    );
  }
}