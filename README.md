<img src="umbrella.png" width="100px"></img>
# Umbrella

Khan Academy interview project

## Installation
```shell
$ git clone git@github.com:cpjk/umbrella.git
$ cd umbrella
$ bundle install
```

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

u1.add_student u2
u2.add_coach u1
u2.add_student u3
u3.add_coach u2
u3.add_student u4
u4.add_coach u3
u4.add_student u5
u5.add_coach u4

Umbrella.limited_infection(start_user=u1, version="v0.1.1", limit=3, buffer=1)
```
