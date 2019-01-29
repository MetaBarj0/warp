# Status
In progress

# Dependencies
Is `part of` `cover_warp_and_warp_shell_with_tests`.

# Topic
Revolves around the general `warp` architecture. As seen in
`cover_warp_and_warp_shell_with_tests`, `warp` is divided in 3 distinct parts.
One of those is the `warp` shell script that is the topic of this requirement.

# Context
As today, `warp` is already segmented in 3 distinct parts :
1. `warp` entrypoint script, checking configuration and fowarding to
   `warp-shell`
2. `warp-shell`, responsible of bootstrapping the system and forwarding unknown
   commands to `warp-native`
3. `warp-native` that is yet to come but will be in charge to execute all
   `warp` features but bootstrap.
Though it is functional, the `warp` script implementation is a litlle bit
cumbersome but worse, is not testable.

# Demand
Provide a suite of test guaranteeing `warp` entrypoint script is testable.
Moreover, `warp` script must be able to ensure the configuration of the host
machine is good to proceed any further. It must also be able to forward command
to the right component of the `warp` project that is :
- bootstrap commands must be forwarded to `warp-shell`.
- other commands must be forwarded to `warp-native`.
- unknown or incorrect commands must trigger an help on usage depending if the
  host machine is bootstrapped or not
It is worth to note that the host system can be in one of these 2 states when
invoking `warp` :
- bootstrapped, meaning the bootstrap process has been run successfully.
- not bootstrapped, meaning the host machine is untouched and need to be
  bootstrapped to go any further.

# Examples mapping

## Invoke warp without any argument

### Examples
One could invoke warp like this
``` bash
./warp
```
### Rules
- Must trigger an help on usage. This help must indicate if the system is
  bootstrapped or not. If the system is bootstrapped, the help must be provided
  by `warp-native` (out of scope).

## Help on usage

### Examples
One could invoke warp to get help, or by typing an incorrect argument
``` bash
./warp help #1
./warp #2
./warp help ignored-arguments... #3
./warp any-argument-but-bootstrap-or-help... #4
```
### Rules
- Must specify that the host system is bootstrapped or not.
- Must be explicitly invokable by `./warp help`
- Must be implicitly triggered by the absence of argument when invoking warp.
  If the host system is bootstrapped, help on usage must be provided by
  `warp-native`, but that is outside of this requirement scope
- Must be implicitly triggered by specifying an unrecognized argument when
  invoking warp. Moreover, the incorrect argument must be reported as incorrect
  or at least, not handled yet if the host system has not been bootstrapped
  yet.
- If the host is bootstrapped, the help on usage must be provided by
  `warp-native`, that is outside of the scope of this requirement

### Questions
1. What about an argument not yet handled by `warp` for instance
   - `./warp image list`
   that could be handled when the system is bootstrapped?

### Answers
1. dealt with the example number 4. Incorrect argument will be specified by
   probably handled when your host machine is bootstrapped

## Recognized arguments
`warp` entrypoint script is only able to provide some help, check the host
machine configuration, bootstrap status, and forward command to the right piece
of the project :
- bootstrap commands to `warp-shell`
- other commands to `warp-native`
Therefore, there is only a limited subset of general command the `warp`
entrypoint script can know :
- The `help` command
- The `bootstrap` command
Moreover, the script must be able to recognize an argument that specifies where
to find the `warp` configuration file. That argument is named
`--configuration-file` in its long version and `-c` in its short version. This
argument is an option accepting a path to a configuration file.

### Examples
``` bash
./warp help
./warp bootstrap ...
./warp help --configuration-file ./warp-config.sh # config file option ignored
./warp -c ../warp-old-config.sh
./warp --configuration-file=/etc/warp-global-conf.sh bootstrap
./warp -c=./warp-config.sh help
```

# References
See in `../notes/testing_shell_scripts.md` about the architecture of testable
shell scripts.
See in `../notes/host_machine_taxonomy.md` to get how a host machine is modified
when using `warp`

# Acceptance Criteria

## Configuration file content criteria
- The `warp` configuration file must be easily understandable and well
  documented
- The `warp` configuration file must contain a variable specifying which
  container technology to use. At this stage, only `docker` is supported
- `warp` entrypoint script source the container technology to use variable
  present in the configuration file
- `warp` entrypoint script must fail if it cannot initialized the container
  technology to use variable from the configuration file.

## Configuration file criteria
- `warp` entrypoint script accepts a configuration file path argument as first
  argument
- By default, the `warp` entrypoint script loads the configuration file in the
  same directory as it with a default name of `warp-config.sh`
- `warp` entrypoint script runs with error if it cannot find or load the
  configuration file.
- `warp` entrypoint script ignore configuration argument if specified after
  another argument.

## Help on usage criteria
- `warp` entrypoint script called without any argument trigger the help on
  usage
- `warp` entrypoint script accepts a `help` argument to display help on usage.
- The help on usage must indicate about the loaded configuration file path
- The help on usage documentation must indicate the host machine is or is not
  bootstrapped yet for a chosen container technology specified in the
  configuration file.
- The help on usage must indicate about the container technology used.

## Bootstrap argument criteria
- `warp` entrypoint script called with a `bootstrap` argument tells the feature
  is not supported yet
