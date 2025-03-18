# API Access Control

API access control manages API access permissions through authentication and authorization mechanisms. It determines:

- Who can access the API
- What actions they can perform
- How access is granted

Core purposes:

1. Data Protection: Prevent unauthorized access to sensitive data
2. System Integrity: Guard against API endpoint misuse
3. Compliance: Meet regulatory requirements
4. Trust: Build user confidence through security

API access control combines identity verification (authentication) with permission management (authorization) using specific protocols and frameworks. Its importance grows with increasing API usage in business operations.

Based on **SECA Standard API Server** we adopted the below architecture:

![API Access Control](@site/static/img/access-control.png)

- More in detail, every request goes to the Control Plane API Server.
  - first check is **identify** who is the customer
  - after authentication we need to verify if the customer has the **privilege** to perform the request
  - afterwards we can **validate** and/or **manipulate** the request to fulfill domain requirements

## Authentication

As stated in the REST API Guidelines, authentication is handled via JSON Web Tokens (JWT). All API endpoints require a valid JWT to be included in the Authorization header using the Bearer scheme (e.g., `Authorization: Bearer <token>`). The JWT validation middleware verifies the token's signature, expiration, and required permissions (see *Authorization*) before allowing access to protected resources. Token issuance and management are handled externally to this API - clients must obtain valid tokens through the appropriate authentication service. Requests with missing, expired, or invalid tokens will receive a 401 Unauthorized response.

## Authorization

Resource Authorization Model makes sure users or applications have the right to invoke Control Plane APIs.

We need a specific service within the cloud environment being responsible for managing access controls and enforcing permissions for other resources

- according to the Control Plane API organization we have a  provider workspace for every resource type.
- we define an **authorization** provider workspace to take care of authorization concepts.

This model centralizes authorization logic, making it scalable, consistent, and easier to manage across a wide range of resources.

The Key Elements of this model are listed below:

- **Dedicated Resource Provider** - This is a centralized service that acts as the authority for all authorization decisions. Instead of each resource handling its own access controls, the dedicated provider manages policies, roles, and permissions for all resources
- **Authorization Policies** - Policies define the permissions granted to users, groups, or services. These policies are managed by the dedicated provider and applied consistently across resources. Policies typically define **who** (identity) has access to **what** (resource) and **how** (permissions, such as read, write, or delete).
- **Roles and Role-Based Access Control (RBAC)**: The provider offers a way to define roles that encapsulate a set of permissions. Roles can be applied to users, groups, or other identities. For example, roles might include "Viewer," "Editor," or "Administrator," each with different levels of access. RBAC simplifies authorization management by assigning roles instead of individual permissions.
- **Access Control Enforcement**: Once policies and roles are defined, the cloud API enforces them consistently across resources. When a user or service tries to access a resource, the dedicated provider validates the request based on the permissions associated with the user’s role or policies.

A resource authorization model with a dedicated resource provider centralizes access control across resources, offering an efficient, consistent, and secure way to manage permissions and enforce policies at scale in a cloud environment. This model enhances security by reducing complexity and enabling centralized governance over resource access.


### Tenant Initialization

To initialize a tenant we need the below requirements fulfilled:

- The TenantId should be provided to the client
- Should exist at least a User with the following Role and RoleAssignments.

```json
//Role with name: authorization-admin
{
  "labels": {},
  "annotations": {
    "description": "Authorization Admin Role"  
  },
  "spec": {
    "permissions": [
      {
        "scopes": [
          "*"
        ],
        "resources": [
          "seca.authorization/*"
        ],
        "verb": [
          "get",
          "put",
          "delete"
        ]
      }
    ]
  }
}

//RoleAssignment with name tenant-admin

{
  "labels": {},
  "annotations": {
    "description": "Authorization Admin Role"  
  },
  "spec": {
    "subs": [
      "user1@example.com" //subject to whoam assign the owner tenant role
    ],
    "roles": [
      "authorization-admin"
    ]
  }
}
```

## Validation

Resource validation in SECA ensures that all requests to create or modify resources meet business rules before being processed. While authentication verifies who is making the request and authorization determines if they have permission, validation ensures the request itself is valid and consistent.

### Common Expression Language (CEL) Validations

SECA implements resource validations using the Common Expression Language (CEL), providing a powerful and flexible way to define validation rules directly in the API specification.

Key Concepts of CEL Validations:

- **Declarative Rules**: Validation rules are defined declaratively in the OpenAPI specification using x-cel-validations extensions
- **Multi-level Validation**: Rules can be applied at both the operation level (for specific actions) and schema level (for resource-wide validations)
- **Rich Expression Support**: CEL supports complex validation scenarios including:
  - Field presence and format validation
  - Cross-field dependencies and relationships
  - Complex business rules and constraints
  - Type validation and coercion

Example validation rule:

```yaml
MetaData:
  x-cel-validations:
    - id: "name_validation"
      description: "Validate MetaData name format"
      constraint: "matches(self.name, '^[a-z0-9][-a-z0-9]*$')"
      error_message: "name must be lowercase alphanumeric and may contain hyphens"

BlockStorage:
  x-cel-validations:
    - id: "block_storage_attachment_validation"
      description: "Ensure block storage volumes are not already attached to other instances"
      constraint: |
        # For each requested volume
        !spec.storage.dataBlockStorageRef.exists(volume,
          resource.instances.exists(instance,
            instance.status.dataBlockStorageRef.exists(attached,
              attached.objectRef == volume.objectRef
            )
          )
        )
      error_message: "One or more block storage volumes are already attached to other instances"
```

### Role

A **Role** is a resource that defines a set of permissions within a specific workspace, allowing controlled access to resources within that workspace. Roles are a key part of **SECA RBAC (Role-Based Access Control)** mechanism, which provides fine-grained access control for users and customer applications interacting with cloud resources.

Key Concepts of a SECA Role:

- **tenant-scoped**: A Role is confined to a single tenant, meaning it bundles permissions to resources within that specific tenant only.
- **Permissions (Rules)**: A Role contains rules that specify which actions are permitted on particular scopes. These rules are defined using:
  - **scopes** (e.g., '*/instances', '/workspace/ws1/subnets') that the role can access.
  - **Verbs** (e.g., get, list, create, delete) that indicate what actions can be taken on the resources.
  - **Resource Names** (optional) to specify individual resources by name for more precise control, technical part of the scope.
- **Least Privilege Principle**: Roles enable Tenant Administrators to grant minimal permissions necessary for a user or application to perform its tasks, enhancing tenant security by limiting access to only what is needed.

This is essential for applying granular access control within a workspace, aligning with the principle of least privilege to keep CSP tenants secure and manageable.

### RoleBinding

A **RoleBinding** is a resource used to associate a Role with specific users, groups, or customer applications, granting them the permissions defined in the role. RoleBindings are a fundamental part of SECA RBAC (Role-Based Access Control) system, as they are the mechanism through which permissions are actually applied to subjects.

Key Concepts of a RoleBinding

- **Workspace-Specific**: A RoleBinding grants access within a single Workspace. It binds a Role (which is also Workspace-scoped) to specific subjects within that Workspace. For granting tenant-wide permissions, a TenantRoleBinding is used instead, which can apply to resources across all Workspaces.
- **Subjects**: RoleBindings specify the subjects (such as users, groups, or customer applications) that will receive the permissions defined in the Role. These subjects can be:
  - **Users**: The standardized JWT-subject (`sub`).
  - **Groups**: Collections of users.
  - **customer applications**: Accounts used by applications or other processes running within the SECA tenant.
- **Reference to a Role**: A RoleBinding references an existing Role to grant permissions within a single Workspace.
- **Applying Permissions**: RoleBindings do not contain permissions themselves; they simply bind a set of permissions (defined in a Role) to one or more subjects.

## Admission Control

**Admission control** in the SECA API Access Control is a mechanism that intercepts requests to the Control Plane before they are persisted in the database, allowing the SECA CSP to enforce policies, apply security rules, and manage resource allocation. Admission controllers act as "gatekeepers" that can accept, modify, or deny requests based on custom or predefined policies, helping ensure a consistent and secure tenant environment.

Key Concepts of Admission Control are the below listed:

- **Request Interception**: When a user or application sends a request to create, update, delete, or connect to a cloud resource, the Control Plane Cloud API processes it through a sequence of admission controllers. These controllers evaluate the request before it is applied to the cluster.
- **Types of Admission Controllers**:
  - **Validating Controllers**: Validate requests according to certain rules. For example, they might check that a cloud resource requests are within limits defined in the tenant subscription.
  - **Mutating Controllers**: Modify requests as needed. For example, they may inject some metadata or other mandatory fields if they would be skip by the user but are needed in the Resource API specification.
