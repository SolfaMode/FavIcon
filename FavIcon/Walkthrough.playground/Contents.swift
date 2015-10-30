//: # FavIcon
//: Welcome to the introduction for the FavIcon library. I hope you find it useful and easy to use.
//: I'll walk you through the various usage scenarios.
//:
//: *Important:* You'll need Internet access to get the most out of this playground.

//: First, you need to import `FavIcon` to pull in the library into the current file.
import FavIcon
//: We'll use `downloadPreferred(_:completion:)` first, which tries to download an icon
//: matching your desired with and height. Of course, if the website does not have many icons 
//: to choose from, you may not get the size you desire.
//: 
//: Since downloads happen asynchronously, you need to provide a closure that will get
//: called when the downloading is finished. This closure will be called from a global queue, so
//: if you want to do something like update your user interface, you'll need to send it to the main queue
//: via something like `dispatch_async()`, unless you like weird bugs 😎
try FavIcons.downloadPreferred("https://apple.com", width: 32, height: 32) { result in
//: The `result` parameter passed to the closure is a `DownloadResultType`.
//: This is a Swift enum type that will be `.Success` or `.Failure`.
    switch result {
    case .Success(let image):
//: In the case of success, the associated value is a `UIImage` on iOS (or a `NSImage` on OS X).
//: Expand the details for the icon variable in the result view on the right to see the downloaded icon 👍
        let icon = image
        break
    case .Failure(let error):
//: Hmm, this should not have executed. Do you have Internet connectivity? 🤔
        print("failed - \(error)")
        break
    }
}

//: If you want to download all detected icons (maybe you like collecting them), call `downloadAll(_:completion:)`.
try FavIcons.downloadAll("https://microsoft.com") { results in
    let numberOfIcons = results.count
    for (index, result) in results.enumerate() {
        switch result {
        case .Success(let image):
            let icon = image
            break
        case .Failure(let error):
            print("failed \(index) - \(error)")
            break
        }
    }
}

//: If you just want to know which icons are available, you can use the `scan(_:completion:)` method instead.
//: Note that the width and height of the icons are not always available.
FavIcons.scan(NSURL(string: "https://google.com")!) { icons in
    for icon in icons {
        let details = "icon: \(icon.url), type \(icon.type), width: \(icon.width), height: \(icon.height)"
        
//: If one is to your liking, you can download it using `download(_:completion:)`.
        FavIcons.download([icon]) { results in
            for result in results {
                switch result {
                case .Success(let image):
                    let icon = image
                    break
                default:
                    break
                }
            }
        }
    }
}


//: That's it. Good luck, have fun!









//: You don't actually need the next two lines when you're using this library, they're just here so that network requests get a chance
//: to execute when inside a playground.
import XCPlayground
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
