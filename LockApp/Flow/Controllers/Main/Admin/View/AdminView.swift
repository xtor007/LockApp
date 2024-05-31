//
//  AdminView.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 18.05.2024.
//

import SwiftUI

struct AdminView: View {
    @StateObject var viewModel: AdminViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                refresher
                filters
                if viewModel.employersToShow.isEmpty {
                    Spacer()
                    Text(Texts.Logs.noData.rawValue)
                        .font(.system(size: 16))
                        .foregroundStyle(Color(.grayAccent))
                    Spacer()
                } else {
                    table
                }
            }
            addButton
        }
        .padding(.bottom, 1)
        .padding(.horizontal, 16)
        .standartBackground()
        .alertWrapper(alertItem: $viewModel.alert)
        .onAppear {
            viewModel.didAppear()
        }
    }
    
    @ViewBuilder
    var refresher: some View {
        HStack {
            Text("\(Texts.Main.average.rawValue) \(viewModel.average.toTwoDecimalPlaces())")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(.shadow))
            Spacer()
            UpdaterView(isLoading: $viewModel.isLoading) {
                viewModel.updateEmployers()
            }
        }
    }
    
    @ViewBuilder
    var filters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(0..<viewModel.filters.count, id: \.self) { index in
                    filter(viewModel.filters[index])
                }
            }
        }
    }
    
    @ViewBuilder
    func filter(_ filter: DepartmentFilter) -> some View {
        let isSelected = viewModel.filter == filter
        Button(action: {
            viewModel.filter = filter
        }, label: {
            Text(filter.text)
                .font(.system(size: 18, weight: isSelected ? .bold : .light))
                .foregroundStyle(Color(isSelected ? .background : .shadow))
                .frame(minWidth: 50)
                .padding(4)
                .padding(.horizontal, 4)
                .background {
                    if isSelected {
                        Capsule()
                            .fill(Color(.accent))
                    } else {
                        Capsule()
                            .stroke(lineWidth: 2)
                            .fill(Color(.accent))
                    }
                }
                .padding(.vertical, 4)
        })
    }
    
    @ViewBuilder
    var table: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Divider()
                ForEach(0..<viewModel.employersToShow.count, id: \.self) { index in
                    cell(viewModel.employersToShow[index])
                    Divider()
                }
            }
        }
    }
    
    @ViewBuilder
    func cell(_ employer: EmployerDBModel) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text((employer.employer.name ?? "") + " " + (employer.employer.surname ?? ""))
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color(.shadow))
                Text(employer.employer.department ?? "")
                    .font(.system(size: 14))
                    .foregroundStyle(Color(.grayAccent))
                Text("⏳" + employer.average.toTwoDecimalPlaces())
                    .font(.system(size: 14))
                    .foregroundStyle(Color(.grayAccent))
            }
            Spacer()
            .padding(.trailing, 4)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.openUser(average: employer.average, user: employer.employer)
        }
    }
    
    @ViewBuilder
    var addButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    viewModel.openAddNewEmployer()
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                        .foregroundStyle(Color(.accent))
                        .background {
                            Circle()
                                .fill(Color(.background))
                        }
                })
            }
        }
        .padding(.vertical, 20)
    }
}

#Preview {
    AdminView(viewModel: .init())
}
