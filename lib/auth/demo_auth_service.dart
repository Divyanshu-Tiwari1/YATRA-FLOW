class DemoAuthService {
  const DemoAuthService();

  static const demoOtp = '123456';

  Future<void> requestOtp({
    required String phoneNumber,
    required String countryCode,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
  }

  Future<bool> verifyOtp({
    required String phoneNumber,
    required String countryCode,
    required String otp,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return otp == demoOtp;
  }
}
