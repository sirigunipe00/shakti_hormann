enum OTPRequestType {
  forgotPassword('FP'),
  ucoDeposit('UcoDeposit'),
  enroll('Enroll'),
  registration('Reg');
const OTPRequestType(this.code);
  final String code;
  
}