# Contributing

## Engineering expectations

ApexConvoy changes must respect Salesforce transaction boundaries, governor limits and shared asynchronous capacity.

## Workflow

1. Open or select an issue.
2. Describe the failure and recovery semantics.
3. Add positive, negative, bulk and retry-safety tests as applicable.
4. Validate in a scratch org.
5. Open a focused pull request.

## Definition of done

- Apex compiles at the declared source API version.
- The implementation is bulk-safe.
- Execution state is not overstated.
- Retry behaviour is idempotent or explicitly documented otherwise.
- Persistent state has clear transaction and rollback semantics.
- No proprietary employer or client material is included.

## Clean-room rule

Contributors must not copy proprietary source code, metadata or documentation from an employer or client.
