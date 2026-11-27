import CoreGraphics
import Foundation
let pids=Set(CommandLine.arguments.dropFirst().compactMap(Int.init))
let all=CGWindowListCopyWindowInfo([.optionOnScreenOnly,.excludeDesktopElements], kCGNullWindowID) as? [[String:Any]] ?? []
for row in all {
 if let pid=row[kCGWindowOwnerPID as String] as? Int,pids.contains(pid),row[kCGWindowLayer as String] as? Int == 0 {print(pid,row[kCGWindowNumber as String]!,row[kCGWindowBounds as String]!)}
}
