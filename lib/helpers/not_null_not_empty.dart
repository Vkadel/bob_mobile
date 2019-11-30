class NotNullNotEmpty {
  String text;
  NotNullNotEmpty(this.text);
  bool isnot() {
    return text != null && text.trim().isNotEmpty;
  }
}
