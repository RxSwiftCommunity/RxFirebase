//
//  FIRDatabaseQuery+Rx.swift
//  RxFirebase
//
//  Created by Arnaud Dorgans on 08/04/2018.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import RxSwift
import RxCocoa
import FirebaseDatabase

public typealias PreviousSiblingKeyDataSnapshot = (snapshot: DataSnapshot, prevKey: String?)

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
    public func observeEvent(_ eventType: DataEventType) -> Observable<DataSnapshot> {
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
    public func observeEventAndPreviousSiblingKey(_ eventType: DataEventType) -> Observable<PreviousSiblingKeyDataSnapshot> {
        return Observable.create { observer in
            let handle = self.base.observe(eventType, andPreviousSiblingKeyWith: { snapshot, prevKey in
                observer.onNext(PreviousSiblingKeyDataSnapshot(snapshot, prevKey))
            }, withCancel: { error in
                observer.onError(error)
            })
            return Disposables.create {
                self.base.removeObserver(withHandle: handle)
            }
        }
    }
    
    /**
     * This is equivalent to observeEventType:withBlock:, except the block is immediately canceled after the initial data is returned.
     *
     * The cancelBlock will be called if you do not have permission to read data at this location.
     *
     * @param eventType The type of event to listen for.
     * @param block The block that should be called.  It is passed the data as a FIRDataSnapshot.
     * @param cancelBlock The block that will be called if you don't have permission to access this data
     */
    public func observeSingleEvent(_ eventType: DataEventType) -> Single<DataSnapshot> {
        return Single.create(subscribe: { (singleEventListener) -> Disposable in
            self.base.observeSingleEvent(of: eventType, with: { (snapshot) in
                singleEventListener(.success(snapshot))
            }, withCancel: { (error) in
                singleEventListener(.error(error))
            })
            return Disposables.create()
        })
    }
    
    /**
     * This is equivalent to observeEventType:withBlock:, except the block is immediately canceled after the initial data is returned. In addition, for FIRDataEventTypeChildAdded, FIRDataEventTypeChildMoved, and
     * FIRDataEventTypeChildChanged events, your block will be passed the key of the previous node by priority order.
     *
     * The cancelBlock will be called if you do not have permission to read data at this location.
     *
     * @param eventType The type of event to listen for.
     * @param block The block that should be called.  It is passed the data as a FIRDataSnapshot and the previous child's key.
     * @param cancelBlock The block that will be called if you don't have permission to access this data
     */
    public func observeSingleEventAndPreviousSiblingKey(_ eventType: DataEventType) -> Single<PreviousSiblingKeyDataSnapshot> {
        return Single.create(subscribe: { (singleEventListener) -> Disposable in
            self.base.observeSingleEvent(of: eventType, andPreviousSiblingKeyWith: { (snapshot, prevKey) in
                singleEventListener(.success(PreviousSiblingKeyDataSnapshot(snapshot, prevKey)))
            }, withCancel: { (error) in
                singleEventListener(.error(error))
            })
            return Disposables.create()
        })
    }
}
