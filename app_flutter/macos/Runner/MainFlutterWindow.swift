import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let visibleFrame = NSScreen.main?.visibleFrame ?? self.frame
    let targetWidth = max(visibleFrame.width, 1440)
    let targetHeight = max(visibleFrame.height, 900)
    let windowFrame = NSRect(
      x: visibleFrame.origin.x,
      y: visibleFrame.origin.y,
      width: targetWidth,
      height: targetHeight
    )
    self.contentViewController = flutterViewController
    self.minSize = NSSize(width: 1440, height: 900)
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
