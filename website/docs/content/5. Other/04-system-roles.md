# System Roles

System roles are predefined roles, that can not be changed by the users
of the system.

## `seca.admin`

This role provides full system access, a user with this role can manage everything
that he is associated with.

```json
{
  "labels": {},
  "annotations": {
    "description": "SECA Administrator"
  },
  "spec": {
    "permissions": [
      {
        "provider": "seca.authorization/v1",
        "resources": [
          "roles/*",
          "role-assignments/*"
        ],
        "verb": [ "get", "list", "delete", "put", "post" ]
      },
      {
        "provider": "seca.region/v1",
        "resources": [
          "regions/*"
        ],
        "verb": [ "get", "list" ]
      },
      {
        "provider": "seca.workspace/v1",
        "resources": [
          "workspaces/*"
        ],
        "verb": [ "get", "list", "delete", "put", "post" ]
      },
      {
        "provider": "seca.network/v1",
        "resources": [
          "networks/*",
          "subnets/*",
          "route-tables/*",
          "nics/*",
          "internet-gateways/*",
          "security-groups/*",
          "public-ips/*",
          "skus/*"
        ],
        "verb": [ "get", "list", "delete", "put", "post" ]
      },
      {
        "provider": "seca.compute/v1",
        "resources": [
          "instances/*",
          "skus/*"
        ],
        "verb": [ "get", "list", "delete", "put", "post" ]
      },
      {
        "provider": "seca.storage/v1",
        "resources": [
          "images/*",
          "block-storages/*",
          "skus/*"
        ],
        "verb": [ "get", "list", "delete", "put", "post" ]
      },
    ]
  }
}
```

## `seca.region-admin`

This role has full access within a region.

```json
{
  "labels": {},
  "annotations": {
    "description": "SECA Region Administrator"
  },
  "spec": {
    "permissions": [
      {
        "provider": "seca.region/v1",
        "resources": [
          "regions/*"
        ],
        "verb": [ "get", "list" ]
      },
      {
        "provider": "seca.workspace/v1",
        "resources": [
          "workspaces/*"
        ],
        "verb": [ "get", "list", "put", "delete" ]
      },
      {
        "provider": "seca.network/v1",
        "resources": [
          "networks/*",
          "subnets/*",
          "route-tables/*",
          "nics/*",
          "internet-gateways/*",
          "security-groups/*",
          "public-ips/*",
          "skus/*"
        ],
        "verb": [ "get", "list", "delete", "put", "post" ]
      },
      {
        "provider": "seca.compute/v1",
        "resources": [
          "instances/*",
          "skus/*"
        ],
        "verb": [ "get", "list", "delete", "put", "post" ]
      },
      {
        "provider": "seca.storage/v1",
        "resources": [
          "images/*",
          "block-storages/*",
          "skus/*"
        ],
        "verb": [ "get", "list", "delete", "put", "post" ]
      },
    ]
  }
}

## `seca.workspace-admin`

This role has full access within a workspace.

```json
{
  "labels": {},
  "annotations": {
    "description": "SECA Workspace Administrator"
  },
  "spec": {
    "permissions": [
      {
        "provider": "seca.region/v1",
        "resources": [
          "regions/*"
        ],
        "verb": [ "get", "list" ]
      },
      {
        "provider": "seca.workspace/v1",
        "resources": [
          "workspaces/*"
        ],
        "verb": [ "get", "list", "put" ]
      },
      {
        "provider": "seca.network/v1",
        "resources": [
          "networks/*",
          "subnets/*",
          "route-tables/*",
          "nics/*",
          "internet-gateways/*",
          "security-groups/*",
          "public-ips/*",
          "skus/*"
        ],
        "verb": [ "get", "list", "delete", "put", "post" ]
      },
      {
        "provider": "seca.compute/v1",
        "resources": [
          "instances/*",
          "skus/*"
        ],
        "verb": [ "get", "list", "delete", "put", "post" ]
      },
      {
        "provider": "seca.storage/v1",
        "resources": [
          "images/*",
          "block-storages/*",
          "skus/*"
        ],
        "verb": [ "get", "list", "delete", "put", "post" ]
      },
    ]
  }
}
```

## `seca.workspace-editor`

This role can edit (create/update) all resources in workspace.

```json
{
  "labels": {},
  "annotations": {
    "description": "SECA Workspace Editor"
  },
  "spec": {
    "permissions": [
      {
        "provider": "seca.region/v1",
        "resources": [
          "regions/*"
        ],
        "verb": [ "get", "list" ]
      },
      {
        "provider": "seca.network/v1",
        "resources": [
          "networks/*",
          "subnets/*",
          "route-tables/*",
          "nics/*",
          "internet-gateways/*",
          "security-groups/*",
          "public-ips/*",
          "skus/*"
        ],
        "verb": [ "get", "list", "put", "post" ]
      },
      {
        "provider": "seca.compute/v1",
        "resources": [
          "instances/*",
          "skus/*"
        ],
        "verb": [ "get", "list", "put", "post" ]
      },
      {
        "provider": "seca.storage/v1",
        "resources": [
          "images/*",
          "block-storages/*",
          "skus/*"
        ],
        "verb": [ "get", "list", "put", "post" ]
      },
    ]
  }
}
```

## `seca.workspace-viewer`

This role can view all resources in a workspace.

```json
{
  "labels": {},
  "annotations": {
    "description": "SECA Workspace Viewer"
  },
  "spec": {
    "permissions": [
      {
        "provider": "seca.region/v1",
        "resources": [
          "regions/*"
        ],
        "verb": [ "get", "list" ]
      },
      {
        "provider": "seca.network/v1",
        "resources": [
          "networks/*",
          "subnets/*",
          "route-tables/*",
          "nics/*",
          "internet-gateways/*",
          "security-groups/*",
          "public-ips/*",
          "skus/*"
        ],
        "verb": [ "get", "list" ]
      },
      {
        "provider": "seca.compute/v1",
        "resources": [
          "instances/*",
          "skus/*"
        ],
        "verb": [ "get", "list" ]
      },
      {
        "provider": "seca.storage/v1",
        "resources": [
          "images/*",
          "block-storages/*",
          "skus/*"
        ],
        "verb": [ "get", "list" ]
      },
    ]
  }
}
```
