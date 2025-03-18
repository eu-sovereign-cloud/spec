# Core API Concepts

## Entity

The primary resources or objects within the API, often corresponding to domain-specific nouns.
In a cloud provider, for example, some primary entities could be virtual machines and networks.

Such an example, a disk can be created by sending an HTTP PUT request containing the resource information.

- The HTTP response indicates whether the request was successfully submitted.
- Whenever possible, resource URIs should be based on nouns (i.e., the resource) rather than verbs (i.e., the operations performed on the resources).

```bash
# Correct
https://mycloud.eu/${scope}/storage/block-storages

# Not Correct
https://mycloud.eu/${scope}/create-storage/block-storages
```

- Sending an HTTP GET request to the collection's URI retrieves a list of the elements within it; each element in the collection also has its own unique URI.
- An HTTP GET request to an element's URI returns the details of that element.

### Relationship

Relationships describe how entities connect or interact with each other, helping structure API endpoints for clarity and hierarchy.

It is important to consider the relationships between different types of resources and how those associations could be exposed.

- For example, `/compute/instances/my-vm/storage/block-storages` **could** represent all the storage/block-storages for the virtual machine my-vm.
- It is also possible to **go in the opposite direction** and represent the association from a disk to a virtualMachine with a URI like `/storage/block-storages/disk-test/instances`.

**However, if this model is adopted excessively, its implementation could become complex.**

*Let's describe below the **SECA specifications** for Entity Relationship.*

### Composition & Aggregation

When designing REST APIs, it’s important to understand and model the relationship type between entities accurately, especially when considering **composition** (strong) relationships (structural) and **aggregation** (weak) relationships.

Here’s a breakdown of each and how to represent them effectively in REST API design.

#### Structural Relationship - Composition

- In a composition relationship, one entity (**the parent**) strongly **owns** another (**the child**), and the child cannot exist independently without the parent.
- If the parent entity is deleted, so is the child entity.

Example: security-group and security-group-rule. A security-group-rule only makes sense within the context of a security-group and is deleted if the parent is deleted.

##### Design Considerations

- Reflect the dependency by nesting the child resource under the parent.
- The child resource’s lifecycle is directly tied to the parent resource.
- Enforce deletion cascades so that deleting a parent removes all associated children

##### API Design

- Parent resource: `GET /security-groups/{securityGroupName}`
- Child resources as sub-resources:
  - `GET /security-groups/{securityGroupName}/security-rules`
  - `GET /security-groups/{securityGroupName}/security-group-rules/{securityGroupRuleName}`
  - Create child resource:
    - `PUT /security-groups/{securityGroupName}/security-group-rules/{securityGroupRuleName}`
  - Delete child along with parent:
    - `DELETE /security-groups/{securityGroupName} would delete both the securityGroup and its securityGroupRules.`

##### Best Practices

- Do not provide a top-level endpoint for the child resource if it makes no sense without the parent, emphasizing the dependency.

#### Aggregation Relationship

- In an aggregation relationship, one entity is **loosely associated** with another, meaning the child can exist independently of the parent.
- The parent may reference the child, but if the parent is deleted, the child remains.

Example: Virtual Machine and Disk. A Disk can exist with or without a VirtualMachine, and deleting a VirtualMachine could not affect the Disk entity.

#### AR - Design Considerations

- Use references or links rather than nesting, as the child can stand alone.
- Provide separate top-level endpoints for each entity, enabling access to the child independently of the parent.
- Use relationship or linking endpoints to associate entities instead of tying them together structurally.

#### AR - API Design

- Separate resources:
  - `GET /compute/instances/{instanceName}`
  - `GET /storage/block-storages/{diskName}`
- Linking endpoints:

```json
{
  "type": "ssd",
  "size_gb": 500,
  "attached_instance": {
    "instance": "/compute/instances/my-instance",
    "device_name": "/dev/sda1",
    "mount_point": "/mnt/data"
  },
  "encryption": {
    "enabled": true,
    "key": "/keys/my-key"
  }
}
```

- Manage relationships independently:
  - `DELETE /virtual-machines/{virtualMachineName} only deletes the virtualMachine without impacting the storage/block-storages.`

#### Differences in API Design for Composition vs. Aggregation

| Aspect | Composition (Structural) | Aggregation (Weak) |
|------- |--------------------------|---------------------------------------|
|Endpoint Structure | Nested within the parent resource | Separate endpoints, linked by reference|
|Resource Independence |Child depends on parent; no standalone endpoint| Child is independent; standalone endpoint allowed|
|Lifecycle Dependency | Child is deleted when parent is deleted| Child remains if parent is deleted|
|Use Case | Strong ownership, e.g., Network and Subnets| Loose association, e.g., VM and storage/block-storages|
|Deletion Behavior |Cascading delete (parent and children)| No cascade; deletion affects only the entity being removed|

#### Additional Design Tips

1. Document relationship types clearly: explain in the API documentation which relationships are compositional (structural) and which are aggregational (weak), so developers know if deleting one entity affects others.
2. When aggregating, leverage **hypermedia links** to indicate connections rather than deeply nesting endpoints. 

For example, in a response for a disk, include links to `virtualMachine`:

```json
{
  "attached_instance": "/virtual-machines/{virtualMachineName}"
}

3. Separate resource ownership logic: if the relationship requires logic specific to the parent-child relationship, consider defining an intermediate resource, such as a vm-attachment relationship resource to better manage the association.

Using this approach will help you model these relationships in a way that reflects real-world dependencies and ownership, while keeping the API design clean and intuitive.

### Cardinalities

## URI Naming Convention

1. It is necessary to adopt a consistent naming convention for URIs. In general, it is useful to use plural nouns for URIs referring to collections.
    - when the resource being modeled has a name consisting of multiple words, it is necessary to use **kebab-case**
    - Resource collections should be all **plurals**
    - Examples:
      - `/providers/compute/instances/`
      - `/providers/network/security-groups/`
      - `/providers/network/network-interfaces/`
2. It is advisable to organize the URIs for collections and elements in a hierarchy. For example, if `/networks` is the path for the network collection, then `/networks/my-net` will be the path for the network whose name is **my-net**.
    - This approach helps to keep the web API intuitive. Many web API frameworks can also route requests based on URI paths with parameters, so it is possible to define a route for the path `/networks/{name}`.
3. In more complex systems, there may be a temptation to provide URIs that allow a client to traverse multiple levels of relationships, such as `/compute/instances/my-vm/storage/block-storages/disk-00/snapshots`. However, this level of complexity can be difficult to maintain and would likely become overly rigid if the relationships between resources change in the future.
    - It is better to try to keep URIs relatively simple. When an entity contains a reference to a resource, it should be possible to use that reference to find the elements related to that resource. The previous query can be replaced with the URI `/compute/instances/my-vm/storage/block-storages` to find all storage/block-storages for virtual machine my-vm, and then `/storage/block-storages/my-disk/snapshots` to find the snapshots for that disk.
    - A rule of thumb is a maximum nesting depth of two. Sometimes a depth of three is also okay
4. Another factor to consider is that all web requests impose a load on the server. The greater the number of requests, the greater the load. Therefore, try to avoid "fragmented" APIs that expose a large number of small resources. Such an API may require a client application to send multiple requests to retrieve all the necessary data. It may be more appropriate to denormalize the data and combine related information into larger resources that can be retrieved with a single request. However, this approach must be balanced against the overhead of retrieving unnecessary data for the client. Retrieving large objects can increase request latency and add bandwidth costs.
5. Avoid introducing dependencies between the resource APIs and the underlying data sources. For example, if the data is persisted in a relational database, it is not necessary for the resource API to expose each table as a collection of resources, as this could likely be a design flaw. Instead, consider the web API as an abstraction over the database. If necessary, introduce a mapping layer between the database and the web API. This way, client applications are isolated from changes to the underlying database schema.
6. Finally, it may not always be possible to map every operation implemented by a web API to a specific resource. Such scenarios, which do not correspond to a resource, can be handled through HTTP requests that invoke a function and return the results as an HTTP response. A web API that implements simple arithmetic operations like addition and subtraction, for example, might provide URIs that expose these operations as pseudo-resources and use the query string to specify the necessary parameters. For example, a GET request to the URI `/add?op1=99&op2=1` returns a response with a body containing the value 100. However, the use of such URI formats is extremely rare and should be only used for sorting, filtering and other non altering operations..
