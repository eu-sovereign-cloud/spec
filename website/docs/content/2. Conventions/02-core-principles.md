# Core Principles

Cloud providers' APIs enable seamless integration and management of cloud resources through programmable interfaces.
These APIs allow developers and system administrators to interact with various cloud services, such as computing power, storage, databases, networking, and machine learning, directly through code or command-line tools. By using these APIs, users can automate workflows, scale resources, and perform tasks like provisioning new instances, configuring virtual networks, or managing user permissions with precision and efficiency. Cloud APIs offer flexibility and control, making it easier to build, deploy, and manage applications in dynamic and scalable environments.

A properly designed REST API should support:

## Platform independence

* Any client should be able to call the API regardless of how it is implemented internally.

## Standard protocols

* No platform independence would be possible without a mechanism that allows the client and the Web service to agree on the format of the data to be exchanged.

## Service evolution

* The REST API must have the ability to evolve and add functionalities independently from client applications.
* With the evolution of the API:
  * Client applications should continue to function without modifications.
  * All functionalities should be discoverable in order to be fully utilized by client applications.
