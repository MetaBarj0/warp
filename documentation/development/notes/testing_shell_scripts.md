#Observation
The shell scripting language is not strictly tied to a precise programming
paradigm and thus, cannot produce programs that are easily testable if the
programmer does not concieve its scripts with a certain discipline.

#Using shell strengths
However, `sh` can use `functions` and, even import them from external script
files.

Therefore, it is possible to use some sort of `dependency injection` techniques
leading to somewhat testable code.

#Discipline to make tests possible
However, it does not suffice and in order to make a testable script, here are my
ideas about a `shell` program architecture :

- First, and most important, the program *must* remains simple and having only
  one purpose. It could be seen as the application of the `Single Role Purpose`
  principle.
- Then, the script must be architectured having in mind 3 concepts :
  1. I have a `frame` that dictates the flow of the program and is responsible
     to use `components`. The `frame` only manipulates high level abstractions
     using standard flow control and loop constructions.
  2. I have `components` that are script files containing specific functions to
     call in the `frame`. These components contain specific implementation
     details either for the production code or a test double.
  3. I have an `entrypoint` that is resposible to use the `frame` and inject
     `components` into it. The `entrypoint` can be both
     - The program per se
     - A test
  Therefore, this point could be seen as a practical application of some sort of
  the `Dependency injection Principle`.
- The `Open Closed principle` is not a matter here as the program *must* be
  simple and well defined and very limited to one purpose.
- The `Liskow Substitution Principle` is not a matter here as I'm not dealing
  with object oriented programming paradigm.
- The `Interface Segregation Principle` is not a matter, no polymorphism
  involved in shell programming

#Shell program architecture
Therefore, it is possible to design shell programs to be testable, here is how :
```
+-----------+   +-----------+   +-----------+   +-----------+   +-----------+
| component |   | component |   | component |   | component |   | component |
+-----------+   +-----------+   +-----------+   +-----------+   +-----------+
      ^               ^               ^               ^               ^
      |               |               |               |               |
      +---------------+---------------+---------------+---------------+
                                      |
                    +-----------------+-----------------+
                    |                                   |
                    |             +-------+             |
                    |       +---> | frame | <---+       |
                    |       |     +-------+     |       |
                    |       |                   |       |
                    |       |                   |       |
                    |  +------------+   +------------+  |
                    +--| entrypoint |   | entrypoint |--+
                       +------------+   +------------+
```
From bottom to top :
- `entrypoint` is either :
  - the real entrypoint of the program
  - a test
  In all cases, the entrypoint directly use the `frame` which describes the
  internal logic of the program and only uses high level abstractions. in the
  case of shell scripting language, the highest level of abstraction is
  function names. The `entrypoint` is also responsible to inject the
  `component` to use inside the `frame`. Injected component can be a test
  double if the `entrypoint` is a test.
- `frame` is the logic behind the program which is only responsible to use
  abstractions (function calls) in a specific and fixed manner. In no case, the
  `frame` uses some implementation details like real components. It only calls
  functions exposed by components injected by the `entrypoint`
- `component` is a shell script file containing at least one function to use
  within the `frame`. A `component` can be either :
  - a real implementation of the program feature, potentially greedy in term of
    resource, I/O, ..., that is, not usable in a test
  - a test double, simulating one of the program feature, usable in a test.
Notice that from a box perspective, all arrows point toward the same directions.

That is it! With that architecture, I can design fully testable shell program.

#Example
Below is a really silly example of what is a testable shell script. It is a
stupid program intentionnaly designed to be slow that succeeds if a random
number selected at runtime is even and fails if the number is odd.

##Tests
Following the Test Driven Development discipline, let's begin by writing a
test. As seen above, the test is an entrypoint. It uses directly the `frame`
and component script file path to inject and that will be used withing the
frame. let's name the test script file `test_even_random_number.sh`
``` bash
#!/bin/sh
. frame.sh

frame_run \
  'get_even_random_number_mock.sh' \
  'validate_random_number.sh'
```
First, I source the file `frame.sh` that contains the real logic of the program.
Remember the `frame` contains only logic using high level abstractions only.
Next, the `frame_run` function is called. Each `frame` script file *must*
expose a function that can be called by an entrypoint and which accepts one or
more arguments.
Talking about `frame_run` arguments, those are component script file paths :
- `get_even_random_number_mock.sh` contains a test double responsible to
  emulate the production component that is unusable in a testing context
  because of its slowness and produces an even random number
- `validate_random_number.sh` contains the real production code about the
  validation of the random number. There is no need to mock it as meets all
  requirements to be used in a test.
In the same flavor, let's write the test `test_odd_random_number.sh`
``` bash
#!/bin/sh
. frame.sh

frame_run \
  'get_odd_random_number_mock.sh' \
  'validate_random_number.sh'
```
This second test implementation is really obvious and quite similar to the
first test written just before.

##The frame
Let's write the logic of the program called the `frame`. This `frame` *must* be
usable in both a testing context and in the production context. Here is the
content of the `frame.sh` script :
``` bash
function load_components() {
  local component=
  for component in "$@"; do
    . "$component"
  done
}

function run() {
  local number=$(get_random_number) \
    && validate_random_number $number
}

function frame_run() {
  load_components "$@" \
    && run
}
```
Remember that this is the `frame_run` function that is called in the
`entrypoint`.
For the sake of clarity, a couple of functions have been extracted and assigned
the roles of :
- loading specified components by the entrypoint `load_components`
- running the real logic of the program `run`
The logic is really silly here as it consists only in sequential successful
function calls returning the result of the execution of the last executed
function.
The return value of `frame_run` dictates if the program fails or succeeds.

##Components used in testing context
There are :
1. `get_even_random_number_mock.sh` that is a test double specifically designed
   to be used in a testing environment when speed is a mandatory prerequiste
2. Same thing for `get_odd_random_number_moca.sh`.
3. `validate_random_number.sh` that is a production component sufficiently
   quick to be used both in production and testing context
``` bash
# get_even_random_number_mock.sh
function get_random_number() {
  echo 2
}
```
``` bash
# get_odd_random_number_mock.sh
function get_random_number() {
  echo 3
}
```
``` bash
# validate_random_number.sh
function validate_random_number() {
  [ $(( $1 % 2 )) -eq 0 ]
}
```
##Test programs
Below are tests that are executed. They are `entrypoints` injecting a test
double as well as a production component suitable to be used in a test context.
Here is `test_even_random_number.sh`
``` bash
#!/bin/sh
. frame.sh

frame_run \
  'get_even_random_number_mock.sh' \
  'validate_random_number.sh'

[ $? -eq 0 ]
```
Here is `test_odd_random_number.sh`
``` bash
#!/bin/sh
. frame.sh

frame_run \
  'get_odd_random_number_mock.sh' \
  'validate_random_number.sh'

[ $? -ne 0 ]
```
The first test ensure that the call of the `frame_run` function succeeds when
fed with a test double of an even random number generator component and a
random number validator component.
The second test ensure that the call of the `frame_run` function fails when
fed with a test double of an odd random number generator component and a
random number validator component.

##The main program
This is the production `entrypoint`. Its way of working is absolutely similar to
one of the test program above, but instead of injecting a test double as random
number generator, it injects the real production `component` that is designed
to be slow and not usable in a testing context. Let's name it `main.sh`
``` bash
#!/bin/sh
. frame.sh

frame_run \
  'get_random_number.sh' \
  'validate_random_number.sh'
```
You can see here that the first injected `component `is the production one.
Moreover, no check is made to see if the execution of the `fram_run` function
was successfull or not as it does not matter for the production program.

#Summary of the architecture
There are 3 kind of entity :
1. `entrypoints` that are responsible to directly use a `frame` and to inject
   `components` using their script paths. An `entrypoint` can be either the
   program per se or a test.
2. `frames` that contains the logic of the program and manipulate abstractions
   materialized as functions exposed by injected `components`. The only things a
   `frame` know about a component is a function signature, not its
   implementation.  The `frame` is an immutable entity used as is both in the
   production
   `entrypoint` and in a test `entrypoint`.
3. `components` that expose functions used in the `frame`. They are entities
   that know about implementation details. They are injected in `frames` by
   `entrypoints`. Therefore, they can be either production `component` or test
   doubles.
That's it!
