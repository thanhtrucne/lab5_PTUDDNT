import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import '../services/api_service.dart';

class TodoProvider with ChangeNotifier {
  List<TodoModel> _todos = [];
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  List<TodoModel> get todos => _todos;
  bool get isLoading => _isLoading;

  Future<void> fetchTodos() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.get('/Todo');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _todos = data.map((item) => TodoModel.fromJson(item)).toList();
      }
    } catch (e) {
      print(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addTodo(String title, String description) async {
    try {
      final response = await _apiService.post('/Todo', {
        'title': title,
        'description': description,
        'isCompleted': false,
      }, authenticated: true);

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _todos.add(TodoModel.fromJson(data));
        notifyListeners();
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> updateTodo(
      int id, String title, String description, bool isCompleted) async {
    try {
      final response = await _apiService.put('/Todo/$id', {
        'id': id,
        'title': title,
        'description': description,
        'isCompleted': isCompleted,
      });
      if (response.statusCode == 204) {
        final index = _todos.indexWhere((t) => t.id == id);
        if (index != -1) {
          _todos[index] = TodoModel(
            id: id,
            title: title,
            description: description,
            isCompleted: isCompleted,
            createdAt: _todos[index].createdAt,
          );
          notifyListeners();
          return true;
        }
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> toggleTodoStatus(TodoModel todo) async {
    return updateTodo(
        todo.id, todo.title, todo.description, !todo.isCompleted);
  }

  Future<bool> deleteTodo(int id) async {
    try {
      final response = await _apiService.delete('/Todo/$id');
      if (response.statusCode == 204) {
        _todos.removeWhere((t) => t.id == id);
        notifyListeners();
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
}
