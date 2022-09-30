import 'package:ntp/ntp.dart';

int _ntpOffset = 0;
int _connectionAttempts = 0;

List<String> _ntpServers = [
  'time.google.com',
  'pool.ntp.br',
  '0.br.pool.ntp.org',
  '1.br.pool.ntp.org',
  '2.br.pool.ntp.org',
  '3.br.pool.ntp.org',
  '169.254.169.123',
  'time.nist.gov'
];

Future<void> adjustNtpOffset() async {
  String server = _ntpServers[_connectionAttempts];
  // ignore: avoid_print
  print("Ajustando a hora para o servidor $server");
  try {
    _ntpOffset = await NTP.getNtpOffset(
      localTime: DateTime.now(),
      lookUpAddress: server,
      timeout: Duration(seconds: 7),
    );
  } catch (e) {
    // Tentar novamente no próximo servidor
    _connectionAttempts += 1;
    if (_connectionAttempts < _ntpServers.length - 1) {
      await adjustNtpOffset();
    } else {
      rethrow;
    }
  }
}

DateTime ntpDateTime() {
  return DateTime.now().add(Duration(milliseconds: _ntpOffset));
}
