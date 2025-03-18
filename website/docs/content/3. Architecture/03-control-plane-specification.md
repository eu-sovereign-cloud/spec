# Control Plane Specification

Control Plan APIs have all the following template:

```bash
# Path based (central API)
https://{service}.{domain}/
providers/{resourceProviderNamespace}/{resourceProviderVersion}/
{scope}/{resourceType}[/{resourceName}][/{action}]?api-version={api-version}[&{queryStringParameters}]
# or DNS based (decentralized API)
https://{resourceProviderNamespace}.{service}.{domain}/{resourceProviderVersion}/
{scope}/{resourceType}[/{resourceName}][/{action}]?api-version={api-version}[&{queryStringParameters}]
```

## Parameters

### `service`

Name of the cloud service, ”api” in our case

### `domain`

Cloud Service Provider domain name (ad es. aruba.it, arubacloud.com, etc.)

### `scope`

A hierarchical set of key-value pairs that identify the origin of the resource. Scopes answer questions like:

* What cloud account contains this resource?
* Which department or organizational unit this resource belongs to?
* What logical group this resource belongs to ?

For example, the resource paths `/workspace/ws1/vpc/my-vpc` and `/workspace/ws2/vpc/my-vpc` can coexist without creating a naming collision for 'my-vpc'. We use `/tenants/{id}/workspaces/{name}`.

### `resourceProviderNamespace`

The workspace and type of a resource. These are defined together because resource types are usually two segments - a vendor workspace and a type name. For example Aruba.Compute. Each Resource is managed by a Resource Provider. The implementation of Resource Provider is CSP specific. A single Resource Provider can manage multiple resource types. For SECA, we always start with "seca.", not to limit a provider to use its own namespace for non-seca-services.

### `resourceType`

The type of Resource

### `resourceName`

The name of the Resource. Sub-resources are allowed. They follow the parent resource in the URL path

### `action`

Optional operations to perform on the resource (e.g., start, stop, restart, delete). These are specific actions beyond the standard CRUD operations.

### `api-version`

The version of the API being used for the request. This ensures compatibility and proper handling of the request format.

#### `query-string-parameters`

Optional parameters that modify or filter the request (parameters like `limit` and `skipToken`).
