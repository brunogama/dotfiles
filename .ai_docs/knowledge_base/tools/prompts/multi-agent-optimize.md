---
model: sonnet
---

Optimize application stack using specialized optimization agents:

\[Extended thinking: This tool coordinates database, performance, and frontend optimization agents to improve
application performance holistically. Each agent focuses on their domain while ensuring optimizations work together.\]

## Optimization Strategy

### 1. Database Optimization

Use Task tool with subagent_type="database-optimizer" to:

- Analyze query performance and execution plans
- Optimize indexes and table structures
- Implement caching strategies
- Review connection pooling and configurations
- Suggest schema improvements

Prompt: "Optimize database layer for: $ARGUMENTS. Analyze and improve:

1. Slow query identification and optimization
1. Index analysis and recommendations
1. Schema optimization for performance
1. Connection pool tuning
1. Caching strategy implementation"

### 2. Application Performance

Use Task tool with subagent_type="performance-engineer" to:

- Profile application code
- Identify CPU and memory bottlenecks
- Optimize algorithms and data structures
- Implement caching at application level
- Improve async/concurrent operations

Prompt: "Optimize application performance for: $ARGUMENTS. Focus on:

1. Code profiling and bottleneck identification
1. Algorithm optimization
1. Memory usage optimization
1. Concurrency improvements
1. Application-level caching"

### 3. Frontend Optimization

Use Task tool with subagent_type="frontend-developer" to:

- Reduce bundle sizes
- Implement lazy loading
- Optimize rendering performance
- Improve Core Web Vitals
- Implement efficient state management

Prompt: "Optimize frontend performance for: $ARGUMENTS. Improve:

1. Bundle size reduction strategies
1. Lazy loading implementation
1. Rendering optimization
1. Core Web Vitals (LCP, FID, CLS)
1. Network request optimization"

## Consolidated Optimization Plan

### Performance Baseline

- Current performance metrics
- Identified bottlenecks
- User experience impact

### Optimization Roadmap

1. **Quick Wins** (\< 1 day)

   - Simple query optimizations
   - Basic caching implementation
   - Bundle splitting

1. **Medium Improvements** (1-3 days)

   - Index optimization
   - Algorithm improvements
   - Lazy loading implementation

1. **Major Optimizations** (3+ days)

   - Schema redesign
   - Architecture changes
   - Full caching layer

### Expected Improvements

- Database query time reduction: X%
- API response time improvement: X%
- Frontend load time reduction: X%
- Overall user experience impact

### Implementation Priority

- Ordered list of optimizations by impact/effort ratio
- Dependencies between optimizations
- Risk assessment for each change

Target for optimization: $ARGUMENTS
