---
title: Common Refactoring Patterns
source_url: https://refactoring.guru/refactoring
last_fetched: '2025-01-12T15:00:00Z'
checksum: sha256:e5f6789012345678901234567890abcdef1234567890abcdef567890
domains: [refactoring, patterns, code-quality]
agent_refs: [swift-pro, backend-architect, code-reviewer]
---

<!-- file: patterns/refactoring-patterns.md -->

# Common Refactoring Patterns

Essential refactoring patterns for improving code quality and maintainability.

<!-- section: extract-patterns -->

## Extract Patterns

### Extract Method

```swift
// Before
func processOrder(order: Order) {
    // Validate order
    guard !order.items.isEmpty else { return }
    guard order.totalAmount > 0 else { return }
    guard order.customer != nil else { return }

    // Calculate discount
    var discount = 0.0
    if order.customer.isPremium {
        discount = order.totalAmount * 0.1
    }
    if order.totalAmount > 100 {
        discount += order.totalAmount * 0.05
    }

    // Apply discount and save
    order.finalAmount = order.totalAmount - discount
    order.save()
}

// After
func processOrder(order: Order) {
    guard validateOrder(order) else { return }

    let discount = calculateDiscount(for: order)
    applyDiscountAndSave(discount, to: order)
}

private func validateOrder(_ order: Order) -> Bool {
    return !order.items.isEmpty &&
           order.totalAmount > 0 &&
           order.customer != nil
}

private func calculateDiscount(for order: Order) -> Double {
    guard let customer = order.customer else { return 0 }
    var discount = 0.0
    if customer.isPremium {
        discount = order.totalAmount * 0.1
    }
    if order.totalAmount > 100 {
        discount += order.totalAmount * 0.05
    }
    return discount
}

private func applyDiscountAndSave(_ discount: Double, to order: Order) {
    order.finalAmount = order.totalAmount - discount
    order.save()
}
```

### Extract Variable

```swift
// Before
func calculatePrice(basePrice: Double, taxRate: Double) -> Double {
    return basePrice + (basePrice * taxRate) +
           (basePrice > 100 ? basePrice * 0.1 : 0)
}

// After
func calculatePrice(basePrice: Double, taxRate: Double) -> Double {
    let tax = basePrice * taxRate
    let premiumCharge = basePrice > 100 ? basePrice * 0.1 : 0
    let totalPrice = basePrice + tax + premiumCharge
    return totalPrice
}
```

### Extract Class/Struct

```swift
// Before
class Order {
    var customerName: String
    var customerEmail: String
    var customerPhone: String
    var customerAddress: String
    var items: [Item]
    var totalAmount: Double
}

// After
struct Customer {
    let name: String
    let email: String
    let phone: String
    let address: String
}

class Order {
    var customer: Customer
    var items: [Item]
    var totalAmount: Double
}
```

<!-- endsection -->

<!-- section: inline-patterns -->

## Inline Patterns

### Inline Method

```swift
// Before
func getTaxRate() -> Double {
    return 0.08
}

func calculateTax(amount: Double) -> Double {
    return amount * getTaxRate()
}

// After
func calculateTax(amount: Double) -> Double {
    return amount * 0.08
}
```

### Inline Variable

```swift
// Before
func hasDiscount(customer: Customer) -> Bool {
    let isPremium = customer.membershipLevel == .premium
    return isPremium
}

// After
func hasDiscount(customer: Customer) -> Bool {
    return customer.membershipLevel == .premium
}
```

<!-- endsection -->

<!-- section: rename-patterns -->

## Rename Patterns

### Rename Symbol

```swift
// Before
class usr {
    var nm: String
    var em: String

    func gA() -> Int {
        // calculate age
    }
}

// After
class User {
    var name: String
    var email: String

    func getAge() -> Int {
        // calculate age
    }
}
```

### Rename to Express Intent

```swift
// Before
func check(date: Date) -> Bool {
    return date < Date()
}

// After
func isExpired(date: Date) -> Bool {
    return date < Date()
}
```

<!-- endsection -->

<!-- section: signature-patterns -->

## Change Signature Patterns

### Add Parameter

```swift
// Before
func sendEmail(to recipient: String, subject: String) {
    // send email
}

// After
func sendEmail(to recipient: String,
               subject: String,
               attachments: [Attachment] = []) {
    // send email with optional attachments
}
```

### Remove Parameter

```swift
// Before
func calculateArea(width: Double, height: Double, unit: String) -> Double {
    // unit is never used
    return width * height
}

// After
func calculateArea(width: Double, height: Double) -> Double {
    return width * height
}
```

### Reorder Parameters

```swift
// Before
func createUser(isAdmin: Bool, email: String, name: String) -> User {
    // Parameters in illogical order
}

// After
func createUser(name: String, email: String, isAdmin: Bool = false) -> User {
    // More logical order with default value
}
```

<!-- endsection -->

<!-- section: safety-patterns -->

## Safety Refactoring Patterns

### Replace Magic Numbers

```swift
// Before
func calculateShipping(weight: Double) -> Double {
    if weight < 5 {
        return 5.99
    } else if weight < 20 {
        return 12.99
    } else {
        return 19.99
    }
}

// After
struct ShippingRates {
    static let lightWeightLimit = 5.0
    static let mediumWeightLimit = 20.0
    static let lightWeightRate = 5.99
    static let mediumWeightRate = 12.99
    static let heavyWeightRate = 19.99
}

func calculateShipping(weight: Double) -> Double {
    if weight < ShippingRates.lightWeightLimit {
        return ShippingRates.lightWeightRate
    } else if weight < ShippingRates.mediumWeightLimit {
        return ShippingRates.mediumWeightRate
    } else {
        return ShippingRates.heavyWeightRate
    }
}
```

### Replace Conditionals with Polymorphism

```swift
// Before
func calculateBonus(employee: Employee) -> Double {
    switch employee.type {
    case .engineer:
        return employee.salary * 0.1
    case .manager:
        return employee.salary * 0.2
    case .executive:
        return employee.salary * 0.3
    default:
        return 0
    }
}

// After
protocol BonusCalculable {
    func calculateBonus() -> Double
}

class Engineer: Employee, BonusCalculable {
    func calculateBonus() -> Double {
        return salary * 0.1
    }
}

class Manager: Employee, BonusCalculable {
    func calculateBonus() -> Double {
        return salary * 0.2
    }
}

class Executive: Employee, BonusCalculable {
    func calculateBonus() -> Double {
        return salary * 0.3
    }
}
```

<!-- endsection -->

<!-- endfile -->
