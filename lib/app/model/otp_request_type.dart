enum OTPRequestType {
  forgotPassword('FP'),
  ucoDeposit('UcoDeposit'),
  enroll('Enroll'),
  registration('Reg');

  final String code;
  const OTPRequestType(this.code);
}