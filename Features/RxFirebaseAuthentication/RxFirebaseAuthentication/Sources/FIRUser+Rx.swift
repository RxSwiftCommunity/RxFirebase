//
//  FIRUser+Rx.swift
//  RxFirebase
//
//  Created by Arnaud Dorgans on 09/09/2018.
//

import FirebaseAuth
import RxSwift

extension Reactive where Base: User {
    
    /**
     @brief Updates the email address for the user. On success, the cached user profile data is
     updated.
     @remarks May fail if there is already an account with this email address that was created using
     email and password authentication.
     
     @param email The email address for the user.
     @param completion Optionally; the block invoked when the user profile change has finished.
     Invoked asynchronously on the main thread in the future.
     
     @remarks Possible error codes:
     
     + `FIRAuthErrorCodeInvalidRecipientEmail` - Indicates an invalid recipient email was
     sent in the request.
     + `FIRAuthErrorCodeInvalidSender` - Indicates an invalid sender email is set in
     the console for this action.
     + `FIRAuthErrorCodeInvalidMessagePayload` - Indicates an invalid email template for
     sending update email.
     + `FIRAuthErrorCodeEmailAlreadyInUse` - Indicates the email is already in use by another
     account.
     + `FIRAuthErrorCodeInvalidEmail` - Indicates the email address is malformed.
     + `FIRAuthErrorCodeRequiresRecentLogin` - Updating a user’s email is a security
     sensitive operation that requires a recent login from the user. This error indicates
     the user has not signed in recently enough. To resolve, reauthenticate the user by
     invoking reauthenticateWithCredential:completion: on FIRUser.
     
     @remarks See `FIRAuthErrors` for a list of error codes that are common to all FIRUser methods.
     */
    public func updateEmail(to email: String) -> Observable<Void> {
        return Observable.create { observer in
            self.base.updateEmail(to: email) { error in
                guard let error = error else {
                    observer.onNext(())
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    /**
     @brief Updates the password for the user. On success, the cached user profile data is updated.
     
     @param password The new password for the user.
     @param completion Optionally; the block invoked when the user profile change has finished.
     Invoked asynchronously on the main thread in the future.
     
     @remarks Possible error codes:
     
     + `FIRAuthErrorCodeOperationNotAllowed` - Indicates the administrator disabled
     sign in with the specified identity provider.
     + `FIRAuthErrorCodeRequiresRecentLogin` - Updating a user’s password is a security
     sensitive operation that requires a recent login from the user. This error indicates
     the user has not signed in recently enough. To resolve, reauthenticate the user by
     invoking reauthenticateWithCredential:completion: on FIRUser.
     + `FIRAuthErrorCodeWeakPassword` - Indicates an attempt to set a password that is
     considered too weak. The NSLocalizedFailureReasonErrorKey field in the NSError.userInfo
     dictionary object will contain more detailed explanation that can be shown to the user.
     
     @remarks See `FIRAuthErrors` for a list of error codes that are common to all FIRUser methods.
     */
    public func updatePassword(to password: String) -> Observable<Void> {
        return Observable.create { observer in
            self.base.updatePassword(to: password) { error in
                guard let error = error else {
                    observer.onNext(())
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    #if os(iOS)
    /**
     @brief Updates the phone number for the user. On success, the cached user profile data is
     updated.
     
     @param phoneNumberCredential The new phone number credential corresponding to the phone number
     to be added to the Firebase account, if a phone number is already linked to the account this
     new phone number will replace it.
     @param completion Optionally; the block invoked when the user profile change has finished.
     Invoked asynchronously on the main thread in the future.
     
     @remarks Possible error codes:
     
     + `FIRAuthErrorCodeRequiresRecentLogin` - Updating a user’s phone number is a security
     sensitive operation that requires a recent login from the user. This error indicates
     the user has not signed in recently enough. To resolve, reauthenticate the user by
     invoking reauthenticateWithCredential:completion: on FIRUser.
     
     @remarks See `FIRAuthErrors` for a list of error codes that are common to all FIRUser methods.
     */
    public func updatePhoneNumber(_ credential: PhoneAuthCredential) -> Observable<Void> {
        return Observable.create { observer in
            self.base.updatePhoneNumber(credential) { error in
                guard let error = error else {
                    observer.onNext(())
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    #endif
    
    /**
     @brief Reloads the user's profile data from the server.
     
     @param completion Optionally; the block invoked when the reload has finished. Invoked
     asynchronously on the main thread in the future.
     
     @remarks May fail with a `FIRAuthErrorCodeRequiresRecentLogin` error code. In this case
     you should call `FIRUser.reauthenticateWithCredential:completion:` before re-invoking
     `FIRUser.updateEmail:completion:`.
     
     @remarks See `FIRAuthErrors` for a list of error codes that are common to all API methods.
     */
    public func reload() -> Observable<Void> {
        return Observable.create { observer in
            self.base.reload { error in
                guard let error = error else {
                    observer.onNext(())
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    /**
     @brief Renews the user's authentication tokens by validating a fresh set of credentials supplied
     by the user  and returns additional identity provider data.
     
     @param credential A user-supplied credential, which will be validated by the server. This can be
     a successful third-party identity provider sign-in, or an email address and password.
     @param completion Optionally; the block invoked when the re-authentication operation has
     finished. Invoked asynchronously on the main thread in the future.
     
     @remarks If the user associated with the supplied credential is different from the current user,
     or if the validation of the supplied credentials fails; an error is returned and the current
     user remains signed in.
     
     @remarks Possible error codes:
     
     + `FIRAuthErrorCodeInvalidCredential` - Indicates the supplied credential is invalid.
     This could happen if it has expired or it is malformed.
     + `FIRAuthErrorCodeOperationNotAllowed` - Indicates that accounts with the
     identity provider represented by the credential are not enabled. Enable them in the
     Auth section of the Firebase console.
     + `FIRAuthErrorCodeEmailAlreadyInUse` -  Indicates the email asserted by the credential
     (e.g. the email in a Facebook access token) is already in use by an existing account,
     that cannot be authenticated with this method. Call fetchProvidersForEmail for
     this user’s email and then prompt them to sign in with any of the sign-in providers
     returned. This error will only be thrown if the "One account per email address"
     setting is enabled in the Firebase console, under Auth settings. Please note that the
     error code raised in this specific situation may not be the same on Web and Android.
     + `FIRAuthErrorCodeUserDisabled` - Indicates the user's account is disabled.
     + `FIRAuthErrorCodeWrongPassword` - Indicates the user attempted reauthentication with
     an incorrect password, if credential is of the type EmailPasswordAuthCredential.
     + `FIRAuthErrorCodeUserMismatch` -  Indicates that an attempt was made to
     reauthenticate with a user which is not the current user.
     + `FIRAuthErrorCodeInvalidEmail` - Indicates the email address is malformed.
     
     @remarks See `FIRAuthErrors` for a list of error codes that are common to all API methods.
     */
    public func reauthenticateAndRetrieveData(with credential: AuthCredential) -> Observable<AuthDataResult> {
        return Observable.create { observer in
            self.base.reauthenticateAndRetrieveData(with: credential) { result, error in
                if let error = error {
                    observer.onError(error)
                } else if let result = result {
                    observer.onNext(result)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    /**
     @brief Retrieves the Firebase authentication token, possibly refreshing it if it has expired.
     
     @param completion Optionally; the block invoked when the token is available. Invoked
     asynchronously on the main thread in the future.
     
     @remarks See `FIRAuthErrors` for a list of error codes that are common to all API methods.
     */
    public func getIDTokenResult() -> Observable<AuthTokenResult> {
        return Observable.create { observer in
            self.base.getIDTokenResult { result, error in
                if let error = error {
                    observer.onError(error)
                } else if let result = result {
                    observer.onNext(result)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    /**
     @brief Retrieves the Firebase authentication token, possibly refreshing it if it has expired.
     
     @param forceRefresh Forces a token refresh. Useful if the token becomes invalid for some reason
     other than an expiration.
     @param completion Optionally; the block invoked when the token is available. Invoked
     asynchronously on the main thread in the future.
     
     @remarks The authentication token will be refreshed (by making a network request) if it has
     expired, or if `forceRefresh` is YES.
     
     @remarks See `FIRAuthErrors` for a list of error codes that are common to all API methods.
     */
    public func getIDTokenResult(forcingRefresh: Bool) -> Observable<AuthTokenResult> {
        return Observable.create { observer in
            self.base.getIDTokenResult(forcingRefresh: forcingRefresh) { result, error in
                if let error = error {
                    observer.onError(error)
                } else if let result = result {
                    observer.onNext(result)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    /**
     @brief Retrieves the Firebase authentication token, possibly refreshing it if it has expired.
     
     @param completion Optionally; the block invoked when the token is available. Invoked
     asynchronously on the main thread in the future.
     
     @remarks See `FIRAuthErrors` for a list of error codes that are common to all API methods.
     */
    public func getIDToken() -> Observable<String> {
        return Observable.create { observer in
            self.base.getIDToken { token, error in
                if let error = error {
                    observer.onError(error)
                } else if let token = token {
                    observer.onNext(token)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    /** @fn getIDTokenForcingRefresh:completion:
     @brief Retrieves the Firebase authentication token, possibly refreshing it if it has expired.
     
     @param forceRefresh Forces a token refresh. Useful if the token becomes invalid for some reason
     other than an expiration.
     @param completion Optionally; the block invoked when the token is available. Invoked
     asynchronously on the main thread in the future.
     
     @remarks The authentication token will be refreshed (by making a network request) if it has
     expired, or if `forceRefresh` is YES.
     
     @remarks See `FIRAuthErrors` for a list of error codes that are common to all API methods.
     */
    public func getIDTokenForcingRefresh(_ forceRefresh: Bool) -> Observable<String> {
        return Observable.create { observer in
            self.base.getIDTokenForcingRefresh(forceRefresh) { token, error in
                if let error = error {
                    observer.onError(error)
                } else if let token = token {
                    observer.onNext(token)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    /** 
     @brief Associates a user account from a third-party identity provider with this user and
     returns additional identity provider data.
     
     @param credential The credential for the identity provider.
     @param completion Optionally; the block invoked when the unlinking is complete, or fails.
     Invoked asynchronously on the main thread in the future.
     
     @remarks Possible error codes:
     
     + `FIRAuthErrorCodeProviderAlreadyLinked` - Indicates an attempt to link a provider of a
     type already linked to this account.
     + `FIRAuthErrorCodeCredentialAlreadyInUse` - Indicates an attempt to link with a
     credential
     that has already been linked with a different Firebase account.
     + `FIRAuthErrorCodeOperationNotAllowed` - Indicates that accounts with the identity
     provider represented by the credential are not enabled. Enable them in the Auth section
     of the Firebase console.
     
     @remarks This method may also return error codes associated with updateEmail:completion: and
     updatePassword:completion: on FIRUser.
     
     @remarks See `FIRAuthErrors` for a list of error codes that are common to all FIRUser methods.
     */
    public func linkAndRetrieveData(with credential: AuthCredential) -> Observable<AuthDataResult> {
        return Observable.create { observer in
            self.base.linkAndRetrieveData(with: credential) { result, error in
                if let error = error {
                    observer.onError(error)
                } else if let result = result {
                    observer.onNext(result)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    /**
     @brief Disassociates a user account from a third-party identity provider with this user.
     
     @param provider The provider ID of the provider to unlink.
     @param completion Optionally; the block invoked when the unlinking is complete, or fails.
     Invoked asynchronously on the main thread in the future.
     
     @remarks Possible error codes:
     
     + `FIRAuthErrorCodeNoSuchProvider` - Indicates an attempt to unlink a provider
     that is not linked to the account.
     + `FIRAuthErrorCodeRequiresRecentLogin` - Updating email is a security sensitive
     operation that requires a recent login from the user. This error indicates the user
     has not signed in recently enough. To resolve, reauthenticate the user by invoking
     reauthenticateWithCredential:completion: on FIRUser.
     
     @remarks See `FIRAuthErrors` for a list of error codes that are common to all FIRUser methods.
     */
    public func unlink(fromProvider provider: String) -> Observable<User> {
        return Observable.create { observer in
            self.base.unlink(fromProvider: provider) { user, error in
                if let error = error {
                    observer.onError(error)
                } else if let user = user {
                    observer.onNext(user)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    /**
     @brief Initiates email verification for the user.
     
     @param completion Optionally; the block invoked when the request to send an email verification
     is complete, or fails. Invoked asynchronously on the main thread in the future.
     
     @remarks Possible error codes:
     
     + `FIRAuthErrorCodeInvalidRecipientEmail` - Indicates an invalid recipient email was
     sent in the request.
     + `FIRAuthErrorCodeInvalidSender` - Indicates an invalid sender email is set in
     the console for this action.
     + `FIRAuthErrorCodeInvalidMessagePayload` - Indicates an invalid email template for
     sending update email.
     + `FIRAuthErrorCodeUserNotFound` - Indicates the user account was not found.
     
     @remarks See `FIRAuthErrors` for a list of error codes that are common to all FIRUser methods.
     */
    public func sendEmailVerification() -> Observable<Void> {
        return Observable.create { observer in
            self.base.sendEmailVerification { error in
                guard let error = error else {
                    observer.onNext(())
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    /**
     @brief Initiates email verification for the user.
     
     @param actionCodeSettings An `FIRActionCodeSettings` object containing settings related to
     handling action codes.
     
     @remarks Possible error codes:
     
     + `FIRAuthErrorCodeInvalidRecipientEmail` - Indicates an invalid recipient email was
     sent in the request.
     + `FIRAuthErrorCodeInvalidSender` - Indicates an invalid sender email is set in
     the console for this action.
     + `FIRAuthErrorCodeInvalidMessagePayload` - Indicates an invalid email template for
     sending update email.
     + `FIRAuthErrorCodeUserNotFound` - Indicates the user account was not found.
     + `FIRAuthErrorCodeMissingIosBundleID` - Indicates that the iOS bundle ID is missing when
     a iOS App Store ID is provided.
     + `FIRAuthErrorCodeMissingAndroidPackageName` - Indicates that the android package name
     is missing when the `androidInstallApp` flag is set to true.
     + `FIRAuthErrorCodeUnauthorizedDomain` - Indicates that the domain specified in the
     continue URL is not whitelisted in the Firebase console.
     + `FIRAuthErrorCodeInvalidContinueURI` - Indicates that the domain specified in the
     continue URI is not valid.
     */
    public func sendEmailVerification(with settings: ActionCodeSettings) -> Observable<Void> {
        return Observable.create { observer in
            self.base.sendEmailVerification(with: settings) { error in
                guard let error = error else {
                    observer.onNext(())
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    /**
     @brief Deletes the user account (also signs out the user, if this was the current user).
     
     @param completion Optionally; the block invoked when the request to delete the account is
     complete, or fails. Invoked asynchronously on the main thread in the future.
     
     @remarks Possible error codes:
     
     + `FIRAuthErrorCodeRequiresRecentLogin` - Updating email is a security sensitive
     operation that requires a recent login from the user. This error indicates the user
     has not signed in recently enough. To resolve, reauthenticate the user by invoking
     reauthenticateWithCredential:completion: on FIRUser.
     
     @remarks See `FIRAuthErrors` for a list of error codes that are common to all FIRUser methods.
     
     */
    public func delete() -> Observable<Void> {
        return Observable.create { observer in
            self.base.delete { error in
                guard let error = error else {
                    observer.onNext(())
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
