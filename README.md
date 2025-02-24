### **TryCarAssessment**

## Overview

TryCarAssessment is an iOS application that demonstrates efficient handling of network requests, data persistence, and offline support using modern Swift best practices. The app interacts with a RESTful API, caches data for offline access, and ensures smooth synchronization.

## Features

- **Custom Network Layer**
  - Built using `URLSession` and `Swift Concurrency`
  - Supports RESTful API requests with structured endpoints
  - Handles JSON parsing and API response validation
  - Implements robust error handling
  - Monitors network connectivity for optimal performance

- **Data Persistence with CoreData**
  - Caches API responses for offline access
  - Manages user favorites locally
  - Stores unsynchronized operations for background syncing

- **Synchronization Mechanism**
  - Ensures pending operations are retried when online
  - Background sync runs periodically to keep data up to date

## Architecture

The project follows a **modular architecture**, with clear separation of concerns:

1. **Network Layer**
   - `NetworkManager.swift` handles API requests
   - `APIService.swift` abstracts API operations
   - `Endpoints.swift` defines API routes and query parameters

2. **Persistence Layer**
   - `CoreDataStack.swift` sets up the CoreData storage
   - `PersistenceManager.swift` handles saving and fetching data

3. **Sync Layer**
   - `SyncManager.swift` manages pending sync operations
   - Background synchronization ensures data consistency

## Dependencies

- **Swift Concurrency** (`async/await`) for network calls
- **CoreData** for efficient offline storage
- **Combine** as the native alternative to RxSwift for reactive programming

## Technologies Used

- **Swift 6**
- **Xcode 16.2**
- **Combine Framework** (for declarative and reactive programming)

## Benefits of Using Combine

- Provides a native and seamless reactive programming approach for Swift
- Reduces boilerplate code compared to RxSwift
- Works efficiently with Swift Concurrency and async/await
- Offers powerful operators for handling asynchronous data streams
- Fully integrated into Apple’s ecosystem, making it future-proof

## Acknowledgments

- [JSONPlaceholder](https://jsonplaceholder.typicode.com/) for API testing
- Apple’s official [CoreData documentation](https://developer.apple.com/documentation/coredata)
- Swift Concurrency guidelines for modern async/await patterns
