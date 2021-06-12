//
//  SettingsView.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 12/06/2021.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Button(action: viewModel.showReconfigureAlert) {
                        Text("Skonfiguruj")
                    }
                    Toggle(isOn: $viewModel.nightModeEnabled) {
                        Text("Night mode")
                    }
                    
                    Toggle(isOn: $viewModel.notificationsEnabled) {
                        VStack(alignment: .leading) {
                            Text(viewModel.notificationsEnabled ? "Wybierz liczbę minut " : "Notyfikacje")
                            if viewModel.notificationsEnabled {
                                Slider(
                                    value: $viewModel.notificationsInterval,
                                    in: 15...120,
                                    minimumValueLabel: Text("15"), maximumValueLabel: Text("120"), label: { EmptyView()})
                            }
                        }
                    }

                    
                    NavigationLink(destination: EmptyView()) {
                        Text("Autorzy")
                    }
                }
                SafeAreaBlurView()
            }
            .navigationBarTitle("Settings")
            .actionSheet(item: $viewModel.actionSheet) { model in
                ActionSheet(
                    title: Text(model.title ?? ""),
                    message: Text(model.message ?? ""),
                    buttons: [
                        .destructive(Text("Import"), action: viewModel.reconfigure),
                        .default(Text("For teachers Import"), action: viewModel.reconfigureAsTeacher),
                        .cancel()
                    ])
            }
            .sheet(isPresented: $viewModel.showReconfigurationProcess) {
                EmptyView() // TODO
            }
            .sheet(isPresented: $viewModel.showReconfigurationProcessForTeachers) {
                EmptyView() // TODO
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel())
    }
}
