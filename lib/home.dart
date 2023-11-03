import 'package:fireflutter/todo.dart';
import 'package:fireflutter/todo_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Todo> todoList = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const Drawer(),
        appBar: AppBar(
          title: const Text(
            'Tasker',
            style: TextStyle(
              fontSize: 35,
            ),
          ),
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            TextEditingController dateinput = TextEditingController();
            TextEditingController nameinput = TextEditingController();

            DateTime? selectedDate;
            await showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(17.0),
                  ),
                ),
                context: context,
                builder: (context) {
                  return SizedBox(
                    height: 270,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: nameinput,
                            decoration:
                                const InputDecoration(label: Text('Task name')),
                          ),
                          TextField(
                            controller: dateinput,
                            decoration:
                                const InputDecoration(label: Text('Task Date')),
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    selectedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now()
                                            .add(const Duration(days: 30)));
                                    //  print(selectedDate.toString());
                                    if (selectedDate != null) {
                                      String formattedDate =
                                          DateFormat('yyyy/MM/dd')
                                              .format(selectedDate!);
                                      setState(() {
                                        dateinput.text = formattedDate;
                                      });
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.edit_calendar,
                                    color: Colors.blue,
                                  )),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white10,
                                      elevation: 0),
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text(
                                    'cancel',
                                    style: TextStyle(color: Colors.black),
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  TodoProvider.instance.insertTodo(Todo(
                                      name: nameinput.text,
                                      date:
                                          selectedDate!.millisecondsSinceEpoch,
                                      isChecked: false));
                                  print(todoList);
                                  Navigator.pop(context);
                                },
                                child: const Text("Yes"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
            setState(() {});
          },
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            Container(
              height: 120,
              color: Colors.blue,
              child: ListTile(
                title: Row(
                  children: [
                    const Text(
                      '21',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 40.0,
                      ),
                      child: Column(
                        children: const [
                          Text(
                            'Aug',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '2021',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                trailing: const Padding(
                  padding: EdgeInsets.only(top: 35.0),
                  child: Text(
                    'Wednesday',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Todo>>(
                future: TodoProvider.instance.getAllTodo(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }
                  if (snapshot.hasData) {
                    todoList = snapshot.data!;
                    return ListView.builder(
                      itemCount: todoList.length,
                      itemBuilder: (context, index) {
                        Todo todo = todoList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: Transform.scale(
                              scale: 2,
                              child: Checkbox(
                                shape: CircleBorder(),
                                value: todo.isChecked,
                                onChanged: (bool? value) async {
                                  todoList[index].isChecked = value!;
                                  await TodoProvider.instance
                                      .updateTodo(todoList[index]);
                                  setState(() {});
                                },
                              ),
                            ),
                            title: Text(todo.name),
                            subtitle: Text(
                                DateTime.fromMillisecondsSinceEpoch(todo.date)
                                    .toString()),
                            trailing: IconButton(
                                onPressed: () async {
                                  if (todo.id != null) {
                                    await TodoProvider.instance
                                        .deleteTodo(todo.id!);
                                  }
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          ),
                        );
                      },
                    );
                  }
                  return Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      child: const CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
