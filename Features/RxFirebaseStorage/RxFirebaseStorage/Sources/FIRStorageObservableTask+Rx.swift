//
//  FIRStorageObservableTask+Rx.swift
//  RxFirebase
//
//  Created by Arnaud Dorgans on 19/07/2018.
//

import RxSwift
import FirebaseStorage

extension Reactive where Base: StorageObservableTask {
    
    /**
     * Observes changes in the upload status: Resume, Pause, Progress, Success, and Failure.
     * @param status The FIRStorageTaskStatus change to observe.
     * @param handler A callback that fires every time the status event occurs,
     * returns a FIRStorageTaskSnapshot containing the state of the task.
     */
    public func observe(_ status: StorageTaskStatus) -> Observable<StorageTaskSnapshot> {
        return Observable.create { observer in
            let handle = self.base.observe(status) { snapshot in
                observer.onNext(snapshot)
            }
            return Disposables.create {
                self.base.removeObserver(withHandle: handle)
            }
        }
    }
}
