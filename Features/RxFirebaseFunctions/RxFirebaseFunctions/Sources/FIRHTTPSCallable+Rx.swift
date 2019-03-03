//
//  FIRHTTPSCallable+Rx.swift
//  RxFirebase
//
//  Created by Arnaud Dorgans on 19/10/2018.
//

import RxSwift
import FirebaseFunctions

extension Reactive where Base: HTTPSCallable {
    
    /**
     * Executes this Callable HTTPS trigger asynchronously without any parameters.
     *
     * The request to the Cloud Functions backend made by this method automatically includes a
     * Firebase Instance ID token to identify the app instance. If a user is logged in with Firebase
     * Auth, an auth ID token for the user is also automatically included.
     *
     * Firebase Instance ID sends data to the Firebase backend periodically to collect information
     * regarding the app instance. To stop this, see `[FIRInstanceID deleteIDWithHandler:]`. It
     * resumes with a new Instance ID the next time you call this method.
     *
     * @param completion The block to call when the HTTPS request has completed.
     */
    public func call() -> Observable<HTTPSCallableResult> {
        return Observable.create { observer in
            self.base.call { result, error in
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
    
    /**
     * Executes this Callable HTTPS trigger asynchronously.
     *
     * The data passed into the trigger can be any of the following types:
     * * NSNull
     * * NSString
     * * NSNumber
     * * NSArray<id>, where the contained objects are also one of these types.
     * * NSDictionary<NSString, id>, where the values are also one of these types.
     *
     * The request to the Cloud Functions backend made by this method automatically includes a
     * Firebase Instance ID token to identify the app instance. If a user is logged in with Firebase
     * Auth, an auth ID token for the user is also automatically included.
     *
     * Firebase Instance ID sends data to the Firebase backend periodically to collect information
     * regarding the app instance. To stop this, see `[FIRInstanceID deleteIDWithHandler:]`. It
     * resumes with a new Instance ID the next time you call this method.
     *
     * @param data Parameters to pass to the trigger.
     * @param completion The block to call when the HTTPS request has completed.
     */
    public func call(_ data: Any?) -> Observable<HTTPSCallableResult> {
        return Observable.create { observer in
            self.base.call(data) { result, error in
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
