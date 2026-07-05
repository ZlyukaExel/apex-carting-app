import 'package:flutter/material.dart';

class OtpWidget extends StatefulWidget {
  final String phone;
  final void Function(String code) onSubmit;
  final void Function() onResend;
  final bool isLoading;
  final String? errorMessage;

  const OtpWidget({
    super.key,
    required this.phone,
    required this.onSubmit,
    required this.onResend,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  State<OtpWidget> createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _codeController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.sms, size: 64, color: Colors.red),
          const SizedBox(height: 24),
          Text(
            'Введите код',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Код отправлен на ${widget.phone}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _codeController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 32, letterSpacing: 16),
            decoration: InputDecoration(
              labelText: 'Код из SMS',
              hintText: '1234',
              errorText: widget.errorMessage,
              counterText: '',
            ),
            enabled: !widget.isLoading,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: widget.isLoading || _codeController.text.length < 4
                ? null
                : () => widget.onSubmit(_codeController.text),
            child: widget.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Подтвердить'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: widget.isLoading ? null : widget.onResend,
            child: const Text('Отправить код повторно'),
          ),
        ],
      ),
    );
  }
}
