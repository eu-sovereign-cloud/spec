# HTTP Semantics

This section describes some typical considerations for designing an API that complies with the HTTP specification. However, it does not cover every possible detail or scenario. In case of doubt, consult the HTTP specifications.

## Media Type

As mentioned earlier, clients and servers exchange representations of resources. In a PUT request, for example, the request body contains a representation of the resource to be created. In a GET request, the response body contains a representation of the retrieved resource.

* In the HTTP protocol, formats are specified using Media Types, also known as MIME types. For non-binary data, most Web APIs support JSON (i.e., the media type application/json) and possibly XML (i.e., the media type application/xml).

The Content-Type header specifies the format of the representation. Below is an example of a PUT request containing JSON data:

```javascript
PUT https://api.cloud.eu/${scope}/compute/instances/my-vm HTTP/1.1
Content-Type: application/json; charset=utf-8
Content-Length: 47

{"profile":"K0063","OS":"Ubuntu24.01"}
```

* If the server does not support the media type, it must return the HTTP status code 415 (Unsupported Media Type).

A client request can include an Accept header containing a list of media types that the client will accept in the server’s response. For example:

```javascript
GET https://api.cloud.eu/${scope}/compute/instances/my-vm HTTP/1.1
Accept: application/json
```

* If the server cannot provide a media type matching those listed, it must return the HTTP status code 406 (Not Acceptable).

### JSON

#### Casing

* *The field casing adopted is **camelCase**.

#### Naming

* *The identifier field of an object will be expressed in the following form: objectId.

#### Type Conversion

* *For those media types where there is no 1:1 conversion between the server-side data type and the one transmitted to clients, we adopt the following convention:

| Native Type | JSON Type | Format Spec | Note |
|-------------|-------------|-------------|-------------|
| null| null | | |
| boolean | bool | | |
| byte, int32, int64, uint32, uint64, float, double | number culture-invariant string | All numbers up to a maximum precision of 64 bits ([IEEE 754](https://en.wikipedia.org/wiki/IEEE_754), [binary64](https://en.wikipedia.org/wiki/Double-precision_floating-point_format)). | ```json {"add": 123.5} ```<br/>```json {"add": 5} ```<br/>```json {"add": "136573525573.86576576"} ``` |
| decimal/arbitrary precision numbers | Culture-invariant string | `(?<sign>[+\|-])?(?<number>\d+)(?<digits>(?<separator>\.)\d+)?` | ```json {"add": "136573525573.86576576"} ``` |
| string | string | [UTF-8](https://en.wikipedia.org/wiki/UTF-8) | If necessary, [UTF-16](https://en.wikipedia.org/wiki/UTF-16) surrogate pairs should be used for escape sequences of glyphs outside the [Basic Multilingual Plane](https://en.wikipedia.org/wiki/Plane_(Unicode)#Basic_Multilingual_Plane) (U+10000 to U+10FFFF)|
| GUID/UUID/ULID | String | `(?<uuid>[0123456789abcdef]{32})` | Example: `a2b4c746c71745a8ad8f3cf7a1cede9b` |
| blob | string | [base64](https://en.wikipedia.org/wiki/Base64) | |
| date, time, datetime, duration, time intervals | string | [RFC339](https://datatracker.ietf.org/doc/html/rfc3339) ([ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) profile) | Time: 09:30,<br/> UtcTime: 09:30Z,<br/> DateTime: 2020-02-26T16:23:11.1196470+01:00,<br/> UtcDateTime: 2020-02-26T15:23:11.1280371Z,<br/> Duration: P3Y6M4DT12H30M5S,<br/> StartAndEndTimeInterval: 2007-03-01T13:00:00Z/2008-05-11T15:30:00Z,<br/> StartAndDurationTimeInterval: 2007-03-01T13:00:00Z/P1Y2M10DT2H30M,<br/> DurationAndEndTimeInterval: P1Y2M10DT2H30M/2008-05-11T15:30:00Z,<br/> DurationOnlyTimeInterval: P1Y2M10DT2H30M``` |
| enum | string | conversion to string with camelCase |  |

### GET Method

* *A successful GET method typically returns the HTTP status code 200 (OK). If the resource is not found, the method should return 404 (Not Found)

### HEAD Method

* *The **HEAD** method requires a response identical to the GET method (using the same semantics as GET), but without returning the response body to the client. It can be used to check the existence of a resource.
The HEAD method is not standardized by the SECA API.

### PUT Method

* *If a **PUT** method creates a new resource, it must return the HTTP status code 202 (Accepted). The URI of the new resource is included in the Location header of the response.
* *If the method updates an existing resource, it will return 202 also. In some cases, it may not be possible to update an existing resource. In such circumstances, consider returning the HTTP status code 409 (Conflict).

### POST Method

* *When it performs a processing task the method may return the HTTP status code 200 and include the result of the operation in the response body.
* *If there are no results, the method can return the HTTP status code 204 (No Content) without a response body, or HTTP 202 (Accepted) if an asynchronous process has been initiated.
  * *In this case, the Location header will contain a reference to a resource that can provide the status of the request's progress.

If the client submits invalid data in the request, the server must return the HTTP status code 400 (Bad Request). The response body should contain additional information about the error or a link to a URI providing more details

### DELETE Method

* *The API will respond with the HTTP status code 204 indicating that the process was handled correctly and that the response body will not contain further information.

### Conditional Requests

See the dedicated [reference](https://datatracker.ietf.org/doc/html/rfc7232) for further details. In short, it's possible to define precondition needed to consider a request valid.

* *These preconditions are usually expressed through specific headers and are used in scenarios where multiple actors are simultaneously modifying a resource. Preconditions (based on an ETag, for example) help prevent the lost update phenomenon.

### Status Code

#### Group By Category

##### 1xx Informational

Not to be used except in experimental conditions, as they are not standardized.

##### 2xx Success

This class of status codes indicates that the action requested by the client has been received, understood, and accepted.

##### 3xx Redirection

This class of status codes indicates that the client must take further action to complete the request. Many of these status codes are used for [URL redirection](https://en.wikipedia.org/wiki/URL_redirection). A user agent may perform the action without user intervention only if the method to be used is GET or HEAD. A user agent may automatically redirect a request. A user agent should detect and prevent any cyclic redirects.

##### 4xx Client Error

This class of status codes is to be used in cases where the client is the cause of the error. Except for HEAD requests, the server should include an entity/representation containing an explanation of the error and whether it is transient or permanent. These status codes are applicable to all methods. User agents should display the information to users.

##### 5xx Server Error

The server was unable to fulfill the request. Status codes that begin with the digit "5" indicate cases where the server encountered an error or was otherwise unable to process the request. Except for HEAD requests, the server should include an entity/representation containing an explanation of the error and whether it is transient or permanent. These status codes are applicable to all methods. User agents should display the information to users.

#### Status Detail

[Reference](https://httpstatuses.com/)

##### 200 OK

Indicates that the client's request has been successfully processed and that there is no more appropriate status code in the 2xx category. Unlike status code 204, a response with a 200 code should include a body. The information returned depends on the method used in the request, for example:

* **GET** - the requested entity.
* **HEAD** - the HTTP headers of the requested entity.
* **POST** - an entity that describes or contains the result of the request.

##### 201 Created

This status code indicates that the resource has been successfully created. If the action cannot be completed immediately, the server must respond with a 202 Accepted status code.

##### 202 Accepted

This status code signifies that the request has been accepted for processing, but the operation has not been completed yet. This is common for long-running operations. The outcome of the request is therefore not yet known and could be prevented if attempted again before the previous process has finished. The purpose is to allow the server to accept a request for another process (normally asynchronous/long-running/scheduled) without forcing the user agent to keep a connection open until the procedure is completed. The entity returned with the response should include an indication of the current status of the request and a pointer to a resource that shows the progress of the task. The Location header can be used instead of a body. The response might also include, in its headers, an estimated time for when the asynchronous process will be completed.

##### 204 No Content

The server has successfully processed the request, and there is no body in the response.

##### 302 Found

The target resource resides temporarily under a different URI. Since the redirection might be altered on occasion, the client ought to continue to use the effective request URI for future requests.

##### 303 See Other

The server is redirecting the user agent to a different resource, as indicated by a URI in the Location header field, which is intended to provide an indirect response to the original request.

##### 304 Not Modified

If the client makes a conditional request (e.g., using the If-Modified-Since or ETag headers), and the resource has not changed. The returned status code indicates that a cached version would be still considered valid.

##### 400 Bad Request

400 is the generic client-side error status, used when no other code in the 4xx error category is more appropriate. Request errors (body or parameters) can fall into this category. The client should not repeat the request without making the appropriate changes, which may be indicated in the response of the previous invalid request.

##### 401 Unauthorized

A 401 error indicates that the client attempted to operate on a resource without providing the necessary credentials. The response must include the WWW-Authenticate header containing a challenge applicable to the requested resource. The client may repeat the request with the appropriate Authorization header. If the initial request already included the header, the 401 response indicates that authorization was denied for those credentials.

##### 403 Forbidden

A 403 code indicates that the request is formally valid, even from an authentication perspective, but the server refuses to process it because the user lacks the necessary permissions, or the resource's state does not allow this particular operation. A 403 response is not a case of incorrect credentials; that would be the 401 Unauthorized code. Re-authenticating would not resolve the issue, and the request should not be repeated, as the problem lies with permissions, not credentials.

##### 404 Not Found

The 404 status indicates that the requested resource could not be found by the client via the URI, but it may become available in the future, so further requests from the client are allowed. No indication is given as to whether the condition is permanent or temporary.

##### 405 Method Not Allowed

The requested URL exists, but the HTTP method used in the request is not allowed for that URL.

##### 409 Conflict

The request could not be completed due to a conflict with the current state of the target resource. This code is used in situations where the user might be able to resolve the conflict and resubmit the request.

##### 412 Precondition Failed

The 412 code indicates that the preconditions expressed by the client in the request headers could not be met by the server (e.g., If-Match).

##### 415 Unsupported Media Type

The origin server is refusing to service the request because the payload is in a format not supported by this method on the target resource.

##### 429 Too Many Requests

The client has sent too many requests in a given amount of time, often due to rate limiting on the server. The server response should include a Retry-After header, which tells the client how long to wait before making additional requests.

##### 500 Server Error

500 is a generic error code. Most web application frameworks return this error when an exception occurs in one of the components handling the requests. A 500 error is not caused by the client, so it is reasonable for a client to retry the operation to obtain a valid response.

##### 503 Service Unavailable

The server is temporarily unable to handle the request. Unlike a 500 Internal Server Error, which suggests an unexpected issue, a 503 means the downtime is intentional or anticipated. In this case, we aim for Service Maintenance use cases.

#### ProblemDetails - Response Body for 4xx and 5xx Categories

* It is necessary to adopt a shared data model for error responses.

This model is outlined in [RFC 7807 - Problem Details](https://tools.ietf.org/html/rfc7807). Libraries and frameworks for various server-side technologies should provide functionalities to easily adopt this model.

A ProblemDetails object, as specified, can contain the following elements:

##### type (string)

A [URI reference](https://tools.ietf.org/html/rfc3986) that identifies the type of problem. When dereferenced, it should provide human-readable documentation (e.g., using [HTML](https://html.spec.whatwg.org/multipage/)). When this value is not present, it is considered populated with "about:blank".

##### title (string)

A brief, human-readable description of the problem. It should not change between occurrences of the same problem, except for localization needs (e.g., using proactive content negotiation; see [RFC7231](https://tools.ietf.org/html/rfc7231#section-3.4), Section 3.4).

##### status (number)

The HTTP status code ([RFC7231 Section 6](https://tools.ietf.org/html/rfc7231#section-6)) generated by the origin server for this occurrence of the problem.

##### detail (string)

A human-readable explanation that describes this specific occurrence of the problem.

##### instance (string)

A URI reference that uniquely identifies this specific occurrence of the problem. It is useful for tracking the instance of the problem within a structured log. It may be dereferenced to obtain more information, but this is not mandatory.

It may also contain a series of elements that provide additional information for the particular type of problem encountered. For example:

```json
HTTP/1.1 404 Not Found
Content-Type: application/problem+json
Content-Language: en

{
    "type": "https://api.seca.eu/problems/resource-not-existing",
    "title": "Resource Not Found",
    "detail": "The resource my-vm does not exist",
    "instance": "/providers/compute/instances/my-vm"
}
```

Or, in the case of validation problems with a request:

```json
HTTP/1.1 400 Bad Request
Content-Type: application/problem+json
Content-Language: en

{
    "type": "https://api.seca.eu/problems/resource-not-valid",
    "title": "Resource Not Valid",
    "detail": "The resource field size of my-block cannot be empty",
    "instance": "/providers/storage/block-storages/my-block"
}
```
