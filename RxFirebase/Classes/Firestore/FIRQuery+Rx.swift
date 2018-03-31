//
//  FIRQuery+Rx.swift
//  RxFirebase
//
//  Created by Arnaud Dorgans on 31/03/2018.
//

import RxCocoa
import RxSwift
import FirebaseFirestore

extension Reactive where Base: Query {
    
    /**
     * Reads the documents matching this query.
     *
     * @param completion a block to execute once the documents have been successfully read.
     *     documentSet will be `nil` only if error is `non-nil`.
     */
    public func getDocuments() -> Observable<QuerySnapshot> {
        return Observable<QuerySnapshot>.create { observer in
            self.base.getDocuments { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot {
                    observer.onNext(snapshot)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    /**
     * Attaches a listener for QuerySnapshot events.
     *
     * @param options Options controlling the listener behavior.
     * @param listener The listener to attach.
     *
     * @return A FIRListenerRegistration that can be used to remove this listener.
     */
    public func listen(options: QueryListenOptions? = nil) -> Observable<QuerySnapshot> {
        return Observable<QuerySnapshot>.create { observer in
            let listener = self.base.addSnapshotListener(options: options) { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot {
                    observer.onNext(snapshot)
                }
            }
            return Disposables.create {
                listener.remove()
            }
        }
    }
}
