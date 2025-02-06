import ActivityClient
import Cascadia
import Dependencies
import Elementary
import Foundation

public struct HomePage: Page {
  @Dependency(\.activityClient) private var activityClient

  public init() {}

  private static let copyrightDateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(languageCode: .english, languageRegion: .unitedStates)
    formatter.timeZone = TimeZone(abbreviation: "PST") ?? formatter.timeZone
    formatter.dateFormat = "yyyy"
    return formatter
  }()

  let styling = Style()

  public var content: some HTML {
    HTMLRaw("<!DOCTYPE html>")
    html(.lang("en"), .custom(name: "data-theme", value: "dark")) {
      head {
        title { "Erik Bautista Santibanez" }
        meta(.charset(.utf8))
        meta(name: .viewport, content: "width=device-width, initial-scale=1.0")
        link(.rel(.stylesheet), .href("https://cdnjs.cloudflare.com/ajax/libs/modern-normalize/3.0.1/modern-normalize.min.css"))
        style(self.styling)
        script(.src("https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"))
        script(.src("https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/languages/swift.min.js"))
        script { HTMLRaw("hljs.highlightAll();") }
        VueScript()
      }
      body {
        header(.class("hero"), .aria.label("About")) {
          hgroup {
            h1(.class("hero-title")) { "Erik Bautista Santibanez" }
            p(.class("hero-subtitle")) { "Swift & Web Developer" }

            let location = self.activityClient.location()
            let residency = location?.residency ?? .default

            p(.class("hero-location")) {
              span(.aria.label("Residency")) {
                svg(.xmlns(), .fill("currentColor"), .viewBox("0 0 256 256"), .class("svg-icon"), .aria.label("Map pin icon")) {
                  path(
                    .d("M128,16a88.1,88.1,0,0,0-88,88c0,75.3,80,132.17,83.41,134.55a8,8,0,0,0,9.18,0C136,236.17,216,179.3,216,104A88.1,88.1,0,0,0,128,16Zm0,56a32,32,0,1,1-32,32A32,32,0,0,1,128,72Z")
                  )
                }
                "\(residency)"
              }

              if let location, location.city != residency.city || location.state != residency.state {
                " \u{2022} "

                span(.aria.label("Location")) {
                  svg(.xmlns(), .fill("currentColor"), .viewBox("0 0 256 256"), .class("svg-icon reversed"), .aria.label("Navigation icon")) {
                    path(.d("M234.35,129,152,152,129,234.35a8,8,0,0,1-15.21.27l-65.28-176A8,8,0,0,1,58.63,48.46l176,65.28A8,8,0,0,1,234.35,129Z"))
                    path(.d("M237.33,106.21,61.41,41l-.16-.05A16,16,0,0,0,40.9,61.25a1,1,0,0,0,.05.16l65.26,175.92A15.77,15.77,0,0,0,121.28,248h.3a15.77,15.77,0,0,0,15-11.29l.06-.2,21.84-78,78-21.84.2-.06a16,16,0,0,0,.62-30.38ZM149.84,144.3a8,8,0,0,0-5.54,5.54L121.3,232l-.06-.17L56,56l175.82,65.22.16.06Z"))
                  }

                  "Currently in "

                  b {
                    [location.city, location.state, location.region == "United States" ? nil : location.region]
                      .compactMap(\.self)
                      .joined(separator: ", ")
                  }
                }
              }
            }
          }
        }
        main(.v.scope("{ selection: undefined }")) {
          header {
            hgroup {
              h2 { "Posts" }
              ul(.class("post-tabs")) {
                for kind in Post.Kind?.allCases {
                  let value = if let kind {
                    "'\(kind.rawValue)'"
                  } else {
                    "undefined"
                  }
                  li {
                    button(
                      .v.on(.click, "selection = \(value)"),
                      .v.bind("aria-selected", "selection == \(value)"),
                      .aria.selected(kind == nil)
                    ) {
                      kind?.tabTitle ?? "All"
                    }
                  }
                }
              }
            }
          }
          section {
            for post in Post.allCases {
              article(
                .class("post"),
                .v.show("!selection || selection == '\(post.kind.rawValue)'")
              ) {
                header { post.dateFormatted }
                h3(.class("post-title")) { post.title }
                div(.class("post-content")) { post.content }
              }
            }
          }
        }
        footer(.aria.label("Credits")) {
          hr()
          p { "©\(Self.copyrightDateFormatter.string(from: Date.now)) Erik Bautista Santibanez" }
          p {
            "Made with \u{2764} using "
            a(.target(.blank), .rel("noopener noreferrer"), .href("https://swift.org")) { "Swift" }
            " + "
            a(.target(.blank), .rel("noopener noreferrer"), .href("https://hummingbird.codes")) { "Hummingbird" }
            "."
          }
        }
      }
    }
  }
}

extension HomePage {
  struct Style: @unchecked Sendable, StyleSheet {
    var body: some Rule {
      // TODO: Add Work-Sans font?

      // Reset components
      ":root" => {
        AnyProperty("line-height", "1.5")
      }

      "h1, h2, h3, h4, h5, figure, p, ol, ul, pre" => {
        AnyProperty("margin", "0")
      }

      "ol[role=\"list\"], ul[role=\"list\"]" => {
        AnyProperty("list-style", "none")
        AnyProperty("padding-inline", "0")
      }

      Element(.img) => {
        AnyProperty("display", "block")
        AnyProperty("max-inline-size", "100%")
      }

      // General
      Pseudo(class: .root) => {
        BackgroundColor("#1c1c1c")
        Color("#fafafa")
        AnyProperty("font-optical-sizing", "auto")
        AnyProperty("font-style", "normal")
      }

      Element(.body) => {
        // AnyProperty("border-top", "1px solid #404040")
        // AnyProperty("border-bottom", "1px solid #404040")
        AnyProperty("margin-top", "2rem")
        AnyProperty("margin-bottom", "3rem")
      }

      Element(.body) > All() => {
        // AnyProperty("border-left", "1px solid #404040")
        // AnyProperty("border-right", "1px solid #404040")
        AnyProperty("max-width", "40rem")
        AnyProperty("margin-right", "auto")
        AnyProperty("margin-left", "auto")
        AnyProperty("padding-left", "1.5rem")
        AnyProperty("padding-right", "1.5rem")
      }

      Class("svg-icon") => {
        Display(.inlineBlock)
        AnyProperty("vertical-align", "middle")
        AnyProperty("position", "relative")
        AnyProperty("bottom", "0.125em")
        AnyProperty("width", "1em")
        AnyProperty("height", "1em")
        AnyProperty("margin-right", "0.25rem")
      }

      Class("reversed") => {
        AnyProperty("scale", "calc(100% * -1) 100%")
      }

      /// Hero header

      Class("hero") => {
        AnyProperty("padding-bottom", "1.5rem")
      }

      Class("hero") * Element(.p) => {
        Color(.hex("#D0D0D0"))
      }

      /// Post tabs

      Class("post-tabs") => {
        AnyProperty("list-style-type", "none")
        AnyProperty("margin", "0")
        AnyProperty("padding", "0")
        AnyProperty("overflow", "hidden")
      }

      Class("post-tabs") > Element(.li) => {
        AnyProperty("float", "left")
        AnyProperty("margin-right", "0.25rem")
      }

      Class("post-tabs") * Element(.button) => {
        BackgroundColor("#3c3c3c")
        AnyProperty("color", "white")
        AnyProperty("border-color", "#505050")
        AnyProperty("border-radius", "9999px")
        AnyProperty("border-style", "solid")
        AnyProperty("border-width", "1.25px")
        AnyProperty("padding", "0.25rem 0.75rem")
      }

      Class("post-tabs") * Element(.button) <> .attr("aria-selected", match: .exact, value: "true") => {
        AnyProperty("background-color", "#F0F0F0")
        AnyProperty("color", "#101010")
        AnyProperty("border-color", "#A0A0A0")
      }

      /// Posts

      Class("post") => {
        AnyProperty("margin-top", "0.75rem")
        AnyProperty("margin-bottom", "1.5rem")
        // AnyProperty("border-bottom", "1px dotted #404040")
      }

      Class("post") > Element(.header) => {
        Color(.gray)
        AnyProperty("font-size", "0.75em")
        AnyProperty("font-weight", "600")
      }

      Class("post-title") => {
        AnyProperty("margin-top", "0.5rem")
      }

      Class("post-content") * All() => {
        AnyProperty("margin", "revert")
      }

      /// Code blocks
      Class("post") * Element(.pre) => {
        AnyProperty("padding", "1rem")
        Background("#242424")
        AnyProperty("border-color", "#3A3A3A")
        AnyProperty("border-style", "solid")
        AnyProperty("border-width", "1.5px")
        AnyProperty("border-radius", "0.75rem")
        AnyProperty("overflow-x", "auto")
      }
    }
  }
}