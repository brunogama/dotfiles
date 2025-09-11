#!/usr/bin/swift

import Foundation

struct ProjectGenerator {
    let projectName: String
    let baseDirectory: String
    
    init(projectName: String, baseDirectory: String = FileManager.default.currentDirectoryPath) {
        self.projectName = projectName
        self.baseDirectory = baseDirectory
    }
    
    func generate() throws {
        let projectPath = (baseDirectory as NSString).appendingPathComponent(projectName)
        
        // Create project directory structure
        try createDirectoryStructure(at: projectPath)
        
        // Generate Package.swift
        try generatePackageSwift(at: projectPath)
        
        // Generate main.swift
        try generateMainSwift(at: projectPath)
        
        // Generate Tests directory and test file
        try generateTests(at: projectPath)
        
        print("✅ Project '\(projectName)' successfully created at: \(projectPath)")
        print("📝 To get started:")
        print("   cd \(projectName)")
        print("   swift run")
    }
    
    private func createDirectoryStructure(at path: String) throws {
        let fileManager = FileManager.default
        
        // Create main project directory
        try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true)
        
        // Create Sources directory and project source directory
        let sourcesPath = (path as NSString).appendingPathComponent("Sources")
        let projectSourcePath = (sourcesPath as NSString).appendingPathComponent(projectName)
        try fileManager.createDirectory(atPath: projectSourcePath, withIntermediateDirectories: true)
        
        // Create Tests directory
        let testsPath = (path as NSString).appendingPathComponent("Tests")
        let projectTestsPath = (testsPath as NSString).appendingPathComponent("\(projectName)Tests")
        try fileManager.createDirectory(atPath: projectTestsPath, withIntermediateDirectories: true)
    }
    
    private func generatePackageSwift(at path: String) throws {
        let packageSwiftContent = """
        // swift-tools-version:5.5
        import PackageDescription

        let package = Package(
            name: "\(projectName)",
            dependencies: [
                // Add your dependencies here
                // .package(url: "https://github.com/example/example.git", from: "1.0.0"),
            ],
            targets: [
                .executableTarget(
                    name: "\(projectName)",
                    dependencies: []),
                .testTarget(
                    name: "\(projectName)Tests",
                    dependencies: ["\(projectName)"]),
            ]
        )
        """
        
        let packageSwiftPath = (path as NSString).appendingPathComponent("Package.swift")
        try packageSwiftContent.write(toFile: packageSwiftPath, atomically: true, encoding: .utf8)
    }
    
    private func generateMainSwift(at path: String) throws {
        let mainSwiftContent = """
        print("Welcome to \(projectName)!")

        // Your code goes here
        func main() {
            // Add your main program logic here
        }

        main()
        """
        
        let mainSwiftPath = (path as NSString).appendingPathComponent("Sources/\(projectName)/main.swift")
        try mainSwiftContent.write(toFile: mainSwiftPath, atomically: true, encoding: .utf8)
    }
    
    private func generateTests(at path: String) throws {
        let testFileContent = """
        import XCTest
        @testable import \(projectName)

        final class \(projectName)Tests: XCTestCase {
            func testExample() throws {
                // Add your test cases here
                XCTAssertTrue(true)
            }
        }
        """
        
        let testFilePath = (path as NSString).appendingPathComponent("Tests/\(projectName)Tests/\(projectName)Tests.swift")
        try testFileContent.write(toFile: testFilePath, atomically: true, encoding: .utf8)
    }
}

// Command line interface
if CommandLine.arguments.count < 2 {
    print("❌ Error: Project name is required")
    print("Usage: \(CommandLine.arguments[0]) <project-name>")
    exit(1)
}

let projectName = CommandLine.arguments[1]
let generator = ProjectGenerator(projectName: projectName)

do {
    try generator.generate()
} catch {
    print("❌ Error: \(error.localizedDescription)")
    exit(1)
}