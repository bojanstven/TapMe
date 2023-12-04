//
//  AchievementsView.swift
//  TapMe
//
//  Created by Bojan Mijic on 4.12.23..
//



import SwiftUI

struct AchievementRow: View {
    let title: String
    let requirement: Int
    let currentTaps: Int
    var unlocked: Bool { currentTaps >= requirement }

    var formattedRequirement: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: requirement)) ?? "\(requirement)"
    }

    var body: some View {
        HStack(alignment: .center, spacing: 10.0) {
            Image(systemName: unlocked ? "medal.fill" : "medal")
                .font(.system(size: 33))
                .foregroundColor(unlocked ? .blue : Color(UIColor.systemGray2))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .fontWeight(.bold)
                    .font(.title2)
                    .foregroundColor(unlocked ? .primary : Color(UIColor.systemGray2))

                Text(unlocked ? "\(formattedRequirement) taps - Unlocked!" : "Required \(formattedRequirement) taps to unlock")
                    .font(.footnote)
                    .foregroundColor(unlocked ? .gray : Color(UIColor.systemGray2))
            }

            Spacer() // Add spacer to push the checkmark to the right

            Image(systemName: unlocked ? "checkmark.shield.fill" : "")
                .font(.system(size: 20))
                .foregroundColor(unlocked ? .green : Color.clear)
        }
        .padding()
        .cornerRadius(14)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}








import SwiftUI

struct AchievementsView: View {
    @StateObject private var tapViewModel: TapViewModel
    @State private var unlockedAchievementsCount: Int
    

    init(tapViewModel: TapViewModel) {
        _tapViewModel = StateObject(wrappedValue: tapViewModel)
        _unlockedAchievementsCount = State(initialValue: UserDefaults.standard.integer(forKey: "UnlockedAchievementsCount"))
    }

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Image(systemName: "medal.fill")
                        .font(.system(size: 26))
                        .foregroundColor(.blue)
                    Text("Achievements")
                        .font(.title)
                        .fontWeight(.bold)
                }

                Text("Here are all your achievements.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)

                AchievementRow(title: "Novice", requirement: 10, currentTaps: tapViewModel.tapCount)
                    .onChange(of: tapViewModel.tapCount) { newValue in
                        updateUnlockedAchievementsCount()
                    }
                AchievementRow(title: "Apprentice", requirement: 100, currentTaps: tapViewModel.tapCount)
                    .onChange(of: tapViewModel.tapCount) { newValue in
                        updateUnlockedAchievementsCount()
                    }
                AchievementRow(title: "Pro", requirement: 1000, currentTaps: tapViewModel.tapCount)
                    .onChange(of: tapViewModel.tapCount) { newValue in
                        updateUnlockedAchievementsCount()
                    }
                AchievementRow(title: "Veteran", requirement: 10000, currentTaps: tapViewModel.tapCount)
                    .onChange(of: tapViewModel.tapCount) { newValue in
                        updateUnlockedAchievementsCount()
                    }
                AchievementRow(title: "Legend", requirement: 20000, currentTaps: tapViewModel.tapCount)
                    .onChange(of: tapViewModel.tapCount) { newValue in
                        updateUnlockedAchievementsCount()
                    }
                AchievementRow(title: "Cheater", requirement: 50000, currentTaps: tapViewModel.tapCount)
                    .onChange(of: tapViewModel.tapCount) { newValue in
                        updateUnlockedAchievementsCount()
                    }
                AchievementRow(title: "God", requirement: 100000, currentTaps: tapViewModel.tapCount)
                    .onChange(of: tapViewModel.tapCount) { newValue in
                        updateUnlockedAchievementsCount()
                    }
            }
            .padding([.leading, .trailing], 12) // Add additional outer padding if needed
        }
        .navigationTitle("Achievements")
        .tabItem {
            Image(systemName: "star.fill")
            Text("Achievements")
        }
        .onDisappear {
            // Save the unlocked achievements count to UserDefaults when the view disappears
            UserDefaults.standard.set(unlockedAchievementsCount, forKey: "UnlockedAchievementsCount")
        }
        .badge(unlockedAchievementsCount > 0 ? Text("\(unlockedAchievementsCount)") : nil)
    }

    private func updateUnlockedAchievementsCount() {
        // Calculate the number of unlocked achievements and update the count
        unlockedAchievementsCount = [
            tapViewModel.tapCount >= 10,
            tapViewModel.tapCount >= 100,
            tapViewModel.tapCount >= 1000,
            tapViewModel.tapCount >= 10000,
            tapViewModel.tapCount >= 20000,
            tapViewModel.tapCount >= 50000,
            tapViewModel.tapCount >= 100000
        ].filter { $0 }.count
    }
}




struct AchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView(tapViewModel: TapViewModel())
    }
}
