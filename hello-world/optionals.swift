var optionalString: String? = "Hello"
print(optionalString == nil)

var optionalName: String? = "John Appleseed"
print(optionalName)

var greeting = "Hello!"
if let name = optionalName {
    greeting = "Hello, \(name)"
}

let nickName: String? = nil
let fullName: String? = "John Appleseed"
let informalGreeting = "Hi \(nickName ?? fullName)"

print(informalGreeting)
