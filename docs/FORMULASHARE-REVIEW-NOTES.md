# FormulaShare review notes

## Purpose

This note records architectural lessons from the open-source [FormulaShare-DX](https://github.com/LawrenceLoz/FormulaShare-DX) project. FormulaShare is MIT licensed by Lawrence Newcombe.

The review validates ApexConvoy's separation as a standalone asynchronous-processing framework. FormulaShare contains mature batch capabilities, but they are coupled to its record-sharing domain, custom objects, metrics, selectors and services. ApexConvoy should generalise the reusable execution concerns without copying FormulaShare-specific implementation.

## Patterns worth adopting

### Batch failure events

FormulaShare batches implement `Database.RaisesPlatformEvents` and process Salesforce `BatchApexErrorEvent` records outside the failed scope transaction.

This addresses a fundamental constraint: when a batch scope throws an unhandled exception, DML and `Database.Stateful` mutations made in that scope roll back. An error-event consumer can record the failure independently.

ApexConvoy should capture:

- asynchronous job ID;
- parent job ID;
- root execution and correlation IDs;
- request ID;
- batch phase;
- failed job scope;
- exception type, message and stack trace;
- event UUID as a deduplication key;
- payload truncation indicators.

### Honest status model

Salesforce may report a Batch Apex job as completed even when application code catches scope failures. ApexConvoy must distinguish platform execution status from business outcome:

- `COMPLETED`;
- `COMPLETED_WITH_ERRORS`;
- `FAILED`;
- `RETRY_SCHEDULED`;
- `EXHAUSTED`;
- `CANCELLED`.

A failed transaction must never be inferred from rolled-back in-memory counters alone.

### Scheduling and concurrency

FormulaShare demonstrates useful platform-aware patterns:

- a stable schedulable wrapper that resolves the actual submitter with `Type.forName()`;
- `AsyncApexJob` selectors for active-job detection;
- parent-job correlation;
- configurable log-cleanup batches;
- chaining work from `finish()`.

ApexConvoy should generalise these patterns through a dispatcher, job registry and explicit overlap policy.

### Summary and detail separation

A production model should separate:

- logical job definition;
- execution;
- attempt;
- completed scope/checkpoint;
- failed item or failed scope;
- diagnostic event.

ApexConvoy owns operational job state. ApexSignal owns diagnostic events. They correlate through identifiers, and neither framework requires the other.

## Patterns to improve rather than reproduce

- Do not store failed scope numbers as comma-separated text.
- Do not let a later exception overwrite the only earlier exception.
- Do not treat `Database.Stateful` as a durable checkpoint.
- Do not swallow an exception and label the business execution successful.
- Do not hard-code one application's batch classes in the core framework.
- Do not introduce a mandatory dependency on fflib or ApexSignal.

## Clean-room and attribution rule

Concepts may inform ApexConvoy's design. FormulaShare source must not be copied without preserving its MIT copyright and licence notice. ApexConvoy implementations should remain independently designed and covered by their own tests and ADRs.
