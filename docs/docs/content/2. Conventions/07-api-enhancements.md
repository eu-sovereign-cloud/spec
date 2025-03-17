# API Enhancements

## Filtering

By exposing a collection of resources through a single URI, applications might retrieve large amounts of data when only a subset of information is needed. For example, a client application needs to find a resources subset. It could retrieve all resources from the URI collection and then filter. This process is clearly inefficient.

To improve client and server needs the API can allow passing a filter in the query string of the URI. We support to filter out only by labels and therefore clients should define a labelSelector queryParam.

The **labelSelector** parameter allows you to filter resources based on their labels.

### Equality-Based Selectors

Equality-based selectors allow you to filter resources by exact label matches. They support two operators:

* *= or ==: Selects resources that match the label key-value pair.
* *!=: Excludes resources that match the label key-value pair.

1. Single Label Match
    Selects resources where the label environment is production.
    > labelSelector=environment=production
2. Multiple Labels (AND Condition):
    Selects resources where app=my-app and environment=production
    > labelSelector=app=my-app,environment=production
3. Label Exclusion:
    Selects resources where environment is not production.
    > labelSelector=environment!=production

#### Set-Based Selectors

Set-based selectors are more advanced and allow you to specify lists of possible values. They use three operators:

* ***in**: Selects resources with a label key that matches any value in a given set.
* ***notin**: Selects resources with a label key that does not match any value in a given set.
* ***exists**: Selects resources with a particular label key, regardless of its value.

1. Label Value in Set
    Selects resources where environment is either production or staging
    > labelSelector=environment in (production, staging)
2. Label Value Not in Set:
    Selects resources where environment is not development or test.
    > labelSelector=environment notin (development, test)
3. Label Key Exists:
    Selects resources that have the app label, regardless of its value.
    > labelSelector=app

### Combining Selectors

You can combine equality-based and set-based selectors to create more complex filters. When using multiple conditions, each is treated as an **AND** condition.

Example:

* *app=my-app
* *environment is either production or staging
* *tier is not frontend

> labelSelector=app=my-app,environment in (production, staging),tier!=frontend

* ***Logical OR is not supported**: Multiple label conditions in a single selector are implicitly combined with AND logic.
* ***URL Encoding**: When using labelSelector in a URL, certain characters (=, !=, ,, in, notin, exists) need URL encoding. For example, labelSelector=app%3Dmy-app.

This flexible labeling structure enables precise filtering of resources like in Kubernetes

## Pagination

Pagination helps manage large data sets by dividing responses into "pages" of data. This prevents overwhelming the API consumer and ensures efficient API performance.

For endpoints returning continuously changing data, cursor-based pagination offers better performance and consistency. A cursor token is used to fetch the next page of data.

We call this param **skipToken** and **limit**

* *It's a query parameter used in API requests to handle pagination in responses for large datasets. The skip token is essentially a marker that tells the API where to continue retrieving results from, allowing clients to navigate through paginated data efficiently.
* *When an API returns a skip token, the client includes it in the next request to retrieve the subsequent set of results; In the response it's included in the metadata structure.
* *The number of returned resources can be limited with the parameter "limit".

This process is repeated, with each nextLink providing a new skip token, until there are no further results.

Using a skip token for pagination in APIs can introduce consistency challenges, especially in systems where data is frequently updated. This is because data may change between paginated requests, potentially leading to gaps, duplicates, or outdated information in the results. Here’s how consistency issues arise and strategies to manage them when using skip tokens.

* *As you retrieve pages of data using a skip token, items may be added, deleted, or modified between requests.

Skip tokens are state-based, meaning they’re associated with a specific snapshot of the data state. As data changes, the relevance of the token might diminish, leading to inconsistencies in paginated responses if not handled well.
