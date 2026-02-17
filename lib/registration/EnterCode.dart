import 'package:flutter/material.dart';


class Entercode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(255, 200, 40, 1), // жёлтый фон
        body: Center(
          child: Container(
            width: 260,
            height: 520,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(220, 220, 220, 1),//grey
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [



                const SizedBox(height: 20),

                // Заголовок
                const Text(
                  'Введите код',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),


                const SizedBox(height: 20),

                // Поле ввода
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Код проверки',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 5,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Подзаголовок
                const Text(
                  'Код не приходит?\nОтправить код еще раз',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 24),

                // Кнопка
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(255, 200, 40, 1),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      //Navigator.pushNamed(context, '/nameData');
                      Navigator.pushNamedAndRemoveUntil(context, '/enterName', (route) => true);

                    },
                    child: const Text(
                      'продолжить',
                      style: TextStyle(fontWeight: FontWeight.bold, ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
