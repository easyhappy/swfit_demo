import Foundation

let plainData = ("1" as NSString).dataUsingEncoding(NSUTF8StringEncoding)
let base64String = plainData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(0))

println(base64String)

let s = "aHR0cDovL2VkZ2Uudi5pYXNrLmNvbS5zaW5hc3RvcmFnZS5jb20vMTM2NTUyOTYyLm1wNA=="
let d = "MTIz"
let decodedData = NSData(base64EncodedString: s, options: NSDataBase64DecodingOptions(0))
let decodedString = NSString(data: decodedData!, encoding: NSUTF8StringEncoding)!

println(decodedString)