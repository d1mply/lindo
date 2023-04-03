
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/messages_controller.dart';


class MessagesPage extends GetView<MessagesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MessagesPage'),
      ),
      body: SafeArea(
        child: Text('MessagesController'),
      ),
    );
  }
}
  