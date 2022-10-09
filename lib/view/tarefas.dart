import 'package:app_listatarefas/repository/todo_repository.dart';
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
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = []; //Lista

  String? errorText;
  Todo? deletedTodo;
  int? deletedTodoPos; //posiçao de quando for deletado

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 20,
          title: const Text(
            'BEM VINDO ÀS SUAS TAREFAS',
          ),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  top: 25,
                  bottom: 20,
                  left: 10,
                  right: 10,
                ),
                child: Text(
                  'Lista de Tarefas',
                  style: TextStyle(
                    fontSize: 35,
                  ),
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
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelText: 'Adicione uma Tarefa',
                          hintText: 'Ex. Fazer Exercício',
                          errorText: errorText,
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                            ),
                          ),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(
                      8.0,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;
                        //Tarefas adicionadas no botão de enviar;

                        if (text.isEmpty) {
                          setState(() {
                            errorText = 'Adicione uma Tarefa';
                          });
                          return;
                        }

                        setState(() {
                          Todo newTodo = Todo(
                            title: text,
                            dateTime: DateTime.now(),
                          );
                          todos.add(newTodo);
                          errorText = null;
                          todoRepository.saveTodoList(todos);
                        });
                        //após adicionar lista, limpar caixa de texto;
                        todoController.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 15,
                        padding: const EdgeInsets.all(
                          16,
                        ),
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
                          elevation: 15,
                          padding: const EdgeInsets.all(
                            11,
                          ),
                        ),
                        onPressed: showDeleteTodosConfirmationDialog,
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
    todoRepository.saveTodoList(todos);

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
            todoRepository.saveTodoList(todos);
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void showDeleteTodosConfirmationDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Limpar Tudo?'),
              content: const Text(
                  'Você tem certeza que deseja apagar todas as tarefas?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteAllTodos();
                  },
                  child: const Text(
                    'Limpar Tudo',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ));
  }

  void deleteAllTodos() {
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }
}
