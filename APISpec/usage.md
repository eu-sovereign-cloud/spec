# Sovereign European Cloud API (SECA)
## Overview
A comprehensive REST API for managing cloud infrastructure resources in compliance with European sovereignty requirements. This API provides control over core Infrastructure-as-a-Service (IaaS) components.

## Key Features
- **Complete Resource Management**: Orchestrate compute instances, block storage, and networking components
- **Role-Based Access Control**: Integrated RBAC system with fine-grained permissions
- **Multi-Tenant Architecture**: workspace-based resource organization
- **Performance Tiers**: Flexible SKUs for compute, storage, and network resources
- **RESTful Design**: Consistent REST API patterns with standardized responses

## Core Services
- **Compute**: Virtual machine management with various performance tiers
- **Storage**: Block storage volumes with guaranteed IOPS levels
- **Network**: LANs, subnets, security groups, and public IP management
- **Identity**: Integrated authentication and authorization

## Technical Specifications
- API Version: v1
- Authentication: JWT-based Bearer tokens
- Content Types: JSON for requests and responses
- Status: Production-ready for core IaaS operations

![API Diagram](https://x.frei-services.net/api-diagram.png)

## Current Scope
The API currently focuses on essential IaaS capabilities, providing the fundamental building blocks for cloud infrastructure:
- Compute instance lifecycle management
- Block storage operations with performance guarantees
- Network configuration and security
- Resource organization through workspaces
- Role-based access control

# Sovereign European Cloud API Guide
## Setting up and Managing Cloud Instances

This guide walks you through the process of creating and managing cloud instances using the Sovereign European Cloud API.

## Prerequisites

### Authentication
- You need to have an active tenantId from your cloud service provider
- You need a valid JWT token for authentication
- The JWT must contain a `sub` claim that identifies you (e.g., email or unique identifier)
- Use the token in the Authorization header: `Authorization: Bearer <your_jwt_token>`
- The tenantId is provided by your iaas cloud provider

### Tenant Initialization
To initialize a tenant we need the below requirements fullfilled:
- The TenantId should be provided to the client
- Should exist at least a User with the following Role and RoleAssignments.

```json
//Role AuthorizationAdmin
{
    "apiVersion": "v1",
    "kind": "role",
    "metadata": {
        "name": "authorization-admin"
    },    
    "spec":{
        "permissions": [
            "seca.authorization/*:write"
        ]
    }
}

//RoleAssignent TenantAdmin

{
    "apiVersion": "v1",
    "kind": "role-assignment",
    "metadata": {
      "name": "TenantAdmin",    
    "spec":{
        "subs": [
            "${userSubject}"
          ],
          "roles": [
            "authorization-admin"
          ]
        "scopes":[
            "tenants/${tenantId}"
        ]
    }
}
```

### SSH Keys
- Prepare your SSH public key
- The system uses external SSH key management
- You'll need the reference to your SSH key for instance creation

## Step 1: Create a Workspace

Create a workspace to organize your resources:

```http
PUT /v1/tenants/{tenant_id}/workspaces/webshop-prod
Content-Type: application/json

{
  "apiVersion": "v1",
  "kind": "workspace",
  "metadata": {
    "description": "Production environment for webshop",
    "labels": {
      "env": "production",
      "project": "webshop"
    }
  }
}
```

Note: Creating a workspace automatically grants you admin permissions for that workspace.

## Step 2: Select Region and Zones

Before creating resources, you need to select a region and its availability zones:

```http
GET /v1/providers/seca.platform/regions
```

This will return available regions and their zones. Resources can be created at either the regional level (like LANs and Public IPs) or the zonal level (like Instances and Block Storage).

## Step 3: Review Available SKUs

### Check Compute SKUs
```http
GET /v1/tenants/{tenant_id}/providers/seca.compute/skus
```

Available compute tiers:
- seca.s: 2 vCPU, 4GB RAM, 3000 benchmark points
- seca.m: 4 vCPU, 8GB RAM, 6000 benchmark points
- seca.l: 8 vCPU, 16GB RAM, 12000 benchmark points
- seca.xl: 16 vCPU, 32GB RAM, 24000 benchmark points

### Check Storage SKUs
```http
GET /v1/tenants/{tenant_id}/providers/seca.storage/skus
```

Important notes about storage:
- Minimum 50GB recommended for guaranteed performance
- Performance tiers:
  - seca.general: No guaranteed throughput
  - seca.100: 100 IOPS guaranteed (99% of time when >50GB)
  - seca.250: 250 IOPS guaranteed (99% of time when >50GB)
  - seca.500: 500 IOPS guaranteed (99% of time when >50GB)

### Check Network SKUs
```http
GET /v1/tenants/{tenant_id}/providers/seca.network/skus
```

Available network tiers:
- seca.10: 10 Mbps guaranteed bandwidth
- seca.100: 100 Mbps guaranteed bandwidth
- seca.1000: 1000 Mbps guaranteed bandwidth

### Review Available Images
```http
GET /v1/providers/seca.storage/images
```

Available images:
- ubuntu-24.04: Ubuntu 24.04 LTS
- redhat-9.3: Red Hat Enterprise Linux 9.3
- debian-12: Debian 12 (Bookworm)

## Step 4: Set Up Storage

Create a block storage volume from an image:

```http
PUT /v1/tenants/{tenant_id}/workspaces/webshop-prod/providers/seca.storage/block-storages/webshop-os-disk
Content-Type: application/json

{
  "apiVersion": "v1",
  "kind": "block-storage",
  "metadata": {
    "labels": {
      "role": "os-disk",
      "app": "webshop"
    },
    "location": {
      "region": "eu-central",
      "zone": "eu-central-1"
    }
  },
  "spec": {
    "blockStorageSkuRef": "seca.100",
    "sizeGB": 50,
    "sourceImageRef": "ubuntu-24.04"
  }
}
```

## Step 5: Set Up Network

### 5.1 Create a LAN
```http
PUT /v1/tenants/{tenant_id}/workspaces/webshop-prod/providers/seca.network/lans/webshop-network
Content-Type: application/json

{
  "apiVersion": "v1",
  "kind": "lan",
  "metadata": {
    "labels": {
      "app": "webshop"
    },
    "location": {
      "region": "eu-central"
    }
  }
}
```

### 5.2 Create a Subnet
```http
PUT /v1/tenants/{tenant_id}/workspaces/webshop-prod/providers/seca.network/lans/webshop-network/subnets/webshop-subnet
Content-Type: application/json

{
  "apiVersion": "v1",
  "kind": "subnet",
  "metadata": {
    "name": "webshop-subnet",
    "labels": {
      "app": "webshop"
    },
    "location": {
      "region": "eu-central",
      "zone": "eu-central-1"
    }
  },
  "spec": {
    "ipv4Range": "192.168.1.0/24",
    "networkSkuRef": "seca.100"
  }
}
```

### 5.3 Set Up Security Group
```http
PUT /v1/tenants/{tenant_id}/workspaces/webshop-prod/providers/seca.network/lans/webshop-network/security-groups/webshop-sg
Content-Type: application/json

{
  "apiVersion": "v1",
  "kind": "security-group",
  "metadata": {
    "name": "webshop-sg",
    "labels": {
      "app": "webshop"
    },
    "location": {
      "region": "eu-central"
    }
  },
  "spec": {
    "rules": [
      {
        "description": "Allow SSH access",
        "direction": "ingress",
        "protocol": "tcp",
        "portRange": {
          "from": 22,
          "to": 22
        },
        "source": {
          "type": "publicInternet",
          "value": "any"
        },
        "priority": 100
      },
      {
        "description": "Allow HTTPS access",
        "direction": "ingress",
        "protocol": "tcp",
        "portRange": {
          "from": 443,
          "to": 443
        },
        "source": {
          "type": "publicInternet",
          "value": "any"
        },
        "priority": 200
      }
    ]
  }
}
```

### 5.4 Create Public IP
```http
PUT /v1/tenants/{tenant_id}/workspaces/webshop-prod/providers/seca.network/public-ips
Content-Type: application/json

{
  "apiVersion": "v1",
  "kind": "public-ip",
  "metadata": {
    "name": "webshop-ip",
    "labels": {
      "app": "webshop"
    },
    "location": {
      "region": "eu-central"
    }
  },
  "spec": {
    "type": "Static"
  }
}
```

## Step 6: Create Instance

Create the compute instance:

```http
PUT /v1/tenants/{tenant_id}/workspaces/webshop-prod/providers/seca.compute/instances/webshop-server
Content-Type: application/json

{
  "apiVersion": "v1",
  "kind": "instance",
  "metadata": {
    "name": "webshop-server",
    "labels": {
      "app": "webshop",
      "role": "web"
    },
    "location": {
      "region": "eu-central",
      "zone": "eu-central-1"
    }
  },
  "spec": {
    "instanceSkuRef": "seca.m",
    "nics": [
      {
        "subnetRef": "webshop-subnet",
        "privateIPs": [
          {
            "adressType": "IPv4",
            "provisioningStrategy": "DHCP"
          }
        ],
        "publicIPRef": ["webshop-ip"]
      }
    ],
    "cloudInitData": {
      "sshKeyExternalRef": ["your-ssh-key-reference"],
      "userData": "#cloud-config\npackages:\n  - nginx"
    },
    "osBlockStorageRef": "webshop-os-disk"
  }
}
```

## Step 7: Access and Use the Instance

1. Wait for the instance to be in "running" state:
```http
GET /v1/tenants/{tenant_id}/workspaces/webshop-prod/providers/seca.compute/instances/webshop-server
```

2. Get the public IP:
```http
GET /v1/tenants/{tenant_id}/workspaces/webshop-prod/providers/seca.network/public-ips/webshop-ip
```

3. Connect to your instance:
```bash
ssh -i <your_private_key> ubuntu@<public_ip>
```

## Error Handling

The API uses standard HTTP status codes:
- 400: Bad Request - Check your request format
- 401: Unauthorized - Verify your JWT token
- 403: Forbidden - Check your permissions
- 404: Not Found - Resource doesn't exist
- 412: Precondition Failed - Resource was modified
- 422: Unprocessable Entity - Invalid resource configuration
- 500: Internal Server Error - Contact support

Each error response includes detailed information:
```json
{
  "errors": [
    {
      "status": "400",
      "code": "INVALID_REQUEST",
      "title": "Bad Request",
      "detail": "Specific error message"
    }
  ]
}
```
