---
name: simpy
description: Use when building discrete-event simulations of systems with processes, queues, and resources (manufacturing, service operations, network traffic, logistics), modeling resource contention, analyzing queue behavior, optimizing capacity planning, or simulating time-based events where entities interact with shared resources
---

# SimPy - Discrete-Event Simulation

Process-based discrete-event simulation framework for modeling systems where entities (customers, vehicles, packets) interact with shared resources (servers, machines, bandwidth) over time.

## When to Use

- Discrete-event systems (events at irregular intervals)
- Resource contention (limited servers, machines, staff)
- Queue analysis (wait times, service times, throughput)
- Process optimization (manufacturing, logistics, service operations)
- Network simulation (packet routing, bandwidth, latency)
- Capacity planning (optimal resource levels)
- System validation (testing before implementation)

**Not suitable for:**
- Continuous simulations with fixed time steps
- Independent processes without resource sharing

## Quick Start

```python
import simpy

def customer(env, name, server):
    """Customer requests resource, uses it, releases."""
    with server.request() as req:
        yield req  # Wait for resource
        print(f'{name} got resource at {env.now}')
        yield env.timeout(3)  # Use resource
        print(f'{name} released at {env.now}')

env = simpy.Environment()
server = simpy.Resource(env, capacity=1)

env.process(customer(env, 'Customer 1', server))
env.process(customer(env, 'Customer 2', server))
env.run()
```

## Core Concepts

### 1. Environment
Manages simulation time and schedules events.
```python
env = simpy.Environment(initial_time=0)
env.run(until=100)  # Run until time 100
```

### 2. Processes
Defined using Python generator functions with `yield`.
```python
def my_process(env):
    print(f'Starting at {env.now}')
    yield env.timeout(5)  # Wait 5 time units
    print(f'Done at {env.now}')

env.process(my_process(env))
```

### 3. Events
Synchronization mechanism:
- `env.timeout(delay)` - Wait for time
- `resource.request()` - Request resource
- `event1 & event2` - Wait for all (AllOf)
- `event1 | event2` - Wait for any (AnyOf)

## Resources

| Type | Use Case |
|------|----------|
| Resource | Limited capacity (servers, machines) |
| PriorityResource | Priority-based queuing |
| PreemptiveResource | High-priority interrupts low-priority |
| Container | Bulk materials (fuel, water) |
| Store | Python objects (FIFO) |
| FilterStore | Selective retrieval |

```python
resource = simpy.Resource(env, capacity=2)
priority_resource = simpy.PriorityResource(env, capacity=1)
fuel_tank = simpy.Container(env, capacity=100, init=50)
warehouse = simpy.Store(env, capacity=10)
```

**Reference:** `references/resources.md`

## Common Patterns

### Customer-Server Queue
```python
import random

def customer(env, name, server):
    arrival = env.now
    with server.request() as req:
        yield req
        wait = env.now - arrival
        print(f'{name} waited {wait:.2f}')
        yield env.timeout(random.uniform(2, 4))

def customer_generator(env, server):
    i = 0
    while True:
        yield env.timeout(random.uniform(1, 3))
        i += 1
        env.process(customer(env, f'Customer {i}', server))

env = simpy.Environment()
server = simpy.Resource(env, capacity=2)
env.process(customer_generator(env, server))
env.run(until=20)
```

### Producer-Consumer
```python
def producer(env, store):
    item_id = 0
    while True:
        yield env.timeout(2)
        yield store.put(f'Item {item_id}')
        item_id += 1

def consumer(env, store):
    while True:
        item = yield store.get()
        yield env.timeout(3)
```

### Parallel Tasks
```python
def coordinator(env):
    task1 = env.process(task(env, 'Task 1', 5))
    task2 = env.process(task(env, 'Task 2', 3))

    # Wait for all
    results = yield task1 & task2
    print(f'All done at {env.now}')
```

## Workflow

1. **Define System** - Identify entities, resources, processes, metrics
2. **Implement Processes** - Create generator functions
3. **Set Up Monitoring** - Collect statistics
4. **Run and Analyze** - Execute simulation, generate reports

## Monitoring

```python
from scripts.resource_monitor import ResourceMonitor

resource = simpy.Resource(env, capacity=2)
monitor = ResourceMonitor(env, resource, "Server")

# After simulation
monitor.report()
monitor.export_csv('results.csv')
```

**Reference:** `references/monitoring.md`

## Advanced Features

- **Process Interaction** - Events, yields, interrupts (`references/process-interaction.md`)
- **Real-Time Simulations** - Synchronized with wall-clock (`references/real-time.md`)

## Scripts

- **`basic_simulation_template.py`** - Complete queue simulation template
- **`resource_monitor.py`** - Reusable monitoring utilities

## References

- **`resources.md`** - All resource types with examples
- **`events.md`** - Event system and patterns
- **`process-interaction.md`** - Process synchronization
- **`monitoring.md`** - Data collection techniques
- **`real-time.md`** - Real-time simulation setup

## Best Practices

1. Always use `yield` in process functions
2. Use `with resource.request() as req:` for cleanup
3. Set `random.seed()` for reproducibility
4. Collect data throughout simulation
5. Validate with analytical solutions
6. Use modular design for processes

## Common Pitfalls

- Forgetting `yield` in processes
- Reusing events (only trigger once)
- Resource leaks (use context managers)
- Inconsistent time units
- Deadlocks (ensure progress possible)
