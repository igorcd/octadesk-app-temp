// ignore_for_file: avoid_print

import 'package:example/helpers/base64_image.dart';
import 'package:flutter/material.dart';
import 'package:octadesk_core/enums/chat_channel_enum.dart';
import 'package:octadesk_services/octadesk_services.dart';

class ExampleView extends StatefulWidget {
  const ExampleView({Key? key}) : super(key: key);

  @override
  State<ExampleView> createState() => _ExampleViewState();
}

class _ExampleViewState extends State<ExampleView> {
  void _uploadFile() async {
    var file = await generateFileFromBase64();
    var resp = await ChatService.uploadFile(
      file: file,
      channel: ChatChannelEnum.web,
    );
    print(resp);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final services = [
      {
        "name": "Chat Service",
        "endpoints": [
          {"title": "/upload - Method: POST - Realizar upload de arquivo", "action": _uploadFile},
        ]
      },
    ];

    Widget title(String text) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(text, style: Theme.of(context).textTheme.headline4),
      );
    }

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(30),
        itemCount: services.length,
        itemBuilder: (context, index) {
          var service = services[index];
          var serviceName = service["name"].toString();
          var endpoints = service["endpoints"] as List<Map<String, Object>>;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              title(serviceName),
              ListView.separated(
                shrinkWrap: true,
                itemCount: endpoints.length,
                separatorBuilder: (context, index) => const Divider(height: 30),
                itemBuilder: (context, index) {
                  var endpoint = endpoints[index];
                  var endpointTitle = endpoint["title"].toString();
                  var action = endpoint["action"];

                  return ElevatedButton(onPressed: action as void Function(), child: Text(endpointTitle));
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
