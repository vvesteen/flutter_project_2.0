// lib/features/profile/presentation/screens/safety_rules_screen.dart
import 'package:flutter/material.dart';

class SafetyRules extends StatelessWidget {
  const SafetyRules({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Правила безопасности'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Общие правила безопасности',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildRuleItem(
              '1. Проверяйте профиль собеседника',
              'Перед поездкой смотрите рейтинг, количество отзывов, верификации (телефон, паспорт, права). Не садитесь к людям с низким рейтингом или без отзывов.',
            ),

            _buildRuleItem(
              '2. Делитесь поездкой с близкими',
              'Используйте функцию «Поделиться поездкой» — отправьте маршрут, данные водителя/пассажира и время прибытия родным или друзьям.',
            ),

            _buildRuleItem(
              '3. Встречайтесь в людных местах',
              'Если вы пассажир — просите водителя подъехать к освещённому месту (АЗС, ТЦ, остановка). Если водитель — не забирайте пассажиров в тёмных дворах.',
            ),

            _buildRuleItem(
              '4. Не садитесь и не высаживайте в подозрительных местах',
              'Если маршрут изменился или место кажется небезопасным — отмените поездку и сообщите в поддержку.',
            ),

            _buildRuleItem(
              '5. Держите телефон заряженным и под рукой',
              'Не выключайте геолокацию и мобильный интернет во время поездки. Имейте под рукой кнопку SOS / экстренный вызов.',
            ),

            const SizedBox(height: 24),
            const Text(
              'Для водителей — дополнительно',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildRuleItem(
              '• Не перевозите людей в состоянии алкогольного/наркотического опьянения',
              'Это запрещено правилами сервиса и законодательством КР.',
            ),
            _buildRuleItem(
              '• Не оставляйте пассажиров в машине без присмотра',
              'Особенно детей и людей в нетрезвом состоянии.',
            ),
            _buildRuleItem(
              '• Фиксируйте состояние автомобиля до и после поездки',
              'Делайте фото салона и багажника перед посадкой пассажира.',
            ),

            const SizedBox(height: 24),
            const Text(
              'Для пассажиров — дополнительно',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildRuleItem(
              '• Садитесь только в машину с указанным номером',
              'Сверьте госномер, марку, цвет и фото водителя с приложением.',
            ),
            _buildRuleItem(
              '• Не садитесь на переднее сиденье, если не уверены',
              'Лучше сесть сзади — это безопаснее.',
            ),
            _buildRuleItem(
              '• Сообщите номер машины и имя водителя близким',
              'Сделайте скриншот поездки сразу после начала.',
            ),

            const SizedBox(height: 32),
            const Text(
              'Экстренные ситуации',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 12),

            const Text(
              '• Нажмите кнопку SOS в приложении\n'
                  '• Позвоните 112 (МЧС, полиция, скорая)\n'
                  '• Сообщите в поддержку приложения (чат или звонок)\n\n'
                  'Мы рекомендуем сохранять спокойствие и действовать быстро.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 40),
            Center(
              child: Text(
                'Безопасность — наш главный приоритет\nПопутчики Кыргызстан © 2026',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(fontSize: 15, height: 1.4),
          ),
        ],
      ),
    );
  }
}