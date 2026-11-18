import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove all non-digit characters
    final String cleanedText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Insert spaces after the first 2 digits and the next 3 digits
    if (cleanedText.length > 5) {
      final String formattedText =
          '${cleanedText.substring(0, 2)} ${cleanedText.substring(2, 5)} ${cleanedText.substring(5)}';
      return TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    } else if (cleanedText.length > 2) {
      final String formattedText =
          '${cleanedText.substring(0, 2)} ${cleanedText.substring(2)}';
      return TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }

    // Return the cleaned text if it's less than or equal to 2 digits
    return TextEditingValue(
      text: cleanedText,
      selection: TextSelection.collapsed(offset: cleanedText.length),
    );
  }
}