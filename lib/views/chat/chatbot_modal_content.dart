import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/models/food.dart';
import 'package:ql_moifood_app/models/global_notification.dart';
import 'package:ql_moifood_app/viewmodels/food_viewmodel.dart';

import 'package:ql_moifood_app/viewmodels/order_viewmodel.dart';
import 'package:ql_moifood_app/models/order.dart';
import 'package:ql_moifood_app/viewmodels/user_viewmodel.dart';
import 'package:ql_moifood_app/models/user.dart';
import 'package:ql_moifood_app/viewmodels/reviews_viewmodel.dart';
import 'package:ql_moifood_app/models/review.dart';
import 'package:ql_moifood_app/viewmodels/notification_viewmodel.dart';

import 'package:ql_moifood_app/resources/widgets/dialogs/app_utils.dart';

class ChatbotDialog extends StatefulWidget {
  const ChatbotDialog({super.key});

  @override
  State<ChatbotDialog> createState() => _ChatbotDialogState();
}

class _ChatbotDialogState extends State<ChatbotDialog> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? 'API_KEY_NOT_FOUND';
  static List<Map<String, String>> _sharedMessages = [];
  static DateTime? _lastInteractionTime;

  @override
  void initState() {
    super.initState();
    _checkSessionTimeout();
  }

  /// Kiểm tra xem phiên chat đã hết hạn 30 phút chưa
  void _checkSessionTimeout() {
    final now = DateTime.now();
    const sessionTimeout = Duration(minutes: 30);
    if (_lastInteractionTime != null) {
      final duration = now.difference(_lastInteractionTime!);
      if (duration > sessionTimeout) {
        _sharedMessages = [];
      }
    }

    if (_sharedMessages.isEmpty) {
      _sharedMessages.add({
        "role": "bot",
        "text": "Chào bạn! Tôi có thể giúp gì cho bạn?",
      });
    }
    _lastInteractionTime = now;
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Cập nhật thời gian tương tác cuối cùng
  void _updateTimestamp() {
    _lastInteractionTime = DateTime.now();
  }

  /// HÀM GỌI GEMINI
  Future<String> _askGemini(String question, String aggregatedData) async {
    try {
      final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: _apiKey);
      final prompt =
          """
Bạn là một trợ lý AI cho admin của MoiFood.
Dưới đây là toàn bộ dữ liệu của hệ thống (ở dạng JSON). 
Dữ liệu này là một object chứa 4 key: 'orders', 'users', 'reviews', và 'notifications'.

$aggregatedData

Hãy trả lời câu hỏi của admin một cách ngắn gọn, chuyên nghiệp, bằng tiếng Việt.
Dựa vào tất cả dữ liệu được cung cấp (đơn hàng, người dùng, review, thông báo) để trả lời.
Câu hỏi: $question
""";

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      return response.text ?? "Không có phản hồi từ Gemini.";
    } catch (e) {
      throw Exception("Lỗi Gemini API: $e");
    }
  }

  /// HÀM SEND MESSAGE
  Future<void> _sendMessage() async {
    final question = _controller.text.trim();
    if (question.isEmpty) return;

    setState(() {
      _sharedMessages.add({"role": "user", "text": question});
      _isLoading = true;
      _controller.clear();
    });
    _scrollToBottom();
    _updateTimestamp();

    try {
      // Lấy tất cả ViewModel từ Provider
      final orderVM = context.read<OrderViewModel>();
      final userVM = context.read<UserViewModel>();
      final reviewVM = context.read<ReviewViewModel>();
      final notificationVM = context.read<NotificationViewModel>();
      final foodVM = context.read<FoodViewModel>();

      // Tải TẤT CẢ dữ liệu đồng thời bằng Future.wait
      await Future.wait([
        orderVM.fetchAllOrders(),
        userVM.fetchUsers(),
        reviewVM.fetchAllReviews(),
        notificationVM.fetchGlobalNotifications(),
        foodVM.fetchFoods(),
      ]);

      // Kiểm tra lỗi
      final errors = [
        orderVM.errorMessage,
        userVM.errorMessage,
        reviewVM.errorMessage,
        notificationVM.errorMessage,
        foodVM.errorMessage,
      ].where((e) => e != null).toList();

      if (errors.isNotEmpty && context.mounted) {
        throw Exception("Lỗi khi tải dữ liệu: ${errors.join(', ')}");
      }

      // Lấy và tổng hợp dữ liệu
      final List<Order> orders = OrderStatus.values
          .map((status) => orderVM.getOrdersByStatus(status))
          .expand((list) => list)
          .toList();
      final List<User> users = userVM.activeUsers + userVM.inactiveUsers;
      final List<Review> reviews = reviewVM.allReviews;
      final List<GlobalNotification> globalNotifs =
          notificationVM.globalNotifications;
      final List<Food> foods =
          foodVM.availableFoods + foodVM.deletedFoods + foodVM.unavailableFoods;

      final Map<String, dynamic> allData = {
        'orders': orders.map((o) => o.toJson()).toList(),
        'users': users.map((u) => u.toJson()).toList(),
        'reviews': reviews.map((r) => r.toJson()).toList(),
        'notifications': globalNotifs.map((n) => n.toJson()).toList(),
        'foods': foods.map((f) => f.toJson()).toList(),
      };

      final String aggregatedDataJson = jsonEncode(allData);
      final reply = await _askGemini(question, aggregatedDataJson);

      setState(() {
        _sharedMessages.add({"role": "bot", "text": reply});
        _isLoading = false;
      });
      _scrollToBottom();
      _updateTimestamp();
    } catch (e) {
      final errorMessage = e.toString();
      setState(() {
        _sharedMessages.add({
          "role": "bot",
          "text": "Xin lỗi, đã xảy ra lỗi: $errorMessage",
        });
        _isLoading = false;
      });
      _scrollToBottom();
      _updateTimestamp();

      if (context.mounted) {
        AppUtils.showErrorDialog(
          context,
          title: "Lỗi Chatbot",
          message: errorMessage,
        );
      }
    }
  }

  /// Cuộn xuống tin nhắn mới nhất
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        color: Colors.white,
        child: Column(
          children: [
            // Thanh tiêu đề
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.indigo.shade400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Chatbot MoiFood (AI)",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Lịch sử chat
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: _sharedMessages.length,
                itemBuilder: (context, index) {
                  final msg = _sharedMessages[index];
                  final isUser = msg["role"] == "user";
                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      constraints: const BoxConstraints(maxWidth: 400),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Colors.blueAccent
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(18),
                          topRight: const Radius.circular(18),
                          bottomLeft: Radius.circular(isUser ? 18 : 4),
                          bottomRight: Radius.circular(isUser ? 4 : 18),
                        ),
                      ),
                      child: Text(
                        msg["text"] ?? "",
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black87,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  // hàm nhập liệu
  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Hỏi AI...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              onSubmitted: (_) => _isLoading ? null : _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _isLoading ? null : _sendMessage,
            icon: const Icon(Icons.send, color: Colors.blueAccent),
            style: IconButton.styleFrom(
              backgroundColor: Colors.blueAccent.withValues(alpha: 0.1),
              shape: const CircleBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
