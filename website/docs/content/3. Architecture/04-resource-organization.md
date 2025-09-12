import Drawio from '@theme/Drawio';
import resourceLevelsDiagram from '!!raw-loader!@site/static/assets/resource-levels.drawio';


# Resource Organization

A cloud organization model is a framework that defines how an organization structures, manages, and governs its resources, users, and permissions within a cloud environment

<Drawio content={resourceLevelsDiagram} page={0} />

## Tenant

A tenant refers to a logical, isolated space created within the cloud environment that is dedicated to a specific organization, user, or customer. This isolation allows multiple customers (tenants) to share the cloud provider’s infrastructure while maintaining security, privacy, and data separation.

Key Aspects of this concept are described below:

- **Isolation**: Each tenant has a distinct, segregated environment that separates their resources and data from those of other tenants.
- **Resource Ownership and Management**: Within a tenant, an organization has ownership over the resources they provision, such as virtual machines, databases, networks, and storage. Tenants are responsible for managing these resources within the confines of their isolated environment.
- **Security**: Tenants have their own access controls settings, which prevent unauthorized access and maintain data privacy. Roles and permission management offers resource based access. control (rbac)
- **Billing and Usage Tracking**: Each tenant has separate billing, with usage tracking that enables the cloud provider to charge tenants based on their resource consumption.

For SECA, the creation of the tenant is not standardized. Billing and usage tracking are out of scope for SECA.

## Workspace

A workspace is a specific, scoped environment within a tenant that groups related resources for collaborative or organizational purposes. Workspaces are often designed to help organize resources for distinct projects, teams, or applications, and they simplify management within a larger tenant.

Key Aspects of this concept are described below:

- **Scoped Environment**: A workspace provides a bounded environment within a tenant where resources, configurations, and settings are applied to a specific set of workloads, applications, or team needs. This allows focused management and separation within the broader tenant context.
- **Resource Grouping**: Workspaces allow related resources—such as virtual machines, storage, applications, and configurations to be grouped together for easier organization, lifecycle management, and monitoring.
- **Collaboration and Permissions**: Workspaces often have configurable access controls, enabling teams to manage permissions specific to the workspace. This is useful for collaborative environments where different teams or users work within the same tenant but require specific access.
- **Billing and Usage Tracking**: Many cloud providers allow resource usage within a workspace to be tracked separately, making it easier to allocate costs to specific projects or teams.
- **Configuration and State Management**: Workspaces may include settings, variables, and secrets specific to the resources they contain, allowing consistent configurations across different environments (e.g., development, testing, production).

## Cloud Resource

A **Cloud Resource** is the core managed entity in the cloud platform. It represents a distinct service or component—such as a virtual machine, a network, or a storage volume—that is provisioned, configured, and managed through the platform’s unified API.

Every cloud resource is defined by two key dimensions:

- The **Resource Provider** responsible for managing it
- The **Resource Type** describing its kind or category

Each cloud resource therefore exists as a specific instance of a resource type, owned and controlled by a resource provider.

This structure ensures clear separation of concerns:
- The **Cloud Resource** is the user-facing unit of consumption.
- The **Resource Provider** abstracts away the complexity of managing it.
- The **Resource Type** defines what kind of resource it is.


### Resource Provider

A **Resource Provider** is the **control-plane component** that enables the creation, management, and maintenance of cloud resources. It acts as the abstraction layer between the unified API and the underlying Cloud Service Provider (CSP) implementation, ensuring users can interact with resources without worrying about infrastructure details.

**Core responsibilities**:
- Provisioning and deprovisioning resources
- Exposing a unified API interface for lifecycle operations
- Managing multiple related resource types within a single domain
- Enforcing security, compliance, and access control policies
- Hiding CSP-specific complexity behind a standardized surface

A Resource Provider is identified by a namespace-like name, and each resource type it manages belongs to this namespace.

Example:
- **seca.compute**: manages compute-related types like Instance
- **seca.network**: manages networking types like Network, Subnet, NIC

In SECA, all Resource Providers services begin with the prefix **seca.** This ensures a consistent namespace for SECA-specific services, while still allowing external providers to use their own namespaces.

SECA groups its Resource Providers in two types:
 - **Foundation**: they provide fundamental building blocks like compute, storage, networking, and identity — which serve as prerequisites for almost all other services.
 - **Extensions**: they represent domain-specific, advanced, or value-added capabilities that are not required for the platform to operate, but extend its functionality for specific use cases or vertical domains.

### Resource Type ###

A **Resource Type** defines a specific **kind of resource** that can be managed by a given Resource Provider. It acts as the schema or blueprint for creating resource instances.

**Key characteristics**:
- Bound to a Resource Provider: each resource type exists only within the context of its provider.
- Domain Model Alignment: all resource types under the same provider share a common domain model and follow the same operational and governance logic.
- Schema Definition: the resource type defines the structure, configurable properties, lifecycle operations, and behaviors for resources created from it.

This combination of **Resource Provider** + **Resource Type** + **Resource Name** forms the complete identity of any cloud resource within the platform.