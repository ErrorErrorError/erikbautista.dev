@_spi(Core) @_spi(Renderer) import Cascadia
import Elementary

struct ScopedClass: Selector {
  let name: String
  let id: String

  init(_ name: String) {
    self.name = switch name.first {
      case ".": String(name.dropFirst())
      default: name
    }
    self.id = String(format: "%06x", UInt.random(in: 0...0xFFFFFF))
  }

  var body: some Selector {
    Class(name)
    Attribute("data-v-\(id)")
  }
}

extension Class {
  init(module name: String) {
    let id = String(format: "%06x", UInt.random(in: 0...0xFFFFFF))
    self.init("\(name)__\(id)")
  }
}

extension HTMLElement where Tag == HTMLTag.style, Content == HTMLRaw {
  init<S: StyleSheet>(_ stylesheet: S) {
    /// TODO: Render with async
    self.init {
      HTMLRaw(stylesheet.render())
    }
  }

  init<S: Rule>(@CSSBuilder _ body: () -> S) {
    self.init {
      HTMLRaw(stylesheet(content: body))
    }
  }
}

extension HTMLAttribute where Tag: HTMLTrait.Attributes.Global {
  static func `class`(_ value: Class) -> Self {
    HTMLAttribute(name: "class", value: value.name, mergedBy: .appending(separatedBy: " "))
  }

  static func `class`(_ value: ScopedClass) -> Self {
    HTMLAttribute(name: "class", value: value.name, mergedBy: .appending(separatedBy: " "))
  }
}

extension String: @retroactive Selector {
  public typealias Body = Never

  @_spi(Core)
  @inlinable @inline(__always)
  public var body: Never {
    neverBody(Self.self)
  }

  @_spi(Renderer)
  @inlinable @inline(__always)
  public static func _render<Writer: CSSStreamWriter>(
    _ value: consuming Self,
    into renderer: inout Renderer<Writer>
  ) {
    renderer.selector { selector in
      selector.write(contentsOf: value.utf8)
    }
  }
}