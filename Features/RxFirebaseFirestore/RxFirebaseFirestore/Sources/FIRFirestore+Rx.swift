//
//  FIRFirestore+Rx.swift
//  RxFirebase
//
//  Created by Arnaud Dorgans on 31/03/2018.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import RxCocoa
import RxSwift
import FirebaseFirestore

extension Reactive where Base: Firestore {
    
    /**
     * Disables usage of the network by this Firestore instance. It can be re-enabled by via
     * `enableNetworkWithCompletion`. While the network is disabled, any snapshot listeners or get calls
     * will return results from cache and any write operations will be queued until the network is
     * restored. The completion block, if provided, will be called once network usage has been disabled.
     */
    public func disableNetwork() -> Observable<Void> {
        return Observable.create { observer in
            self.base.disableNetwork(completion: { error in
                guard let error = error else {
                    observer.onNext(())
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            })
            return Disposables.create()
        }
    }
    
    /**
     * Re-enables usage of the network by this Firestore instance after a prior call to
     * `disableNetworkWithCompletion`. Completion block, if provided, will be called once network uasge
     * has been enabled.
     */
    public func enableNetwork() -> Observable<Void> {
        return Observable.create { observer in
            self.base.enableNetwork(completion: { error in
                guard let error = error else {
                    observer.onNext(())
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            })
            return Disposables.create()
        }
    }
    
    /**
     * Executes the given updateBlock and then attempts to commit the changes applied within an atomic
     * transaction.
     *
     * In the updateBlock, a set of reads and writes can be performed atomically using the
     * `FIRTransaction` object passed to the block. After the updateBlock is run, Firestore will attempt
     * to apply the changes to the server. If any of the data read has been modified outside of this
     * transaction since being read, then the transaction will be retried by executing the updateBlock
     * again. If the transaction still fails after 5 retries, then the transaction will fail.
     *
     * Since the updateBlock may be executed multiple times, it should avoiding doing anything that
     * would cause side effects.
     *
     * Any value maybe be returned from the updateBlock. If the transaction is successfully committed,
     * then the completion block will be passed that value. The updateBlock also has an `NSError` out
     * parameter. If this is set, then the transaction will not attempt to commit, and the given error
     * will be passed to the completion block.
     *
     * The `FIRTransaction` object passed to the updateBlock contains methods for accessing documents
     * and collections. Unlike other firestore access, data accessed with the transaction will not
     * reflect local changes that have not been committed. For this reason, it is required that all
     * reads are performed before any writes. Transactions must be performed while online. Otherwise,
     * reads will fail, the final commit will fail, and the completion block will return an error.
     *
     * @param updateBlock The block to execute within the transaction context.
     * @param completion The block to call with the result or error of the transaction. This
     *     block will run even if the client is offline, unless the process is killed.
     */
    public func runTransaction(_ updateBlock: @escaping (Transaction) throws -> Any?) -> Observable<Any?> {
        return self.runTransaction(type: Any.self, updateBlock)
    }
    
    /**
     * Executes the given updateBlock and then attempts to commit the changes applied within an atomic
     * transaction.
     *
     * In the updateBlock, a set of reads and writes can be performed atomically using the
     * `FIRTransaction` object passed to the block. After the updateBlock is run, Firestore will attempt
     * to apply the changes to the server. If any of the data read has been modified outside of this
     * transaction since being read, then the transaction will be retried by executing the updateBlock
     * again. If the transaction still fails after 5 retries, then the transaction will fail.
     *
     * Since the updateBlock may be executed multiple times, it should avoiding doing anything that
     * would cause side effects.
     *
     * Any value maybe be returned from the updateBlock. If the transaction is successfully committed,
     * then the completion block will be passed that value. The updateBlock also has an `NSError` out
     * parameter. If this is set, then the transaction will not attempt to commit, and the given error
     * will be passed to the completion block.
     *
     * The `FIRTransaction` object passed to the updateBlock contains methods for accessing documents
     * and collections. Unlike other firestore access, data accessed with the transaction will not
     * reflect local changes that have not been committed. For this reason, it is required that all
     * reads are performed before any writes. Transactions must be performed while online. Otherwise,
     * reads will fail, the final commit will fail, and the completion block will return an error.
     *
     * @param type The type of the result in the completion's block.
     * @param updateBlock The block to execute within the transaction context.
     * @param completion The block to call with the result or error of the transaction. This
     *     block will run even if the client is offline, unless the process is killed.
     */
    public func runTransaction<T>(type: T.Type, _ updateBlock: @escaping (Transaction) throws -> T?) -> Observable<T?> {
        return Observable.create { observer in
            self.base.runTransaction({ transaction, errorPointer in
                do {
                    return try updateBlock(transaction)
                } catch {
                    errorPointer?.pointee = error as NSError
                    return nil
                }
            }, completion: { value, error in
                guard let error = error else {
                    observer.onNext(value as? T)
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            })
            return Disposables.create()
        }
    }
}
