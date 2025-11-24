class VerifyPhoneArgs {
  const VerifyPhoneArgs({required this.phone, required this.email});
  final String phone;
  final String email;
}

class ConfirmPinArgs {
  const ConfirmPinArgs({required this.pin});
  final String pin;
}
