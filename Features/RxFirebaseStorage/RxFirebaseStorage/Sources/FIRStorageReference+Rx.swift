//
//  FIRStorageReference+Rx.swift
//  RxFirebase
//
//  Created by Arnaud Dorgans on 19/07/2018.
//

import RxSwift
import FirebaseStorage

extension Reactive where Base: StorageReference {
    
    /**
     * Asynchronously uploads data to the currently specified FIRStorageReference.
     * This is not recommended for large files, and one should instead upload a file from disk.
     * @param uploadData The NSData to upload.
     * @param metadata FIRStorageMetadata containing additional information (MIME type, etc.)
     * about the object being uploaded.
     * @param completion A completion block that either returns the object metadata on success,
     * or an error on failure.
     */
    public func putData(_ uploadData: Data, metadata: StorageMetadata? = nil) -> Observable<StorageMetadata> {
        return Observable.create { observer in
            let task = self.base.putData(uploadData, metadata: metadata) { metadata, error in
                guard let error = error else {
                    if let metadata = metadata {
                        observer.onNext(metadata)
                    }
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    /**
     * Asynchronously uploads a file to the currently specified FIRStorageReference.
     * @param fileURL A URL representing the system file path of the object to be uploaded.
     * @param metadata FIRStorageMetadata containing additional information (MIME type, etc.)
     * about the object being uploaded.
     * @param completion A completion block that either returns the object metadata on success,
     * or an error on failure.
     */
    public func putFile(from url: URL, metadata: StorageMetadata? = nil) -> Observable<StorageMetadata> {
        return Observable.create { observer in
            let task = self.base.putFile(from: url, metadata: metadata) { metadata, error in
                guard let error = error else {
                    if let metadata = metadata {
                        observer.onNext(metadata)
                    }
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    /**
     * Asynchronously downloads the object at the FIRStorageReference to an NSData object in memory.
     * An NSData of the provided max size will be allocated, so ensure that the device has enough free
     * memory to complete the download. For downloading large files, writeToFile may be a better option.
     * @param size The maximum size in bytes to download. If the download exceeds this size
     * the task will be cancelled and an error will be returned.
     * @param completion A completion block that either returns the object data on success,
     * or an error on failure.
     */
    public func getData(maxSize: Int64) -> Observable<Data> {
        return Observable.create { observer in
            let task = self.base.getData(maxSize: maxSize) { data, error in
                guard let error = error else {
                    if let data = data {
                        observer.onNext(data)
                    }
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    /**
     * Asynchronously retrieves a long lived download URL with a revokable token.
     * This can be used to share the file with others, but can be revoked by a developer
     * in the Firebase Console if desired.
     * @param completion A completion block that either returns the URL on success,
     * or an error on failure.
     */
    public func downloadURL() -> Observable<URL> {
        return Observable.create { observer in
            self.base.downloadURL { url, error in
                guard let error = error else {
                    if let url = url {
                        observer.onNext(url)
                    }
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    /**
     * Asynchronously downloads the object at the current path to a specified system filepath.
     * @param fileURL A file system URL representing the path the object should be downloaded to.
     * @param completion A completion block that fires when the file download completes.
     * Returns an NSURL pointing to the file path of the downloaded file on success,
     * or an error on failure.
     */
    public func write(toFile url: URL) -> Observable<URL> {
        return Observable.create { observer in
            let task = self.base.write(toFile: url) { url, error in
                guard let error = error else {
                    if let url = url {
                        observer.onNext(url)
                    }
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    /**
     * Retrieves metadata associated with an object at the current path.
     * @param completion A completion block which returns the object metadata on success,
     * or an error on failure.
     */
    public func getMetadata() -> Observable<StorageMetadata> {
        return Observable.create { observer in
            self.base.getMetadata { metadata, error in
                guard let error = error else {
                    if let metadata = metadata {
                        observer.onNext(metadata)
                    }
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    /**
     * Updates the metadata associated with an object at the current path.
     * @param metadata An FIRStorageMetadata object with the metadata to update.
     * @param completion A completion block which returns the FIRStorageMetadata on success,
     * or an error on failure.
     */
    public func updateMetadata(_ metadata: StorageMetadata) -> Observable<StorageMetadata> {
        return Observable.create { observer in
            self.base.updateMetadata(metadata) { metadata, error in
                guard let error = error else {
                    if let metadata = metadata {
                        observer.onNext(metadata)
                    }
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    /**
     * Deletes the object at the current path.
     * @param completion A completion block which returns nil on success, or an error on failure.
     */
    public func delete() -> Observable<Void> {
        return Observable.create { observer in
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
}
