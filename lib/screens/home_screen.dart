import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rare_crew_task/screens/add_or_edit_screen.dart';

import '../view_model/items_view_model.dart';

class HomeScreen extends StatefulWidget {
  final String accessToken, refreshToken;
  const HomeScreen(
      {Key? key, required this.accessToken, required this.refreshToken})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final signInProvider = Provider((ref) => ItemsViewModel.instance);
    final responseProvider =
        FutureProvider<List<Map<String, dynamic>>>((ref) async {
      final readData = ref.read(signInProvider);
      await readData.initializeDatabase();
      return await readData.getAll();
    });
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tasks',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => AddOrEditScreen(
                              buttonTitle: 'Add',
                              accessToken: widget.accessToken,
                              refreshToken: widget.refreshToken,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Add',
                      ),
                    ),
                  ],
                ),
              ),
              Consumer(
                builder: (context, watch, child) {
                  final respnese = watch(responseProvider);
                  return respnese.map(
                      data: (data) {
                        return Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.all(5),
                                color: const Color(0xff10ADBC),
                                child: ListTile(
                                  leading: Text(
                                    data.value[index]['name'],
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  title: Text(
                                    '${data.value[index]['cost']}\$',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  trailing: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) =>
                                                        AddOrEditScreen(
                                                  buttonTitle: 'Edit',
                                                  accessToken:
                                                      widget.accessToken,
                                                  refreshToken:
                                                      widget.refreshToken,
                                                  id: data.value[index]['_id'],
                                                ),
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await ItemsViewModel.instance
                                                .delete(
                                                    data.value[index]['_id']);
                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: data.value.length,
                          ),
                        );
                      },
                      error: (data) => const Center(
                            child: Text('Eror'),
                          ),
                      loading: (data) => const Center(
                            child: CircularProgressIndicator(),
                          ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
