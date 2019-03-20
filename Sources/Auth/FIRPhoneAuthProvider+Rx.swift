// Pods
// 

import RxSwift
import FirebaseAuth

#if os(iOS)
extension Reactive where Base: PhoneAuthProvider {
  
  /**
   @brief Starts the phone number authentication flow by sending a verification code to the
   specified phone number.
   @param phoneNumber The phone number to be verified.
   @param UIDelegate An object used to present the SFSafariViewController. The object is retained
   by this method until the completion block is executed.
   @param completion The callback to be invoked when the verification flow is finished.
   @remarks Possible error codes:
   
   + `FIRAuthErrorCodeCaptchaCheckFailed` - Indicates that the reCAPTCHA token obtained by
   the Firebase Auth is invalid or has expired.
   + `FIRAuthErrorCodeQuotaExceeded` - Indicates that the phone verification quota for this
   project has been exceeded.
   + `FIRAuthErrorCodeInvalidPhoneNumber` - Indicates that the phone number provided is
   invalid.
   + `FIRAuthErrorCodeMissingPhoneNumber` - Indicates that a phone number was not provided.
   */
  public func verifyPhoneNumber(_ phoneNumber: String, uiDelegate: AuthUIDelegate? = nil) -> Observable<String> {
    return Observable.create { observer in
      self.base.verifyPhoneNumber(phoneNumber, uiDelegate: uiDelegate) { result, error in
        if let result = result {
          observer.onNext(result)
          observer.onCompleted()
        } else if let error = error {
          observer.onError(error)
        }
      }
      return Disposables.create()
    }
  }
}
#endif
