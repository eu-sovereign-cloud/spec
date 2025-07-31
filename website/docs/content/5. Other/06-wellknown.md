# Well-known URI

A "Well-Known Uniform Resource Identifier" (well-known URI) is a standardized URL path that enables applications to automatically discover important configuration details about a service, without requiring manual setup or hardcoded endpoints. For the SECA API, well-known URIs allow client applications to programmatically retrieve configuration information needed to interact with the API, streamlining integration and reducing the risk of configuration errors. This mechanism promotes interoperability by ensuring that clients can always locate the necessary settings in a predictable location.

This specification defines well-known URIs only for global SECA API providers and their endpoints. Regional providers and endpoints are addressed separately in the regional SECA API specification.

The format of the well-known URI defined in [this OpenAPI specification](/docs/api/Extensions/Wellknown-v1/get-wellknown).

## Well-known Authentication

Since the SECA API does not enforce a specific authentication model,
support for one of the following authentication methods is recommended:

* [`oauth-authorization-server`](https://www.rfc-editor.org/rfc/rfc8414.html)
* [`openid-configuration`](http://openid.net/specs/openid-connect-discovery-1_0.html)
