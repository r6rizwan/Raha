import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/service_provider_model.dart';
import '../profile/bookings_notifier.dart';

class BookingSheet extends ConsumerStatefulWidget {
  const BookingSheet({super.key, required this.provider});
  final ServiceProviderModel provider;
  @override
  ConsumerState<BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends ConsumerState<BookingSheet> {
  DateTime? scheduledAt;
  final notes = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(
      left: 16,
      right: 16,
      top: 16,
      bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.provider.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        TextButton(
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              firstDate: DateTime.now().add(const Duration(days: 1)),
              lastDate: DateTime.now().add(const Duration(days: 90)),
            );
            if (date == null || !context.mounted) return;
            final time = await showTimePicker(
              context: context,
              initialTime: const TimeOfDay(hour: 10, minute: 0),
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
          child: Text(
            scheduledAt == null
                ? 'Pick date and time'
                : DateFormat('EEE, d MMM · h:mm a').format(scheduledAt!),
          ),
        ),
        TextField(
          controller: notes,
          decoration: const InputDecoration(
            hintText: 'Any special instructions?',
          ),
        ),
        Text('Indicative price: ${widget.provider.priceRange}'),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: loading
              ? null
              : () async {
                  if (scheduledAt == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a time')),
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
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  } finally {
                    if (mounted) setState(() => loading = false);
                  }
                },
          child: loading
              ? const CircularProgressIndicator()
              : const Text('Confirm Booking'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}
