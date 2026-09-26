import 'package:flutter/material.dart';
import '../../../../core/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../orders_controller.dart';
import '../../data/models/order_model.dart';

class OrderTrackingScreen extends StatelessWidget {
  final OrderModel order;
  final OrdersController orders;

  const OrderTrackingScreen({
    super.key,
    required this.order,
    required this.orders,
  });

  static const List<OrderStatus> _steps = [
    OrderStatus.received,
    OrderStatus.reviewing,
    OrderStatus.preparing,
    OrderStatus.ready,
    OrderStatus.completed,
  ];

  IconData _stepIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.received:
        return Icons.check_circle_outline;
      case OrderStatus.reviewing:
        return Icons.rate_review_outlined;
      case OrderStatus.preparing:
        return Icons.inventory_2_outlined;
      case OrderStatus.ready:
        return Icons.store_outlined;
      case OrderStatus.completed:
        return Icons.flag_outlined;
      case OrderStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  void _showCancelSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'إلغاء الطلب',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'هل تريد إلغاء الطلب ${order.id}؟ لا يمكن التراجع عن الإلغاء.',
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(sheetContext).pop(),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.divider),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'تراجع',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      orders.cancelOrder(order.id);
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Color(0xFFD32F2F),
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            duration: Duration(milliseconds: 1500),
                            content: Text(
                              'تم إلغاء الطلب',
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                    },
                    child: Container(
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD32F2F),
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'تأكيد الإلغاء',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCancelled = order.status == OrderStatus.cancelled;
    final currentIndex = isCancelled ? -1 : _steps.indexOf(order.status);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: orders,
          builder: (context, child) => Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 16, 8),
                child: Row(
                  children: [
                    const BackButton(color: AppColors.primary),
                    const SizedBox(width: 4),
                    const Expanded(
                      child: Text(
                        'تتبع الطلب',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    _buildHeaderCard(),
                    const SizedBox(height: 20),
                    if (isCancelled) _buildCancelledBanner(),
                    if (isCancelled) const SizedBox(height: 16),
                    _buildTimeline(currentIndex),
                    if (!isCancelled) ...[
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'تتحديث الحالات تلقائيًا عند ربط الخادم.',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (order.cancellable) ...[
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () => _showCancelSheet(context),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: const Color(0xFFD32F2F)),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'إلغاء الطلب',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFD32F2F),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'رقم الطلب',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  order.id,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${order.total.toStringAsFixed(2)} ${AppConstants.currency}',
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${order.itemCount} صنف',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCancelledBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFD32F2F).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFD32F2F).withValues(alpha: 0.4),
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.cancel_outlined, size: 20, color: Color(0xFFD32F2F)),
          SizedBox(width: 8),
          Text(
            'تم إلغاء هذا الطلب',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFFD32F2F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(int currentIndex) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          for (int i = 0; i < _steps.length; i++) ...[
            _buildStep(_steps[i], i, currentIndex),
            if (i < _steps.length - 1)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 16),
                child: SizedBox(
                  height: 24,
                  child: Container(
                    width: 2,
                    color: i < currentIndex
                        ? AppColors.primary
                        : AppColors.divider,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildStep(OrderStatus status, int index, int currentIndex) {
    final isDone = currentIndex >= 0 && index < currentIndex;
    final isCurrent = index == currentIndex;
    final isActive = isDone || isCurrent;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.background,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? Colors.transparent : AppColors.divider,
            ),
          ),
          child: Icon(
            isDone ? Icons.check : _stepIcon(status),
            size: 18,
            color: isActive ? Colors.white : AppColors.divider,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                orderStatusLabel(status),
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
              if (isCurrent)
                const Text(
                  'طلبك الآن هنا',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}