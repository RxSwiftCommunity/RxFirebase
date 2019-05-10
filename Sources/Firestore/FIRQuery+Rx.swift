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
     * Reads the documents matching this query.
     */
    public func getDocuments(source: FirestoreSource) -> Observable<QuerySnapshot> {
        return Observable<QuerySnapshot>.create { observer in
            self.base.getDocuments(source: source) { snapshot, error in
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
        return self.base.limit(to: 1)
            .rx
            .getDocuments()
            .map { snapshot in
                guard let document = snapshot.documents.first(where: { $0.exists }) else {
                    throw NSError(domain: FirestoreErrorDomain, code: FirestoreErrorCode.notFound.rawValue, userInfo: nil)
                }
                return document
            }
    }
    
    /**
     * Attaches a listener for QuerySnapshot events.
     */
    public func listen() -> Observable<QuerySnapshot> {
        return Observable<QuerySnapshot>.create { observer in
            let listener = self.base.addSnapshotListener { snapshot, error in
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
    
    /**
     * Attaches a listener for QuerySnapshot events.
     *
     * @param includeMetadataChanges Whether metadata-only changes (i.e. only
     *     `FIRDocumentSnapshot.metadata` changed) should trigger snapshot events.
     */
    public func listen(includeMetadataChanges: Bool) -> Observable<QuerySnapshot> {
        return Observable<QuerySnapshot>.create { observer in
            let listener = self.base.addSnapshotListener(includeMetadataChanges: includeMetadataChanges) { snapshot, error in
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
