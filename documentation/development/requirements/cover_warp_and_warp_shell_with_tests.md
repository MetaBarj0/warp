#Status
In progress

#Topic
Consists in getting `warp` and `warp-shell` scripts testable in a way to ensure
a maximum maintainability even at shell script level.

#Related actors
Contributors primarily, users at a lesser extent, to build confidence

#Context
`warp` is segmented in 3 parts so far.

The first, that is the entry point is the `warp` shell script. Its purpose is
to make basic check and commands about configuration and forward further
execution to `warp-shell`.

The second is `warp-shell`. This intermediate shell script is responsible to
bootstrap the host machine to get it able to run the full feature set of
`warp`. It is a way more complex than the `warp` shell script entry point but
similar in functionnality so to speak. It attempts to bootstrap the system if
user is issuing the right command, otherwise, it forwards further execution to
`warp-native`

The third and last part is `warp-native`. It is not yet started but it is
intended to be able to execute the whole `warp` feature set except the
`bootstrap` process, taken care by the `warp-shell` part. As its name suggests,
this part will be using a compiled language and be executed in a mastered
environment, a container in a linux subsystem.

#Demand
Cover the 'warp' and 'warp-shell' with tests, ensuring maximum maintainability
even for shell script parts of `warp`

#Dependencies
- `part of` the `warp_maximum_maintainability`

#References
- A note explaining how to get testable shell scripts :
  `../notes/testing_shell_scripts.md`

#Acceptance Criteria
- A suite of tests exists and is fully executable to test 'warp' and
  'warp-shell'
- Created suite of tests must be runnable using CTest tool
- 'warp' and 'warp-shell' must at least keep their current features working
