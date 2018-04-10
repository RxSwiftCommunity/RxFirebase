//
//  FIRDatabaseQuery+Rx.swift
//  RxFirebase
//
//  Created by Arnaud Dorgans on 08/04/2018.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseDatabase

extension Reactive where Base: DatabaseQuery {
    
    /**
     * observeEventType:withBlock: is used to listen for data changes at a particular location.
     * This is the primary way to read data from the Firebase Database. Your block will be triggered
     * for the initial data and again whenever the data changes.
     *
     * The cancelBlock will be called if you will no longer receive new events due to no longer having permission.
     *
     * Use removeObserverWithHandle: to stop receiving updates.
     *
     * @param eventType The type of event to listen for.
     * @param block The block that should be called with initial data and updates.  It is passed the data as a FIRDataSnapshot.
     * @param cancelBlock The block that should be called if this client no longer has permission to receive these events
     * @return A handle used to unregister this block later using removeObserverWithHandle:
     */
    func observe(_ eventType: DataEventType) -> Observable<DataSnapshot> {
        return Observable.create { observer in
            let handle = self.base.observe(eventType, with: { snapshot in
                observer.onNext(snapshot)
            }, withCancel: { error in
                observer.onError(error)
            })
            return Disposables.create {
                self.base.removeObserver(withHandle: handle)
            }
        }
    }
    
    /**
     * observeEventType:andPreviousSiblingKeyWithBlock: is used to listen for data changes at a particular location.
     * This is the primary way to read data from the Firebase Database. Your block will be triggered
     * for the initial data and again whenever the data changes. In addition, for FIRDataEventTypeChildAdded, FIRDataEventTypeChildMoved, and
     * FIRDataEventTypeChildChanged events, your block will be passed the key of the previous node by priority order.
     *
     * The cancelBlock will be called if you will no longer receive new events due to no longer having permission.
     *
     * Use removeObserverWithHandle: to stop receiving updates.
     *
     * @param eventType The type of event to listen for.
     * @param block The block that should be called with initial data and updates.  It is passed the data as a FIRDataSnapshot
     * and the previous child's key.
     * @param cancelBlock The block that should be called if this client no longer has permission to receive these events
     * @return A handle used to unregister this block later using removeObserverWithHandle:
     */
    func observe(_ eventType: DataEventType) -> Observable<(snapshot: DataSnapshot, prevKey: String?)> {
        return Observable.create { observer in
            let handle = self.base.observe(eventType, andPreviousSiblingKeyWith: { (snapshot, prevKey) in
                observer.onNext((snapshot, prevKey))
            }, withCancel: { error in
                observer.onError(error)
            })
            return Disposables.create {
                self.base.removeObserver(withHandle: handle)
            }
        }
    }
    
    func observeSingleEvent(_ eventType: DataEventType) {
        self.base.observeSingleEvent(of: eventType, with: { snapshot in
            
        }, withCancel: { error in
            
        })
    }
}
