//
//  FIRDocumentReference+Rx.swift
//  RxFirebase
//
//  Created by Arnaud Dorgans on 31/03/2018.
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
     * exist, it will be created. If you pass `FIRSetOptions`, the provided data will be merged into
     * an existing document.
     *
     * @param documentData An `NSDictionary` containing the fields that make up the document
     * to be written.
     * @param options A `FIRSetOptions` used to configure the set behavior.
     * @param completion A block to execute once the document has been successfully written to the
     *     server. This block will not be called while the client is offline, though local
     *     changes will be visible immediately.
     */
    public func setData(_ documentData: [String: Any], options: SetOptions) -> Observable<Void> {
        return Observable<Void>.create { observer in
            self.base.setData(documentData, options: options) { error in
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
    public func getDocument() -> Observable<DocumentSnapshot?> {
        return Observable.create { observer in
            self.base.getDocument { snapshot, error in
                if let error = error {
                    observer.onError(error)
                }
                observer.onNext(snapshot)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    /**
     * Attaches a listener for DocumentSnapshot events.
     *
     * @param options Options controlling the listener behavior.
     * @param listener The listener to attach.
     *
     * @return A FIRListenerRegistration that can be used to remove this listener.
     */
    public func listen(options: DocumentListenOptions? = nil) -> Observable<DocumentSnapshot> {
        return Observable<DocumentSnapshot>.create { observer in
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
