# SKU Handling

## Abstract

This document provides an overview of SKU (Stock Keeping Unit) management, a fundamental aspect of resource provisioning in cloud environments. SKUs represent distinct configurations or offerings for resources such as compute, storage, or network, allowing customers to select the most suitable option for their needs. Each SKU defines a set of attributes—such as performance, capacity, and pricing—that characterize the resource instance.

> **Note:** SKUs are read-only for users. They are created, updated, and deleted exclusively by the Cloud Service Provider (CSP).

## SKUs are regional

SKUs are regional resources, meaning their availability and characteristics may vary between regions. To ensure flexibility and broad deployment options, Cloud Service Providers (CSPs) replicate SKUs across all data centers within a region. This regional approach allows customers to select SKUs that best match their requirements and ensures consistent resource offerings.

## Shared and Tenant-Specific SKUs

By convention, CSPs can designate a public tenant, aliased as `public`, to host shared SKUs. These public SKUs are available to all tenants, facilitating a common resource catalog and simplifying management. However, CSPs may also offer tenant-specific SKUs, which are only available within a particular customer tenant. This enables tailored offerings for specific customers, such as custom hardware configurations or exclusive service levels.

The public tenant is not inherently special but leverages the general Role-Based Access Control (RBAC) system to grant access to its SKUs. Shared SKUs in the `seca` tenant provide a baseline for resource provisioning, while tenant-specific SKUs allow for customization and differentiation.

## Creating SKUs

SKUs are managed exclusively by the CSP. The process involves:

1. Defining the SKU attributes, such as resource type, performance characteristics, and pricing.
2. Assigning the SKU to a region and determining its availability.
3. Registering the SKU in the appropriate tenant—either the public `seca` tenant for shared SKUs or a customer tenant for exclusive offerings.
4. Using the SECA API to create and manage SKUs, ensuring they are discoverable and selectable during resource provisioning.

## Deleting SKUs

Deleting a SKU removes it from the catalog, making it unavailable for future resource provisioning. Existing resources created with the deleted SKU remain unaffected, but new instances cannot be created using that SKU. If a SKU needs to be restored, it can be recreated with the same or updated attributes.

## Updating SKUs

SKUs are considered immutable once created. To change a SKU, the existing SKU should be deleted and a new SKU created with the updated attributes. This approach maintains consistency and avoids confusion, especially when tracking resource configurations and pricing.

## Best practices

> **This section is intended for Cloud Service Providers (CSP) only. SKU management operations—creation, update, and deletion—are performed exclusively by the CSP. Tenants and end users have read-only access to SKUs.**

To ensure efficient, secure, and reliable SKU management, follow these best practices:

1. Create a new SKU for each update or change; avoid in-place updates.
2. Use unique references for each SKU, such as version numbers or identifiers.
3. Maintain a versioning scheme for SKUs to track changes and updates.
4. Regularly review and delete unused SKUs to optimize resources and reduce catalog clutter.
5. Document SKU changes and updates, including version numbers, update dates, and descriptions.
6. Use labels and annotations to provide context and metadata for SKUs, such as resource type, performance tier, and region.

### Example

By using labels and annotations effectively, you can provide valuable context and metadata about your SKUs, making it easier to manage, track, and maintain your resource catalog.

Example of a SKU with annotations:

```json
GET /providers/seca.compute/v1/tenants/public/skus/standard-4cpu-16gb

{
  "labels": {
    "resourceType": "compute",
    "cpu": "4",
    "memory": "16",
    "region": "eu-west-1"
  },
  "annotations": {
    "name": "Standard Compute 4CPU 16GB",
    "description": "A standard compute SKU with 4 vCPUs and 16GB RAM, suitable for general workloads.",
    "release": "2024-04-25T00:00:00Z",
    "eol": "2026-04-25T00:00:00Z",
    "recommendedStorage": "100",
    "performanceTier": "standard"
  },
  "spec": {
    "cpuArchitecture": "amd64",
    "bootType": "UEFI"
  }
}
```

### Example: Block Storage Resource Related to a SKU

A block storage resource references a SKU to define its performance and characteristics. For example, a high-performance or standard block storage can be created by specifying the appropriate SKU reference.

```http
PUT ${storage-provider-url}/v1/tenants/{tenant_id}/workspaces/web-shop-prod/block-storages/web-shop-os-disk
Content-Type: application/json

{
  "labels": {
    "env": "production",
    "project": "web-shop"
  },
  "annotations": {
    "description": "Linux OS Disk - High Performance",
  },
  "spec": {
    "skuRef": "tenants/seca/skus/rd20k", // High-performance remote durable block storage SKU (20,000 IOPS)
    "sizeGB": 50,
    "sourceImageRef": "tenants/public/images/ubuntu-24.04"
  }
}
```

## Note on skuRef and Tenant Resolution

When specifying `skuRef` (or other resource references) in your API requests:

- If the reference includes a tenant (e.g., `tenants/seca/skus/seca.rd20k`), the resource is resolved in that tenant (such as the well-known standard tenant `seca`).
- If the tenant is omitted (e.g., `skus/seca.rd20k`), the resource is resolved in the same tenant as the resource being created.

This allows referencing shared resources in the public tenant or using tenant-specific resources by default.

### Example: Reference without Tenant

```http
PUT ${storage-provider-url}/v1/tenants/{tenant_id}/workspaces/web-shop-prod/block-storages/web-shop-os-disk
Content-Type: application/json

{
  "labels": {
    "env": "production",
    "project": "web-shop"
  },
  "annotations": {
    "description": "Linux OS Disk - High Performance",
  },
  "spec": {
    "skuRef": "tenants/seca/skus/rd20k", // Looks up SKU in the same tenant as the resource being created
    "sizeGB": 50,
    "sourceImageRef": "tenants/ubuntu/images/ubuntu-24.04"
  }
}
```

### Example: Reference with Tenant

```http
PUT ${storage-provider-url}/v1/tenants/{tenant_id}/workspaces/web-shop-prod/block-storages/web-shop-os-disk
Content-Type: application/json

{
  "labels": {
    "env": "production",
    "project": "web-shop"
  },
  "annotations": {
    "description": "Linux OS Disk - High Performance",
  },
  "spec": {
    "skuRef": "tenants/seca/skus/rd20k", // Looks up SKU in the standard tenant 'seca'
    "sizeGB": 50,
    "sourceImageRef": "tenants/public/images/ubuntu-24.04"
  }
}
```