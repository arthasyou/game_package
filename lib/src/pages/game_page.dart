import 'package:flutter/material.dart';

import '../widgets/slot_machine_widget.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SlotMachineWidget(),
      ),
    );
  }
}
