# SECA Usage

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

![API Diagram](@site/static/img/api-diagram.png)

## Current Scope

The API currently focuses on essential IaaS capabilities, providing the fundamental building blocks for cloud infrastructure:

- Compute instance lifecycle management
- Block storage operations with performance guarantees
- Network configuration and security
- Resource organization through workspaces
- Role-based access control

## Setting up and Managing Cloud Instances

This guide walks you through the process of creating and managing cloud instances using the Sovereign European Cloud API.

## Prerequisites

### Authentication

- You need to have an active tenantId from your cloud service provider
- You need a valid JWT token for authentication
- The JWT must contain a `sub` claim that identifies you (e.g., email or unique identifier)
- Use the token in the Authorization header: `Authorization: Bearer <your_jwt_token>`
- The tenantId is provided by your iaas cloud provider

### SSH Keys

- Prepare your SSH public key
- The system uses external SSH key management
- You'll need the reference to your SSH key for instance creation

Let's suppose you, as subject user@secapi.eu, and tenant administrator, start a new project!


## Step 0: Make sure you have the grant to get region details

Create the **Role**: region-administrator 


```
PUT ${authorization-provider-url}/v1/tenants/tenant-id/roles/region-administrator
{
  "labels": {},
  "annotations": {
    "description": "Resource administrator"
  },
  "spec": {
    "permissions": [
      {
        "scopes": [
          "*"
        ],
        "resources": [
          "regions/*"
        ],
        "verb": [
          "get",
          "list"
        ]
      }
    ]
  }
}
```

Create the **Role-Assignment**: region-administrator 

```
PUT ${authorization-provider-url}/v1/tenants/tenant-id/role-assignments/region-administrator
{
  "labels": {}
  "annotations": {
    "description": "Region Administrator"
  },
  "spec": {
    "subs": [
      "user@secapi.eu"
    ],
    "roles": [
      "region-administrator"
    ]
  }
}
```

## Step 1: Get Region Details and Provider References

```http
GET /v1/regions
```
here you get **provider-url** that can be:
- dns-based (e.g https://eu-workspace.ionos.secapi.eu)
- path-based (e.g. https://aruba.secapi.eu/providers/seca.workspace)

This will return available regions and their zones. Resources can be created at either the regional level (like LANs and Public IPs) or the zonal level (like Instances).

## Step 1: Create a Workspace

Create a workspace to organize your resources:

```http
PUT ${workspace-provider-url}/v1/tenants/{tenant_id}/workspaces/web-shop-prod
Content-Type: application/json

{
  "labels": {
    "env": "production",
    "project": "web-shop"
  }
  "annotations": {
    "description": "Production environment for web-shop",
  }
}
```

Note: Creating a workspace automatically grants you admin permissions for that workspace.


## Step 2: Review Available SKUs

### Check Compute SKUs

```http
GET ${compute-provider-url}/v1/tenants/{tenant_id}/skus
```

Available compute tiers:

- seca.s: 2 vCPU, 4GB RAM, 3000 benchmark points
- seca.m: 4 vCPU, 8GB RAM, 6000 benchmark points
- seca.l: 8 vCPU, 16GB RAM, 12000 benchmark points
- seca.xl: 16 vCPU, 32GB RAM, 24000 benchmark points

### Check Storage SKUs

```http
GET ${storage-provider-url}/v1/tenants/{tenant_id}/skus
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
GET ${network-provider-url}/v1/tenants/{tenant_id}/skus
```

Available network tiers:

- seca.10: 10 Mbps guaranteed bandwidth
- seca.100: 100 Mbps guaranteed bandwidth
- seca.1000: 1000 Mbps guaranteed bandwidth

### Review Available Images

```http
GET ${storage-provider-url}/v1/images
```

Available images:

- ubuntu-24.04: Ubuntu 24.04 LTS
- redhat-9.3: Red Hat Enterprise Linux 9.3
- debian-12: Debian 12 (Bookworm)

## Step 4: Set Up Storage

Create a block storage volume from an image:

```http
PUT ${storage-provider-url}/v1/tenants/{tenant_id}/workspaces/web-shop-prod/block-storages/web-shop-os-disk
Content-Type: application/json

{
  "labels": {
    "language": "en",
    "billing.cost-center": "platform-eng",
    "env": "production"
  },
  "annotations": {
    "description": "Resource with some human readable description",
    "color": "red",
    "externalID": "980c0d88-09e1-42f9-a4ae-f8f4687d6c99"
  },
  "spec": {
    "profile": {
      "storageSkuRef": "tenants/{tenant_id}/skus/gold",
      "skuExtensions": {
        "additionalProp1": {}
      }
    },
    "sizeGB": 50,
    "origin": {
      type: {
        "sourceImageRef": "tenants/{tenant_id}/images/ubuntu-24.04"
      }
    }
  }
}
```

## Step 5: Set Up Network

### 5.1 Create a LAN

```http
PUT ${network-provider-url}/v1/tenants/{tenant_id}/workspaces/web-shop-prod/lans/web-shop-network
Content-Type: application/json

{
  "labels": {
    "language": "en",
    "billing.cost-center": "platform-eng",
    "env": "production"
  },
  "annotations": {
    "description": "Resource with some human readable description",
    "color": "red",
    "externalID": "980c0d88-09e1-42f9-a4ae-f8f4687d6c99"
  },
  "spec": {
    "profile": {
      "networkSkuRef": "tenants/{tenant_id}/skus/gold-lan",
      "skuExtensions": {
        "additionalProp1": {}
      }
    }
  }
}
```

### 5.2 Create a Subnet

```http
PUT ${network-provider-url}/v1/tenants/{tenant_id}/workspaces/web-shop-prod/lans/web-shop-network/subnets/web-shop-subnet
Content-Type: application/json

{
  "labels": {
    "language": "en",
    "billing.cost-center": "platform-eng",
    "env": "production"
  },
  "annotations": {
    "description": "Resource with some human readable description",
    "color": "red",
    "externalID": "980c0d88-09e1-42f9-a4ae-f8f4687d6c99"
  },
  "spec": {
    "profile": {
      "networkSkuRef": "tenants/{tenant_id}/skus/gold-subnet"
    },
    "cidr": {
      "ipv4Range": "198.51.100.42"
    },
    "dhcpEnabled": true,
    "defaultGateway": {
      "type": "auto",
      "value": "string"
    }
  }
}
```

### 5.3 Set Up Security Group

```http
PUT ${network-provider-url}/v1/tenants/{tenant_id}/workspaces/web-shop-prod/lans/web-shop-network/security-groups/web-shop-sg
Content-Type: application/json

{
  "labels": {
    "language": "en",
    "billing.cost-center": "platform-eng",
    "env": "production"
  },
  "annotations": {
    "description": "Resource with some human readable description",
    "color": "red",
    "externalID": "980c0d88-09e1-42f9-a4ae-f8f4687d6c99"
  },
  "spec": {
    "rules": [
      {
        "labels": {
          "language": "en",
          "billing.cost-center": "platform-eng",
          "env": "production"
        },
        "annotations": {
          "description": "Resource with some human readable description",
          "color": "red",
          "externalID": "980c0d88-09e1-42f9-a4ae-f8f4687d6c99"
        },
        "spec": {
          "description": "string",
          "direction": "ingress",
          "protocol": "tcp",
          "portRange": {
            "from": 65535,
            "to": 65535
          },
          "source": {
            "type": "securityGroup",
            "value": "string"
          },
          "priority": 10000
        }
      }
    ]
  }
}
```

### 5.4 Create Public IP

```http
PUT ${network-provider-url}/v1/tenants/{tenant_id}/workspaces/web-shop-prod/public-ips
Content-Type: application/json

{
  "labels": {
    "language": "en",
    "billing.cost-center": "platform-eng",
    "env": "production"
  },
  "annotations": {
    "description": "Resource with some human readable description",
    "color": "red",
    "externalID": "980c0d88-09e1-42f9-a4ae-f8f4687d6c99"
  },
  "spec": {
    "ipVersion": "IPv4",
    "type": "Static"
  }
}
```
## Step 6: Create NIC

Create the NIC instance:

```http
PUT ${network-provider-url}/v1/tenants/{tenant_id}/workspaces/web-shop-prod/nic
Content-Type: application/json

{
  "labels": {
    "language": "en",
    "billing.cost-center": "platform-eng",
    "env": "production"
  },
  "annotations": {
    "description": "Resource with some human readable description",
    "color": "red",
    "externalID": "980c0d88-09e1-42f9-a4ae-f8f4687d6c99"
  },
  "spec": {
    "subnetRef": "tenants/{tenant_id}/workspaces/web-shop-prod/lans/web-shop-network/subnets/web-shop-subnet",
    "staticPrivateIPs": [],
    "publicIPRef": "tenants/{tenant_id}/workspaces/web-shop-prod/public-ips"
  }
}
```

## Step 7: Create Instance

Create the compute instance:

```http
PUT ${compute-provider-url}/v1/tenants/{tenant_id}/workspaces/web-shop-prod/instances/web-shop-server
Content-Type: application/json

{
  "labels": {
    "language": "en",
    "billing.cost-center": "platform-eng",
    "env": "production"
  },
  "annotations": {
    "description": "Resource with some human readable description",
    "color": "red",
    "externalID": "980c0d88-09e1-42f9-a4ae-f8f4687d6c99"
  },
  "spec": {
    "profile": {
      "instanceSkuRef": "tenants/{tenant_id}/skus/gold",
      "skuExtensions": {
        "additionalProp1": {}
      }
    },
    "network": {
      "primaryNicRef": "tenants/{tenant_id}/workspaces/web-shop-prod/nic",
      "otherNics": []
    },
    "operatingSystem": {
      "cloudInitData": {
        "userData": "string",
        "sshKeyExternalRef": [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0g..."
        ]
      },
      "osBlockStorageRef": {
        "objectRef": "tenants/{tenant_id}/workspaces/web-shop-prod/block-storages/web-shop-os-disk",
        "properties": {
          "connectionType": "iSCSI",
          "deviceKind": "instance",
          "deviceRef": "instance-123"
        }
      }
    },
    "storage": {
      "dataBlockStorageRef": []
    }
  }
}

```

## Step 7: Access and Use the Instance

1. Wait for the instance to be in "running" state:

    ```http
    GET ${compute-provider-url}/v1/tenants/{tenant_id}/workspaces/web-shop-prod/instances/web-shop-server
    ```

2. Get the public IP:

    ```http
    GET ${network-provider-url}/v1/tenants/{tenant_id}/workspaces/web-shop-prod/public-ips/web-shop-ip
    ```

3. Connect to your instance:

    ```bash
    ssh -i <your_private_key> ubuntu@<public_ip>
    ```

## Error Handling

The API uses standard HTTP status codes:

- `400`: Bad Request - Check your request format
- `401`: Unauthorized - Verify your JWT token
- `403`: Forbidden - Check your permissions
- `404`: Not Found - Resource doesn't exist
- `412`: Precondition Failed - Resource was modified
- `422`: Unprocessable Entity - Invalid resource configuration
- `500`: Internal Server Error - Contact support

Each error response includes detailed information:

```json
{
  "status": 400,
  "type": "http://secapi.eu/errors/invalid-request",
  "title": "Bad Request",
  "detail": "The request was invalid or cannot be served."
}
```
