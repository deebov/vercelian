import SwiftUI

struct ProjectSelectorView: View {
    @ObservedObject var store = DeploymentStore.shared
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(spacing: GeistSpacing.sm) {
            // Team picker
            if !store.teams.isEmpty {
                Menu {
                    Button("Personal Account") {
                        store.selectTeam(nil)
                    }

                    Divider()

                    ForEach(store.teams) { team in
                        Button(team.displayName) {
                            store.selectTeam(team)
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 11))
                        Text(store.selectedTeam?.displayName ?? "Personal")
                            .font(GeistFont.medium(GeistFont.footnote))
                            .lineLimit(1)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 8, weight: .semibold))
                    }
                    .foregroundColor(GeistColors.foreground(colorScheme))
                    .padding(.horizontal, GeistSpacing.sm)
                    .padding(.vertical, 6)
                    .background(GeistColors.backgroundSecondary(colorScheme))
                    .cornerRadius(GeistRadius.sm)
                    .overlay(
                        RoundedRectangle(cornerRadius: GeistRadius.sm)
                            .stroke(GeistColors.border(colorScheme), lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }

            // Project picker
            Menu {
                Button("All Projects") {
                    store.selectProject(nil)
                }

                if !store.projects.isEmpty {
                    Divider()

                    ForEach(store.projects) { project in
                        Button(project.name) {
                            store.selectProject(project)
                        }
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "folder.fill")
                        .font(.system(size: 11))
                    Text(store.selectedProject?.name ?? "All Projects")
                        .font(GeistFont.medium(GeistFont.footnote))
                        .lineLimit(1)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 8, weight: .semibold))
                }
                .foregroundColor(GeistColors.foreground(colorScheme))
                .padding(.horizontal, GeistSpacing.sm)
                .padding(.vertical, 6)
                .background(GeistColors.backgroundSecondary(colorScheme))
                .cornerRadius(GeistRadius.sm)
                .overlay(
                    RoundedRectangle(cornerRadius: GeistRadius.sm)
                        .stroke(GeistColors.border(colorScheme), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(.horizontal, GeistSpacing.md)
        .frame(height: 40)
    }
}

#Preview {
    ProjectSelectorView()
}
