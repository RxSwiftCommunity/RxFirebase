import Foundation

guard CommandLine.arguments.count > 1 else {
  exit(1)
}
let version = CommandLine.arguments[1]

let basePath = "../"
let files = (try? FileManager.default.contentsOfDirectory(atPath: basePath)) ?? []
let specs = files.filter { $0.range(of: ".podspec") != nil }
for path in specs {
  print(path)
  let path = basePath + path
  guard var content = try? String(contentsOfFile: path) as NSString,
    let regex = try? NSRegularExpression(pattern: "s\\.version\\ +=\\ +'(.+)'", options: []) else {
      exit(1)
  }
  let result = regex.firstMatch(in: String(content), options: [], range: NSRange(location: 0, length: content.length))
  if let range = result.flatMap({
    $0.range(at: 1)
  }) {
    content = content.replacingCharacters(in: range, with: version) as NSString
    do {
      try String(content).write(toFile: path, atomically: false, encoding: .utf8)
    } catch {
      exit(1)
    }
  }
}

