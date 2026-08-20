# Security policy

## Sensitive material

Do not commit GitHub App private keys, access tokens, installation tokens,
passwords, SSH keys, or copied target-repository credentials. Do not add a
workflow that searches a target repository for credentials.

## Publication boundary

Review publication is opt-in for every invocation. A portable workflow may
prepare a review body or inline comments, but it must not submit them until the
user explicitly requests publication and a publisher is configured outside this
repository.

## Reporting

Report a security concern privately to the repository owner. Do not include
sensitive evidence in a public issue.
