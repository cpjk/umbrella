<img src="umbrella.png" width="100px"></img>
# Umbrella

Khan Academy interview project

## Installation
```shell
$ git clone git@github.com:cpjk/umbrella.git
$ cd umbrella
$ bundle install
```
## Umbrella.infection
This function takes a version string and user, and does a breadth-first traversal of the all users connected to the initial user through 'coaches' and 'is coached by' relationships, setting the version string for all visited users to the given version string.

## Umbrella.limited_infection
This function acts like `Umbrella.infection`, but also takes a user limit, and an optional buffer. The algorithm will infect users through breadth-first traversal, until the user limit is reached. After the limit is reached, the algorithm will try to minimize the number of version differences between users and their coaches and students by traversing through the uninfected siblings of the limit user (via the user through which the limit user was reached), and individually infecting them only if doing so will result in less differences than not infecting them. This approach is naive, because it does not take into account the effect on the next user of infecting/not infecting one user. The buffer is an optional parameter that limits the number of siblings that will be considered after the limit is reached.

## Usage
You can create a network of users with `User#add_coach` and `User#add_student`.

In order to infect a user and the other users connected to him/her, pass the user and the new version to `Umbrella.infection` or `Umbrella.limited_infection`. `Umbrella.limited_infection` also takes a limit for the number of users that should be infected, and an optional `buffer` parameter to limit the number of allowable infections beyond the limit (this can be useful for balancing the number of student-coach version differences possibly caused by prematurely halting the infection).

Example usage:

```ruby
u1 = User.new
u2 = User.new
u3 = User.new
u4 = User.new
u5 = User.new
User.add_student(u1, u2)
User.add_student(u2, u3)
User.add_student(u3, u4)
User.add_student(u4, u5)

Umbrella.limited_infection(start_user=u1, version="v0.1.1", limit=3, buffer=1)
```

## Testing

Umbrella uses [minitest](https://github.com/seattlerb/minitest) for testing. To run the tests:
```shell
$ bundle exec rake test
```
