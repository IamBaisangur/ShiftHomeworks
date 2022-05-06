import Foundation

class ThreadSafeArray <T : Equatable> {
    
    private var safeArray = [T]()
    private let queue = DispatchQueue(label: "queue", attributes: .concurrent)
    
    private var valueArray: [T] {
        queue.sync {
            self.safeArray
        }
    }

    public var isEmpty: Bool {
        self.valueArray.isEmpty
    }
    
    public var count: Int {
        self.valueArray.count
    }
    
    public func append(_ item: T) {
        queue.async(flags: .barrier) {
            self.safeArray.append(item)
        }
    }
    
    public func remove(at index: Int) {
        self.safeArray.remove(at: index)
    }

    public func `subscript`(index: Int) -> T {
        self.valueArray[index]
    }
    
    public func contains(_ element: T) -> Bool {
        self.valueArray.contains(element)
    }

    init(safeArray: [T]){
        self.safeArray = safeArray
    }
}
