import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo_model.dart';
import '../providers/todo_provider.dart';

class EditTodoScreen extends StatefulWidget {
  final TodoModel todo;
  const EditTodoScreen({Key? key, required this.todo}) : super(key: key);

  @override
  _EditTodoScreenState createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late bool _isCompleted;
  bool _isLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final List<String> _priorityOptions = ['Thấp', 'Trung bình', 'Cao'];
  int _selectedPriority = 1;
  final List<Map<String, dynamic>> _priorityColors = [
    {'color': Color(0xFF4CAF50), 'icon': Icons.low_priority_rounded},
    {'color': Color(0xFF6C63FF), 'icon': Icons.drag_handle_rounded},
    {'color': Color(0xFFE040FB), 'icon': Icons.priority_high_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _descController = TextEditingController(text: widget.todo.description);
    _isCompleted = widget.todo.isCompleted;

    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
            begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A2E), Color(0xFF0D0D1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.arrow_back_ios_new,
                                color: Colors.white, size: 18),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Chỉnh Sửa Công Việc',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Icon
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [
                            _priorityColors[_selectedPriority]['color']
                                as Color,
                            const Color(0xFF6C63FF),
                          ]),
                          boxShadow: [
                            BoxShadow(
                              color: (_priorityColors[_selectedPriority]
                                          ['color'] as Color)
                                  .withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 4,
                            )
                          ],
                        ),
                        child: Icon(
                          _priorityColors[_selectedPriority]['icon']
                              as IconData,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Form Card
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          const Text('Tiêu đề *',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _titleController,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                            decoration: _inputDeco(
                                'Tiêu đề công việc...', Icons.title_rounded),
                          ),
                          const SizedBox(height: 18),

                          // Description
                          const Text('Mô tả',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _descController,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                            maxLines: 4,
                            decoration: _inputDecoMultiline(
                                'Mô tả chi tiết...', Icons.notes_rounded),
                          ),
                          const SizedBox(height: 18),

                          // Status Toggle
                          const Text('Trạng thái',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5)),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () =>
                                setState(() => _isCompleted = !_isCompleted),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: _isCompleted
                                    ? const Color(0xFF6C63FF).withOpacity(0.2)
                                    : Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: _isCompleted
                                      ? const Color(0xFF6C63FF)
                                      : Colors.white.withOpacity(0.15),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: _isCompleted
                                          ? const LinearGradient(colors: [
                                              Color(0xFF6C63FF),
                                              Color(0xFFE040FB)
                                            ])
                                          : null,
                                      border: _isCompleted
                                          ? null
                                          : Border.all(
                                              color: Colors.white38, width: 2),
                                    ),
                                    child: _isCompleted
                                        ? const Icon(Icons.check_rounded,
                                            color: Colors.white, size: 14)
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _isCompleted
                                        ? 'Đã hoàn thành ✓'
                                        : 'Chưa hoàn thành',
                                    style: TextStyle(
                                      color: _isCompleted
                                          ? const Color(0xFF6C63FF)
                                          : Colors.white54,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Priority
                          const Text('Độ ưu tiên',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5)),
                          const SizedBox(height: 10),
                          Row(
                            children: List.generate(3, (i) {
                              final isSelected = _selectedPriority == i;
                              final color =
                                  _priorityColors[i]['color'] as Color;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => _selectedPriority = i),
                                  child: AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 200),
                                    margin: EdgeInsets.only(
                                        right: i < 2 ? 8 : 0),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? color.withOpacity(0.2)
                                          : Colors.white.withOpacity(0.05),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? color
                                            : Colors.white.withOpacity(0.12),
                                        width: isSelected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                            _priorityColors[i]['icon']
                                                as IconData,
                                            color: isSelected
                                                ? color
                                                : Colors.white38,
                                            size: 18),
                                        const SizedBox(height: 4),
                                        Text(_priorityOptions[i],
                                            style: TextStyle(
                                                color: isSelected
                                                    ? color
                                                    : Colors.white38,
                                                fontSize: 11,
                                                fontWeight: isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        // Delete Button
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: _confirmDelete,
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: Colors.redAccent.withOpacity(0.5)),
                              ),
                              child: const Center(
                                child: Icon(Icons.delete_outline_rounded,
                                    color: Colors.redAccent, size: 26),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Save Button
                        Expanded(
                          flex: 3,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _doUpdate,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  _priorityColors[_selectedPriority]
                                      ['color'] as Color,
                                  const Color(0xFF6C63FF),
                                ]),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Container(
                                height: 56,
                                alignment: Alignment.center,
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5),
                                      )
                                    : const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.save_rounded,
                                              color: Colors.white, size: 22),
                                          SizedBox(width: 8),
                                          Text('Lưu Thay Đổi',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  letterSpacing: 0.8)),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
          TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF6C63FF)),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
            const BorderSide(color: Color(0xFF6C63FF), width: 1.5),
      ),
    );
  }

  InputDecoration _inputDecoMultiline(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
          TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 14),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: Icon(icon, color: const Color(0xFF6C63FF)),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
            const BorderSide(color: Color(0xFF6C63FF), width: 1.5),
      ),
    );
  }

  Future<void> _doUpdate() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: const Text('Vui lòng nhập tiêu đề!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    final success =
        await Provider.of<TodoProvider>(context, listen: false).updateTodo(
      widget.todo.id,
      _titleController.text.trim(),
      _descController.text.trim(),
      _isCompleted,
    );
    setState(() => _isLoading = false);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF6C63FF),
          content: const Text('✅ Đã lưu thay đổi!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: const Text('Lưu thất bại, thử lại!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Xóa công việc?',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text('Xóa "${widget.todo.title}"?\nKhông thể hoàn tác.',
            style: TextStyle(color: Colors.white.withOpacity(0.6))),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Hủy',
                  style:
                      TextStyle(color: Colors.white.withOpacity(0.6)))),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await Provider.of<TodoProvider>(context, listen: false)
          .deleteTodo(widget.todo.id);
      Navigator.pop(context);
    }
  }
}
