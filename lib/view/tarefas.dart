import 'package:flutter/material.dart';
import '../model/todo.dart';
import 'list_todos.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController todoController = TextEditingController();
  final List<Todo> todos = []; //Lista

  Todo? deletedTodo;
  int? deletedTodoPos;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Tarefas App',
            textAlign: TextAlign.center,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Lista de Tarefas',
                  style: TextStyle(fontSize: 35),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: todoController,
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          labelText: 'Adicione uma Tarefa',
                          hintText: 'Ex. Fazer Exercício',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;
                        //Tarefas adicionadas no botão de enviar;
                        setState(() {
                          Todo newTodo = Todo(
                            title: text,
                            dateTime: DateTime.now(),
                          );
                          todos.add(newTodo);
                        });
                        //após adicionar lista, limpar caixa de texto;
                        todoController.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      //lista de tarefas;
                      for (Todo todo in todos)
                        TodoListItem(
                          todo: todo,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          //Texto no inferior com a quantidades de tarefas;
                          'Você possui ${todos.length} tarefas pendentes',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(
                            11,
                          ),
                        ),
                        onPressed: () {
                          //limpar toda a lista;
                          String text = todoController.text;

                          setState(() {
                            Todo(
                              title: text,
                              dateTime: DateTime.now(),
                            );
                            todos.clear();
                          });
                          todoController.clear();
                        },
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });
    ScaffoldMessenger.of(context).clearSnackBars(); //limpar notificação
    ScaffoldMessenger.of(context).showSnackBar(
      //Mostrar notificação
      SnackBar(
        content: Text(
          'Tarefa ${todo.title} foi removida com sucesso!',
        ),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPos!, deletedTodo!);
            });
          },
        ),
      ),
    );
  }
}
