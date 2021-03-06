//
//  Day04VC_2018.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 03/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day04VC_2018: AoCVC, AdventDay, InputLoadable {
    private enum GuardEventType {
        case shiftBegins(guardId: Int)
        case fallsAsleep
        case wakesUp
    }

    private struct GuardDate: Hashable {
        let yearMonthDay: String
        let minute: Int
    }

    private struct GuardEvent {
        let eventType: GuardEventType
        let date: GuardDate
    }

    private class GuardLog {
        var id: Int
        var events = [GuardEvent]()
        private var dictionary = [String: Set<Int>]() //yearMonthDay : sleepMinute

        init(id: Int) {
            self.id = id
        }

        func parse() {
            var asleepSinceMinute: Int?
            for event in self.events {
                switch event.eventType {
                case .fallsAsleep:
                    asleepSinceMinute = event.date.minute
                case .wakesUp:
                    let sleepStartMinute = asleepSinceMinute!
                    for minute in sleepStartMinute..<event.date.minute {
                        if self.dictionary[event.date.yearMonthDay] == nil {
                            self.dictionary[event.date.yearMonthDay] = Set<Int>()
                        }
                        self.dictionary[event.date.yearMonthDay]?.insert(minute)
                    }
                    asleepSinceMinute = nil
                case .shiftBegins: break
                }
            }
        }

        var totalAsleepMinutes: Int {
            return dictionary.reduce(0, {$0 + $1.value.count})
        }

        var mostFrequentSleepMinute: (bestMinute: Int, sleepCount: Int) {
            var sleeps = [Int](repeating: 0, count: 60)
            for yearMonthDay_minutes in self.dictionary {
                for minute in yearMonthDay_minutes.value {
                    sleeps[minute] += 1
                }
            }
            var bestSleep = -1
            var bestSleepIndex = -1
            for i in 0..<sleeps.count {
                if sleeps[i] > bestSleep {
                    bestSleep = sleeps[i]
                    bestSleepIndex = i
                }
            }
            return (bestSleepIndex, bestSleep)
        }

        
    }

    private class SpyLog {
        private var guardEvents = [GuardEvent]()
        private var currentGuardIdOnShift: Int! = nil
        private var currentGuardIdSleeping: Int! = nil
        private var dictionary = [Int: GuardLog]()

        func populate(from strings: [String]) {
            for string in strings {
                let dateEvent = string.split(separator: "]")
                let dateString = String(dateEvent[0]).replacingOccurrences(of: "[", with: "")
                let dateTime = dateString.split(separator: " ")
                let yearMonthDay = String(dateTime[0])
                let hoursMinutes = dateTime[1].split(separator: ":")
                let minute = Int(String(hoursMinutes[1]))!

                let guardDate = GuardDate(yearMonthDay: yearMonthDay, minute: minute)

                let eventString = String(dateEvent[1])
                let eventType: GuardEventType
                if eventString.contains("begins shift") {
                    let split = eventString.split(separator: "#")
                    let idSplit = String(split[1]).split(separator: " ")
                    let id = Int(String(idSplit[0]))!
                    eventType = .shiftBegins(guardId: id)
                } else if eventString.contains("asleep") {
                    eventType = .fallsAsleep
                } else {
                    eventType = .wakesUp
                }

                self.guardEvents.append(GuardEvent(eventType: eventType, date: guardDate))
            }

            self.guardEvents.sort { (eventA, eventB) -> Bool in
                if eventA.date.yearMonthDay == eventB.date.yearMonthDay {
                    return eventA.date.minute < eventB.date.minute
                }
                return eventA.date.yearMonthDay < eventB.date.yearMonthDay
            }

//            for guardEvent in self.guardEvents {
//                print("\(guardEvent.date.yearMonthDay) -- \(guardEvent.date.minute) -- \(guardEvent.eventType)")
//            }
        }

        func parse() {
            for event in self.guardEvents {
                switch event.eventType {
                case .shiftBegins(let guardId):
                    self.currentGuardIdOnShift = guardId
                case .fallsAsleep:
                    if self.dictionary[self.currentGuardIdOnShift] == nil {
                        self.dictionary[self.currentGuardIdOnShift] = GuardLog(id: self.currentGuardIdOnShift)
                    }
                    self.currentGuardIdSleeping = self.currentGuardIdOnShift
                    self.dictionary[self.currentGuardIdOnShift]!.events.append(event)
                case .wakesUp:
                    if self.dictionary[self.currentGuardIdSleeping] == nil {
                        self.dictionary[self.currentGuardIdSleeping] = GuardLog(id: self.currentGuardIdSleeping)
                    }
                    self.dictionary[self.currentGuardIdSleeping]!.events.append(event)
                    self.currentGuardIdSleeping = nil
                }
            }

            for guardLog in self.dictionary.values {
                guardLog.parse()
            }
        }

        func getMostSleepyGuard() -> Int {
            self.dictionary.values.sorted(by: {$0.totalAsleepMinutes > $1.totalAsleepMinutes}).first!.id
        }

        func getSleepMinutes(for guardId: Int) -> Int {
            return self.dictionary[guardId]?.totalAsleepMinutes ?? -1
        }

        func getBestSleepInfo(for guardId: Int) -> (bestMinute: Int, sleepCount: Int) {
            return self.dictionary[guardId]?.mostFrequentSleepMinute ?? (bestMinute: -1, sleepCount: -1)
        }

        func getMostSleptMinuteInfo() -> (guardId: Int, sleptMinute: Int) {
            var mostSleepingMinute = [Int: (Int, Int)]() // guardID : sleepInfo

            for guardLog in self.dictionary.values {
                mostSleepingMinute[guardLog.id] = guardLog.mostFrequentSleepMinute
            }

            var mostSleepingGuardId = -1
            var mostSleptMinuteCount = -1
            var mostSleptMinute = -1
            
            mostSleepingMinute.forEach { (guardId, sleepInfo) in
                if sleepInfo.1 > mostSleptMinuteCount {
                    mostSleptMinuteCount = sleepInfo.1
                    mostSleepingGuardId = guardId
                    mostSleptMinute = sleepInfo.0
                }
            }

            return (guardId: mostSleepingGuardId, sleptMinute: mostSleptMinute)
        }
    }

    private var spyLog = SpyLog()
    
    func loadInput() {
        self.spyLog.populate(from: "Day04Input_2018".loadAsTextStringArray())
        self.spyLog.parse()
    }
    
    func solveFirst() {
        let sleepyId = self.spyLog.getMostSleepyGuard()
        let bestSleepMinute = self.spyLog.getBestSleepInfo(for: sleepyId).bestMinute
        let solution = sleepyId * bestSleepMinute
        self.setSolution(challenge: 0, text: "\(solution)")
    }
    
    func solveSecond() {
        let sleepInfo = self.spyLog.getMostSleptMinuteInfo()
        let solution = sleepInfo.guardId * sleepInfo.sleptMinute
        self.setSolution(challenge: 1, text: "\(solution)")
    }
}
