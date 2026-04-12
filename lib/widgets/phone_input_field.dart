import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:city_voice_app/utils/phone_validator.dart';
import 'package:city_voice_app/l10n/app_localizations.dart';

/// Unified phone input widget: country selector + phone field in one container.
///
/// Features:
/// - Flag + country code on the left
/// - Phone number input on the right
/// - Single shared border and background
/// - Bottom-sheet country picker
/// - Digits-only input with validation
/// - Focus and error state management
class PhoneInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<Map<String, dynamic>>? onValidationChanged;
  final bool readOnly;
  final String initialCountryCode;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.onValidationChanged,
    this.readOnly = false,
    this.initialCountryCode = '+1',
  });

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  late String _selectedCountryCode;
  String? _validationError;
  bool _isValid = false;
  late final FocusNode _focusNode;

  // Country code -> (name, iso code)
  static const Map<String, Map<String, String>> _countries = {
    '+1': {'name': 'United States', 'iso': 'US'},
    '+7': {'name': 'Russia / Kazakhstan', 'iso': 'RU'},
    '+44': {'name': 'United Kingdom', 'iso': 'GB'},
    '+49': {'name': 'Germany', 'iso': 'DE'},
    '+33': {'name': 'France', 'iso': 'FR'},
    '+81': {'name': 'Japan', 'iso': 'JP'},
    '+86': {'name': 'China', 'iso': 'CN'},
    '+91': {'name': 'India', 'iso': 'IN'},
  };

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = widget.initialCountryCode;
    _focusNode = FocusNode();
    if (widget.controller.text.isNotEmpty) _validatePhoneNumber();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _validatePhoneNumber() {
    final phone = widget.controller.text.trim();

    if (phone.isEmpty) {
      _validationError = null;
      _isValid = false;
    } else {
      final phoneWithCode = _ensureCountryCode(phone);
      final validation = PhoneValidator.validate(phoneWithCode);
      _isValid = validation['valid'] as bool;
      _validationError = _isValid ? null : validation['message'] as String?;
    }

    widget.onValidationChanged?.call({
      'valid': _isValid,
      'error': _validationError,
      'fullNumber': _ensureCountryCode(widget.controller.text.trim()),
      'countryCode': _selectedCountryCode,
    });

    setState(() {});
  }

  String _ensureCountryCode(String phone) {
    final trimmed = phone.trim();
    if (trimmed.startsWith('+')) return trimmed;
    return '$_selectedCountryCode$trimmed';
  }

  /// Convert ISO country code to emoji flag
  String _flagEmoji(String iso) {
    if (iso.length != 2) return '';
    final int base = 0x1F1E6 - 'A'.codeUnitAt(0);
    final first = base + iso.codeUnitAt(0);
    final second = base + iso.codeUnitAt(1);
    return String.fromCharCode(first) + String.fromCharCode(second);
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _countries.entries.map((entry) {
              final code = entry.key;
              final meta = entry.value;
              final iso = meta['iso'] ?? '';
              final name = meta['name'] ?? code;
              final selected = code == _selectedCountryCode;
              return ListTile(
                leading: Text(_flagEmoji(iso), style: const TextStyle(fontSize: 20)),
                title: Text('$name ($code)'),
                trailing: selected ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
                onTap: () {
                  setState(() => _selectedCountryCode = code);
                  _validatePhoneNumber();
                  Navigator.of(ctx).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final borderColor = _validationError != null
        ? theme.colorScheme.error
        : (_focusNode.hasFocus ? theme.colorScheme.primary : theme.dividerColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Unified container: country selector + phone input with animated border
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: _focusNode.hasFocus
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withAlpha(30),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              // Country selector (flag + code + dropdown icon)
              InkWell(
                onTap: widget.readOnly ? null : _showCountryPicker,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(7)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _flagEmoji(_countries[_selectedCountryCode]?['iso'] ?? ''),
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _selectedCountryCode,
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.keyboard_arrow_down, size: 18, color: theme.textTheme.bodyMedium?.color),
                    ],
                  ),
                ),
              ),
              // Subtle divider
              Container(width: 1, height: 48, color: theme.dividerColor.withAlpha(100)),
              // Phone number input
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                  child: TextField(
                    focusNode: _focusNode,
                    controller: widget.controller,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      _validatePhoneNumber();
                      widget.onChanged?.call(value);
                    },
                    decoration: InputDecoration(
                      hintText: widget.hintText ?? localizations.enterPhone,
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(120),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Error message below with animation
        if (_validationError != null) ...[
          const SizedBox(height: 8),
          AnimatedOpacity(
            opacity: _validationError != null ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                _validationError ?? '',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Enhanced phone field with country selector popup
/// Shows all supported countries with names (no flags)
class CountryPhoneField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<Map<String, dynamic>>? onValidationChanged;
  final String? labelText;
  final String? hintText;

  const CountryPhoneField({
    super.key,
    required this.controller,
    this.onChanged,
    this.onValidationChanged,
    this.labelText,
    this.hintText,
  });

  @override
  State<CountryPhoneField> createState() => _CountryPhoneFieldState();
}

class _CountryPhoneFieldState extends State<CountryPhoneField> {
  late String _selectedCountryCode;
  String? _validationError;
  bool _isValid = false;

  static const Map<String, String> countries = {
    '+1': 'United States',
    '+7': 'Russia / Kazakhstan',
    '+44': 'United Kingdom',
    '+49': 'Germany',
    '+33': 'France',
    '+81': 'Japan',
    '+86': 'China',
    '+91': 'India',
  };

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = '+1';
  }

  void _validatePhoneNumber() {
    final phone = widget.controller.text.trim();

    if (phone.isEmpty) {
      _validationError = null;
      _isValid = false;
    } else {
      final phoneWithCode = phone.startsWith('+')
          ? phone
          : '$_selectedCountryCode$phone';
      final validation = PhoneValidator.validate(phoneWithCode);
      _isValid = validation['valid'] as bool;
      _validationError = _isValid ? null : validation['message'] as String?;
    }

    widget.onValidationChanged?.call({
      'valid': _isValid,
      'error': _validationError,
      'fullNumber': widget.controller.text.startsWith('+')
          ? widget.controller.text.trim()
          : '$_selectedCountryCode${widget.controller.text.trim()}',
      'countryCode': _selectedCountryCode,
    });

    setState(() {});
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select Country',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: countries.length,
              itemBuilder: (context, index) {
                final code = countries.keys.elementAt(index);
                final countryName = countries[code]!;

                return ListTile(
                  title: Text('$code $countryName'),
                  trailing: _selectedCountryCode == code
                      ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                      : null,
                  onTap: () {
                    setState(() => _selectedCountryCode = code);
                    _validatePhoneNumber();
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Country selector button
        Material(
          child: InkWell(
            onTap: _showCountryPicker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: _isValid ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Country',
                          style: theme.textTheme.labelSmall,
                        ),
                        Text(
                          '${countries[_selectedCountryCode]} ($_selectedCountryCode)',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: theme.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Phone input field
        TextField(
          controller: widget.controller,
          onChanged: (value) {
            _validatePhoneNumber();
            widget.onChanged?.call(value);
          },
          decoration: InputDecoration(
            labelText: widget.labelText ?? localizations.phoneNumber,
            hintText: widget.hintText ?? localizations.enterPhone,
            prefixText: '$_selectedCountryCode ',
            prefixStyle: theme.textTheme.bodyMedium,
            prefixIcon: const Icon(Icons.phone),
            errorText: _validationError,
            suffixIcon: _isValid
                ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
                : widget.controller.text.isNotEmpty
                    ? Icon(Icons.error, color: Theme.of(context).colorScheme.error)
                    : null,
          ),
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }
}
