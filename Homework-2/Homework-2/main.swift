import Foundation

var array = ThreadSafeArray<Int>(safeArray: [])
let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
let groupTests = DispatchGroup()

func appendInArray() {
    for number in 0...1000 {
        array.append(number)
    }
}

func tests() {
    groupTests.enter()
    concurrentQueue.async {
        appendInArray()
        groupTests.leave()
    }
    
    groupTests.enter()
    concurrentQueue.async {
        appendInArray()
        groupTests.leave()
    }
    
    groupTests.wait()
}

tests()

print(array.count)
