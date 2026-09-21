# Roadmap

## v0.1 — Batch lifecycle foundation

- [x] Template-method Batch Apex base class
- [x] Execution and correlation context
- [x] Structured scope results
- [x] Stateful job summary
- [x] Completion hook
- [x] Partial-save result helper
- [x] Example implementation and unit tests

## v0.2 — Durable execution model

- [ ] Job, attempt, checkpoint and failed-item objects
- [ ] Custom Metadata job definitions
- [ ] Record-level failure capture
- [ ] Idempotency contracts and keys
- [ ] Restart from durable checkpoint
- [ ] Retention and cleanup policies

## v0.3 — Retry and orchestration

- [ ] Retry policies with bounded backoff
- [ ] Dead-letter workflow
- [ ] Job chaining and dependency graph
- [ ] Queueable execution strategy
- [ ] Scheduled dispatch
- [ ] Cancellation and pause/resume controls

## v0.4 — Operations

- [ ] Concurrency and duplicate-run protection
- [ ] Flex Queue visibility
- [ ] LWC administration console
- [ ] Progress, throughput and error metrics
- [ ] Optional ApexSignal adapter
- [ ] Alerts and external export

## Future exploration

- Apex Cursor execution strategy where appropriate
- Adaptive scope sizing based on workload evidence
- Multi-org control-plane patterns
