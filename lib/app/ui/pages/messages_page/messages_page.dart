
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/messages_controller.dart';


class MessagesPage extends GetView<MessagesController> {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MessagesPage'),
      ),
      body: const SafeArea(
        child: Text('MessagesController'),
      ),
    );
  }
}
  