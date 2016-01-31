require "minitest/autorun"
require_relative "../infection"

class InfectionTest < Minitest::Test

  def test_infects_first_user
    u1 = User.new
    u2 = User.new

    u1.add_student u2
    u2.add_coach u1

    infect(u1, "v0.1.1")

    assert u1.site_version == "v0.1.1"
  end

  def test_infects_next_user
    u1 = User.new
    u2 = User.new

    u1.add_student u2
    u2.add_coach u1

    infect(u1, "v0.1.1")

    assert u1.site_version == "v0.1.1" && u2.site_version == "v0.1.1"
  end

  def test_does_not_infect_unconnected_user
    u1 = User.new
    u2 = User.new

    infect(u1, "v0.1.1")

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

    infect(u1, "v0.1.1")

    assert u1.site_version == "v0.1.1"
    assert u2.site_version == "v0.1.1"
    assert u3.site_version == "v0.1.1"
  end
end
