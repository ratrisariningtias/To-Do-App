import 'package:flutter/material.dart';

class TodoItem {
  String title;
  bool completed;

  TodoItem({required this.title, this.completed = false});
}

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  List<TodoItem> todos = [];
  TextEditingController _searchController = TextEditingController();
  List<TodoItem> filteredTodos = [];

  @override
  void initState() {
    super.initState();
    filteredTodos = todos;
  }

  void _addTodo() {
    String newTodo = '';
    bool showError = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Tambah To-Do',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Tulis to-do kamu',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          // Set border color based on showError flag
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: showError ? Colors.red : Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onChanged: (value) {
                          newTodo = value;
                          setState(() {
                            showError = false;
                          });
                        },
                      ),
                      SizedBox(
                          height: 8), // Penambahan padding di bawah TextField
                      Visibility(
                        visible: showError,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            'To-do tidak boleh kosong',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Batal'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (newTodo.isNotEmpty) {
                                setState(() {
                                  todos.add(TodoItem(title: newTodo));
                                  filteredTodos = List.from(
                                      todos); // Buat salinan baru dari todos
                                });
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.pink,
                                    content: Text('To-do berhasil dibuat'),
                                  ),
                                );
                                _searchTodo(); // Perbarui filteredTodos setelah menambahkan todo baru
                              } else {
                                setState(() {
                                  showError = true; // Menampilkan pesan error
                                });
                              }
                            },
                            child: Text('Tambah'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _editTodo(int index) {
    String editedTodo = todos[index].title;
    bool showError = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        TextEditingController _editingController =
            TextEditingController(text: todos[index].title);
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Edit To-Do',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        autofocus: true,
                        controller: _editingController,
                        decoration: InputDecoration(
                          hintText: 'Edit to-do kamu di sini',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          // Set border color based on showError flag
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: showError ? Colors.red : Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            editedTodo = value;
                            showError =
                                false; // Reset showError when user types
                          });
                        },
                      ),
                      SizedBox(height: 8),
                      Visibility(
                        visible: showError,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            'To-do tidak boleh kosong',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Batal'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (editedTodo.isNotEmpty) {
                                setState(() {
                                  todos[index].title = editedTodo;
                                });
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.pink,
                                    content: Text('To-do berhasil diubah'),
                                  ),
                                );
                                _searchTodo(); // Perbarui filteredTodos setelah mengedit todo
                              } else {
                                setState(() {
                                  showError = true; // Menampilkan pesan error
                                });
                              }
                            },
                            child: Text('Simpan'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _deleteTodo(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Hapus To-Do',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('Apakah Anda yakin ingin menghapus to-do ini?'),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Tidak'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            todos.removeAt(index);
                            filteredTodos = todos;
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.pink,
                              content: Text('To-do berhasil dihapus'),
                            ),
                          );
                        },
                        child: Text('Ya'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _completeTodo(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    todos[index].completed
                        ? 'Batalkan Penyelesaian To-Do'
                        : 'Selesaikan To-Do',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    todos[index].completed
                        ? 'Apakah Anda yakin ingin membatalkan penyelesaian to-do ini?'
                        : 'Apakah Anda yakin ingin menyelesaikan to-do ini?',
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Tidak'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            todos[index].completed = !todos[index].completed;
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.pink,
                              content: Text(
                                todos[index].completed
                                    ? 'To-do berhasil diselesaikan'
                                    : 'Penyelesaian to-do dibatalkan',
                              ),
                            ),
                          );
                        },
                        child: Text('Ya'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _searchTodo() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredTodos = todos
          .where((todo) => todo.title.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do App'),
        backgroundColor: Colors.pink[200],
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        left: 16,
                        right: 16,
                        top: 16,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Cari To-Do',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextField(
                            controller: _searchController,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Cari to-do di sini',
                            ),
                            onChanged: (value) {
                              _searchTodo();
                            },
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  _searchController.clear();
                                  _searchTodo();
                                  Navigator.of(context).pop();
                                },
                                child: Text('Bersihkan'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _searchTodo();
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cari'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: filteredTodos.isEmpty
          ? Center(
              child: Text(
                _searchController.text.isNotEmpty
                    ? 'Tidak ada hasil pencarian'
                    : 'List to-do kamu kosong, silahkan tambah',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: filteredTodos.length,
              separatorBuilder: (BuildContext context, int index) =>
                  SizedBox(height: 16),
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(filteredTodos[index].title),
                  onDismissed: (direction) {
                    _deleteTodo(todos.indexOf(filteredTodos[index]));
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    color: Colors.pink[100],
                    child: ListTile(
                      title: Text(
                        filteredTodos[index].title,
                        style: filteredTodos[index].completed
                            ? TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.black,
                              )
                            : null,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () =>
                                _editTodo(todos.indexOf(filteredTodos[index])),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteTodo(
                                todos.indexOf(filteredTodos[index])),
                          ),
                          IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () => _completeTodo(
                                todos.indexOf(filteredTodos[index])),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        tooltip: 'Tambah To-Do',
        child: Icon(Icons.add),
        backgroundColor: Colors.pink[200],
      ),
      backgroundColor: Colors.pink[50],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      resizeToAvoidBottomInset: false, // Mengatur perilaku keyboard
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'To-Do List App',
    home: ToDoList(),
  ));
}
