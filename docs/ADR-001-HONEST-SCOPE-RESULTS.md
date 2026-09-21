# ADR-001: Use explicit scope results

- **Status:** Accepted
- **Date:** 2026-09-21

## Context

Counting a scope as successful merely because its method returned hides partial DML failures. Conversely, catching every exception can make a failed Batch Apex job appear successful.

## Decision

Business handlers return an `ApexConvoyScopeResult` containing attempted, successful and failed counts. A helper converts partial-save `Database.SaveResult` collections into this model. Unhandled scope exceptions are not swallowed.

## Consequences

- Job summaries describe completed scope transactions honestly.
- Applications can use partial DML deliberately.
- Future failed-item persistence can extend the result model.
- Failed transaction state cannot be treated as a durable checkpoint.
