# Tenant and Token

To interact with the SECA API, a token must first be obtained by the CSP. Detailed
information about the token and API access control mechanisms can be found [here](../Conventions/api-security).

While the SECA API does not enforce a specific tenant or authorization model,
the general process typically involves the following steps, which must be implemented by the CSP:

1. The tenant establishes a contractual agreement with the CSP.
2. The tenant creates a user account using the CSP's specific mechanisms.
3. The SECA API is enabled or activated, depending on the CSP's requirements.
4. The tenant generates a **JWT** (JSON Web Token) using the CSP's designated method.
   This token is then used to interact with the SECA API provided by the CSP.

The diagram below provides a visual representation of the tenant and token process:

![Tenant and Token](@site/static/img/tenant-token.png)

## Recommendation

While not mandatory, adopting open standards such as OAuth 2.0 or OpenID Connect (OIDC)
is highly recommended. Leveraging OIDC enables SECA API clients to standardize token
acquisition processes, ensuring compatibility and interoperability beyond the scope of
this specification.
