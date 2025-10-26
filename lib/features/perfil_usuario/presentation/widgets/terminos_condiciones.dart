import 'package:flutter/material.dart';

class TerminosCondiciones extends StatelessWidget {
  const TerminosCondiciones({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos y condiciones', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(255, 248, 251, 255),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFF1E88E5),
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Términos y Condiciones de \n Uso',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '1. Aceptación de términos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Al acceder y utilizar esta aplicación, aceptas estar sujeto a estos términos y condiciones de uso, todas las leyes y regulaciones aplicables.',
                  style: TextStyle(fontSize: 14, height: 1.5),
                ),
                SizedBox(height: 20),
                Text(
                  '2. Uso de la aplicación',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Esta aplicación está destinada para uso personal y no comercial. No debes usar esta aplicación de ninguna manera que cause daño a la aplicación o afecte el acceso de otros usuarios.',
                  style: TextStyle(fontSize: 14, height: 1.5),
                ),
                SizedBox(height: 20),
                Text(
                  '3. Privacidad',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Tu privacidad es importante para nosotros. Toda la información personal que proporciones será tratada de acuerdo con nuestra Política de Privacidad.',
                  style: TextStyle(fontSize: 14, height: 1.5),
                ),
                SizedBox(height: 20),
                Text(
                  '4. Modificaciones',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Nos reservamos el derecho de modificar estos términos en cualquier momento. Las modificaciones entrarán en vigor inmediatamente después de su publicación.',
                  style: TextStyle(fontSize: 14, height: 1.5),
                ),
                SizedBox(height: 20),
                Text(
                  '5. Contacto',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Si tienes preguntas sobre estos términos, por favor contáctanos a través de los canales oficiales de la aplicación.',
                  style: TextStyle(fontSize: 14, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}