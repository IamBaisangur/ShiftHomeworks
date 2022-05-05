import Foundation

class ThreadSafeArray <T : Equatable> {
    
    private var safeArray = [T]()
    let queue = DispatchQueue(label: "queue", attributes: .concurrent)
    
    public var valueArray: [T] {
        var result = [T]()
        queue.sync {
            result = self.safeArray
        }
        return result
    }

    public var isEmpty: Bool {
        if self.valueArray.isEmpty {
            return true
        }
        return false
    }
    
    public var count: Int {
        return self.valueArray.count
    }
    
    public func append(_ item: T) {
        queue.async(flags: .barrier) {
            self.safeArray.append(item)
        }
    }
    
    public func remove(at index: Int) {
        queue.async(flags: .barrier) {
            self.safeArray.remove(at: index)
        }
    }

    public func `subscript`(index: Int) -> T {
            return self.valueArray[index]
    }
    
    public func contains(_ element: T) -> Bool {
        if self.valueArray.firstIndex(of: element) != nil {
            return true
        }
        return false
    }

    init(safeArray: [T]){
        self.safeArray = safeArray
    }
}

var array = ThreadSafeArray<Int>(safeArray: [])
let semaphore = DispatchSemaphore(value: 1)
let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)

public func appendInArray() {
    for number in 0...1000 {
        semaphore.wait()
        array.append(number)
        semaphore.signal()
    }
}

concurrentQueue.sync {
    array.queue.async {
        appendInArray()
    }
    array.queue.async {
        appendInArray()
    }
    sleep(2)
}

print(array.count)


// свойство "isEmpty: Bool"
//
//print(array.isEmpty)
//
//
// метод "contains(_ element: T) -> Bool"
//
//print(array.contains(123))
//print(array.contains(123434))
//
//
//
//
//
// метод "subscript(index: Int) ->"
//
//print(array.valueArray)
//print(array.subscript(index: 2000))
//
//
//
//
//
// метод "remove(at index: Int)"
//
//public func removeCheck() {
//        semaphore.wait()
//        array.remove(at: 2001)
//        semaphore.signal()
//}
//removeCheck()
//print(array.count)
//print(array.valueArray)
