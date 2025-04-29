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
- **resource** - resource URN which uniquely identifies a resource within the hierarchy, following the path format 
  ```
  tenants/{tenant-id}/workspaces/{workspace-name}/instances/{instance-name}
  ```
- **verb** - specifies the HTTP method used by the customer to perform an operation on the resource, such as GET, POST, PUT, or DELETE.
- **createdAt** -  Indicates the time when the resource was created. The field is set by the provider and should not be modified by the user.
- **deletedAt** - If set, indicates the time when the resource was marked for deletion. Resources with this field set are considered pending deletion.
- **lastModifiedAt** - Indicates the time when the resource was created or last modified. Field is used for "If-Unmodified-Since" logic for concurrency control. The provider guarantees that a modification on a single resource can happen only once every millisecond.
- **resourceVersion** - Incremented on every modification of the resource. Used for optimistic concurrency control.
- **apiVersion** - API version of the resource.
- **kind** - identifies the resource type.
- **ref** - Reference to a resource. The reference is represented as the full URN (Uniform Resource Name) name of the resource. The reference can be used to refer to a resource in other resources.
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

The purpose of this section is to provide insights into the current state of a resource. Customers,by examining this status information, can assess resource health, troubleshoot issues, and confirm successful deployments or configurations.

What do we include in the status object is below described:

- **conditions**
  - **type** - the condition type (e.g Ready, Available, Progressing)
  - **status** - whether the condition is met (True, False, or Unknown)
  - **lastTransitionAt** - When the condition last changed
  - **reason** - Details about the current condition status, helpful for debugging or understanding issues.
  - **message** - Human-readable message indicating details about the last status transition
- **state** - indicates the resource lifecycle phase, like Pending, Succeeded, Failed or Unknown.

In addition, there are attributes under the status section that may change after the initial creation. These attributes are updated by the CSP to reflect the user’s intended input or the current state of the resource.

Unlike the **admission controller**, which mutates or enriches user input during request processing by filling in fields, updates to the status section do not modify or enrich the user’s input. Instead, the CSP updates the status solely to reflect the current observed state of the resource within the system.

## Resource Lifecycle

| Operation | HTTP Verb | Description |
|---------- |---------|-------------|
| Read      |  GET    | Retrieve the representation of a specific resource|
| Create    |  PUT    | Creates a resource|
| Update    |  PUT    | Updates a resource|
| Delete    |  DELETE | Deletes a specific resource|
| List      |  GET    | Retrieve the representations of a set of resources. The output set can be determined based on a filter passed on input|
| Action    |  POST   | Control Plan APIs can be extended by Actions (for example PowerOff and Restart for Virtual Machines)|
