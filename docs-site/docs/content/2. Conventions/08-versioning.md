# Versioning

We need to implement API versioning to manage changes and maintain compatibility across their services. SECA's approach to API versioning is guided by principles that ensure stability and flexibility for developers.

**SECA API versioning** helps manage changes and compatibility within the API as SECA evolves. Each API resource in SECA (like Compute.Instance, Network.VPC, Authorization.Role) is versioned to ensure stability, consistency, and backward compatibility. SECA API versions, inspired by Kubernetes, are  denoted by **vXalphaY**, **vXbetaY**, or **vX**, where:

- **Alpha (vXalphaY)** - Represents early-stage features that are experimental.
  - APIs in this stage are subject to breaking changes, meaning they may change or be removed entirely.
  - X is the major version number (e.g., v1).
- **Beta (vXbetaY)** - Considered stable enough for more extensive testing but may still have breaking changes.
  - Beta features are expected to stay around for at least a few releases, though feedback may lead to further changes before they’re marked as stable.
- **Stable (vX)** - Represents APIs that are considered production-ready and highly stable.
  - Changes here are rare, non-breaking, and backward-compatible.
  - Once an API reaches v1 or another stable version, breaking changes are avoided, though deprecation policies apply to manage the gradual removal of older API versions.
  - When using the SECA Cloud Service Provider, selecting the correct version for each resource is essential for ensuring stability and compatibility.

## Usage

The SECA Resource Versioning is specified as part of the URL path when making API calls.

```bash
GET /v1/workspaces/my-workspace/providers/network/vpcs
```

However, when referencing resources within API responses or configurations, the version is omitted from the resource name. This approach ensures that resource identifiers remain consistent and unaffected by version changes, promoting stability and ease of use.

```json
{
  "metadata": {
    "name": "primary-load-balancer",
    "labels": []
  },
  "spec": {
    "routingTableRef": "/providers/network/routing-tables/default"
  }
}
```

## Breaking Change Definition

The API represents a contract between parties. Changes that directly or indirectly impact the backward compatibility of an API are to be considered breaking changes.

- Services must explicitly define their understanding of breaking changes, especially regarding additive modifications—new fields, new parameters, both potentially with default values.
- Services must be consistent in their definition of the extensibility of a contract.

The definition of backward compatibility also partially depends on technical and business requirements. For some teams, adding a new field may fall under the category of a breaking change. For others, it may be considered an additive modification and therefore not necessarily impactful for existing clients.

### Examples of additive modifications that are not necessarily breaking

- Adding a new feature expressed in terms not previously available (therefore new).
- Adding an element (property, query string parameters, etc.) without making it mandatory and assigning a default value.

### Universal examples of breaking changes

- Removal, renaming, or alteration of part of a contract in the form of data models, types, paths, parameters, or other elements. Examples:
- Removing a method.
- Adding a mandatory parameter to a method without providing a default.
- Adding a mandatory attribute without providing a default.
- Removing attributes.
- Changing the type of an attribute.
- Expanding or modifying the range of allowed values for a particular element.
- Changes in behavior even with the same contract/API.
- Changes in error codes and so-called Fault Contracts, which express the result of an error condition.
- Anything that violates the principle of least surprise.
