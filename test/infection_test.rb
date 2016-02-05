require "minitest/autorun"
require_relative "../lib/infection"

class InfectionTest < Minitest::Test

  def test_infects_first_user
    u1 = User.new
    u2 = User.new

    u1.add_student u2
    u2.add_coach u1

    Infection.infect(u1, "v0.1.1")

    assert u1.site_version == "v0.1.1"
  end

  def test_infects_next_user
    u1 = User.new
    u2 = User.new

    u1.add_student u2
    u2.add_coach u1

    Infection.infect(u1, "v0.1.1")

    assert u1.site_version == "v0.1.1" && u2.site_version == "v0.1.1"
  end

  def test_does_not_infect_unconnected_user
    u1 = User.new
    u2 = User.new

    Infection.infect(u1, "v0.1.1")

    refute u2.site_version == "v0.1.1"
  end

  def test_circular_relationship
    u1 = User.new
    u2 = User.new
    u3 = User.new

    u1.add_student u2
    u2.add_coach u1
    u2.add_student u3
    u3.add_coach u2
    u3.add_student u1
    u1.add_coach u3

    Infection.infect(u1, "v0.1.1")

    assert u1.site_version == "v0.1.1"
    assert u2.site_version == "v0.1.1"
    assert u3.site_version == "v0.1.1"
  end

  def test_limited_infection_infects_first_user
    u1 = User.new
    u2 = User.new

    u1.add_student u2
    u2.add_coach u1

    Infection.limited_infect(u1, "v0.1.1", limit=2, buffer=1)

    assert u1.site_version == "v0.1.1"
  end

  def test_limited_infection_limited_infection_infects_next_user
    u1 = User.new
    u2 = User.new

    u1.add_student u2
    u2.add_coach u1

    Infection.limited_infect(u1, "v0.1.1", 4, 0)

    assert u1.site_version == "v0.1.1" && u2.site_version == "v0.1.1"
  end

  def test_limited_infection_does_not_infect_unconnected_user
    u1 = User.new
    u2 = User.new

    Infection.limited_infect(u1, "v0.1.1", 4, 0)

    refute u2.site_version == "v0.1.1"
  end

  def test_limited_infection_circular_relationship
    u1 = User.new
    u2 = User.new
    u3 = User.new

    u1.add_student u2
    u2.add_coach u1
    u2.add_student u3
    u3.add_coach u2
    u3.add_student u1
    u1.add_coach u3

    Infection.limited_infect(u1, "v0.1.1", 4, 0)

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

    u1.add_student u2
    u2.add_coach u1
    u2.add_student u3
    u3.add_coach u2
    u3.add_student u4
    u4.add_coach u3
    u4.add_student u5
    u5.add_coach u4

    Infection.limited_infect(u1, "v0.1.1", 2, 0)
    assert u1.site_version == "v0.1.1"
    assert u2.site_version == "v0.1.1"
    refute u3.site_version == "v0.1.1"
  end

  def test_limited_infect_infects_up_to_limit_plus_buffer
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

    Infection.limited_infect(u1, "v0.1.1", 3, 1)
    assert u1.site_version == "v0.1.1"
    assert u2.site_version == "v0.1.1"
    assert u3.site_version == "v0.1.1"
    refute u4.site_version == "v0.1.1"
  end
end
