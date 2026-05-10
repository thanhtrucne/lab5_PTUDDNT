import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';

class AddTodoScreen extends StatefulWidget {
  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen>
    with SingleTickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
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
    _descriptionController.dispose();
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
                          'Thêm Công Việc',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Icon header
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              _priorityColors[_selectedPriority]['color']
                                  as Color,
                              const Color(0xFF6C63FF),
                            ],
                          ),
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
                          _priorityColors[_selectedPriority]['icon'] as IconData,
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
                          const Text(
                            'Tiêu đề *',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _titleController,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                            decoration: InputDecoration(
                              hintText: 'Ví dụ: Học bài chương 5...',
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.3),
                                  fontSize: 14),
                              prefixIcon: const Icon(
                                  Icons.title_rounded,
                                  color: Color(0xFF6C63FF)),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.05),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.12)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                    color: Color(0xFF6C63FF), width: 1.5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Description
                          const Text(
                            'Mô tả',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _descriptionController,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: 'Thêm ghi chú, chi tiết...',
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.3),
                                  fontSize: 14),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(bottom: 60),
                                child: Icon(Icons.notes_rounded,
                                    color: Color(0xFF6C63FF)),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.05),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.12)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                    color: Color(0xFF6C63FF), width: 1.5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Priority selector
                          const Text(
                            'Độ ưu tiên',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: List.generate(3, (i) {
                              final isSelected = _selectedPriority == i;
                              final color = _priorityColors[i]['color'] as Color;
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
                                            : Colors.white
                                                .withOpacity(0.12),
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
                                          size: 18,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _priorityOptions[i],
                                          style: TextStyle(
                                            color: isSelected
                                                ? color
                                                : Colors.white38,
                                            fontSize: 11,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
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
                    const SizedBox(height: 28),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _doAddTodo,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              _priorityColors[_selectedPriority]['color']
                                  as Color,
                              const Color(0xFF6C63FF),
                            ]),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                          Icons.add_task_rounded,
                                          color: Colors.white,
                                          size: 22),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Thêm Công Việc',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
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

  Future<void> _doAddTodo() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: const Text('Vui lòng nhập tiêu đề công việc!'),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    final success = await Provider.of<TodoProvider>(context, listen: false)
        .addTodo(
            _titleController.text.trim(), _descriptionController.text.trim());
    setState(() => _isLoading = false);
    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: const Text('Thêm thất bại! Vui lòng thử lại.'),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}
