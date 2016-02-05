require_relative "user_edge"

class User
  attr_accessor :site_version

  # allow direct reading but not setting of edges
  attr_reader :edges_to_students
  attr_reader :edges_to_coaches

  def initialize()
    @edges_to_students = []
    @edges_to_coaches = []
  end

  def add_student(student)
    @edges_to_students << UserEdge.new(student)
  end

  def add_coach(coach)
    @edges_to_coaches << UserEdge.new(coach)
  end

  def edges
    edges_to_students + edges_to_coaches
  end

  # class methods

  def self.add_coach(student, coach)
    student.add_coach(coach)
    coach.add_student(student)
  end

  def self.add_student(coach, student)
    coach.add_student(student)
    student.add_coach(coach)
  end
end
