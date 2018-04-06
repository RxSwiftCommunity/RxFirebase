//
//  FIRWriteBatch+Rx.swift
//  RxFirebase
//
//  Created by Arnaud Dorgans on 31/03/2018.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import RxCocoa
import RxSwift
import FirebaseFirestore

extension Reactive where Base: WriteBatch {
    
    /**
     * Commits all of the writes in this write batch as a single atomic unit.
     *
     * @param completion A block to be called once all of the writes in the batch have been
     *     successfully written to the backend as an atomic unit. This block will only execute
     *     when the client is online and the commit has completed against the server. The
     *     completion handler will not be called when the device is offline, though local
     *     changes will be visible immediately.
     */
    public func commit() -> Observable<Void> {
        return Observable.create { observer in
            self.base.commit { error in
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
