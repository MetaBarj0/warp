# Host machine transformation
It is crucial to understand the general execution flow of `warp` to go any
further :
```
                                                    warp
+----------------+ bootstrap +-------------------+ command +-----------------+
| untainted host |---------->| bootstrapped host |-------->| warp using host |
+----------------+           +-------------------+         +-----------------+

    ===================================================================>>>
                                    TIME
```
An `untainted host` is a host that have been remained unmodified by the `warp`
project.
A `bootstrapped host` is a host on which the bootstrap process of the `warp`
project has been successfully run onto and that is ready to use the full set
of command of the `warp project`.
A `warp using host` is a host both bootstrapped and that had executed at least
one command from the full feature set of `warp`

# Bootstrap and configuration
`warp` behavior is ruled by the content of its configuration file. As a result,
a host machine bootstrap with a certain configuration is not considered
bootstrapped with another configuration.
