# RxFirebase

[![CI Status](http://img.shields.io/travis/arnauddorgans/RxFirebase.svg?style=flat)](https://travis-ci.org/arnauddorgans/RxFirebase)
[![Version](https://img.shields.io/cocoapods/v/RxFirebase.svg?style=flat)](http://cocoapods.org/pods/RxFirebase)
[![License](https://img.shields.io/cocoapods/l/RxFirebase.svg?style=flat)](http://cocoapods.org/pods/RxFirebase)
[![Platform](https://img.shields.io/cocoapods/p/RxFirebase.svg?style=flat)](http://cocoapods.org/pods/RxFirebase)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

RxFirebase is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RxFirebase/Firestore'
pod 'RxFirebase/RemoteConfig'
```

## Usage

```swift
import RxFirebase
```

### Firestore

Setting data:
```swift
let db = Firestore.firestore()

// Add a new document in collection "cities"
db.collection("cities")
    .document("SF")
    .rx
    .setData([
        "name": "San Francisco",
        "state": "CA",
        "country": "USA",
        "capital": false,
        "population": 860000
        ]).subscribe(onError: { error in
            print("Error setting data: \(error)")
        }).disposed(by: disposeBag)
       
// Add a new document with a generated id.
db.collection("cities")
    .rx
    .addDocument(data: [
        "name": "San Francisco",
        "state": "CA",
        "country": "USA",
        "capital": false,
        "population": 860000
        ]).subscribe(onNext: { ref in
            print("Document added with ID: \(ref.documentID)")
        }, onError: { error in
            print("Error adding document: \(error)")
        }).disposed(by: disposeBag)
        
// Set the "capital" field of the city 'SF'
db.collection("cities")
    .document("SF")
    .rx
    .updateData([
        "capital": true
        ]).subscribe(onNext: {
            print("Document successfully updated")
        }, onError: { error in
            print("Error updating document: \(error)")
        }).disposed(by: disposeBag)
        
// https://firebase.google.com/docs/firestore/manage-data/add-data
```

Get a document:
```swift
let db = Firestore.firestore()

db.collection("cities")
    .document("SF")
    .rx
    .getDocument()
    .subscribe(onNext: { document in
        if let document = document {
            print("Document data: \(document.data())")
        } else {
            print("Document does not exist")
        }
    }, onError: { error in
        print("Error fetching snapshots: \(error)")
    }).disposed(by: disposeBag)
    
// https://firebase.google.com/docs/firestore/query-data/get-data
```

Get Realtime Updates:
```swift
let db = Firestore.firestore()

// Document
db.collection("cities")
    .document("SF")
    .rx
    .listen()
    .subscribe(onNext: { document in
        print("Current data: \(document.data())")
    }, onError: { error in
        print("Error fetching snapshots: \(error)")
    }).disposed(by: disposeBag)
    
// Collection
db.collection("cities")
    .rx
    .listen()
    .subscribe(onNext: { snapshot in
        snapshot.documentChanges.forEach { diff in
            if (diff.type == .added) {
                print("New city: \(diff.document.data())")
            }
            if (diff.type == .modified) {
                print("Modified city: \(diff.document.data())")
            }
            if (diff.type == .removed) {
                print("Removed city: \(diff.document.data())")
            }
        }
    }, onError: { error in
        print("Error fetching snapshots: \(error)")
    }).disposed(by: disposeBag)

// https://firebase.google.com/docs/firestore/query-data/listen
```

Batched writes:
```swift
let db = Firestore.firestore()

// Get new write batch
let batch = db.batch()

// Update the population of 'SF'
let sfRef = db.collection("cities").document("SF")
batch.updateData(["population": 1000000 ], forDocument: sfRef)

// Commit the batch
batch.rx
    .commit()
    .subscribe(onNext: {
        print("Batch write succeeded.")
    }, onError: { error in
        print("Error writing batch \(error)")
    }).disposed(by: disposeBag)
    
// https://firebase.google.com/docs/firestore/manage-data/transactions
```

Transactions:
```swift
let db = Firestore.firestore()
let sfReference = db.collection("cities").document("SF")

db.rx.runTransaction { transaction, errorPointer in
    let sfDocument: DocumentSnapshot
    do {
        try sfDocument = transaction.getDocument(sfReference)
    } catch let fetchError as NSError {
        errorPointer?.pointee = fetchError
        return nil
    }
    
    guard let oldPopulation = sfDocument.data()?["population"] as? Int else {
        let error = NSError(
            domain: "AppErrorDomain",
            code: -1,
            userInfo: [
                NSLocalizedDescriptionKey: "Unable to retrieve population from snapshot \(sfDocument)"
            ]
        )
        errorPointer?.pointee = error
        return nil
    }
    
    transaction.updateData(["population": oldPopulation + 1], forDocument: sfReference)
    return nil
    }.subscribe(onNext: { _ in
        print("Transaction successfully committed!")
    }, onError: { error in
        print("Transaction failed: \(error)")
    }).disposed(by: disposeBag)
    
    // https://firebase.google.com/docs/firestore/manage-data/transactions
```

### RemoteConfig

Fetch:
```swift
// TimeInterval is set to expirationDuration here, indicating the next fetch request will use
// data fetched from the Remote Config service, rather than cached parameter values, if cached
// parameter values are more than expirationDuration seconds old. See Best Practices in the
// README for more information.
RemoteConfig.remoteConfig()
    .rx
    .fetch(withExpirationDuration: TimeInterval(expirationDuration), activateFetched: true)
    .subscribe(onNext: { status in
        print("Config fetched! with success:\(status == .success)")
    }, onError: { error in
        print("Error: \(error)")
    }).disposed(by: disposeBag)

    // https://firebase.google.com/docs/remote-config/ios
```

## Author

Arnaud Dorgans, arnaud.dorgans@gmail.com

## License

RxFirebase is available under the MIT license. See the LICENSE file for more info.
