# SECA API Design Principles

## Core Principles

1. **Common Resource Structure**
   Each resource follows a standardized structure, with metadata described in ResourceMetaData.

2. **Spec and Status Separation**
   Resources are divided into "spec" (desired state) and "status" (current state) sections.

3. **Deletion Handling**
   Deletion is treated specially, with a deleted description in the spec until the resource is fully removed.

4. **Provider Responsibility**
   Once a 202 status is sent, providers must manage the resource object and work towards syncing spec and status.

5. **Client-Side Naming**
   Instead of server-side IDs, we use client-side "names" which can be customized (e.g., "server-${uuid}").

6. **Name Uniqueness**
   Names must be unique within a given context.

7. **Unified Error Handling**
   Error codes and error objects are standardized across all providers.

8. **PUT-Centric Operations**
   The API doesn't use CREATE operations, relying solely on PUT requests.

## Todos
- Define the context for name uniqueness
- Formalize the deletion process
- Refine error code and object unification through real-world scenario testing
- Consider the potential addition of convenient CREATE operations with server-provided names