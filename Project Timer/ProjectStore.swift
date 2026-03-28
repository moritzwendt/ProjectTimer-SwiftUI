//
//  ProjectStore.swift
//  Project Timer
//
//  Created by Moritz Wendt on 28.03.26.
//
import Foundation
import Observation

@Observable
class ProjectStore {
    var projects: [Project] = [] {
        didSet { save() }
    }
    
    var lastArchivedProject: Project?
    
    private let saveKey = "project_timer_data_v5"
    
    init() { load() }
    
    func addProject(title: String, description: String, link: String) {
        let newProject = Project(title: title, description: description, link: link, createdAt: Date(), totalTrackedTime: 0)
        projects.append(newProject)
    }
    
    func updateProject(_ project: Project) {
        if let index = projects.firstIndex(where: { $0.id == project.id }) {
            projects[index] = project
        }
    }
    
    func archiveProject(_ project: Project) {
        if let index = projects.firstIndex(where: { $0.id == project.id }) {
            lastArchivedProject = projects[index]
            projects[index].isDeleted = true
        }
    }
    
    func undoArchive() {
        if let last = lastArchivedProject,
           let index = projects.firstIndex(where: { $0.id == last.id }) {
            projects[index].isDeleted = false
            lastArchivedProject = nil
        }
    }
    
    func deletePermanently(ids: Set<UUID>) {
        projects.removeAll(where: { ids.contains($0.id) })
    }
    
    func restoreProjects(ids: Set<UUID>) {
        for id in ids {
            if let index = projects.firstIndex(where: { $0.id == id }) {
                projects[index].isDeleted = false
            }
        }
    }
    
    func addTime(to projectID: UUID, seconds: TimeInterval) {
        if let index = projects.firstIndex(where: { $0.id == projectID }) {
            projects[index].totalTrackedTime += seconds
        }
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(projects) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func load() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Project].self, from: data) {
            projects = decoded
        }
    }
}
