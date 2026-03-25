# Resource Model

- Every object managed by the APIs is a Resource. It can be created, updated, read, listed and disposed of.
- Generally, each Resource has a provisioning state, managed by a specific Resource Provider that owns one or more Resources, grouped by shared characteristics.

## Resource Definition

| Section | Description |
|-------------|---------|
|labels| User-defined key/value pairs that are mutable and can be used to organize and categorize resources. They can be used to filter resources. The number of labels is eventually limited by the CSP. |
|annotations| User-defined key/value pairs that are mutable and can be used to add annotations. The number of annotations is eventually limited by the CSP. |
|extensions | User-defined key/value pairs that are mutable and can be used to add extensions. Extensions are subject to validation by the CSP, and any value that is not accepted will be rejected during admission.|
|metadata| a set of standard fields included in every SECA Resource Object, which provides essential information for identifying, categorizing, and managing that resource within the CSP|
|spec| specific settings that define the desired state of a SECA Resource Object. These properties vary depending on the type of resource and determine how the resource behaves in the CSP.|
|status| reflects the current observed state of the object within the CSP. This field is typically managed and updated automatically by the CSP system and provides insight into the resource's actual state versus its desired configuration|

### Labels

The labels (key/value pairs) enable flexible grouping of resources according to specific organizational needs. Labels are mutable, allowing users to update them as conditions or priorities change. They also support filtering, helping users efficiently locate and manage resources at scale. 

### Annotations

Being flexible, it allows the user to ogranize his resources through annotation (key/value pair) to describe and configure specific conditions. They are mutable and can be limited by the CSP.

### Extensions

Extensions are user-defined key/value pairs that are mutable and allow users to add custom metadata or functionality to a resource. These extensions provide flexibility but must adhere to specific validation rules enforced by the Cloud Service Provider (CSP). During the admission process, each extension is validated, and any key or value that does not meet the CSP’s requirements will be rejected. This ensures that all extensions are safe, consistent, and compatible with the system.


### Metadata

> This section is read-only and is included only in the GET response payload; it cannot be modified through create or update operations.

Additional data that convey some system information related to the control loop mechanisms that regulate the system’s dynamic equilibrium
Some of their functions are:

- **Semantic Interoperability** - which allows searching across different disciplinary fields through a series of equivalences between descriptors;
- **Availability** -  meta information such as the region and availability zone where a resource is hosted

The fields we are currently providing are the below listed:

- **name** - Resource identifier in dash-case (kebab-case) format. Must start and end with an alphanumeric character. Can contain lowercase letters, numbers, and hyphens. Multiple segments can be joined with dots. Each segment follows the same rules.
- **provider** - resource provider which is responsible for managing the lifecycle, configuration, and operations of the resource. (E.g: seca.compute/v1)
- **resource** - resource-specific path that identifies the resource within its workspace context. Contains the type and name segment(s) of the resource, without the provider, version, tenant, or workspace prefix (those are available as separate metadata fields):
  ```
  instances/{instance-name}
  networks/{network-name}/route-tables/{rt-name}
  ```
- **verb** - specifies the HTTP method used by the customer to perform an operation on the resource, such as GET, POST, PUT, or DELETE.
- **createdAt** -  Indicates the time when the resource was created. The field is set by the provider and should not be modified by the user.
- **deletedAt** - If set, indicates the time when the resource was marked for deletion. Resources with this field set are considered pending deletion.
- **lastModifiedAt** - Indicates the time when the resource was created or last modified. Field is used for "If-Unmodified-Since" logic for concurrency control. The provider guarantees that a modification on a single resource can happen only once every millisecond.
- **resourceVersion** - Incremented on every modification of the resource. Used for optimistic concurrency control.
- **apiVersion** - API version of the resource.
- **kind** - identifies the resource type.
- **ref** - Full URN (Uniform Resource Name) of the resource. The URN is **not** a URL — it has no protocol scheme, host, or endpoint prefix. It is a portable, transport-agnostic identifier. The format is:
  ```
  {provider}/{version}/tenants/{tenant}/workspaces/{workspace}/{type}/{name}
  ```
  Example: `seca.compute/v1/tenants/tn-1/workspaces/ws-1/instances/my-server`

  A configured SDK client can derive a transport URL from a URN, but the URN alone is not a URL. This keeps the URN portable across environments and CSP deployments.
- **tenant** - specifies the tenant identifier to which the resource belongs.
- **workspace** - specifies the workspace identifier to which the resource belongs.
- **region** -  specifies the geographical region where the resource is located.
- **zone** - specifies the specific availability zone within the region where the resource resides.



### Spec

The record of intent that describes the changes to be applied to a resource; in other words, the desired state of the resource.

- This section is highly customizable, allowing users to specify attributes which the CSP s uses to tailor the resource's setup and allocation to meet operational needs.
- By configuring these properties, the CSP ensures that the cloud resource aligns with both user requirements and cloud-specific features, automating resource management and scalability across complex, multi-cloud or hybrid cloud environments.

### Status
> This section is read-only and is included only in the GET response payload; it cannot be modified through create or update operations.

The purpose of this section is to provide insights into the current state of a resource. Customers, by examining this status information, can assess resource health, troubleshoot issues, and confirm successful deployments or configurations.

The status object contains two complementary parts:

1. **Status fields** - Represent the current observed state of the resource
2. **Conditions** - Provide a historical record of state transitions and events

#### Status Fields

The status section includes various fields that describe the current state of a resource. These fields are updated by the CSP to reflect the actual observed state:

- **state** - indicates the resource lifecycle phase, like Pending, Succeeded, Failed or Unknown.
- **Resource-specific fields** - Additional fields that vary by resource type (e.g., `powerState` for Instances, `primary` for database clusters, `endpoint` for services)

These fields represent the "what is" - the current snapshot of the resource state at any given moment.

#### Conditions

Conditions complement status fields by providing a historical view and event-based semantics. Following Kubernetes conventions, conditions capture:

- **What changed** - State transitions and significant events
- **When it changed** - Timestamps for audit and debugging
- **Why it changed** - Context and reasons for transitions

Each condition in the conditions array contains:

- **type** - The condition type (e.g., Ready, Available, PowerStateChanged, PrimaryChanged)
- **lastTransitionAt** - Timestamp when the condition last changed state
- **reason** - Machine-readable cause for the condition (e.g., UserRequested, Failover, AutoScaling)
- **message** - Human-readable message providing details about the transition

#### How Status Fields and Conditions Work Together

Status fields and conditions serve different but complementary purposes:

- **Status fields** provide the current state snapshot
- **Conditions** provide the transition history and event context

**Example: Instance Power State Management**

Consider an Instance resource where the user requests a power-off operation:

**Before power-off (Instance running):**
```yaml
status:
  state: Succeeded
  powerState: "on"
  conditions:
    - type: Ready
      status: "True"
      lastTransitionAt: "2024-12-11T10:00:00Z"
      reason: InstanceRunning
      message: "Instance is running and ready"
```

**During power-off (transition in progress):**
```yaml
status:
  state: Succeeded
  powerState: "transitioning"    # status field reflects current state
  conditions:
    - type: Ready
      lastTransitionAt: "2024-12-11T11:30:00Z"
      reason: PowerStateChanging
      message: "Instance is shutting down"
    
    - type: PowerStateChanged      # New condition added
      lastTransitionAt: "2024-12-11T11:30:00Z"
      reason: UserRequested
      message: "Power state changing from 'on' to 'off' as requested by user"
```

**After power-off (Instance stopped):**
```yaml
status:
  state: Succeeded
  powerState: "off"                # status field updated to new state
  conditions:
    - type: Ready
      lastTransitionAt: "2024-12-11T11:30:00Z"
      reason: InstanceStopped
      message: "Instance is stopped"
    
    - type: PowerStateChanged      # Condition remains in history
      lastTransitionAt: "2024-12-11T11:30:15Z"
      reason: UserRequested
      message: "Power state changed from 'on' to 'off' successfully"
```

**After power-on (Instance restarted):**
```yaml
status:
  state: Succeeded
  powerState: "on"                 # status field back to 'on'
  conditions:
    - type: Ready
      lastTransitionAt: "2024-12-11T12:00:00Z"
      reason: InstanceRunning
      message: "Instance is running and ready"
    
    - type: PowerStateChanged      # New event recorded
      lastTransitionAt: "2024-12-11T12:00:00Z"
      reason: UserRequested
      message: "Power state changed from 'off' to 'on' successfully"
```

In this example:
- The `powerState` field always shows the **current** power state
- The `state` field shows the overall lifecycle phase (remains "Succeeded" as the resource exists and operations complete successfully)
- The `Ready` condition indicates whether the instance is **currently** ready to serve requests
- The `PowerStateChanged` condition provides a **historical record** of power state transitions, capturing when, why, and how the state changed

This pattern allows clients to:
1. **Poll status fields** to check current state
2. **Monitor conditions** to track events and understand state transition history
3. **Debug issues** by examining the reason and message in conditions
4. **Build automation** that reacts to specific condition types

#### Additional Status Attributes

In addition to `state` and `conditions`, the status section may include other attributes that change after initial resource creation. These attributes are updated by the CSP to reflect the current observed state of the resource (e.g., assigned IP addresses, generated endpoints, capacity metrics).

Unlike the **admission controller**, which mutates or enriches user input during request processing by filling in fields, updates to the status section do not modify or enrich the user's input. Instead, the CSP updates the status solely to reflect the current observed state of the resource within the system.


## Resource Lifecycle

| Operation | HTTP Verb | Description |
|---------- |---------|-------------|
| Read      |  GET    | Retrieve the representation of a specific resource|
| Create    |  PUT    | Creates a resource|
| Update    |  PUT    | Updates a resource|
| Delete    |  DELETE | Deletes a specific resource|
| List      |  GET    | Retrieve the representations of a set of resources. The output set can be determined based on a filter passed on input|
| Action    |  POST   | Control Plan APIs can be extended by Actions (for example PowerOff and Restart for Virtual Machines)|
