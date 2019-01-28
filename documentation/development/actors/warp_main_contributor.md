# Who
The warp main contributor is the developer who initially created `carrier`

# Context
`carrier` is a system that takes place on top of `docker` and manage on-premise
built images and appliances at a certain level.

This actor is responsible to migrate `carrier` to `warp`.

The very main purpose of this is to drastically augment the maintainability of
the project.

Another very important purpose is to decouple at maximum `warp` from any
specific container or appliance system. As an image, `carrier` was thought to
be used on top of `docker` and only `docker`. Thus, `warp` must be usable on top
of `docker` but also on top of any other container and appliance system such as
`linux namespace and cgroups native manipulation` for instance, or why not,
`rkt` or even `windows containers`.

A by product of this maintainability enhancement is the possibility to add new
features in `warp` that do not exist and never exist in `carrier`.

# Roles
- This actor is the main contributor of `carrier`
- requirements associated with this actor are all about maintainability of the
  project