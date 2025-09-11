#!/usr/bin/env swift

import Foundation

// MARK: - Main Execution

do {
    let creator = try ProjectCreator()
    try creator.run()
} catch {
    print("❌ Error: \(error)")
    exit(1)
}

// MARK: - Project Creator Class

class ProjectCreator {
    private let fileManager = FileManager.default
    private let currentDirectory = FileManager.default.currentDirectoryPath
    private var packageName: String = ""
    private var projectPath: String = ""
    
    // User configuration
    private var packageType: PackageType = .executable
    private var shouldCreateGitRepo: Bool = false
    private var shouldCreateREADME: Bool = false
    private var licenseType: LicenseType = .none
    
    enum PackageType: String {
        case executable, library
    }
    
    enum LicenseType: String, CaseIterable {
        case mit, apache, none
    }
    
    // MARK: - User Interaction
    
    func run() throws {
        print("🚀 Starting Swift Project Creator")
        
        try getProjectName()
        try selectPackageType()
        try selectGitOption()
        try selectReadmeOption()
        try selectLicenseOption()
        
        try createProjectStructure()
        try createReadme()
        try createLicense()
        try initializeGitRepo()
        
        print("\n✅ Successfully created project at: \(projectPath)")
        print("\nNext steps:")
        print("cd \(packageName)")
        if packageType == .executable {
            print("swift run")
        }
        print("open Package.swift")
    }
    
    private func getProjectName() throws {
        print("\n📦 Enter package name:", terminator: " ")
        guard let name = readLine()?.trimmingCharacters(in: .whitespaces), !name.isEmpty else {
            throw ProjectError.missingPackageName
        }
        packageName = name
        projectPath = currentDirectory + "/" + packageName
    }
    
    private func selectPackageType() throws {
        print("\n📦 Select package type:")
        print("1. Executable (default)")
        print("2. Library")
        print("Enter your choice (1-2):", terminator: " ")
        
        guard let choice = readLine() else { return }
        switch choice {
        case "2": packageType = .library
        default: packageType = .executable
        }
    }
    
    private func selectGitOption() throws {
        print("\n🎋 Initialize Git repository? (y/N):", terminator: " ")
        guard let choice = readLine()?.lowercased() else { return }
        shouldCreateGitRepo = choice == "y" || choice == "yes"
    }
    
    private func selectReadmeOption() throws {
        print("\n📝 Create README.md? (Y/n):", terminator: " ")
        guard let choice = readLine()?.lowercased() else { return }
        shouldCreateREADME = choice != "n" && choice != "no"
    }
    
    private func selectLicenseOption() throws {
        print("\n📜 Select license:")
        LicenseType.allCases.enumerated().forEach { index, type in
            print("\(index + 1). \(type.rawValue.capitalized)")
        }
        print("Enter choice (1-\(LicenseType.allCases.count)):", terminator: " ")
        
        guard let choice = readLine(), let value = Int(choice) else { return }
        licenseType = LicenseType.allCases[value - 1]
    }
    
    // MARK: - Project Creation
    
    private func createProjectStructure() throws {
        print("\n🛠  Creating project structure...")
        
        try createDirectory()
        try runSwiftPackageInit()
    }
    
    private func createDirectory() throws {
        if fileManager.fileExists(atPath: projectPath) {
            print("⚠️  Directory already exists. Overwriting...")
            try fileManager.removeItem(atPath: projectPath)
        }
        try fileManager.createDirectory(atPath: projectPath, withIntermediateDirectories: true)
    }
    
    private func runSwiftPackageInit() throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
        process.arguments = [
            "package",
            "init",
            "--type", packageType.rawValue,
            "--name", packageName
        ]
        process.currentDirectoryPath = projectPath
        
        try process.run()
        process.waitUntilExit()
        
        guard process.terminationStatus == 0 else {
            throw ProjectError.packageCreationFailed
        }
    }
    
    // MARK: - Additional Features
    
    private func createReadme() throws {
        guard shouldCreateREADME else { return }
        
        let content = """
        # \(packageName)
        
        \(packageType == .executable ? "A Swift executable package" : "A Swift library")
        
        ## Usage
        
        ```bash
        swift build
        \(packageType == .executable ? "swift run" : "swift test")
        ```
        """
        
        try content.write(
            to: URL(fileURLWithPath: projectPath + "/README.md"),
            atomically: true,
            encoding: .utf8
        )
    }
    
    private func createLicense() throws {
        guard licenseType != .none else { return }
        
        let author = try getAuthorName()
        let year = Calendar.current.component(.year, from: Date())
        
        let content: String
        switch licenseType {
        case .mit:
            content = """
            MIT License
            
            Copyright (c) \(year) \(author)
            
            Permission is hereby granted...
            """
        case .apache:
            content = """
            Apache License 2.0
            
            Copyright \(year) \(author)
            
            Licensed under the Apache License...
            """
        case .none:
            return
        }
        
        try content.write(
            to: URL(fileURLWithPath: projectPath + "/LICENSE"),
            atomically: true,
            encoding: .utf8
        )
    }
    
    private func getAuthorName() throws -> String {
        let process = Process()
        let outputPipe = Pipe()
        
        process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        process.arguments = ["config", "user.name"]
        process.standardOutput = outputPipe
        
        try process.run()
        process.waitUntilExit()
        
        let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
        guard let name = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .newlines) else {
            throw ProjectError.authorNameNotFound
        }
        
        return name
    }
    
    private func initializeGitRepo() throws {
        guard shouldCreateGitRepo else { return }
        
        print("\n🎋 Initializing Git repository...")
        try shellCommand("git init", at: projectPath)
        try shellCommand("git add .", at: projectPath)
        try shellCommand("git commit -m \"Initial commit\"", at: projectPath)
    }
    
    // MARK: - Utilities
    
    private func shellCommand(_ command: String, at path: String) throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/zsh")
        process.arguments = ["-c", command]
        process.currentDirectoryPath = path
        
        try process.run()
        process.waitUntilExit()
        
        guard process.terminationStatus == 0 else {
            throw ProjectError.gitInitializationFailed
        }
    }
}

// MARK: - Error Handling

enum ProjectError: Error {
    case missingPackageName
    case packageCreationFailed
    case authorNameNotFound
    case gitInitializationFailed
}

extension ProjectError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .missingPackageName:
            return "Package name cannot be empty"
        case .packageCreationFailed:
            return "Failed to create Swift package"
        case .authorNameNotFound:
            return "Could not determine author name from Git config"
        case .gitInitializationFailed:
            return "Git repository initialization failed"
        }
    }
}