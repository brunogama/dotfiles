#!/usr/bin/env swift
import Foundation

// Helper function to run shell commands.
func runCommand(_ command: String) {
    let process = Process()
    process.launchPath = "/bin/bash"
    process.arguments = ["-c", command]
    process.launch()
    process.waitUntilExit()
    if process.terminationStatus != 0 {
        print("Error: Command failed: \(command)")
        exit(Int(process.terminationStatus))
    }
}

// Ask the user for the SPM package name.
print("Enter the name of your SPM package:")
guard let packageName = readLine(), !packageName.isEmpty else {
    print("Invalid package name.")
    exit(1)
}

// Let the user choose the type of package.
print("\nSelect package type:")
print("1. Executable (default)")
print("2. Library")
let packageTypeChoice = readLine() ?? "1"
let packageType = (packageTypeChoice == "2") ? "library" : "executable"

// Ask if the user wants to initialize a git repository.
print("\nInitialize git repository? (y/N):")
let gitChoice = readLine() ?? "n"
let initGit = gitChoice.lowercased() == "y"

// Create the SPM package in the current (relative) directory.
let packageInitCommand = "swift package init --type \(packageType) --name \(packageName)"
print("\nCreating SPM package '\(packageName)' as a \(packageType)...")
runCommand(packageInitCommand)

// Optionally initialize a git repository.
if initGit {
    print("Initializing git repository...")
    runCommand("git init")
}

// Optionally create a README.md file if it doesn't exist.
let fileManager = FileManager.default
if !fileManager.fileExists(atPath: "README.md") {
    let readmeContent = "# \(packageName)\n\nCreated with swift package initializer."
    do {
        try readmeContent.write(toFile: "README.md", atomically: true, encoding: .utf8)
        print("README.md created.")
    } catch {
        print("Error creating README.md: \(error)")
    }
}

print("\nSPM package '\(packageName)' created successfully!")