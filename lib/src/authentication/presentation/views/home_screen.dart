import 'package:clean_architecture_tdd/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:clean_architecture_tdd/src/authentication/presentation/widgets/add_user_dialog.dart';
import 'package:clean_architecture_tdd/src/authentication/presentation/widgets/loading_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController nameController = TextEditingController();

  void getUsers() {
    context.read<AuthenticationCubit>().getUsers();
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is UserCreated) {
          getUsers();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Add Users'),
          ),
          body: state is GettingUsers
              ? const LoadingColumn(message: 'Getting Users')
              : state is CreatingUser
                  ? const LoadingColumn(message: 'Creating User')
                  : state is UsersLoaded
                      ? ListView.builder(
                          itemCount: state.users.length,
                          itemBuilder: (context, index) {
                            final user = state.users[index];
                            return ListTile(
                              title: Text(user.name),
                              subtitle: Text(user.createdAt),
                              leading: SizedBox(
                                width: 50,
                                height: 50,
                                child: Image.network(
                                  user.avatar,
                                  scale: 0.5,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        )
                      : const SizedBox.shrink(),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => AddUserDialog(
                  nameController: nameController,
                ),
              );
            },
            label: const Text('Add User'),
            icon: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
