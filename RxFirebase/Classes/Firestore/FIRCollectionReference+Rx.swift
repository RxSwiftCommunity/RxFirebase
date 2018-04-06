//
//  FIRCollectionReference+Rx.swift
//  RxFirebase
//
//  Created by Arnaud Dorgans on 31/03/2018.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import RxCocoa
import RxSwift
import FirebaseFirestore

extension Reactive where Base: CollectionReference {
    
    /**
     * Add a new document to this collection with the specified data, assigning it a document ID
     * automatically.
     *
     * @param data An `NSDictionary` containing the data for the new document.
     * @param completion A block to execute once the document has been successfully written to
     *     the server. This block will not be called while the client is offline, though local
     *     changes will be visible immediately.
     *
     * @return A `FIRDocumentReference` pointing to the newly created document.
     */
    public func addDocument(data: [String: Any]) -> Observable<DocumentReference> {
        return Observable<DocumentReference>.create { observer in
            var ref: DocumentReference?
            ref = self.base.addDocument(data: data) { error in
                if let error = error {
                    observer.onError(error)
                } else if let ref = ref {
                    observer.onNext(ref)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
