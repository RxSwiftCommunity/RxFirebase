//
//  FIRDocumentReference+Rx.swift
//  RxFirebase
//
//  Created by Arnaud Dorgans on 31/03/2018.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import RxCocoa
import RxSwift
import FirebaseFirestore

extension Reactive where Base: DocumentReference {
    
    /**
     * Overwrites the document referred to by this `FIRDocumentReference`. If no document exists, it
     * is created. If a document already exists, it is overwritten.
     *
     * @param documentData An `NSDictionary` containing the fields that make up the document
     *     to be written.
     * @param completion A block to execute once the document has been successfully written to the
     *     server. This block will not be called while the client is offline, though local
     *     changes will be visible immediately.
     */
    public func setData(_ documentData: [String: Any]) -> Observable<Void> {
        return Observable<Void>.create { observer in
            self.base.setData(documentData) { error in
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
     * Writes to the document referred to by this DocumentReference. If the document does not yet
     * exist, it will be created. If you pass `merge:YES`, the provided data will be merged into
     * any existing document.
     *
     * @param documentData An `NSDictionary` containing the fields that make up the document
     * to be written.
     * @param merge Whether to merge the provided data into any existing document.
     * @param completion A block to execute once the document has been successfully written to the
     *     server. This block will not be called while the client is offline, though local
     *     changes will be visible immediately.
     */
    public func setData(_ documentData: [String: Any], merge: Bool) -> Observable<Void> {
        return Observable<Void>.create { observer in
            self.base.setData(documentData, merge: merge) { error in
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
     * Updates fields in the document referred to by this `FIRDocumentReference`. If the document
     * does not exist, the update fails and the specified completion block receives an error.
     *
     * @param fields An `NSDictionary` containing the fields (expressed as an `NSString` or
     *     `FIRFieldPath`) and values with which to update the document.
     * @param completion A block to execute when the update is complete. If the update is successful the
     *     error parameter will be nil, otherwise it will give an indication of how the update failed.
     *     This block will only execute when the client is online and the commit has completed against
     *     the server. The completion handler will not be called when the device is offline, though
     *     local changes will be visible immediately.
     */
    public func updateData(_ fields: [AnyHashable: Any]) -> Observable<Void> {
        return Observable<Void>.create { observer in
            self.base.updateData(fields) { error in
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
     * Deletes the document referred to by this `FIRDocumentReference`.
     *
     * @param completion A block to execute once the document has been successfully written to the
     *     server. This block will not be called while the client is offline, though local
     *     changes will be visible immediately.
     */
    public func delete() -> Observable<Void> {
        return Observable<Void>.create { observer in
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
    
    /**
     * Reads the document referenced by this `FIRDocumentReference`.
     *
     * @param completion a block to execute once the document has been successfully read.
     */
    public func getDocument() -> Observable<DocumentSnapshot> {
        return Observable.create { observer in
            self.base.getDocument { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot, snapshot.exists {
                    observer.onNext(snapshot)
                    observer.onCompleted()
                } else {
                    observer.onError(NSError(domain: FirestoreErrorDomain, code: FirestoreErrorCode.notFound.rawValue, userInfo: nil))
                }
            }
            return Disposables.create()
        }
    }
    
    /**
     * Reads the document referenced by this `FIRDocumentReference`.
     *
     * @param source indicates whether the results should be fetched from the cache
     *     only (`Source.cache`), the server only (`Source.server`), or to attempt
     *     the server and fall back to the cache (`Source.default`).
     * @param completion a block to execute once the document has been successfully read.
     */
    public func getDocument(source: FirestoreSource) -> Observable<DocumentSnapshot> {
        return Observable.create { observer in
            self.base.getDocument(source: source) { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot, snapshot.exists {
                    observer.onNext(snapshot)
                    observer.onCompleted()
                } else {
                    observer.onError(NSError(domain: FirestoreErrorDomain, code: FirestoreErrorCode.notFound.rawValue, userInfo: nil))
                }
            }
            return Disposables.create()
        }
    }
    
    /**
     * Attaches a listener for DocumentSnapshot events.
     *
     * @param includeMetadataChanges Whether metadata-only changes (i.e. only
     *     `FIRDocumentSnapshot.metadata` changed) should trigger snapshot events.
     */
    public func listen(includeMetadataChanges: Bool) -> Observable<DocumentSnapshot> {
        return Observable<DocumentSnapshot>.create { observer in
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
    
    /**
     * Attaches a listener for DocumentSnapshot events.
     */
    public func listen() -> Observable<DocumentSnapshot> {
        return Observable<DocumentSnapshot>.create { observer in
            let listener = self.base.addSnapshotListener() { snapshot, error in
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
