import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/store_info.dart';

class StoreInfoScreen extends StatelessWidget {
  const StoreInfoScreen({super.key});

  Future<void> _openUrl(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = StoreInfo.current;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(
              top: -70,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              left: -40,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.07),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _buildTopBar(),
                const SizedBox(height: 12),
                _buildHero(info),
                const SizedBox(height: 16),
                _buildLocationCard(info),
                const SizedBox(height: 16),
                _buildHoursCard(info),
                const SizedBox(height: 16),
                _buildContactCard(info),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    '${AppConstants.storeName} · v${AppConstants.appVersion}',
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 11,
                      color: AppColors.textSecondary,
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

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 8, 8),
      child: Row(
        children: const [
          BackButton(color: AppColors.primary),
          SizedBox(width: 4),
          Expanded(
            child: Text(
              'معلومات المتجر',
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
    );
  }

  Widget _buildHero(StoreInfo info) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset(
            'assets/images/store_logo.png',
            width: double.infinity,
            fit: BoxFit.fitWidth,
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    info.name,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    info.tagline,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _TagChip(label: 'مواد غذائية'),
                      SizedBox(width: 8),
                      _TagChip(label: 'كماليات'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _card(Widget child) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _cardHeader(IconData icon, String title, List<Color> gradient) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCard(StoreInfo info) {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(
            Icons.location_on_outlined,
            'موقعنا',
            const [AppColors.primary, AppColors.primaryDark],
          ),
          const SizedBox(height: 14),
          Text(
            info.address,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 13,
              height: 1.7,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => _openUrl(Uri.parse(info.mapUrl)),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map_outlined, size: 18, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'افتح الخريطة',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoursCard(StoreInfo info) {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(
            Icons.access_time_filled,
            'أوقات العمل',
            const [Color(0xFFE8833A), Color(0xFFC2571B)],
          ),
          const SizedBox(height: 14),
          for (int i = 0; i < info.shifts.length; i++) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.schedule,
                      size: 18,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          info.shifts[i].label,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${info.shifts[i].openTime} — ${info.shifts[i].closeTime}',
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (i < info.shifts.length - 1) const SizedBox(height: 10),
          ],
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppColors.secondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    info.politeNote,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(StoreInfo info) {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(
            Icons.call_outlined,
            'تواصل معنا',
            const [Color(0xFF2E9E63), Color(0xFF1E6E42)],
          ),
          const SizedBox(height: 14),
          for (int i = 0; i < info.shifts.length; i++) ...[
            _buildShiftContact(info.shifts[i]),
            if (i < info.shifts.length - 1) const SizedBox(height: 10),
          ],
          const SizedBox(height: 10),
          _buildShopContact(info.shopPhone),
        ],
      ),
    );
  }

  Widget _buildShiftContact(StoreShift shift) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  shift.label,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                shift.phone.substring(3),
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: 'اتصال',
                  icon: Icons.call,
                  gradient: const [AppColors.primary, AppColors.primaryDark],
                  onTap: () => _openUrl(Uri.parse('tel:+${shift.phone}')),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  label: 'واتساب',
                  icon: Icons.chat_bubble_outline,
                  gradient: const [Color(0xFF25D366), Color(0xFF1DA851)],
                  onTap: () =>
                      _openUrl(Uri.parse('https://wa.me/${shift.whatsapp}')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShopContact(String phone) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'رقم المحل (اتصال فقط)',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                phone.substring(3),
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _ActionButton(
            label: 'اتصل بالمحل',
            icon: Icons.call,
            gradient: const [AppColors.primary, AppColors.primaryDark],
            onTap: () => _openUrl(Uri.parse('tel:+$phone')),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;

  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}