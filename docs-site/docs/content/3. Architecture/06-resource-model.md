# Resource Model

- Every object managed by the APIs is a Resource. It can be created, updated, read, listed and disposed of.
- Generally, each Resource has a provisioning state, managed by a specific Resource Provider that owns one or more Resources, grouped by shared characteristics.

## Resource Definition

| Section | Description |
|-------------|---------|
|metadata| a set of standard fields included in every SECA Resource Object, which provides essential information for identifying, categorizing, and managing that resource within the CSP|
|spec| specific settings that define the desired state of a SECA Resource Object. These properties vary depending on the type of resource and determine how the resource behaves in the CSP.|
|status| reflects the current observed state of the object within the CSP. This field is typically managed and updated automatically by the CSP system and provides insight into the resource's actual state versus its desired configuration|

### Metadata

Additional data that convey some system information related to the control loop mechanisms that regulate the system’s dynamic equilibrium
Some of their functions are:

- **Semantic Interoperability** - which allows searching across different disciplinary fields through a series of equivalences between descriptors;
- **Availability** -  meta information such as the region and availability zone where a resource is hosted

The fields we are currently providing are the below listed:

- **id** - Resource Id
- **region** - In which region the resource is hosted within the cloud provider’s infrastructure. Available with both regional and zonal resources
- **zone** - In which availabilityZone the resource is hosted within the cloud provider’s infrastructure. Available only with zonal resources
- **creationTimestamp** -  cloud resource metadata to provide information about the resource’s lifecycle, specifically when it was created .
- **deletionTimestamp** - cloud resource metadata to provide information about when it was scheduled for deletion
- **lastModifiedTimestamp** - cloud resource metadata to provide information about when occurred the last update, also used for multi-version concurrency control (MVCC) - see "if-match".
- **labels** - key-value pair mechanism used for organizing, categorizing, and identifying resources based on user-defined attributes.

### Properties

The record of intent that describes the changes to be applied to a resource; in other words, the desired state of the resource.

- This section is highly customizable, allowing users to specify attributes which the CSP s uses to tailor the resource's setup and allocation to meet operational needs.
- By configuring these properties, the CSP ensures that the cloud resource aligns with both user requirements and cloud-specific features, automating resource management and scalability across complex, multi-cloud or hybrid cloud environments.

### Status

The purpose of this section is to provide insights into the current state of a resource. Customers,by examining this status information, can assess resource health, troubleshoot issues, and confirm successful deployments or configurations.

What do we include in the status object is below described:

- **conditions**
  - **type** - the condition type (e.g Ready, Available, Progressing)
  - **status** - whether the condition is met (True, False, or Unknown)
  - **lastTransitionTime** - When the condition last changed
  - **reason** - Details about the current condition status, helpful for debugging or understanding issues.
  - **message** - Human-readable message indicating details about the last status transition
- **state** - indicates the resource lifecycle phase, like Pending, Succeeded, Failed or Unknown.

In addition we can have Resource-Specific Status Fields; each cloud resource type has unique status fields tailored to its function;
such an example:

- **hostIp** - IP addresses assigned to the Virtual Machine (E.g Compute Instance)
- **availableReplicas** - number of nodes currently available and running (E.g KaaS Node Pool)
- **updatedReplicas** - number of nodes with the latest resource version (E.g KaaS Node Pool)
- **replicas** - desired node replicas as per the spec (E.g KaaS Node Pool)
- **unavailableReplicas** - number of node replicas not available due to issues (E.g KaaS Node Pool)

## Resource Lifecycle

| Operation | HTTP Verb | Description |
|---------- |---------|-------------|
| Read      |  GET    | Retrieve the representation of a specific resource|
| Create    |  PUT    | Creates a resource|
| Update    |  PUT    | Updates a resource|
| Delete    |  DELETE | Deletes a specific resource|
| List      |  GET    | Retrieve the representations of a set of resources. The output set can be determined based on a filter passed on input|
| Action    |  POST   | Control Plan APIs can be extended by Actions (for example PowerOff and Restart for Virtual Machines)|
