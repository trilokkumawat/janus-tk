import 'package:flutter/material.dart';

class TodoDetailScreen extends StatelessWidget {
  final String todoId;
  
  const TodoDetailScreen({
    super.key,
    required this.todoId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Details'),
      ),
      body: Center(
        child: Text('Todo Detail Screen - ID: $todoId'),
      ),
    );
  }
}

