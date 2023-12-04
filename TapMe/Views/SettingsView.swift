//
//  SettingsView.swift
//  TapMe
//
//  Created by Bojan Mijic on 4.12.23..
//



import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var isSoundOn: Bool = true
    @Published var isHapticsOn: Bool = true
    @Published var tapViewModel: TapViewModel

    init(tapViewModel: TapViewModel) {
        self.tapViewModel = tapViewModel
    }
}

struct SettingsView: View {
    @StateObject private var settingsViewModel: SettingsViewModel

    init(tapViewModel: TapViewModel) {
        _settingsViewModel = StateObject(wrappedValue: SettingsViewModel(tapViewModel: tapViewModel))
    }

    @State private var isDeleteConfirmationPresented: Bool = false
    @State private var firstInstallDate: Date?

    var body: some View {
        VStack {
            AppIconView()

            Text("\(Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "")")
                .font(.title)
                .fontWeight(.bold)

            Text("Created with a touch of AI magic")
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(.gray)

            Text("v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.gray)

            Spacer()

            Section {
                HStack {
                    Image(systemName: settingsViewModel.isSoundOn ? "speaker.wave.2.fill" : "speaker.slash.fill")
                        .foregroundColor(.primary)
                        .padding(.trailing, 5)
                    Toggle("Sound", isOn: $settingsViewModel.isSoundOn)
                }

                HStack {
                    Image(systemName: settingsViewModel.isHapticsOn ? "iphone.gen3.radiowaves.left.and.right" : "iphone.gen3.slash")
                        .foregroundColor(.primary)
                        .padding(.trailing, 5)
                    Toggle("Haptics", isOn: $settingsViewModel.isHapticsOn)
                }
            }
            .padding(7)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(14)

            // New section for additional information
            VStack(alignment: .leading, spacing: 6) {
                Section(header: Text("Additional Information")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top, 14.0)) {

                    // Row for First install date
                    HStack {
                        Image(systemName: "calendar.badge.checkmark")
                            .foregroundColor(.primary)
                            .padding(.trailing, 10)
                        Text("First install date")
                            .fontWeight(.regular)

                        Spacer()

                        Text("\(formattedFirstInstallDate())")
                            .fontWeight(.light)
                            .foregroundColor(Color.gray)

                    }
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 14)
                    .fill(Color(UIColor.systemGray6)))

                    // Row for Tap Count
                    HStack {
                        Image(systemName: "hand.tap.fill")
                            .foregroundColor(.primary)
                            .padding(.trailing, 10)
                        Text("Tap Count:")
                            .fontWeight(.regular)

                        Spacer()

                        Text("\(settingsViewModel.tapViewModel.tapCount)")
                            .fontWeight(.light)
                            .foregroundColor(Color.gray)
                    }
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 14)
                        .fill(Color(UIColor.systemGray6)))
                }

                Spacer()
            }

            Spacer()
            
                .onAppear {
                    settingsViewModel.objectWillChange.send()
                }


            Button(action: {
                isDeleteConfirmationPresented.toggle()
            }) {
                Label("Delete all data", systemImage: "exclamationmark.triangle.fill")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(14)
            }
            .padding()
            .alert(isPresented: $isDeleteConfirmationPresented) {
                Alert(
                    title: Text("Are you sure?"),
                    message: Text("This will permanently delete all saved app data, including tap scores, unlocked achievements, and premissions."),
                    primaryButton: .default(Text("Cancel")),
                    secondaryButton: .destructive(Text("Delete"), action: {
                        // Perform the deletion logic here
                        // Set tap count to 0 using the ViewModel
                        settingsViewModel.tapViewModel.resetTapCount()
                    })
                )
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .onAppear {
            // Load first install date from UserDefaults
            firstInstallDate = UserDefaults.standard.object(forKey: "firstInstallDate") as? Date

            // If the first install date is nil, set it to the current date
            if firstInstallDate == nil {
                firstInstallDate = Date()
                UserDefaults.standard.set(firstInstallDate, forKey: "firstInstallDate")
            }
        }
    }

    // Helper function to format the first install date
    private func formattedFirstInstallDate() -> String {
        guard let date = firstInstallDate else {
            return "Unknown"
        }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        return formatter.string(from: date)
    }
}

struct AppIconView: View {
    @State private var appIcon: UIImage? = {
        if let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
           let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? [String: Any],
           let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? [String],
           let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }()

    var body: some View {
        Image(uiImage: appIcon ?? UIImage(systemName: "questionmark")!)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .cornerRadius(20)
            .padding()
            .onAppear {
                appIcon = {
                    if let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
                       let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? [String: Any],
                       let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? [String],
                       let lastIcon = iconFiles.last {
                        return UIImage(named: lastIcon)
                    }
                    return nil
                }()
            }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(tapViewModel: TapViewModel())
    }
}
