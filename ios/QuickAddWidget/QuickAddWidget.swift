import SwiftUI
import WidgetKit

/// Home screen widget that adds the user's default drink with one tap.
///
/// The iOS counterpart of `QuickAddWidgetProvider` on Android: the widget is a
/// static "+1" tile whose tap opens the app through the `remembeer://quick-add`
/// URL. `AppDelegate` turns that URL into a `quickAddPressed` call on the
/// `quick_add_action` method channel, which Dart handles in `main.dart`.
struct QuickAddEntry: TimelineEntry {
  let date: Date
}

struct QuickAddProvider: TimelineProvider {
  func placeholder(in context: Context) -> QuickAddEntry {
    QuickAddEntry(date: Date())
  }

  func getSnapshot(in context: Context, completion: @escaping (QuickAddEntry) -> Void) {
    completion(QuickAddEntry(date: Date()))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<QuickAddEntry>) -> Void) {
    // The widget never changes, so a single entry that is never refreshed is enough.
    completion(Timeline(entries: [QuickAddEntry(date: Date())], policy: .never))
  }
}

struct QuickAddWidgetView: View {
  /// Opened by the containing app when the widget is tapped; see `AppDelegate`.
  private static let quickAddURL = URL(string: "remembeer://quick-add")!

  var body: some View {
    Text("+1")
      .font(.system(size: 44, weight: .bold, design: .rounded))
      .foregroundColor(Color("QuickAddText"))
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .accessibilityLabel("Plus one - Add default drink")
      .widgetURL(QuickAddWidgetView.quickAddURL)
      .quickAddWidgetBackground(Color("WidgetBackground"))
  }
}

extension View {
  /// iOS 17 requires `containerBackground` for widgets; older versions use a plain background.
  @ViewBuilder
  func quickAddWidgetBackground(_ color: Color) -> some View {
    if #available(iOS 17.0, *) {
      containerBackground(for: .widget) { color }
    } else {
      background(color)
    }
  }
}

struct QuickAddWidget: Widget {
  static let kind = "QuickAddWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: QuickAddWidget.kind, provider: QuickAddProvider()) { _ in
      QuickAddWidgetView()
    }
    .configurationDisplayName("Quick Add")
    .description("Add your default drink with one tap.")
    .supportedFamilies([.systemSmall])
  }
}

@main
struct QuickAddWidgetBundle: WidgetBundle {
  var body: some Widget {
    QuickAddWidget()
  }
}
