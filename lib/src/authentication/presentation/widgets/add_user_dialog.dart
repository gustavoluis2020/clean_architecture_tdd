import 'package:clean_architecture_tdd/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddUserDialog extends StatelessWidget {
  const AddUserDialog({super.key, required this.nameController});

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'userName',
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  context.read<AuthenticationCubit>().createUser(
                        createdAt: DateTime.now().toString(),
                        name: name,
                        avatar:
                            'https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/1013.jpg',
                      );
                },
                child: const Text('Create User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
