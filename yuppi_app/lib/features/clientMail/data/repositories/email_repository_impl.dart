import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yuppi_app/features/clientMail/dominio/repositories/email_repository.dart';

class SendGridEmailRepository implements EmailRepository {
  static const String _apiKey =
      'API KEY'; 
  static const String _fromEmail = 'noreply@yuppi.shop';
  static const _fromName = 'Yuppi';

  static const String _sendGridUrl = 'URL_SendGrid';

  @override
  Future<void> sendRegistrationEmail({
    required String email,
    required String name,
  }) async {
    final body = _buildEmailBody(
      toEmail: email,
      subject: '¡Bienvenido a Yuppi!',
      htmlContent: '''
        <div style="font-family: 'Arial', sans-serif; color: #333;">
          <h2 style="color: #4FA8F6;">¡Bienvenido a Yuppi, $name! 🎉</h2>

          <p>Gracias por unirte a <strong>Yuppi</strong>, la plataforma que convierte el aprendizaje en una aventura emocionante para tus hijos.</p>

          <p>A partir de ahora podrás:</p>
          <ul>
            <li>📸 Guiar a tu hijo mientras explora el mundo con su cámara</li>
            <li>🎁 Crear recompensas personalizadas por sus logros</li>
            <li>📊 Ver su progreso y reconocer sus fortalezas</li>
            <li>🗣️ Mejorar su pronunciación con inteligencia artificial</li>
          </ul>

          <p>Este es el comienzo de una experiencia educativa diferente, diseñada con amor, juego y tecnología.</p>

          <hr style="margin: 20px 0;" />

          <p style="font-size: 14px; color: #666;">
            Si necesitas ayuda o soporte, no dudes en escribirnos a 
            <a href="mailto:soporte@yuppiapp.com">soporte@yuppiapp.com</a>.
          </p>

          <p style="font-size: 14px; color: #666;">
            💡 Consejo: guarda este correo por si necesitas volver a acceder a tu cuenta.
          </p>

          <p style="margin-top: 30px;">¡Gracias por confiar en nosotros! 💙<br><strong>El equipo de Yuppi</strong></p>
        </div>
      ''',
    );

    await _send(body);
  }

  @override
  Future<void> sendRewardNotification({
    required String email,
    required String childName,
    required String rewardName,
    required int remainingCoins,
    required int remainingThisReward,
  }) async {
    final body = _buildEmailBody(
      toEmail: email,
      subject: 'Recompensa canjeada en Yuppi 🎉',
      htmlContent: '''
        <div style="font-family: 'Arial', sans-serif; color: #333;">
          <h3>Hola 👋</h3>

          <p>Tu hijo(a) <strong>$childName</strong> ha canjeado la recompensa: <strong>$rewardName</strong>.</p>

          <p>🪙 Monedas restantes: <strong>$remainingCoins</strong></p>
          <p>🎯 Recompensas restantes de esta categoría: <strong>$remainingThisReward</strong></p>

          <hr style="margin: 20px 0;" />

          <p style="font-size: 14px; color: #666;">
            Puedes revisar esta información desde tu cuenta en Yuppi. ¡Gracias por seguir motivando su aprendizaje!
          </p>

          <p style="margin-top: 30px;">Con cariño,<br><strong>El equipo de Yuppi 💙</strong></p>
        </div>
      ''',
    );

    await _send(body);
  }

  Future<void> _send(Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(_sendGridUrl),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 202) {
      throw Exception(
        'Error al enviar correo: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Map<String, dynamic> _buildEmailBody({
    required String toEmail,
    required String subject,
    required String htmlContent,
  }) {
    return {
      "personalizations": [
        {
          "to": [
            {"email": toEmail},
          ],
          "subject": subject,
        },
      ],
      "from": {"email": _fromEmail, "name": _fromName},
      "content": [
        {"type": "text/html", "value": htmlContent},
      ],
    };
  }
}
