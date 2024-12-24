import 'package:flutter/material.dart';
import 'package:sigmatech/common/widgets/appbar/appbar.dart';

class StoreScreen extends StatelessWidget{
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text( 'Store', style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          // TCartCounterIcon(onPressed: (){}),
        ],
      ),
    );
    throw UnimplementedError();
  }
}