import Cocoa

let numbers = [1,2,3]
let strings = ["A","B","C"]

let joinedArr = zip(numbers, strings)
let unzippedArr = joinedArr.map{ tuple ->String in
    return "\(tuple.0)\(tuple.1)"
}

dump(unzippedArr)
