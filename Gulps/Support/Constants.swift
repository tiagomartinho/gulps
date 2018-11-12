import Foundation

public enum Constants {
  public static func bundle() -> String {
    return "it.fancypixel.BigGulp"
  }

  public enum Gulp: Int {
    case small, goal
    public func key() -> String {
      switch self {
      case .small:
        return "GULP_SMALL"
      case .goal:
        return "PORTION_GOAL"
      }
    }
  }

  public enum Notification: Int {
    case on, from, to, interval
    public func key() -> String {
      switch self {
      case .on:
        return "NOTIFICATION_ON"
      case .from:
        return "NOTIFICATION_FROM"
      case .to:
        return "NOTIFICATION_TO"
      case .interval:
        return "NOTIFICATION_INTERVAL"
      }
    }
  }
}
