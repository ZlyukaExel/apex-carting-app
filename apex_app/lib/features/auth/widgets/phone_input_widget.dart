import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneInputWidget extends StatefulWidget {
  final void Function(String phone) onSubmit;
  final bool isLoading;

  const PhoneInputWidget({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<PhoneInputWidget> createState() => _PhoneInputWidgetState();
}

class _PhoneInputWidgetState extends State<PhoneInputWidget> {
  final _controller = TextEditingController(text: '+7');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final phone = _controller.text.trim();
    if (phone.length >= 10) {
      widget.onSubmit(phone);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.sports_motorsports, size: 80, color: Colors.red),
          const SizedBox(height: 24),
          Text(
            'Апекс',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Бронирование заездов в картинг-клубе',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 40),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Номер телефона',
              hintText: '+7XXXXXXXXXX',
              prefixIcon: Icon(Icons.phone),
            ),
            enabled: !widget.isLoading,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: widget.isLoading ? null : _submit,
            child: widget.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Получить код'),
          ),
        ],
      ),
    );
  }
}
