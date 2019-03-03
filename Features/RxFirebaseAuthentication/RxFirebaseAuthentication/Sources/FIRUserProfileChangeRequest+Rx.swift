//
//  FIRUserProfileChangeRequest+Rx.swift
//  RxFirebase
//
//  Created by Arnaud Dorgans on 09/09/2018.
//

import RxSwift
import FirebaseAuth

extension Reactive where Base: UserProfileChangeRequest {
    
    /**
     @brief Commits any pending changes.
     @remarks This method should only be called once. Once called, property values should not be
     changed.
     
     @param completion Optionally; the block invoked when the user profile change has been applied.
     Invoked asynchronously on the main thread in the future.
     */
    public func commitChanges() -> Observable<Void> {
        return Observable.create { observer in
            self.base.commitChanges { error in
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
