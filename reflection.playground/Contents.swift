import UIKit





func stringRepresentation(of object: Any, indentationLevel: Int = 1) -> String {
  let reflection = Mirror(reflecting: object)
  let type = reflection.subjectType

  guard let style = reflection.displayStyle else {
    return String(reflecting: object)
  }

  if style == .enum {
    return String("\(object)")
  }

  var result = ""
  let indentation = String(repeating: "\t", count: indentationLevel)

  result.append("<\(type)>")

  if !reflection.children.isEmpty {
    result.append(": \n")
  }

  var childs = [String]()
  for child in reflection.children {
    let childRepresentation = stringRepresentation(of: child.value, indentationLevel: indentationLevel + 1)
    var childResult = indentation

    if let propertyName = child.label {
      let representation = "\(propertyName): \(childRepresentation)"
      childResult.append(representation)
    } else if let dictionary = child.value as? (Any, Any) {
      let key = String(reflecting: dictionary.0)
      let value = stringRepresentation(of: dictionary.1, indentationLevel: indentationLevel + 1)
      let representation = "\(key): \(value)"
      childResult.append(representation)
    } else {
      childResult.append("\(childRepresentation)")
    }

    childs.append(childResult)
  }

  result.append(childs.sorted().joined(separator: "\n"))

  return result
}


do {
  class CustomClass {
    var name: String = ""
  }

  class CustomClas2 {
    var name: String = ""
    var age: Int? = nil
  }

  class CustomClass3 {
    var innerClass: CustomClass = CustomClass()
    var innerClass2: CustomClass? = nil
    var direction = Direction.north
    var action: (String, Int?) -> Void = { _, _ in }
  }

  enum Direction {
    case north
    case west
  }

  let c1 = CustomClass()
  c1.name = "Max"

  let c2 = CustomClas2()
  c2.name = "Kate"
  c2.age = 26

  let c2_2 = CustomClas2()
  c2_2.name = "John"

  let c3 = CustomClass3()
  c3.innerClass = c1

  let string = "CustomString"
  let int = 42
  let double = 42.0
  let _enum = Direction.west
  let dictionary: [String: Any] = [
    "name": "Max",
    "custom_object": c3
  ]
  let array: [Any] = [
    _enum,
    string,
    int,
    double,
    dictionary
  ]

  print(stringRepresentation(of: array))
}
