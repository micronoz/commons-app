extension StringExtension on String {
  String capitalize() {
    return split(' ')
        .map((s) => '${s[0].toUpperCase()}${s.substring(1)}')
        .join(' ');
  }
}
