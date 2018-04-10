//
//  FIRQuery+Rx.swift
//  RxFirebase
//
//  Created by Arnaud Dorgans on 31/03/2018.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import RxCocoa
import RxSwift
import FirebaseFirestore

extension Reactive where Base: Query {
    
    /**
     * Reads the documents matching this query.
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
     * Reads the first document matching this query.
     */
    public func getFirstDocument() -> Observable<QueryDocumentSnapshot> {
        return self.getDocuments()
            .map { snapshot in
                guard let document = snapshot.documents.first else {
                    throw NSError(domain: FirestoreErrorDomain, code: FirestoreErrorCode.notFound.rawValue, userInfo: nil)
                }
                return document
            }
    }
    
    /**
     * Attaches a listener for QuerySnapshot events.
     *
     * @param options Options controlling the listener behavior.
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
