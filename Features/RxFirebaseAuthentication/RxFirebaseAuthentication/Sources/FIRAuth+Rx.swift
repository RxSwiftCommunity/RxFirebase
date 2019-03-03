//
//  FIRAuth+Rx.swift
//  RxFirebase
//
//  Created by Arnaud Dorgans on 29/08/2018.
//

import RxSwift
import FirebaseAuth

extension Reactive where Base: Auth {
    
    /**
     @brief Sets the currentUser on the calling Auth instance to the provided user object.
     @param  user The user object to be set as the current user of the calling Auth instance.
     @param completion Optionally; a block invoked after the user of the calling Auth instance has
     been updated or an error was encountered.
     */
    public func updateCurrentUser(_ user: User) -> Observable<Void> {
        return Observable.create { observer in
            self.base.updateCurrentUser(user) { error in
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
     @brief Fetches the list of IdPs that can be used for signing in with the provided email address.
     Useful for an "identifier-first" sign-in flow.
     
     @param email The email address for which to obtain a list of identity providers.
     @param completion Optionally; a block which is invoked when the list of providers for the
     specified email address is ready or an error was encountered. Invoked asynchronously on the
     main thread in the future.
     
     @remarks Possible error codes:
     
     + `FIRAuthErrorCodeInvalidEmail` - Indicates the email address is malformed.
     
     @remarks See `FIRAuthErrors` for a list of error codes that are common to all API methods.
     */
    public func fetchProviders(forEmail email: String) -> Observable<[String]> {
        return Observable.create { observer in
            self.base.fetchProviders(forEmail: email) { providers, error in
                guard let error = error else {
                    observer.onNext(providers ?? [])
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    /** 
     @brief Fetches the list of all sign-in methods previously used for the provided email address.
     
     @param email The email address for which to obtain a list of sign-in methods.
     @param completion Optionally; a block which is invoked when the list of sign in methods for the
     specified email address is ready or an error was encountered. Invoked asynchronously on the
     main thread in the future.
     
     @remarks Possible error codes:
     
     + `FIRAuthErrorCodeInvalidEmail` - Indicates the email address is malformed.
     
     @remarks See @c FIRAuthErrors for a list of error codes that are common to all API methods.
     */
    public func fetchSignInMethods(forEmail email: String) -> Observable<[String]> {
        return Observable.create { observer in
            self.base.fetchSignInMethods(forEmail: email) { methods, error in
                guard let error = error else {
                    observer.onNext(methods ?? [])
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    /**
     @brief Signs in using an email address and password.
     
     @param email The user's email address.
     @param password The user's password.
     @param completion Optionally; a block which is invoked when the sign in flow finishes, or is
     canceled. Invoked asynchronously on the main thread in the future.
     
     @remarks Possible error codes:
     
     + `FIRAuthErrorCodeOperationNotAllowed` - Indicates that email and password
     accounts are not enabled. Enable them in the Auth section of the
     Firebase console.
     + `FIRAuthErrorCodeUserDisabled` - Indicates the user's account is disabled.
     + `FIRAuthErrorCodeWrongPassword` - Indicates the user attempted
     sign in with an incorrect password.
     + `FIRAuthErrorCodeInvalidEmail` - Indicates the email address is malformed.
     
     
     @remarks See `FIRAuthErrors` for a list of error codes that are common to all API methods.
     */
    public func signIn(withEmail email: String, password: String) -> Observable<AuthDataResult> {
        return Observable.create { observer in
            self.base.signIn(withEmail: email, password: password) { auth, error in
                if let error = error {
                    observer.onError(error)
                } else if let auth = auth {
                    observer.onNext(auth)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    /**
     @brief Signs in using an email address and email sign-in link.
     
     @param email The user's email address.
     @param link The email sign-in link.
     @param completion Optionally; a block which is invoked when the sign in flow finishes, or is
     canceled. Invoked asynchronously on the main thread in the future.
     
     @remarks Possible error codes:
     
     + `FIRAuthErrorCodeOperationNotAllowed` - Indicates that email and email sign-in link
     accounts are not enabled. Enable them in the Auth section of the
     Firebase console.
     + `FIRAuthErrorCodeUserDisabled` - Indicates the user's account is disabled.
     + `FIRAuthErrorCodeInvalidEmail` - Indicates the email address is invalid.
     
     
     @remarks See `FIRAuthErrors` for a list of error codes that are common to all API methods.
     */
    public func signIn(withEmail email: String, link: String) -> Observable<AuthDataResult> {
        return Observable.create { observer in
            self.base.signIn(withEmail: email, link: link) { auth, error in
                if let error = error {
                    observer.onError(error)
                } else if let auth = auth {
                    observer.onNext(auth)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    /** 
     @brief Asynchronously signs in to Firebase with the given 3rd-party credentials (e.g. a Facebook
     login Access Token, a Google ID Token/Access Token pair, etc.) and returns additional
     identity provider data.
     
     @param credential The credential supplied by the IdP.
     @param completion Optionally; a block which is invoked when the sign in flow finishes, or is
     canceled. Invoked asynchronously on the main thread in the future.
     
     @remarks Possible error codes:
     
     + `FIRAuthErrorCodeInvalidCredential` - Indicates the supplied credential is invalid.
     This could happen if it has expired or it is malformed.
     + `FIRAuthErrorCodeOperationNotAllowed` - Indicates that accounts
     with the identity provider represented by the credential are not enabled.
     Enable them in the Auth section of the Firebase console.
     + `FIRAuthErrorCodeAccountExistsWithDifferentCredential` - Indicates the email asserted
     by the credential (e.g. the email in a Facebook access token) is already in use by an
     existing account, that cannot be authenticated with this sign-in method. Call
     fetchProvidersForEmail for this user’s email and then prompt them to sign in with any of
     the sign-in providers returned. This error will only be thrown if the "One account per
     email address" setting is enabled in the Firebase console, under Auth settings.
     + `FIRAuthErrorCodeUserDisabled` - Indicates the user's account is disabled.
     + `FIRAuthErrorCodeWrongPassword` - Indicates the user attempted sign in with an
     incorrect password, if credential is of the type EmailPasswordAuthCredential.
     + `FIRAuthErrorCodeInvalidEmail` - Indicates the email address is malformed.
     + `FIRAuthErrorCodeMissingVerificationID` - Indicates that the phone auth credential was
     created with an empty verification ID.
     + `FIRAuthErrorCodeMissingVerificationCode` - Indicates that the phone auth credential
     was created with an empty verification code.
     + `FIRAuthErrorCodeInvalidVerificationCode` - Indicates that the phone auth credential
     was created with an invalid verification Code.
     + `FIRAuthErrorCodeInvalidVerificationID` - Indicates that the phone auth credential was
     created with an invalid verification ID.
     + `FIRAuthErrorCodeSessionExpired` - Indicates that the SMS code has expired.
     
     
     
     @remarks See `FIRAuthErrors` for a list of error codes that are common to all API methods
     */
    public func signInAndRetrieveData(with credential: AuthCredential) -> Observable<AuthDataResult> {
        return Observable.create { observer in
            self.base.signInAndRetrieveData(with: credential) { auth, error in
                if let error = error {
                    observer.onError(error)
                } else if let auth = auth {
                    observer.onNext(auth)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    /**
     @brief Asynchronously creates and becomes an anonymous user.
     @param completion Optionally; a block which is invoked when the sign in finishes, or is
     canceled. Invoked asynchronously on the main thread in the future.
     
     @remarks If there is already an anonymous user signed in, that user will be returned instead.
     If there is any other existing user signed in, that user will be signed out.
     
     @remarks Possible error codes:
     
     + `FIRAuthErrorCodeOperationNotAllowed` - Indicates that anonymous accounts are
     not enabled. Enable them in the Auth section of the Firebase console.
     
     @remarks See `FIRAuthErrors` for a list of error codes that are common to all API methods.
     */
    public func signInAnonymously() -> Observable<AuthDataResult> {
        return Observable.create { observer in
            self.base.signInAnonymously { auth, error in
                if let error = error {
                    observer.onError(error)
                } else if let auth = auth {
                    observer.onNext(auth)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    /**
     @brief Asynchronously signs in to Firebase with the given Auth token.
     
     @param token A self-signed custom auth token.
     @param completion Optionally; a block which is invoked when the sign in finishes, or is
     canceled. Invoked asynchronously on the main thread in the future.
     
     @remarks Possible error codes:
     
     + `FIRAuthErrorCodeInvalidCustomToken` - Indicates a validation error with
     the custom token.
     + `FIRAuthErrorCodeCustomTokenMismatch` - Indicates the service account and the API key
     belong to different projects.
     
     
     
     @remarks See `FIRAuthErrors` for a list of error codes that are common to all API methods.
     */
    public func signIn(withCustomToken token: String) -> Observable<AuthDataResult> {
        return Observable.create { observer in
            self.base.signIn(withCustomToken: token) { auth, error in
                if let error = error {
                    observer.onError(error)
                } else if let auth = auth {
                    observer.onNext(auth)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    /** 
     @brief Creates and, on success, signs in a user with the given email address and password.
     
     @param email The user's email address.
     @param password The user's desired password.
     @param completion Optionally; a block which is invoked when the sign up flow finishes, or is
     canceled. Invoked asynchronously on the main thread in the future.
     
     @remarks Possible error codes:
     
     + `FIRAuthErrorCodeInvalidEmail` - Indicates the email address is malformed.
     + `FIRAuthErrorCodeEmailAlreadyInUse` - Indicates the email used to attempt sign up
     already exists. Call fetchProvidersForEmail to check which sign-in mechanisms the user
     used, and prompt the user to sign in with one of those.
     + `FIRAuthErrorCodeOperationNotAllowed` - Indicates that email and password accounts
     are not enabled. Enable them in the Auth section of the Firebase console.
     + `FIRAuthErrorCodeWeakPassword` - Indicates an attempt to set a password that is
     considered too weak. The NSLocalizedFailureReasonErrorKey field in the NSError.userInfo
     dictionary object will contain more detailed explanation that can be shown to the user.
     
     @remarks See `FIRAuthErrors` for a list of error codes that are common to all API methods.
     */
    public func createUser(withEmail email: String, password: String) -> Observable<AuthDataResult> {
        return Observable.create { observer in
            self.base.createUser(withEmail: email, password: password) { auth, error in
                if let error = error {
                    observer.onError(error)
                } else if let auth = auth {
                    observer.onNext(auth)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    /**
     @brief Resets the password given a code sent to the user outside of the app and a new password
     for the user.
     
     @param newPassword The new password.
     @param completion Optionally; a block which is invoked when the request finishes. Invoked
     asynchronously on the main thread in the future.
     
     @remarks Possible error codes:
     
     + `FIRAuthErrorCodeWeakPassword` - Indicates an attempt to set a password that is
     considered too weak.
     + `FIRAuthErrorCodeOperationNotAllowed` - Indicates the administrator disabled sign
     in with the specified identity provider.
     + `FIRAuthErrorCodeExpiredActionCode` - Indicates the OOB code is expired.
     + `FIRAuthErrorCodeInvalidActionCode` - Indicates the OOB code is invalid.
     
     @remarks See `FIRAuthErrors` for a list of error codes that are common to all API methods.
     */
    public func confirmPasswordReset(withCode code: String, newPassword: String) -> Observable<Void> {
        return Observable.create { observer in
            self.base.confirmPasswordReset(withCode: code, newPassword: newPassword) { error in
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
     @brief Checks the validity of an out of band code.
     
     @param code The out of band code to check validity.
     @param completion Optionally; a block which is invoked when the request finishes. Invoked
     asynchronously on the main thread in the future.
     */
    public func checkActionCode(_ code: String) -> Observable<ActionCodeInfo> {
        return Observable.create { observer in
            self.base.checkActionCode(code) { info, error in
                if let error = error {
                    observer.onError(error)
                } else if let info = info {
                    observer.onNext(info)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    /** 
     @brief Checks the validity of a verify password reset code.
     
     @param code The password reset code to be verified.
     @param completion Optionally; a block which is invoked when the request finishes. Invoked
     asynchronously on the main thread in the future.
     */
    public func verifyPasswordResetCode(_ code: String) -> Observable<String> {
        return Observable.create { observer in
            self.base.verifyPasswordResetCode(code) { result, error in
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
     @brief Applies out of band code.
     
     @param code The out of band code to be applied.
     @param completion Optionally; a block which is invoked when the request finishes. Invoked
     asynchronously on the main thread in the future.
     
     @remarks This method will not work for out of band codes which require an additional parameter,
     such as password reset code.
     */
    public func applyActionCode(_ code: String) -> Observable<Void> {
        return Observable.create { observer in
            self.base.applyActionCode(code) { error in
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
     @brief Initiates a password reset for the given email address.
     
     @param email The email address of the user.
     @param completion Optionally; a block which is invoked when the request finishes. Invoked
     asynchronously on the main thread in the future.
     
     @remarks Possible error codes:
     
     + `FIRAuthErrorCodeInvalidRecipientEmail` - Indicates an invalid recipient email was
     sent in the request.
     + `FIRAuthErrorCodeInvalidSender` - Indicates an invalid sender email is set in
     the console for this action.
     + `FIRAuthErrorCodeInvalidMessagePayload` - Indicates an invalid email template for
     sending update email.
     
     
     */
    public func sendPasswordReset(withEmail email: String) -> Observable<Void> {
        return Observable.create { observer in
            self.base.sendPasswordReset(withEmail: email) { error in
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
     @brief Initiates a password reset for the given email address and @FIRActionCodeSettings object.
     
     @param email The email address of the user.
     @param actionCodeSettings An `FIRActionCodeSettings` object containing settings related to
     handling action codes.
     @param completion Optionally; a block which is invoked when the request finishes. Invoked
     asynchronously on the main thread in the future.
     
     @remarks Possible error codes:
     
     + `FIRAuthErrorCodeInvalidRecipientEmail` - Indicates an invalid recipient email was
     sent in the request.
     + `FIRAuthErrorCodeInvalidSender` - Indicates an invalid sender email is set in
     the console for this action.
     + `FIRAuthErrorCodeInvalidMessagePayload` - Indicates an invalid email template for
     sending update email.
     + `FIRAuthErrorCodeMissingIosBundleID` - Indicates that the iOS bundle ID is missing when
     `handleCodeInApp` is set to YES.
     + `FIRAuthErrorCodeMissingAndroidPackageName` - Indicates that the android package name
     is missing when the `androidInstallApp` flag is set to true.
     + `FIRAuthErrorCodeUnauthorizedDomain` - Indicates that the domain specified in the
     continue URL is not whitelisted in the Firebase console.
     + `FIRAuthErrorCodeInvalidContinueURI` - Indicates that the domain specified in the
     continue URI is not valid.
     
     
     */
    public func sendPasswordReset(withEmail email: String, actionCodeSettings: ActionCodeSettings) -> Observable<Void> {
        return Observable.create { observer in
            self.base.sendPasswordReset(withEmail: email, actionCodeSettings: actionCodeSettings) { error in
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
     @brief Sends a sign in with email link to provided email address.
     
     @param email The email address of the user.
     @param actionCodeSettings An `FIRActionCodeSettings` object containing settings related to
     handling action codes.
     @param completion Optionally; a block which is invoked when the request finishes. Invoked
     asynchronously on the main thread in the future.
     */
    public func sendSignInLink(toEmail email: String, actionCodeSettings: ActionCodeSettings) -> Observable<Void> {
        return Observable.create { observer in
            self.base.sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
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
     @brief Registers a block as an "auth state did change" listener. To be invoked when:
     
     + The block is registered as a listener,
     + A user with a different UID from the current user has signed in, or
     + The current user has signed out.
     
     @param listener The block to be invoked. The block is always invoked asynchronously on the main
     thread, even for it's initial invocation after having been added as a listener.
     
     @remarks The block is invoked immediately after adding it according to it's standard invocation
     semantics, asynchronously on the main thread. Users should pay special attention to
     making sure the block does not inadvertently retain objects which should not be retained by
     the long-lived block. The block itself will be retained by `FIRAuth` until it is
     unregistered or until the `FIRAuth` instance is otherwise deallocated.
     
     @return A handle useful for manually unregistering the block as a listener.
     */
    public var stateDidChange: Observable<User?> {
        return Observable.create { observer in
            let handle = self.base.addStateDidChangeListener { _, user in
                observer.onNext(user)
            }
            return Disposables.create {
                self.base.removeStateDidChangeListener(handle)
            }
        }
    }
    
    /** 
     @brief Registers a block as an "ID token did change" listener. To be invoked when:
     
     + The block is registered as a listener,
     + A user with a different UID from the current user has signed in,
     + The ID token of the current user has been refreshed, or
     + The current user has signed out.
     
     @param listener The block to be invoked. The block is always invoked asynchronously on the main
     thread, even for it's initial invocation after having been added as a listener.
     
     @remarks The block is invoked immediately after adding it according to it's standard invocation
     semantics, asynchronously on the main thread. Users should pay special attention to
     making sure the block does not inadvertently retain objects which should not be retained by
     the long-lived block. The block itself will be retained by `FIRAuth` until it is
     unregistered or until the `FIRAuth` instance is otherwise deallocated.
     
     @return A handle useful for manually unregistering the block as a listener.
     */
    public var idTokenDidChange: Observable<User?> {
        return Observable.create { observer in
            let handle = self.base.addIDTokenDidChangeListener { _, user in
                observer.onNext(user)
            }
            return Disposables.create {
                self.base.removeIDTokenDidChangeListener(handle)
            }
        }
    }
}

