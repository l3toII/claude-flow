## Summary

**Story**: [{{story_id}}]({{orchestrator_url}}/project/backlog/{{story_file}}) - {{story_title}}
**Ticket**: Closes #{{app_ticket_number}}

{{story_context}}

## Related

| Type | Reference |
|------|-----------|
| Story (orchestrator) | {{story_id}} |
| Ticket ({{app_name}}) | Closes #{{app_ticket_number}} |

## Changes

{{commits_summary}}

<details>
<summary>Files changed ({{files_count}})</summary>

{{files_changed_list}}

</details>

## Test Plan

{{acceptance_criteria_as_checklist}}

## Review

{{review_agent_verdict}}

{{#if review_warnings}}
<details>
<summary>Warnings ({{warnings_count}})</summary>

{{review_agent_warnings}}

</details>
{{/if}}

{{#if has_screenshots}}
## Screenshots

{{screenshots}}
{{/if}}

{{#if has_breaking_changes}}
## Breaking Changes

{{breaking_changes}}
{{/if}}

## Checklist

- [ ] Tests passent
- [ ] Review agent OK
- [ ] Testé manuellement
