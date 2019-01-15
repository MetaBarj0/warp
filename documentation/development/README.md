#Development Documentation
##Purpose
This folder gathers all development documentation in a semi-formal way.
The purpose of this documentation is to track development progress of the
`warp` project to maximize its maintainability and understandability.

##Project development approach
The `warp` project development adopts the Acceptance Test Driven Development
approach.
Each aspect of the project (features, enhancements, ...) are driven by
requirements expressed in a semi-formal way as well.

##Actors
Each requirement is tied to one or more actors.
An actor is a stakeholder of the project.
A stakeholder of the project can be an user, one of the `warp` project
maintainer (developer), an hypothetical product owner, ...

##Requirements
A requirement is a demand of a new feature, a fix, an enhancement, a way of
doing things...
The only requisite is a requirement must be relevant for a stakeholder who use
`warp`.

###Requirement recipe
As said, a requirement is written using a semi-formal format so, there is not
any need of a strong discipline to write one.
However, a few elements are need to make the requirement understandable and
relevant :
- A major `topic`, field of application of this requirement. It could be
  `feature`, `enhancement`, `fix`, ...
- One or more related `actors`
- A bit of `context`, explaining how current `warp` implementation work and how
  some stuff is not working as intended or is missing
- The `demand` per se, briefly explaining what to bring to `warp` in order for
  it to perform better
- The `Acceptance Criteria` that are the most important part of the requirement.
  These criteria give the definition of the requirement and all these criteria
  must be met to consider the requirement fulfilled.
- `Examples`, that can help any stakeholder to understand how that requirement
  can be observed in its implementation within the project.
Besides these elements, a requirement author is free to add as many paragraphs
he wants. Keep in mind however that a requirement must be clear and readable.

###Requirement Life Cycle
A requirement birth at any moment of the project development life time.
Initially, it must not be tied to a current development as a requirement does
already exist for it.
A requirement can evolve during its development.
Once a development is finished meaning that all acceptance criteria for a
requirement are met, a requirement must be marked as `done`.
