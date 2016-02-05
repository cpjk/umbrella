require "minitest/autorun"
require_relative "../lib/umbrella"
require "pry"

class UserTest < Minitest::Test

  def test_adding_student_adds_student
    u1 = User.new
    u2 = User.new

    u1.add_student u2

    assert u1.edges_to_students[0].to_user == u2
  end

  def test_removing_student_removes_student
    u1 = User.new
    u2 = User.new

    u1.add_student u2
    u1.remove_student u2

    assert u1.edges_to_students.empty?
  end

  def test_adding_coach_adds_coach
    u1 = User.new
    u2 = User.new

    u1.add_coach u2

    assert u1.edges_to_coaches[0].to_user == u2
  end

  def test_removing_coach_removes_coach
    u1 = User.new
    u2 = User.new

    u1.add_coach u2
    u1.remove_coach u2

    assert u1.edges_to_coaches.empty?
  end

  def test_edges_returns_all_edges
    u1 = User.new
    u2 = User.new

    u1.add_coach u2
    u1.add_student u2

    assert u1.edges - (u1.edges_to_students + u1.edges_to_coaches) == []
  end

  # class method tests

  def test_class_add_coach_adds_coach_and_student_edges
    u1 = User.new
    u2 = User.new

    User.add_coach(u1, u2)

    assert u1.edges_to_coaches[0].to_user == u2
    assert u2.edges_to_students[0].to_user == u1
  end

  def test_class_add_coach_adds_coach_and_student_edges
    u1 = User.new
    u2 = User.new

    User.add_student(u1, u2)

    assert u1.edges_to_students[0].to_user == u2
    assert u2.edges_to_coaches[0].to_user == u1
  end
end
