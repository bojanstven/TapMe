//
//  StoreView.swift
//  TapMe
//
//  Created by Bojan Mijic on 4.12.23..
//



import SwiftUI

struct StoreView: View {
    @StateObject private var tapViewModel: TapViewModel

    init(tapViewModel: TapViewModel) {
        _tapViewModel = StateObject(wrappedValue: tapViewModel)
    }

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "wand.and.stars")
                    .font(.system(size: 26))
                    .foregroundColor(.blue)
                Text("Store")
                    .font(.title)
                    .fontWeight(.bold)
            }
//            .padding()

            VStack {
                Text("Welcome to our store! Buy upgrades below.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)

                // Rounded bubble displaying the current tap count
                HStack {
                                    Text("\(tapViewModel.tapCount)")
                                        .font(.system(size: 38, weight: .bold))
                                        .foregroundColor(.white)
                                    Text("¢")
                                        .font(.system(size: 33, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 14)
                                .fill(Color.blue))
                                .padding(.bottom, 20)
                            }


            Button(action: {
                // Action for 2x Click Upgrade
            }) {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "2.circle.fill")
                        .font(.system(size: 33))
                        .foregroundColor(.primary)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Upgrade: 2x tap count")
                            .fontWeight(.bold)
                            .font(.headline)
                            .foregroundColor(.primary)

                        Text("Required 5.000 ¢")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(14)
            }

            Button(action: {
                // Action for 5x Click Upgrade
            }) {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "5.circle.fill")
                        .font(.system(size: 33))
                        .foregroundColor(.primary)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Upgrade: 5x tap count")
                            .fontWeight(.bold)
                            .font(.headline)
                            .foregroundColor(.primary)

                        Text("Required 10.000 ¢")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(14)
            }

            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemBackground))
//        .onAppear {
//            tapCount = UserDefaults.standard.integer(forKey: "totalTaps")
        }
    }


struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView(tapViewModel: TapViewModel())
    }
}
