//
//  FIRDatabaseReference+Rx.swift
//  RxFirebase
//
//  Created by Arnaud Dorgans on 03/05/2018.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import RxSwift
import FirebaseDatabase

public typealias DatabaseReferenceTransactionResult = (committed: Bool, snapshot: DataSnapshot?)

extension Reactive where Base: DatabaseReference {
    
    /**
     * The same as setValue: with an additional priority to be attached to the data being written.
     * Priorities are used to order items.
     *
     * @param value The value to be written.
     * @param priority The priority to be attached to that data.
     */
    public func setValue(_ value: Any?, andPriority priority: Any? = nil) -> Single<DatabaseReference> {
        return Single.create(subscribe: { (singleEventListener) -> Disposable in
            self.base.setValue(value, andPriority: priority, withCompletionBlock: { (error, ref) in
                if let error = error {
                    singleEventListener(.error(error))
                }
                else {
                    singleEventListener(.success(ref))
                }
            })
            return Disposables.create()
        })
    }
    
    /**
     * Remove the data at this Firebase Database location. Any data at child locations will also be deleted.
     *
     * The effect of the delete will be visible immediately and the corresponding events
     * will be triggered. Synchronization of the delete to the Firebase Database servers will
     * also be started.
     *
     * remove: is equivalent to calling setValue:nil
     */
    public func removeValue() -> Single<DatabaseReference> {
        return Single.create(subscribe: { (singleEventListener) -> Disposable in
            self.base.removeValue(completionBlock: { (error, ref) in
                if let error = error {
                    singleEventListener(.error(error))
                }
                else {
                    singleEventListener(.success(ref))
                }
            })
            return Disposables.create()
        })
    }
    
    /**
     * Sets a priority for the data at this Firebase Database location.
     * Priorities can be used to provide a custom ordering for the children at a location
     * (if no priorities are specified, the children are ordered by key).
     *
     * You cannot set a priority on an empty location. For this reason
     * setValue:andPriority: should be used when setting initial data with a specific priority
     * and setPriority: should be used when updating the priority of existing data.
     *
     * Children are sorted based on this priority using the following rules:
     *
     * Children with no priority come first.
     * Children with a number as their priority come next. They are sorted numerically by priority (small to large).
     * Children with a string as their priority come last. They are sorted lexicographically by priority.
     * Whenever two children have the same priority (including no priority), they are sorted by key. Numeric
     * keys come first (sorted numerically), followed by the remaining keys (sorted lexicographically).
     *
     * Note that priorities are parsed and ordered as IEEE 754 double-precision floating-point numbers.
     * Keys are always stored as strings and are treated as numbers only when they can be parsed as a
     * 32-bit integer
     *
     * @param priority The priority to set at the specified location.
     */
    public func setPriority(_ priority: Any?) -> Single<DatabaseReference> {
        return Single.create(subscribe: { (singleEventListener) -> Disposable in
            self.base.setPriority(priority, withCompletionBlock: { (error, ref) in
                if let error = error {
                    singleEventListener(.error(error))
                }
                else {
                    singleEventListener(.success(ref))
                }
            })
            return Disposables.create()
        })
    }
    
    /**
     * Updates the values at the specified paths in the dictionary without overwriting other
     * keys at this location.
     *
     * @param values A dictionary of the keys to change and their new values
     */
    public func updateChildValues(_ values: [AnyHashable: Any]) -> Single<DatabaseReference> {
        return Single.create(subscribe: { (singleEventListener) -> Disposable in
            self.base.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if let error = error {
                    singleEventListener(.error(error))
                }
                else {
                    singleEventListener(.success(ref))
                }
            })
            return Disposables.create()
        })
    }
    
    /**
     * Ensure the data at this location is set to the specified value and priority when
     * the client is disconnected (due to closing the browser, navigating
     * to a new page, or network issues).
     *
     * @param value The value to be set after the connection is lost.
     * @param priority The priority to be set after the connection is lost.
     */
    public func onDisconnectSetValue(_ value: Any?, andPriority priority: Any? = nil) -> Single<DatabaseReference> {
        return Single.create(subscribe: { (singleEventListener) -> Disposable in
            self.base.onDisconnectSetValue(value, andPriority: priority, withCompletionBlock: { (error, ref) in
                if let error = error {
                    singleEventListener(.error(error))
                }
                else {
                    singleEventListener(.success(ref))
                }
            })
            return Disposables.create()
        })
    }
    
    /**
     * Ensure the data at this location is removed when
     * the client is disconnected (due to closing the app, navigating
     * to a new page, or network issues).
     *
     * onDisconnectRemoveValue is especially useful for implementing "presence" systems.
     */
    public func onDisconnectRemoveValue() -> Single<DatabaseReference> {
        return Single.create(subscribe: { (singleEventListener) -> Disposable in
            self.base.onDisconnectRemoveValue(completionBlock: { (error, ref) in
                if let error = error {
                    singleEventListener(.error(error))
                }
                else {
                    singleEventListener(.success(ref))
                }
            })
            return Disposables.create()
        })
    }
    
    /**
     * Ensure the data has the specified child values updated when
     * the client is disconnected (due to closing the browser, navigating
     * to a new page, or network issues).
     *
     *
     * @param values A dictionary of child node keys and the values to set them to after the connection is lost.
     */
    public func onDisconnectUpdateChildValues(_ values: [AnyHashable: Any]) -> Single<DatabaseReference> {
        return Single.create(subscribe: { (singleEventListener) -> Disposable in
            self.base.onDisconnectUpdateChildValues(values, withCompletionBlock: { (error, ref) in
                if let error = error {
                    singleEventListener(.error(error))
                }
                else {
                    singleEventListener(.success(ref))
                }
            })
            return Disposables.create()
        })
    }
    
    /**
     * Cancel any operations that are set to run on disconnect. If you previously called onDisconnectSetValue:,
     * onDisconnectRemoveValue:, or onDisconnectUpdateChildValues:, and no longer want the values updated when the
     * connection is lost, call cancelDisconnectOperations:
     */
    public func cancelDisconnectOperations() -> Single<DatabaseReference> {
        return Single.create(subscribe: { (singleEventListener) -> Disposable in
            self.base.cancelDisconnectOperations(completionBlock: { (error, ref) in
                if let error = error {
                    singleEventListener(.error(error))
                }
                else {
                    singleEventListener(.success(ref))
                }
            })
            return Disposables.create()
        })
    }
    
    /**
     * Performs an optimistic-concurrency transactional update to the data at this location. Your block will be called with a FIRMutableData
     * instance that contains the current data at this location. Your block should update this data to the value you
     * wish to write to this location, and then return an instance of FIRTransactionResult with the new data.
     *
     * If, when the operation reaches the server, it turns out that this client had stale data, your block will be run
     * again with the latest data from the server.
     *
     * When your block is run, you may decide to abort the transaction by return [FIRTransactionResult abort].
     *
     * Since your block may be run multiple times, this client could see several immediate states that don't exist on the server. You can suppress those immediate states until the server confirms the final state of the transaction.
     *
     * @param block This block receives the current data at this location and must return an instance of FIRTransactionResult
     * @param completionBlock This block will be triggered once the transaction is complete, whether it was successful or not. It will indicate if there was an error, whether or not the data was committed, and what the current value of the data at this location is.
     * @param localEvents Set this to NO to suppress events raised for intermediate states, and only get events based on the final state of the transaction.
     */
    public func runTransactionBlock(_ block: @escaping (MutableData) -> TransactionResult, withLocalEvents: Bool) -> Single<DatabaseReferenceTransactionResult> {
        
        return Single.create(subscribe: { (singleEventListener) -> Disposable in
            self.base.runTransactionBlock(block, andCompletionBlock: { (error, committed, snapshot) in
                if let error = error {
                    singleEventListener(.error(error))
                }
                else {
                    singleEventListener(.success(DatabaseReferenceTransactionResult(committed, snapshot)))
                }
            })
            return Disposables.create()
        })
    }
    
    /**
     * Performs an optimistic-concurrency transactional update to the data at this location. Your block will be called with a FIRMutableData
     * instance that contains the current data at this location. Your block should update this data to the value you
     * wish to write to this location, and then return an instance of FIRTransactionResult with the new data.
     *
     * If, when the operation reaches the server, it turns out that this client had stale data, your block will be run
     * again with the latest data from the server.
     *
     * When your block is run, you may decide to abort the transaction by return [FIRTransactionResult abort].
     *
     * Since your block may be run multiple times, this client could see several immediate states that don't exist on the server. You can suppress those immediate states until the server confirms the final state of the transaction.
     *
     * @param block This block receives the current data at this location and must return an instance of FIRTransactionResult
     * @param completionBlock This block will be triggered once the transaction is complete, whether it was successful or not. It will indicate if there was an error, whether or not the data was committed, and what the current value of the data at this location is.
     */
    public func runTransactionBlock(_ block: @escaping (MutableData) -> TransactionResult) -> Single<DatabaseReferenceTransactionResult> {
        return self.runTransactionBlock(block, withLocalEvents: true)
    }
}
