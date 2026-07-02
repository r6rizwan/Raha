import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/errors/failures.dart';
import '../../data/models/service_provider_model.dart';
import '../profile/bookings_notifier.dart';
import '../../core/theme/app_theme.dart';

class BookingSheet extends ConsumerStatefulWidget {
  const BookingSheet({super.key, required this.provider});
  final ServiceProviderModel provider;

  @override
  ConsumerState<BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends ConsumerState<BookingSheet> {
  // Strict Corporate Design System Color Palette
  static const Color primaryColor = AppColors.primary;
  static const Color mintBgColor = AppColors.mint;
  static const Color goldColor = AppColors.gold;
  static const Color backgroundColor = AppColors.background;
  static const Color cardColor = AppColors.card;
  static const Color textColor = AppColors.text;
  static const Color mutedColor = AppColors.muted;
  static const Color borderColor = AppColors.border;

  DateTime? scheduledAt;
  final notes = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- TOP DISMISS DRAWER ACCENT HANDLE ---
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // --- HEADER MATRICES ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SCHEDULE SERVICE',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: goldColor,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.provider.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: mintBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.provider.priceRange.isNotEmpty
                      ? widget.provider.priceRange
                      : '\$\$',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // --- DATE AND TIME SCHEDULE SELECTOR BLOCK ---
          GestureDetector(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                firstDate: DateTime.now().add(const Duration(days: 1)),
                lastDate: DateTime.now().add(const Duration(days: 90)),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: primaryColor,
                        onPrimary: Colors.white,
                        onSurface: textColor,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (date == null || !context.mounted) return;
              final time = await showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 10, minute: 0),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: primaryColor,
                        onPrimary: Colors.white,
                        onSurface: textColor,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (time != null) {
                setState(
                  () => scheduledAt = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    time.hour,
                    time.minute,
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 0.8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 16,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        scheduledAt == null
                            ? 'Select date and time'
                            : DateFormat(
                                'EEE, d MMM · h:mm a',
                              ).format(scheduledAt!),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: scheduledAt == null
                              ? FontWeight.w500
                              : FontWeight.w700,
                          color: scheduledAt == null ? mutedColor : textColor,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: mutedColor,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // --- INSTRUCTIONS INPUT TEXT FIELD ---
          TextField(
            controller: notes,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            style: const TextStyle(
              fontSize: 13,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'Any special instructions or details?',
              hintStyle: const TextStyle(color: mutedColor, fontSize: 13),
              filled: true,
              fillColor: cardColor,
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: borderColor, width: 0.8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: borderColor, width: 0.8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: primaryColor, width: 1.0),
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Indicative price informational baseline tag
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 12,
                color: mutedColor,
              ),
              const SizedBox(width: 4),
              Text(
                'Final rates may differ slightly depending on scope of service.',
                style: TextStyle(
                  fontSize: 10,
                  color: mutedColor.withValues(alpha: 0.95),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // --- BOOKING MUTATION ACTION BUTTONS BAR ---
          SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor: primaryColor.withValues(alpha: 0.6),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: loading
                  ? null
                  : () async {
                      if (scheduledAt == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select an appointment time'),
                            backgroundColor: textColor,
                          ),
                        );
                        return;
                      }
                      setState(() => loading = true);
                      try {
                        await ref
                            .read(bookingNotifierProvider.notifier)
                            .createBooking(
                              providerId: widget.provider.id,
                              scheduledAt: scheduledAt!,
                              notes: notes.text,
                              amount: 0,
                            );
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Booking requested! Provider will confirm shortly.',
                              ),
                              backgroundColor: primaryColor,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(friendlyMessageForError(e)),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      } finally {
                        if (mounted) setState(() => loading = false);
                      }
                    },
              child: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      'Confirm Booking',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.1,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),

          SizedBox(
            height: 44,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: mutedColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
