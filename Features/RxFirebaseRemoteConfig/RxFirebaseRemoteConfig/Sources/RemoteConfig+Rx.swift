//
//  RemoteConfig+Rx.swift
//  RxFirebase
//
//  Created by Arnaud Dorgans on 03/04/2018.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import RxSwift
import FirebaseRemoteConfig

extension Reactive where Base: RemoteConfig {
    
    /// Fetches Remote Config data with a callback. Call activateFetched to make fetched data available
    /// to your app.
    /// @param activateFetched   Make fetched data available to your app.
    /// @param completionHandler Fetch operation callback.
    public func fetch(activateFetched: Bool = false) -> Observable<RemoteConfigFetchStatus> {
        return Observable<RemoteConfigFetchStatus>.create { observer in
            self.base.fetch { status, error in
                guard let error = error else {
                    if activateFetched, status == .success {
                        self.base.activateFetched()
                    }
                    observer.onNext(status)
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    /// Fetches Remote Config data and sets a duration that specifies how long config data lasts.
    /// @param expirationDuration  Duration that defines how long fetched config data is available, in
    ///                            seconds. When the config data expires, a new fetch is required.
    /// @param activateFetched     Make fetched data available to your app.
    /// @param completionHandler   Fetch operation callback.
    public func fetch(withExpirationDuration duration: TimeInterval, activateFetched: Bool = false) -> Observable<RemoteConfigFetchStatus> {
        return Observable<RemoteConfigFetchStatus>.create { observer in
            self.base.fetch(withExpirationDuration: duration) { status, error in
                guard let error = error else {
                    if activateFetched, status == .success {
                        self.base.activateFetched()
                    }
                    observer.onNext(status)
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
