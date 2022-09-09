export './services/chat_service.dart';
export './services//nucleus_service.dart';
export './services/person_service.dart';
export './services/numbers_service.dart';
export './services/integrator_service.dart';

import 'package:octadesk_core/octadesk_core.dart';
import 'package:octadesk_services/http_clients/nucleus_client.dart';
import 'package:octadesk_services/http_clients/octa_client.dart';

void initializeHttpClients({
  required String jwt,
  required Map<String, String> apis,
  required String accessToken,
  OctaEnvironmentEnum? environment,
}) {
  OctaClient.setApis(apis, jwt);
  NucleusClient.setAuthorizationHeader(accessToken);
}

void disposeHttpClients() {
  OctaClient.dispose();
  NucleusClient.setAuthorizationHeader("");
}

void setEnvironment({OctaEnvironmentEnum? environment}) {
  var url = "";

  // Ambiente de Dev
  if (environment == OctaEnvironmentEnum.dev) {
    url = "https://nucleus.devoctadesk.com/api";
  }

  // Ambiente de QA
  else if (environment == OctaEnvironmentEnum.qa) {
    url = "https://nucleus.qaoctadesk.com/api";
  }

  // Ambiente de prod
  else {
    url = 'https://nucleus.octadesk.com';
  }

  NucleusClient.client.options.baseUrl = url;
}
