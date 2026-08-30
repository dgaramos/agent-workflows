# Generic spec drift example

An accepted spec says an overdue invoice triggers one notification, while code
retries indefinitely. The classifier returns `code-wrong`, cites the accepted
requirement and retry loop, and recommends correcting code/tests without
changing requirements. A draft spec under an accepted-spec profile policy
returns a handoff; it is never treated as accepted by inference.
