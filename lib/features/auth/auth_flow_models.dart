class VerifyPhoneArgs {
  const VerifyPhoneArgs({
    required this.phone,
    required this.email,
    required this.flowId,
  });
  final String phone;
  final String email;
  final String flowId;
}

class ConfirmPinArgs {
  const ConfirmPinArgs({required this.pin, required this.flowId});
  final String pin;
  final String flowId;
}

class LoginPinArgs {
  const LoginPinArgs({required this.phone, this.redirect});
  final String phone;
  final String? redirect;
}
