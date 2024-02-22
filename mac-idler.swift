import Foundation
import CoreGraphics

var putToBed = false

// Define sleep schedule arguments
let sleepStartHourArgument = "-start"
let sleepEndHourArgument = "-end"

// Function to execute 'pmset displaysleepnow'
func putDisplayToSleep() {
  if !putToBed {
    let task = Process()
    task.launchPath = "/usr/bin/pmset"
    task.arguments = ["displaysleepnow"]
    task.launch()
    putToBed = true
  }
}

// Function to wake the display using 'caffeinate'
func wakeDisplay() {
  if putToBed {
    let task = Process()
    task.launchPath = "/usr/bin/caffeinate"
    task.arguments = ["-u", "-t", "1"]
    task.launch()
    putToBed = false
  }
}

// Main
if CommandLine.argc < 2 {
  print("Usage: DisplaySleepMonitor <idle time in seconds> \(sleepStartHourArgument) <start hour> \(sleepEndHourArgument) <end hour>")
  exit(1)
}

guard let thresholdSeconds = Double(CommandLine.arguments[1]) else {
  print("Invalid number format for idle time.")
  exit(1)
}

var sleepStartHour: Int? = nil
var sleepEndHour: Int? = nil

for (index, arg) in CommandLine.arguments.enumerated() {
    if (index > 1 && index + 1 < CommandLine.arguments.count) {
        let nextArg = CommandLine.arguments[index + 1]
        switch arg {
        case sleepStartHourArgument:
            if let hour = Int(nextArg) {
                sleepStartHour = hour
            } else {
                print("Invalid format for sleep start hour.")
                exit(1)
            }
        case sleepEndHourArgument:
            if let hour = Int(nextArg) {
                sleepEndHour = hour
            } else {
                print("Invalid format for sleep end hour.")
                exit(1)
            }
        default:
            break
        }
    }
}

// Timer to check the idle time every second
Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
  let idleTime = CGEventSource.secondsSinceLastEventType(.combinedSessionState, eventType: CGEventType(rawValue: UInt32.max)!)
  let currentHour = Calendar.current.component(.hour, from: Date())

  if let sleepStartHour = sleepStartHour, let sleepEndHour = sleepEndHour {
    // Handle schedules spanning midnight
    if sleepStartHour > sleepEndHour {
      if currentHour >= sleepStartHour || currentHour < sleepEndHour {
        // Within sleep schedule
        if !putToBed && idleTime >= thresholdSeconds {
          putDisplayToSleep()
        } else if putToBed && idleTime < thresholdSeconds {
          wakeDisplay()
        }
      } else {
        // Outside sleep schedule
        if putToBed {
          wakeDisplay()
        }
      }
    } else {
      // Regular case (sleep schedule within same day)
      if currentHour >= sleepStartHour && currentHour < sleepEndHour {
        // Within sleep schedule
        if !putToBed && idleTime >= thresholdSeconds {
          putDisplayToSleep()
        } else if putToBed && idleTime < thresholdSeconds {
          wakeDisplay()
        }
      } else {
        // Outside sleep schedule
        if putToBed {
          wakeDisplay()
        }
      }
    }
  } else {
    // Fallback behavior if no sleep schedule provided
   if idleTime >= thresholdSeconds && !putToBed {
      putDisplayToSleep()
    } else if idleTime < thresholdSeconds && putToBed {
      wakeDisplay()
    }
   }
}

// Run the main loop
RunLoop.current.run()
