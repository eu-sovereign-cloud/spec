# Asynchronous Operations

![Diagram](@site/static/img/async-request.png)

POST, PUT, or DELETE operation require processing, that takes some time to complete. Waiting for the operation to finish before sending a response to the client can cause unacceptable latency. We make all these operations asynchronous. Return the HTTP status code 202 (Accepted) to indicate that the request has been accepted for processing but has not yet been completed.

If the client sends a GET request to this endpoint, the response must contain the current status of the request. Optionally, it can also include the estimated time for completion.

```json
HTTP/1.1 200 OK
Content-Type: application/json

{

    "status": {
        "state": "Creating",
        "conditions": [
            {
                "type:": "VPCScheduled",
                "status": "True",
                "lastTransitionTime": "2024-11-06T14:25:18Z",
                "reason": "VPCInitialized",
                "message": "The VPC has been initialized successfully"
            }
        ]
    }
}
```

*The API must validate both the request and the action to be performed before starting the long-running process. If the request is invalid or semantically not possible, it should respond immediately with an error code, such as HTTP 400 (Bad Request) or 409 (Conflict).*
