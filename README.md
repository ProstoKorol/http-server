# HTTP Server

Incredibly fast http-server for your app backend. Request session & (middleware | filters) are coming.
Primarily designed for cooperative multitasking, but also has a fallback to [dispatch](https://github.com/tris-foundation/async-dispatch) if you can't use fibers for some reason.
Currently limited to us-ascii routes due to fastest router algorithm sufficient for most cases. Unicode router is coming.
Obviously, our work on server foundation (fibers, reflection, tls, etc.) took a lot of time, so http-server is very simple for now but already has some killer features and we have a lot coming. Stay tuned.

## Package.swift

```swift
.Package(url: "https://github.com/tris-foundation/http-server.git", majorVersion: 0)
```

## Memo

```swift
// route return types
return HTTPResponse(string: String)
return HTTPResponse(html: String)
return HTTPResponse(bytes: [UInt8])
return HTTPResponse(json: [UInt8])
return HTTPResponse(status: HTTPResponseStatus)

enum HTTPResponseStatus: String {
    case ok
    case notFound
    case badRequest
    case unauthorized
    case internalServerError
}

return String // - return HTTPResponse(string: String)

return Any | [String : Any] // - return HTTPResponse(json: serializeToJson(..))


// main routers
func route(method: HTTPRequestType, url: String, handler: (Void) -> Any)
func route(method: HTTPRequestType, url: String, handler: (HTTPRequest) -> Any)
func route<A>(method: HTTPRequestType, url: String, handler: (A) -> Any)
func route<A>(method: HTTPRequestType, url: String, handler: (HTTPRequest, A) -> Any)

// convenience routers
func route(get url: String, handler: (Void) -> Any)
func route(get url: String, handler: (HTTPRequest) -> Any)
func route<A>(get url: String, handler: (A) -> Any)
func route<A>(get url: String, handler: (HTTPRequest, A) -> Any)

func route(head url: String, handler: (Void) -> Any)
func route(head url: String, handler: (HTTPRequest) -> Any)
func route<A>(head url: String, handler: (A) -> Any)
func route<A>(head url: String, handler: (HTTPRequest, A) -> Any)

func route(post url: String, handler: (Void) -> Any)
func route(post url: String, handler: (HTTPRequest) -> Any)
func route<A>(post url: String, handler: (A) -> Any)
func route<A>(post url: String, handler: (HTTPRequest, A) -> Any)

func route(put url: String, handler: (Void) -> Any)
func route(put url: String, handler: (HTTPRequest) -> Any)
func route<A>(put url: String, handler: (A) -> Any)
func route<A>(put url: String, handler: (HTTPRequest, A) -> Any)

func route(delete url: String, handler: (Void) -> Any)
func route(delete url: String, handler: (HTTPRequest) -> Any)
func route<A>(delete url: String, handler: (A) -> Any)
func route<A>(delete url: String, handler: (HTTPRequest, A) -> Any)

func route(options url: String, handler: (Void) -> Any)
func route(options url: String, handler: (HTTPRequest) -> Any)
func route<A>(options url: String, handler: (A) -> Any)
func route<A>(options url: String, handler: (HTTPRequest, A) -> Any)
```

## Usage

You can find this code and more in [examples](https://github.com/tris-foundation/examples).

```swift
// 0. Create server

// AsyncDispatch - preemptive multitasking, spawns Dispatch task for each connection
// AsyncFiber - cooperative multitasking, runs new fiber for each connection

let server = try Server(host: "0.0.0.0", port: 8080, async: AsyncFiber())

// 1. Simple route

server.route(get: "/hello") {
    return "hey there!"
}

// 2. Map url param to primitive types

server.route(get: "/hello/:name") { (name: String) in
    return "hey \(name)!"
}

server.route(get: "/robot/:id") { (id: Int) in
    return "Hello. My name is Robo\(id). I'm here to.. BSOD"
}

// 3. Reflection

// 3.1. map url params to custom model

struct Page {
    let name: String
    let skip: Int
}

// you can also mix url and query params:
// example: /page/news?skip=2
server.route(get: "/page/:name") { (page: Page) in
    return "page \(page.name), skip \(page.skip)"
}

// 3.2. post data

struct TodoUpdate {
    let name: String
    let done: Bool
}

// post query example: name=commitChanges&done=true
server.route(post: "/todo") { (todo: TodoUpdate) in
    return "todo \(todo.name) state \(todo.done)"
}

// example: /todo/commitChanges
// post query: done=true
server.route(post: "/todo/:name") { (todo: TodoUpdate) in
    return "todo mix \(todo.name) state \(todo.done)"
}

// 3.3. serialize model into json

server.route(get: "/todo/as/json") {
    return TodoUpdate(name: "serialized", done: true)
}

// 4. Use request data & return json dictionary

server.route(get: "/request") { request in
    return [
        "url": request.url,
        "host": request.host,
        "user-agent": request.userAgent
    ]
}

// 5. Wildcard

server.route(get: "/*") { (request: HTTPRequest) in
    return "wildcard: \(request.url)"
}

try server.start()
```
