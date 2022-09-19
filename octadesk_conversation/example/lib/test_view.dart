import 'package:example/rooms_view.dart';
import 'package:flutter/material.dart';
import 'package:octadesk_conversation/octadesk_conversation.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:octadesk_services/enums/authentication_provider_enum.dart';
import 'package:octadesk_services/octadesk_services.dart';

class TestView extends StatefulWidget {
  const TestView({Key? key}) : super(key: key);

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  Future<void>? _initializationFuture;

  Future<void> initialize() async {
    try {
      setEnvironment(environment: OctaEnvironmentEnum.qa);

      // Login
      var auth = await NucleusService.auth(
        AuthDTO(
          userName: "nicolas.rosendo@octadesk.com",
          password: "1",
          tenantId: "93a95cf7-2d04-40b1-9801-3eb95e0c6081",
        ),
        AuthenticationProviderEnum.email,
      );

      var user = UserModel.fromAuthenticationDTO(auth);

      // Inicializar clientes HTTP
      initializeHttpClients(
        accessToken: auth.accessToken,
        apis: auth.apis,
        jwt: auth.jwToken,
      );

      // Initializar o cliente
      await OctadeskConversation.instance.initialize(
        agentId: user.id,
        socketUrl: auth.apis["chatSocketBase"]!,
        subDomain: auth.octaAuthenticated.subDomain,
      );
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _initializationFuture = initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializationFuture,
      builder: (context, snapshot) {
        // Error
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                snapshot.error.toString(),
                maxLines: 3,
              ),
            ),
          );
        }

        // Loading
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }

        // Conteúdo
        return Scaffold(
          //  App Bar
          appBar: AppBar(
            title: Text("Octadesk conversation"),
            actions: [
              PopupMenuButton(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: StreamBuilder(
                    stream: OctadeskConversation.instance.getAgentConnectionStatusStream(),
                    builder: (context, snapshot) {
                      return Text(snapshot.data.toString());
                    },
                  ),
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(child: Text("Online")),
                    PopupMenuItem(child: Text("Offline")),
                    PopupMenuItem(child: Text("Ausente")),
                  ];
                },
              )
            ],
          ),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 300,
                child: RoomsView(
                  onSelectRoom: (key) async {},
                ),
              ),
              VerticalDivider(),
              Expanded(
                child: Text("Fazer"),
              )
            ],
          ),
        );
      },
    );
  }
}
