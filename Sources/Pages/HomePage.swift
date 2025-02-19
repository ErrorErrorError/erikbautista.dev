import ActivityClient
import Cascadia
import Dependencies
import Elementary
import Foundation

public struct HomePage: Page {
  public init() {}

  private static let copyrightDateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(languageCode: .english, languageRegion: .unitedStates)
    formatter.timeZone = TimeZone(abbreviation: "PST") ?? formatter.timeZone
    formatter.dateFormat = "yyyy"
    return formatter
  }()

  let styling: HomePage.Style = Style()

  public var content: some HTML {
    HTMLRaw("<!DOCTYPE html>")
    html(.lang("en")) {
      head {
        title { "Erik Bautista Santibanez | Portfolio" }
        meta(.charset(.utf8))
        meta(name: .viewport, content: "width=device-width, initial-scale=1.0")
        link(.rel(.stylesheet), .href("https://cdnjs.cloudflare.com/ajax/libs/modern-normalize/3.0.1/modern-normalize.min.css"))
        style { HTMLRaw(".xml .hljs-meta{color:#6C7986}.hljs-comment,.hljs-quote{color:#6C7986}.hljs-tag,.hljs-attribute,.hljs-keyword,.hljs-selector-tag,.hljs-literal,.hljs-name{color:#FC5FA3}.hljs-variable,.hljs-template-variable{color:#FC5FA3}.hljs-code,.hljs-string,.hljs-meta-string{color:#FC6A5D}.hljs-regexp,.hljs-link{color:#5482FF}.hljs-title,.hljs-symbol,.hljs-bullet,.hljs-number{color:#41A1C0}.hljs-section,.hljs-meta{color:#FC5FA3}.hljs-class .hljs-title,.hljs-type,.hljs-built_in,.hljs-builtin-name,.hljs-params{color:#D0A8FF}.hljs-attr{color:#BF8555}.hljs-subst{color:#FFF}.hljs-formula{font-style:italic}.hljs-selector-id,.hljs-selector-class{color:#9b703f}.hljs-doctag,.hljs-strong{font-weight:bold}.hljs-emphasis{font-style:italic}") }
        style(self.styling)
        script(.src("https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"), .defer)
        script(.src("https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/languages/swift.min.js"), .defer)
        script(.type(.module)) { HTMLRaw("hljs.highlightAll();") }
      }
      body {
        div(.v.scope("{ showCode: true, selection: undefined }")) {
          // header(.class("wrapped")) {
          //   // TODO: Allow changing from swift-syntax based language to plain text, and other languages?
          //   div(.class("container spacer")) {}
          // }
          Spacer()
          main {
            UserHero()
            Spacer()
            // ExperienceSection()
            PostsSection()
          }
          Spacer()
          footer(.aria.label("Credits"), .class("wrapped")) {
            div(.id("end-footer"), .class("container")) {
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
          .inlineStyle("text-align", value: "center")
        }
        VueScript()
      }
    }
  }

  private struct Spacer: HTML {
    var content: some HTML {
      div(.class("wrapped")) { 
        div(.class("container spacer")) {}
      }
    }
  }

  private struct UserHero: HTML {
    @Dependency(\.activityClient) private var activityClient

    var content: some HTML {
      section(.id("user"), .class("wrapped"), .aria.label("About")) {
        div(.class("container")) {
          pre {
            a(.href("#user")) {
              code(.class("code-tag")) { "User.swift" }
            }
          }

          header(.class("code-header")) {
            pre {
              code(.data("highlighted", value: "yes"), .class("hljs language-swift")) {
                span(.class("hljs-comment")) { "/// User.swift\n" }
                span(.class("hljs-comment")) { "/// Portfolio\n" }
                span(.class("hljs-keyword")) { "struct" }
                " "
                span(.class("hljs-title class_")) { "User" }
                ": "
                span(.class("hljs-title class_")) { "Portfolio" }
                " {\n  "

                span(.class("hljs-keyword")) { "let" }
                " name = "
                span(.class("hljs-string")) {
                  "\""
                  span(.class("hero-title")) { "Erik Bautista Santibanez" }
                  "\""
                }
                ";\n  "

                span(.class("hljs-keyword")) { "let" }
                " role = "
                span(.class("hljs-string")) {
                  "\""
                  span(.class("hero-subtitle")) { "Mobile & Web Developer" }
                  "\""
                }
                ";\n  "

                span(.class("hljs-keyword")) { "let" }
                " home = "
                span(.class("hljs-string")) {
                  "\""
                  span(.class("hero__location")) { self.residency }
                  "\""
                }
                ";\n"
                self.location
                "}"
              }
            }
          }
        }
      }
    }

    @HTMLBuilder
    var residency: some HTML {
      let location = self.activityClient.location()
      let residency = location?.residency ?? .default

      svg(.xmlns(), .fill("currentColor"), .viewBox("0 0 256 256"), .class("svg-icon"), .aria.label("Map pin icon")) {
        path(
          .d("M128,16a88.1,88.1,0,0,0-88,88c0,75.3,80,132.17,83.41,134.55a8,8,0,0,0,9.18,0C136,236.17,216,179.3,216,104A88.1,88.1,0,0,0,128,16Zm0,56a32,32,0,1,1-32,32A32,32,0,0,1,128,72Z")
        )
      }
      " \(residency)"
    }

    @HTMLBuilder
    var location: some HTML {
      let location = self.activityClient.location()
      let residency = location?.residency ?? .default

      if let location, location.city != residency.city || location.state != residency.state {
        "  "
        span(.class("hljs-keyword")) { "let" }
        " location = "
        span(.class("hljs-string")) {
          "\""
          span(.class("hero__location"), .aria.label("Location")) {
            svg(.xmlns(), .fill("currentColor"), .viewBox("0 0 256 256"), .class("svg-icon reversed"), .aria.label("Navigation icon")) {
              path(.d("M234.35,129,152,152,129,234.35a8,8,0,0,1-15.21.27l-65.28-176A8,8,0,0,1,58.63,48.46l176,65.28A8,8,0,0,1,234.35,129Z"))
              path(.d("M237.33,106.21,61.41,41l-.16-.05A16,16,0,0,0,40.9,61.25a1,1,0,0,0,.05.16l65.26,175.92A15.77,15.77,0,0,0,121.28,248h.3a15.77,15.77,0,0,0,15-11.29l.06-.2,21.84-78,78-21.84.2-.06a16,16,0,0,0,.62-30.38ZM149.84,144.3a8,8,0,0,0-5.54,5.54L121.3,232l-.06-.17L56,56l175.82,65.22.16.06Z"))
            }

            " Currently in "

            b {
              [location.city, location.state, location.region == "United States" ? nil : location.region]
                .compactMap(\.self)
                .joined(separator: ", ")
            }
          }
          "\"\n"
        }
      } else {
        EmptyHTML()
      }
    }
  }

  private struct PostsSection: HTML {
    var content: some HTML {
      section(.id("dev-logs"), .class("wrapped")) {
        div(.class("container")) {
          pre {
            a(.href("#dev-logs")) {
              code(.class("code-tag")) { "DevLogs.swift" }
            }
          }

          header(.class("code-header")) {
            pre(.class("hljs language-swift")) {
              code {
                """
                /// DevLogs.swift
                /// Portfolio
                var logs: [DevLog] = await fetch(.all)
                """
              }
            }
            // ul(.class("posts__tab")) {
            //   for kind in Post.Kind?.allCases {
            //     let value = if let kind {
            //       "'\(kind.rawValue)'"
            //     } else {
            //       "undefined"
            //     }
            //     li {
            //       button(
            //         .class("posts__tab-item"),
            //         .v.on(.click, "selection = \(value)"),
            //         .v.bind("aria-selected", "selection == \(value)"),
            //         .aria.selected(kind == nil)
            //       ) {
            //         kind?.tabTitle ?? "All"
            //       }
            //     }
            //   }
            // }
          }

          for (idx, post) in Post.allCases.reversed().enumerated() {
            article(
              .class("post"),
              .id(post.slug),
              .v.show("!selection || selection == '\(post.kind.rawValue)'")
            ) {
              header {
                section {
                  span(.class("post__date")) { post.datePosted.uppercased() }
                    .inlineStyle("flex-grow", value: "1")

                  pre {
                    a(.href("#\(post.slug)")) {
                      code(.class("hljs language-swift")) {
                        "logs[\(idx)]"
                      }
                      .inlineStyle("font-size", value: "0.75em")
                      .inlineStyle("color", value: "#777")
                      .inlineStyle("font-weight", value: "500")
                    }
                  }
                }
                .inlineStyle("display", value: "flex")
                .inlineStyle("align-items", value: "baseline")

                if let postHeader = post.header {
                  section {
                    switch postHeader {
                    case let .link(link):
                      a(
                        .href(link),
                        .target(.blank),
                        .rel("noopener noreferrer"),
                        .class("post__header")
                      ) {
                        figure {
                          // TODO: add OpenGraph link
                        }
                      }
                    case let .image(asset, label):
                      img(.src(asset.url.assetString), .class("post__header"), .custom(name: "alt", value: label), .aria.label(label))
                    case let .video(asset):
                      video(
                        .class("post__header"),
                        .custom(name: "autoplay", value: ""),
                        .custom(name: "playsinline", value: ""),
                        .custom(name: "muted", value: ""),
                        .custom(name: "controls", value: ""),
                        .custom(name: "loop", value: "")
                      ) {
                        source(.src(asset.url.assetString), .custom(name: "type", value: asset.mime))
                        "Your browser does not support playing this video"
                      }
                    case let .code(rawCode, lang):
                      pre(.class("post__header")) {
                        code(.class("hljs language-\(lang.rawValue)")) {
                          HTMLRaw(rawCode)
                        }
                      }
                    }
                  }
                }
              }
              h3(.class("post__title")) { post.title }
              section(.class("post__content")) { post.content }

              if !post.links.isEmpty {
                section(.class("post__links")) {
                  for link in post.links {
                    a(
                      .href(link.href),
                      .target(.blank),
                      .rel("noopener noreferrer"),
                      .class("post__link-\(link.role.rawValue)")
                    ) {
                      HTMLText(link.title)
                      " "
                      if link.isExternal {
                        svg(.xmlns(), .fill("currentColor"), .viewBox("0 0 256 256"), .class("svg-icon"), .aria.label("external link icon")) {
                          path(
                            .d("M228,104a12,12,0,0,1-24,0V69l-59.51,59.51a12,12,0,0,1-17-17L187,52H152a12,12,0,0,1,0-24h64a12,12,0,0,1,12,12Zm-44,24a12,12,0,0,0-12,12v64H52V84h64a12,12,0,0,0,0-24H48A20,20,0,0,0,28,80V208a20,20,0,0,0,20,20H176a20,20,0,0,0,20-20V140A12,12,0,0,0,184,128Z")
                          )
                        }
                      } else {
                        svg(.xmlns(), .fill("currentColor"), .viewBox("0 0 256 256"), .class("svg-icon"), .aria.label("external link icon")) {
                          path(
                            .d("M224.49,136.49l-72,72a12,12,0,0,1-17-17L187,140H40a12,12,0,0,1,0-24H187L135.51,64.48a12,12,0,0,1,17-17l72,72A12,12,0,0,1,224.49,136.49Z")
                          )
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  private struct ExperienceSection: HTML {
    var content: some HTML {
      section(.id("experience"), .class("wrapped")) {
        div(.class("container")) {
          code(.class("code-tag")) { "Experience.swift" }

          header(.class("code-header")) {
            pre(.class("hljs language-swift")) {
              code {
                """
                /// Experience.swift
                /// Portfolio
                var experiences: [Post]
                """
              }
            }
          }
        }
      }
    }
  }
}

extension HomePage {
  struct Style: @unchecked Sendable, StyleSheet {
    var body: some Rule {
      self.resetStyles()
      self.generalStyles()
      self.heroStyles()
      self.postTabsStyles()
      self.postStyles()
    }

    // MARK: - Reset components

    @CSSBuilder func resetStyles() -> some Rule {
      Pseudo(class: .root) => {
        AnyProperty("line-height", "1.5")
      }

      "pre a" => {
        AnyProperty("text-decoration", "none")
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
    }

    @CSSBuilder func generalStyles() -> some Rule {
      // MARK: - General

      "@font-face" => {
        AnyProperty("font-family", "\"CommitMono\"")
        AnyProperty("src", "url(\"https://raw.githubusercontent.com/eigilnikolajsen/commit-mono/ecd81cdbd7f7eb2acaaa2f2f7e1a585676f9beff/src/fonts/fontlab/CommitMonoV143-VF.woff2\")")
        AnyProperty("font-style", "normal")
        AnyProperty("font-weight", "400")
        AnyProperty("font-display", "swap")
      }

      Pseudo(class: .root) => {
        BackgroundColor("#1c1c1c")
        Color("#fafafa")
        AnyProperty("font-optical-sizing", "auto")
        AnyProperty("font-style", "normal")
        AnyProperty("font-size", "0.9em")
      }

      Class("wrapped") => {
        AnyProperty("border-top", "1px solid #303030")
      }

      Class("container") => {
        AnyProperty("max-width", "40rem")
        AnyProperty("margin-right", "auto")
        AnyProperty("margin-left", "auto")
        AnyProperty("border-left", "1px solid #303030")
        AnyProperty("border-right", "1px solid #303030")
      }

      Class("code-tag") => {
        AnyProperty("display", "block")
        Color("#777")
        AnyProperty("text-align", "end")
        AnyProperty("font-size", "0.75em")
        AnyProperty("font-weight", "500")
        AnyProperty("font-family", "\"CommitMono\", monospace")

        AnyProperty("padding-top", "1.5rem")
        AnyProperty("padding-left", "1.5rem")
        AnyProperty("padding-right", "1.5rem")
        AnyProperty("padding-bottom", "0.75rem")
      }

      Class("code-header") => {
        AnyProperty("padding-left", "1.5rem")
        AnyProperty("padding-right", "1.5rem")
        AnyProperty("padding-bottom", "1.5rem")
      }

      Class("svg-icon") => {
        Display(.inlineBlock)
        AnyProperty("vertical-align", "middle")
        AnyProperty("position", "relative")
        AnyProperty("bottom", "0.125em")
        AnyProperty("width", "1em")
        AnyProperty("height", "1em")
      }

      Class("reversed") => {
        AnyProperty("scale", "calc(100% * -1) 100%")
      }

      "code" => {
        AnyProperty("font-family", "\"CommitMono\", monospace")
        AnyProperty("font-feature-settings", "\"ss03\", \"ss04\", \"ss05\"")
        AnyProperty("line-height", "1")
      }

      ID("end-footer") => {
        AnyProperty("padding-top", "1rem")
        AnyProperty("padding-left", "1.5rem")
        AnyProperty("padding-right", "1.5rem")
        AnyProperty("padding-bottom", "1rem")
      }

      Class("spacer") => {
        AnyProperty("height", "0.85rem")
        AnyProperty("background", "repeating-linear-gradient(45deg, transparent 0% 35%, #333 35% 50%, transparent 50% 85%, #333 85% 100%)")
        AnyProperty("background-size", "5px 5px")
      }
    }

    @CSSBuilder func heroStyles() -> some Rule {
      Class("hero__location") => {
        Color(.hex("#D0D0D0"))
      }
    }

    @CSSBuilder func postTabsStyles() -> some Rule {
      Class("posts__tab") => {
        AnyProperty("list-style-type", "none")
        AnyProperty("margin", "0")
        AnyProperty("padding", "0")
        AnyProperty("overflow", "hidden")
      }

      Class("posts__tab") > Element(.li) => {
        AnyProperty("float", "left")
        AnyProperty("margin-right", "0.25rem")
      }

      Class("posts__tab-item") => {
        BackgroundColor("#3c3c3c")
        AnyProperty("color", "white")
        AnyProperty("border-color", "#505050")
        AnyProperty("border-radius", "9999px")
        AnyProperty("border-style", "solid")
        AnyProperty("border-width", "1.25px")
        AnyProperty("padding", "0.25rem 0.75rem")
      }

      Class("posts__tab-item") <> .attr("aria-selected", match: .exact, value: "true") => {
        AnyProperty("background-color", "#F0F0F0")
        AnyProperty("color", "#101010")
        AnyProperty("border-color", "#A0A0A0")
      }
    }

    @CSSBuilder func postStyles() -> some Rule {
      // MARK: - Post

      Class("post") => {
        AnyProperty("width", "100%")
        AnyProperty("display", "inline-block")
        AnyProperty("padding", "1.5rem")
        AnyProperty("background-image", "repeating-linear-gradient(90deg,#444 0 15px,transparent 0 30px)")
        AnyProperty("background-repeat", "repeat-x")
        AnyProperty("background-size", "100% 1px")
      }

      Class("post__date") => {
        Color("#9A9A9A")
        AnyProperty("font-size", "0.75em")
        AnyProperty("font-weight", "600")
      }

      Class("post__title") => {
        AnyProperty("margin-top", "0.5rem")
      }

      Class("post__content") * All() => {
        AnyProperty("margin", "revert")
      }

      Class("post__content") * Element(.blockquote) => {
        // AnyProperty("all", "unset")
        AnyProperty("display", "block")
        AnyProperty("background", "#2A2A2A")
        AnyProperty("border", "1.5px solid #4A4A4A")
        AnyProperty("padding", "0.125rem 1rem")
        AnyProperty("margin-right", "0")
        AnyProperty("margin-left", "0")
        AnyProperty("border-radius", "0.5rem")
      }

      Class("post__header") => {
        AnyProperty("width", "100%")
        AnyProperty("margin-top", "1.25rem")
        AnyProperty("margin-bottom", "1.25rem")
        AnyProperty("border-color", "#3A3A3A")
        AnyProperty("border-style", "solid")
        AnyProperty("border-width", "1.5px")
        AnyProperty("border-radius", "0.85rem")
      }

      Class("post__links") => {
        AnyProperty("display", "flex")
        AnyProperty("gap", "0.75rem")
        AnyProperty("margin-top", "1.5rem")
      }

      ".post__link-primary, .post__link-secondary, .post__link-tertiary" => {
        AnyProperty("all", "unset")
        AnyProperty("font-size", "0.85em")
        AnyProperty("font-weight", "550")
        AnyProperty("align-content", "center")
        AnyProperty("min-height", "1.5rem")
        AnyProperty("min-width", "2rem")
        AnyProperty("padding", "0.375rem 0.75rem")
        AnyProperty("cursor", "pointer")
        AnyProperty("border-radius", "0.5rem")
      }

      Class("post__link-primary") => {
        Color(.white)
        AnyProperty("background", "linear-gradient(to bottom, hsla(0, 0%, 24%, 1), hsla(0, 0%, 16%, 1))")
        AnyProperty("box-shadow", "inset 0 1px 1px rgba(255, 255, 255, 0.12)")
      }

      Class("post__link-secondary") => {
        Color(.black)
        AnyProperty("box-shadow", "inset 0px -1px 2px 0px hsl(0 0% 50% / 0.5)")
        AnyProperty("background", "linear-gradient(to bottom, hsl(0deg 0% 100%), hsl(0deg 0% 92.91%))")
      }

      Class("post__link-tertiary") => {
        Color(.white)
        AnyProperty("background", "hsla(0, 0%, 50%, 0.25)")
      }

      ".post__content pre, .post__header pre" => {
        AnyProperty("padding", "0.75rem")
        Background("#242424")
        AnyProperty("border-color", "#3A3A3A")
        AnyProperty("border-style", "solid")
        AnyProperty("border-width", "1.5px")
        AnyProperty("border-radius", "0.5rem")
        AnyProperty("overflow-x", "auto")
        AnyProperty("font-size", "0.85em")
      }
    }
  }
}
