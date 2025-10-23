# Implementation Guide

## Table of Contents
1. [Getting Started](#getting-started)
2. [Library Integration Patterns](#library-integration-patterns)
3. [Configuration Strategies](#configuration-strategies)
4. [Error Handling Implementation](#error-handling-implementation)
5. [Analytics Integration](#analytics-integration)
6. [Security Implementation](#security-implementation)
7. [Testing Strategies](#testing-strategies)

## Getting Started

### Step 1: Project Setup

1. **Add Framework Files**
   ```
   YourProject/
   ├── LivenessFramework/
   │   ├── LivenessDetectionFramework.swift
   │   ├── EnhancedErrorMetadata.swift
   │   └── Extensions/
   ```

2. **Import Dependencies**
   ```swift
   import Foundation
   import UIKit
   import AVFoundation
   import Network
   ```

3. **Configure Info.plist**
   ```xml
   <key>NSCameraUsageDescription</key>
   <string>Camera access required for biometric authentication</string>
   ```

### Step 2: Basic Integration

```swift
@MainActor
class AuthenticationViewController: UIViewController {
    @IBOutlet weak var cameraPreviewView: UIImageView!
    
    private lazy var livenessManager = LivenessDetectionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLivenessDetection()
    }
    
    private func setupLivenessDetection() {
        // Check library requirements
        let requirements = livenessManager.getConfigurationRequirements(for: .uiBased)
        
        if requirements.requiresUI {
            setupUIComponents()
        }
    }
    
    private func setupUIComponents() {
        cameraPreviewView.contentMode = .scaleAspectFit
        cameraPreviewView.backgroundColor = .black
        cameraPreviewView.layer.cornerRadius = 8
        cameraPreviewView.layer.masksToBounds = true
    }
}
```

## Library Integration Patterns

### Pattern 1: Delegate-Based Libraries

```swift
// Example: FaceTec SDK integration
class FaceTecAdapter: NSObject, LivenessDetectorAdapter {
    let libraryName = "FaceTec"
    let requiresUIConfiguration = true
    
    private let analytics: LivenessAnalytics
    private var detectionContinuation: CheckedContinuation<LivenessResult, Never>?
    
    init(analytics: LivenessAnalytics) {
        self.analytics = analytics
        super.init()
    }
    
    func configure(with config: LivenessConfiguration) async throws {
        guard let uiConfig = config.uiConfiguration else {
            throw LivenessConfigurationError.missingUIConfiguration
        }
        
        // Configure FaceTec with UI components
        FaceTecSDK.initialize(
            productionKeyText: getAPIKey(from: config.parameters),
            licenseKey: getLicenseKey(from: config.parameters)
        ) { success in
            if !success {
                // Handle initialization failure
            }
        }
    }
    
    func startDetection(sessionId: String) async -> LivenessResult {
        return await withCheckedContinuation { continuation in
            self.detectionContinuation = continuation
            
            // Start FaceTec session
            let sessionViewController = FaceTecSessionViewController()
            sessionViewController.delegate = self
            
            configuredViewController?.present(sessionViewController, animated: true)
        }
    }
    
    private func getAPIKey(from parameters: [String: SendableValue]) -> String {
        if case .string(let key) = parameters["apiKey"] {
            return key
        }
        return ""
    }
    
    private func getLicenseKey(from parameters: [String: SendableValue]) -> String {
        if case .string(let key) = parameters["licenseKey"] {
            return key
        }
        return ""
    }
}

extension FaceTecAdapter: FaceTecSessionDelegate {
    func faceTecSessionCompleted(
        sessionResult: FaceTecSessionResult,
        faceScanResult: FaceTecFaceScanResult?
    ) {
        switch sessionResult.status {
        case .sessionCompletedSuccessfully:
            let success = LivenessSuccess(
                confidence: Double(faceScanResult?.confidence ?? 0),
                processingTime: sessionResult.processingTime,
                timestamp: Date(),
                metadata: ["facetec_session_id": .string(sessionResult.sessionId)],
                sessionId: currentSessionId ?? "unknown",
                libraryName: libraryName
            )
            detectionContinuation?.resume(returning: .success(success))
            
        case .sessionUserCancelled:
            let error = createError(
                category: .userAction,
                message: "User cancelled the session"
            )
            detectionContinuation?.resume(returning: .failure(error))
            
        default:
            let error = createError(
                category: .processing,
                message: sessionResult.errorMessage ?? "Unknown error"
            )
            detectionContinuation?.resume(returning: .failure(error))
        }
        
        detectionContinuation = nil
    }
}
```

### Pattern 2: Callback-Based Libraries

```swift
// Example: iProov SDK integration
class iProovAdapter: LivenessDetectorAdapter {
    let libraryName = "iProov"
    let requiresUIConfiguration = true
    
    private let analytics: LivenessAnalytics
    
    func configure(with config: LivenessConfiguration) async throws {
        // Configure iProov
        IProov.setBaseURL(getBaseURL(from: config.parameters))
        IProov.setAPIKey(getAPIKey(from: config.parameters))
    }
    
    func startDetection(sessionId: String) async -> LivenessResult {
        return await withCheckedContinuation { continuation in
            
            IProov.launch(
                type: .enrol,
                token: sessionId,
                from: configuredViewController
            ) { result in
                switch result {
                case .success:
                    let success = LivenessSuccess(
                        confidence: nil,
                        processingTime: result.processingTime,
                        timestamp: Date(),
                        metadata: ["iproov_token": .string(sessionId)],
                        sessionId: sessionId,
                        libraryName: self.libraryName
                    )
                    continuation.resume(returning: .success(success))
                    
                case .failure(let error):
                    let livenessError = LivenessError(
                        category: self.mapErrorCategory(error),
                        severity: .error,
                        libraryCode: error.code,
                        message: error.localizedDescription,
                        timestamp: Date(),
                        metadata: [:],
                        sessionId: sessionId,
                        libraryName: self.libraryName
                    )
                    continuation.resume(returning: .failure(livenessError))
                }
            }
        }
    }
    
    private func mapErrorCategory(_ error: IProovError) -> LivenessErrorCategory {
        switch error.type {
        case .networkError:
            return .network
        case .cameraError:
            return .camera
        case .userCancelled:
            return .userAction
        default:
            return .unknown
        }
    }
}
```

### Pattern 3: Promise-Based Libraries

```swift
// Example: Onfido SDK integration
class OnfidoAdapter: LivenessDetectorAdapter {
    let libraryName = "Onfido"
    let requiresUIConfiguration = false
    
    func configure(with config: LivenessConfiguration) async throws {
        let apiKey = getAPIKey(from: config.parameters)
        OnfidoConfig.configure(apiKey: apiKey)
    }
    
    func startDetection(sessionId: String) async -> LivenessResult {
        do {
            let result = try await OnfidoSDK.shared.performLivenessCheck(
                sessionId: sessionId
            )
            
            return .success(LivenessSuccess(
                confidence: result.confidence,
                processingTime: result.duration,
                timestamp: Date(),
                metadata: ["onfido_check_id": .string(result.checkId)],
                sessionId: sessionId,
                libraryName: libraryName
            ))
            
        } catch {
            return .failure(LivenessError(
                category: mapErrorToCategory(error),
                severity: .error,
                libraryCode: nil,
                message: error.localizedDescription,
                timestamp: Date(),
                metadata: [:],
                sessionId: sessionId,
                libraryName: libraryName
            ))
        }
    }
}
```

## Configuration Strategies

### Strategy 1: Environment-Based Configuration

```swift
enum Environment {
    case development
    case staging
    case production
}

struct LibraryConfiguration {
    let environment: Environment
    let apiKeys: [String: String]
    let endpoints: [String: String]
    let timeouts: [String: TimeInterval]
    
    static func forEnvironment(_ env: Environment) -> LibraryConfiguration {
        switch env {
        case .development:
            return LibraryConfiguration(
                environment: env,
                apiKeys: [
                    "FaceTec": "dev_facetec_key",
                    "iProov": "dev_iproov_key"
                ],
                endpoints: [
                    "iProov": "https://dev.iproov.com",
                    "Onfido": "https://api.dev.onfido.com"
                ],
                timeouts: [
                    "default": 30.0,
                    "extended": 60.0
                ]
            )
        case .staging:
            return LibraryConfiguration(
                environment: env,
                apiKeys: [
                    "FaceTec": "staging_facetec_key",
                    "iProov": "staging_iproov_key"
                ],
                endpoints: [
                    "iProov": "https://staging.iproov.com",
                    "Onfido": "https://api.staging.onfido.com"
                ],
                timeouts: [
                    "default": 45.0,
                    "extended": 90.0
                ]
            )
        case .production:
            return LibraryConfiguration(
                environment: env,
                apiKeys: [
                    "FaceTec": Bundle.main.infoDictionary?["FACETEC_API_KEY"] as? String ?? "",
                    "iProov": Bundle.main.infoDictionary?["IPROOV_API_KEY"] as? String ?? ""
                ],
                endpoints: [
                    "iProov": "https://api.iproov.com",
                    "Onfido": "https://api.onfido.com"
                ],
                timeouts: [
                    "default": 30.0,
                    "extended": 60.0
                ]
            )
        }
    }
}
```

### Strategy 2: Feature Flag-Based Configuration

```swift
struct FeatureFlags {
    let enhancedAnalytics: Bool
    let threatDetection: Bool
    let performanceMonitoring: Bool
    let debugLogging: Bool
    
    static let current = FeatureFlags(
        enhancedAnalytics: true,
        threatDetection: true,
        performanceMonitoring: true,
        debugLogging: false
    )
}

class ConfigurableLibraryManager {
    private let configuration: LibraryConfiguration
    private let featureFlags: FeatureFlags
    
    init(environment: Environment, featureFlags: FeatureFlags = .current) {
        self.configuration = LibraryConfiguration.forEnvironment(environment)
        self.featureFlags = featureFlags
    }
    
    func createAnalytics() -> LivenessAnalytics {
        if featureFlags.enhancedAnalytics {
            return EnhancedLivenessAnalyticsImpl()
        } else {
            return LivenessAnalyticsImpl()
        }
    }
}
```

## Error Handling Implementation

### Comprehensive Error Mapping

```swift
extension LivenessDetectionManager {
    func handleLibraryError(
        _ error: Error,
        from library: String,
        sessionId: String
    ) -> LivenessError {
        
        // Map common error types
        switch error {
        case let nsError as NSError:
            return mapNSError(nsError, library: library, sessionId: sessionId)
        case let urlError as URLError:
            return mapURLError(urlError, library: library, sessionId: sessionId)
        default:
            return LivenessError(
                category: .unknown,
                severity: .error,
                libraryCode: nil,
                message: error.localizedDescription,
                timestamp: Date(),
                metadata: [:],
                sessionId: sessionId,
                libraryName: library
            )
        }
    }
    
    private func mapNSError(
        _ error: NSError,
        library: String,
        sessionId: String
    ) -> LivenessError {
        
        let category: LivenessErrorCategory
        let severity: LivenessErrorSeverity
        
        switch error.domain {
        case NSURLErrorDomain:
            category = .network
            severity = .error
        case AVFoundationErrorDomain:
            category = .camera
            severity = .error
        case "com.yourapp.liveness":
            category = .processing
            severity = .warning
        default:
            category = .unknown
            severity = .error
        }
        
        return LivenessError(
            category: category,
            severity: severity,
            libraryCode: "\(error.code)",
            message: error.localizedDescription,
            timestamp: Date(),
            metadata: [
                "domain": .string(error.domain),
                "user_info": .dictionary(error.userInfo.mapValues(SendableValue.init))
            ],
            sessionId: sessionId,
            libraryName: library
        )
    }
    
    private func mapURLError(
        _ error: URLError,
        library: String,
        sessionId: String
    ) -> LivenessError {
        
        let category: LivenessErrorCategory
        
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost:
            category = .network
        case .timedOut:
            category = .timeout
        case .userCancelledAuthentication:
            category = .userAction
        default:
            category = .network
        }
        
        return LivenessError(
            category: category,
            severity: .error,
            libraryCode: "\(error.code.rawValue)",
            message: error.localizedDescription,
            timestamp: Date(),
            metadata: [
                "url": .string(error.failureURLString ?? "unknown")
            ],
            sessionId: sessionId,
            libraryName: library
        )
    }
}
```

### Retry Logic Implementation

```swift
actor RetryManager {
    private var retryAttempts: [String: Int] = [:]
    private let maxRetries: Int = 3
    private let retryDelay: TimeInterval = 2.0
    
    func shouldRetry(for sessionId: String) -> Bool {
        let attempts = retryAttempts[sessionId, default: 0]
        return attempts < maxRetries
    }
    
    func recordAttempt(for sessionId: String) {
        retryAttempts[sessionId, default: 0] += 1
    }
    
    func resetAttempts(for sessionId: String) {
        retryAttempts.removeValue(forKey: sessionId)
    }
    
    func getRetryDelay(for sessionId: String) -> TimeInterval {
        let attempts = retryAttempts[sessionId, default: 0]
        return retryDelay * Double(attempts) // Exponential backoff
    }
}

extension LivenessDetectionManager {
    func performDetectionWithRetry(
        using libraryType: LivenessLibraryType,
        in viewController: UIViewController,
        parameters: [String: SendableValue] = [:]
    ) async -> LivenessResult {
        
        let sessionId = UUID().uuidString
        let retryManager = RetryManager()
        
        while await retryManager.shouldRetry(for: sessionId) {
            await retryManager.recordAttempt(for: sessionId)
            
            let result = await performLivenessDetection(
                using: libraryType,
                in: viewController,
                parameters: parameters
            )
            
            switch result {
            case .success:
                await retryManager.resetAttempts(for: sessionId)
                return result
                
            case .failure(let error):
                // Determine if error is retryable
                if isRetryableError(error) {
                    let delay = await retryManager.getRetryDelay(for: sessionId)
                    try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    continue
                } else {
                    return result
                }
            }
        }
        
        // Max retries exceeded
        return .failure(LivenessError(
            category: .processing,
            severity: .fatal,
            libraryCode: "MAX_RETRIES_EXCEEDED",
            message: "Maximum retry attempts exceeded",
            timestamp: Date(),
            metadata: ["max_retries": .int(maxRetries)],
            sessionId: sessionId,
            libraryName: "RetryManager"
        ))
    }
    
    private func isRetryableError(_ error: LivenessError) -> Bool {
        switch error.category {
        case .network, .timeout:
            return true
        case .camera, .userAction, .configuration:
            return false
        case .processing, .authentication, .unknown:
            return error.severity != .fatal
        }
    }
}
```

## Analytics Integration

### Custom Analytics Provider

```swift
protocol AnalyticsProvider {
    func track(event: String, parameters: [String: Any])
    func logError(error: Error, context: [String: Any])
    func setUserProperty(key: String, value: Any)
}

class FirebaseAnalyticsProvider: AnalyticsProvider {
    func track(event: String, parameters: [String: Any]) {
        Analytics.logEvent(event, parameters: parameters)
    }
    
    func logError(error: Error, context: [String: Any]) {
        Crashlytics.crashlytics().log("Liveness Error: \(error.localizedDescription)")
        Crashlytics.crashlytics().setCustomKeysAndValues(context)
    }
    
    func setUserProperty(key: String, value: Any) {
        Analytics.setUserProperty(String(describing: value), forName: key)
    }
}

class MixpanelAnalyticsProvider: AnalyticsProvider {
    private let mixpanel = Mixpanel.mainInstance()
    
    func track(event: String, parameters: [String: Any]) {
        mixpanel.track(event: event, properties: parameters)
    }
    
    func logError(error: Error, context: [String: Any]) {
        var errorParams = context
        errorParams["error_message"] = error.localizedDescription
        mixpanel.track(event: "Liveness_Error", properties: errorParams)
    }
    
    func setUserProperty(key: String, value: Any) {
        mixpanel.people.set(property: key, to: value)
    }
}
```

### Analytics Aggregation

```swift
class AggregatedAnalyticsProvider: AnalyticsProvider {
    private let providers: [AnalyticsProvider]
    
    init(providers: [AnalyticsProvider]) {
        self.providers = providers
    }
    
    func track(event: String, parameters: [String: Any]) {
        providers.forEach { $0.track(event: event, parameters: parameters) }
    }
    
    func logError(error: Error, context: [String: Any]) {
        providers.forEach { $0.logError(error: error, context: context) }
    }
    
    func setUserProperty(key: String, value: Any) {
        providers.forEach { $0.setUserProperty(key: key, value: value) }
    }
}

// Usage
let analyticsProvider = AggregatedAnalyticsProvider(providers: [
    FirebaseAnalyticsProvider(),
    MixpanelAnalyticsProvider()
])
```

## Security Implementation

### Secure Configuration Storage

```swift
import Security

class SecureConfigurationManager {
    private let keychain = Keychain(service: "com.yourapp.liveness")
    
    func storeAPIKey(_ key: String, for library: String) throws {
        try keychain.set(key, key: "api_key_\(library)")
    }
    
    func getAPIKey(for library: String) -> String? {
        return try? keychain.get("api_key_\(library)")
    }
    
    func storeLicenseKey(_ key: String, for library: String) throws {
        try keychain.set(key, key: "license_key_\(library)")
    }
    
    func getLicenseKey(for library: String) -> String? {
        return try? keychain.get("license_key_\(library)")
    }
    
    func removeCredentials(for library: String) {
        try? keychain.remove("api_key_\(library)")
        try? keychain.remove("license_key_\(library)")
    }
}
```

### Threat Detection Implementation

```swift
class ThreatDetectionManager {
    private let threatDetection = ThreatDetectionService()
    private let securityAnalytics: SecurityAnalyticsProvider
    
    init(securityAnalytics: SecurityAnalyticsProvider) {
        self.securityAnalytics = securityAnalytics
    }
    
    func analyzeLivenessFailure(
        error: LivenessError,
        context: [String: Any]
    ) async -> ThreatAssessment {
        
        let threatIntel = await threatDetection.analyzeThreat(
            sessionId: error.sessionId,
            userIdentifier: context["user_id"] as? String,
            errorDetails: context
        )
        
        let threatLevel = assessThreatLevel(threatIntel)
        
        if threatLevel >= .high {
            await securityAnalytics.reportSecurityIncident(
                type: .suspiciousBiometricActivity,
                severity: threatLevel,
                details: [
                    "session_id": error.sessionId,
                    "attack_vector": threatIntel.attackVector?.rawValue ?? "unknown",
                    "confidence": threatIntel.attackConfidenceScore ?? 0
                ]
            )
        }
        
        return ThreatAssessment(
            threatLevel: threatLevel,
            recommendedAction: getRecommendedAction(for: threatLevel),
            additionalContext: threatIntel
        )
    }
    
    private func assessThreatLevel(_ threat: ThreatIntelligence) -> ThreatLevel {
        guard let confidence = threat.attackConfidenceScore else { return .low }
        
        switch confidence {
        case 0.8...:
            return .critical
        case 0.6..<0.8:
            return .high
        case 0.4..<0.6:
            return .medium
        default:
            return .low
        }
    }
    
    private func getRecommendedAction(for level: ThreatLevel) -> RecommendedAction {
        switch level {
        case .critical:
            return .blockUser
        case .high:
            return .requireAdditionalVerification
        case .medium:
            return .flagForReview
        case .low:
            return .monitor
        }
    }
}

enum ThreatLevel: String, CaseIterable {
    case low = "LOW"
    case medium = "MEDIUM"
    case high = "HIGH"
    case critical = "CRITICAL"
}

enum RecommendedAction {
    case monitor
    case flagForReview
    case requireAdditionalVerification
    case blockUser
}

struct ThreatAssessment {
    let threatLevel: ThreatLevel
    let recommendedAction: RecommendedAction
    let additionalContext: ThreatIntelligence
}
```

## Testing Strategies

### Unit Testing Framework

```swift
import XCTest
@testable import LivenessFramework

class LivenessFrameworkTests: XCTestCase {
    
    var manager: LivenessDetectionManager!
    var mockAnalytics: MockAnalyticsProvider!
    
    override func setUp() {
        super.setUp()
        mockAnalytics = MockAnalyticsProvider()
        manager = LivenessDetectionManager()
    }
    
    func testLibraryConfiguration() {
        // Test configuration requirements
        let requirements = manager.getConfigurationRequirements(for: .delegateBased)
        
        XCTAssertFalse(requirements.requiresUI)
        XCTAssertTrue(requirements.requiredParameters.contains("apiKey"))
    }
    
    func testErrorMapping() {
        // Test error category mapping
        let networkError = URLError(.notConnectedToInternet)
        let mappedError = manager.handleLibraryError(
            networkError,
            from: "TestLibrary",
            sessionId: "test-session"
        )
        
        XCTAssertEqual(mappedError.category, .network)
        XCTAssertEqual(mappedError.severity, .error)
    }
    
    func testThreatDetection() async {
        let threatDetection = ThreatDetectionService()
        
        let threat = await threatDetection.analyzeThreat(
            sessionId: "test-session",
            userIdentifier: "test-user",
            errorDetails: [
                "error_type": "photo_attack",
                "confidence": 0.9
            ]
        )
        
        XCTAssertEqual(threat.attackVector, .photo)
        XCTAssertNotNil(threat.attackConfidenceScore)
    }
}

// Mock implementations for testing
class MockAnalyticsProvider: LivenessAnalytics {
    var loggedEvents: [LivenessAnalyticsEvent] = []
    var loggedErrors: [LivenessError] = []
    var loggedSuccesses: [LivenessSuccess] = []
    
    func logEvent(_ event: LivenessAnalyticsEvent) async {
        loggedEvents.append(event)
    }
    
    func logError(_ error: LivenessError) async {
        loggedErrors.append(error)
    }
    
    func logSuccess(_ success: LivenessSuccess) async {
        loggedSuccesses.append(success)
    }
}

class MockLibraryAdapter: LivenessDetectorAdapter {
    let libraryName = "MockLibrary"
    let requiresUIConfiguration = false
    
    var configurationCalled = false
    var startDetectionCalled = false
    var stopDetectionCalled = false
    
    var simulatedResult: LivenessResult = .failure(LivenessError(
        category: .unknown,
        severity: .error,
        libraryCode: "MOCK_ERROR",
        message: "Mock error",
        timestamp: Date(),
        metadata: [:],
        sessionId: "mock-session",
        libraryName: "MockLibrary"
    ))
    
    func configure(with config: LivenessConfiguration) async throws {
        configurationCalled = true
    }
    
    func startDetection(sessionId: String) async -> LivenessResult {
        startDetectionCalled = true
        return simulatedResult
    }
    
    func stopDetection() async {
        stopDetectionCalled = true
    }
}
```

### Integration Testing

```swift
class LivenessIntegrationTests: XCTestCase {
    
    func testFullDetectionFlow() async {
        let expectation = XCTestExpectation(description: "Detection completes")
        
        let manager = LivenessDetectionManager()
        let mockViewController = UIViewController()
        
        Task {
            let result = await manager.performLivenessDetection(
                using: .delegateBased,
                in: mockViewController,
                parameters: [
                    "apiKey": .string("test-key"),
                    "environment": .string("test")
                ]
            )
            
            switch result {
            case .success(let success):
                XCTAssertNotNil(success.sessionId)
                XCTAssertEqual(success.libraryName, "DelegateLibrary")
            case .failure(let error):
                XCTFail("Expected success, got error: \(error.message)")
            }
            
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
}
```

### Performance Testing

```swift
class PerformanceTests: XCTestCase {
    
    func testDetectionPerformance() {
        let manager = LivenessDetectionManager()
        let mockViewController = UIViewController()
        
        measure {
            let expectation = XCTestExpectation(description: "Performance test")
            
            Task {
                _ = await manager.performLivenessDetection(
                    using: .delegateBased,
                    in: mockViewController,
                    parameters: ["apiKey": .string("test")]
                )
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
        }
    }
    
    func testMemoryUsage() {
        let manager = LivenessDetectionManager()
        
        // Measure memory before
        let initialMemory = getMemoryUsage()
        
        // Perform multiple operations
        for i in 0..<100 {
            let sessionId = "test-session-\(i)"
            let error = LivenessError(
                category: .processing,
                severity: .warning,
                libraryCode: nil,
                message: "Test error \(i)",
                timestamp: Date(),
                metadata: [:],
                sessionId: sessionId,
                libraryName: "TestLibrary"
            )
            
            Task {
                await manager.analytics.logError(error)
            }
        }
        
        // Measure memory after
        let finalMemory = getMemoryUsage()
        let memoryDifference = finalMemory - initialMemory
        
        // Assert reasonable memory usage
        XCTAssertLessThan(memoryDifference, 10_000_000) // 10MB threshold
    }
    
    private func getMemoryUsage() -> Int64 {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        return kerr == KERN_SUCCESS ? Int64(info.resident_size) : 0
    }
}
```

This implementation guide provides comprehensive patterns and strategies for integrating the liveness detection framework into real-world applications. Each section includes practical examples and best practices for production use.
