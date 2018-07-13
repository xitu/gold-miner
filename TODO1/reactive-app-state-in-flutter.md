class _ProviderState extends State<Provider> {
  ...
  @override
  dispose() {
    widget.data.removeListener(didValueChange);
    super.dispose();
  }
  ...
}
