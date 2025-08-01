extension StringCapitalization on String {
  String capitalizeFirst() {
    if (isEmpty) return '';
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
