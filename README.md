# MeetUp — SwiftUI starter

## Requirements
- Xcode 15 or newer, iOS 17 or newer.
- SwiftUI app target.

## Setup
1. Create a new Xcode project: iOS > App, name `MeetUp`, Interface `SwiftUI`, Language `Swift`.
2. Remove the generated `ContentView.swift` and `MeetUpApp.swift` from the project (or replace their contents).
3. Drag the `MeetUp` folder's Swift files into the project in Xcode and choose **Copy items if needed** and **Add to target: MeetUp**. Ensure no duplicate @main App exists.
4. Build and run in an iOS 17+ simulator.

## Included
- Four tabs: Home, Events, Friends, Profile.
- Add, edit, delete events; categories, dates, places, descriptions.
- Add/remove local friend names and select them for events.
- Per-event preparation checklist with completion toggles.
- Local persistence using UserDefaults + Codable.

## Not included
- Accounts, real invitations, multi-user synchronization, voting, shared budgets, push notifications.
- This is a single-device educational starter, not a production backend.

## Suggested next steps
- Move storage to SwiftData.
- Add voting on proposed dates/places.
- Add expense models and calculations.
- Introduce backend authentication and synchronized groups.
- Write unit tests for event and expense logic.
