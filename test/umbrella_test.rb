require "minitest/autorun"
require_relative "../lib/umbrella"

class UmbrellaTest < Minitest::Test

  def test_infects_first_user
    u1 = User.new
    u2 = User.new

    User.add_student(u1, u2)

    Umbrella.infection(u1, "v0.1.1")

    assert u1.site_version == "v0.1.1"
  end

  def test_infects_next_user
    u1 = User.new
    u2 = User.new

    User.add_student(u1, u2)

    Umbrella.infection(u1, "v0.1.1")

    assert u1.site_version == "v0.1.1" && u2.site_version == "v0.1.1"
  end

  def test_does_not_infect_unconnected_user
    u1 = User.new
    u2 = User.new

    Umbrella.infection(u1, "v0.1.1")

    refute u2.site_version == "v0.1.1"
  end

  def test_circular_relationship
    u1 = User.new
    u2 = User.new
    u3 = User.new

    User.add_student(u1, u2)
    User.add_student(u2, u3)
    User.add_student(u3, u1)

    Umbrella.infection(u1, "v0.1.1")

    assert u1.site_version == "v0.1.1"
    assert u2.site_version == "v0.1.1"
    assert u3.site_version == "v0.1.1"
  end

  def test_limited_infection_infects_first_user
    u1 = User.new
    u2 = User.new

    User.add_student(u1, u2)

    Umbrella.limited_infection(u1, "v0.1.1", limit=2, buffer=1)

    assert u1.site_version == "v0.1.1"
  end

  def test_limited_infection_limited_infection_infects_next_user
    u1 = User.new
    u2 = User.new

    User.add_student(u1, u2)

    Umbrella.limited_infection(u1, "v0.1.1", 4, 0)

    assert u1.site_version == "v0.1.1" && u2.site_version == "v0.1.1"
  end

  def test_limited_infection_does_not_infect_unconnected_user
    u1 = User.new
    u2 = User.new

    Umbrella.limited_infection(u1, "v0.1.1", 4, 0)

    refute u2.site_version == "v0.1.1"
  end

  def test_limited_infection_circular_relationship
    u1 = User.new
    u2 = User.new
    u3 = User.new

    User.add_student(u1, u2)
    User.add_student(u2, u3)
    User.add_student(u3, u1)

    Umbrella.limited_infection(u1, "v0.1.1", 4, 0)

    assert u1.site_version == "v0.1.1"
    assert u2.site_version == "v0.1.1"
    assert u3.site_version == "v0.1.1"
  end

  def test_limited_infect_infects_up_to_limit
    u1 = User.new
    u2 = User.new
    u3 = User.new
    u4 = User.new
    u5 = User.new

    User.add_student(u1, u2)
    User.add_student(u2, u3)
    User.add_student(u3, u4)
    User.add_student(u4, u5)

    Umbrella.limited_infection(u1, "v0.1.1", 2, 0)

    assert u1.site_version == "v0.1.1"
    assert u2.site_version == "v0.1.1"
    refute u3.site_version == "v0.1.1"
  end

  def test_limited_infect_minimizes_diffs_after_limit
    u1 = User.new
    u2 = User.new
    u3 = User.new
    u4 = User.new
    u5 = User.new

    User.add_student(u1, u2)
    User.add_student(u1, u3)
    User.add_student(u3, u4)
    User.add_student(u3, u5)

    Umbrella.limited_infection(u1, "v0.1.1", 2, 1)

    assert u1.site_version == "v0.1.1"
    assert u2.site_version == "v0.1.1"

    # u3 should not be infected, since infecting it will create
    # two version differences (with its children)
    # vs one difference if it is uninfected (with its coach)
    refute u3.site_version == "v0.1.1"
    refute u4.site_version == "v0.1.1"
    refute u5.site_version == "v0.1.1"

    u1 = User.new
    u2 = User.new
    u3 = User.new
    u4 = User.new
    u5 = User.new
    u6 = User.new

    User.add_student(u1, u2)
    User.add_student(u1, u6)
    User.add_student(u1, u3)
    User.add_student(u6, u3)
    User.add_student(u3, u4)

    Umbrella.limited_infection(u1, "v0.1.1", 3, 1)

    assert u1.site_version == "v0.1.1"
    assert u2.site_version == "v0.1.1"
    assert u6.site_version == "v0.1.1"

    # u3 should be infected, because if uninfected
    # it will create two diffs (with its coaches)
    # as opposed to one diff if infected (with its student)
    assert u3.site_version == "v0.1.1"
    refute u4.site_version == "v0.1.1"
  end

  def test_limited_infect_minimizes_infected_after_limit
    u1 = User.new
    u2 = User.new
    u3 = User.new
    u4 = User.new
    u5 = User.new
    u6 = User.new

    User.add_student(u1, u2)
    User.add_student(u1, u6)
    User.add_student(u1, u3)
    User.add_student(u6, u3)
    User.add_student(u3, u4)
    User.add_student(u3, u5)

    Umbrella.limited_infection(u1, "v0.1.1", 2, 1)

    assert u1.site_version == "v0.1.1"
    assert u2.site_version == "v0.1.1"

    # u6 should not be infected, because infecting
    # it will create the same number of diffs as not infecting it
    refute u6.site_version == "v0.1.1"
    refute u3.site_version == "v0.1.1"
    refute u4.site_version == "v0.1.1"
    refute u5.site_version == "v0.1.1"
  end
end
