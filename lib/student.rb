class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student=self.new
    student.id=row[0]
    student.name=row[1]
    student.grade=row[2]
    student
  end

  def self.count_all_students_in_grade_9
   DB[:conn].execute("SELECT COUNT(students.id) FROM students
   GROUP BY grade
   HAVING students.grade=9;")
  end

  def self.students_below_12th_grade
    DB[:conn].execute("SELECT COUNT(students.id) FROM students
    GROUP BY grade
    HAVING students.grade<12;")
  end

  def self.first_x_students_in_grade_10(number)
    DB[:conn].execute("SELECT * FROM students
    WHERE students.grade=10
    LIMIT ?;", number)
  end

  def self.first_student_in_grade_10
    row=DB[:conn].execute("SELECT * FROM students
    WHERE students.grade=10
    LIMIT 1;")

    Student.new_from_db(row[0])
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = ?
    SQL

    DB[:conn].execute(sql, grade)
  end

  def self.all
    sql = <<-SQL
    SELECT * FROM students
    SQL

    all_rows=DB[:conn].execute(sql)
    all_rows.collect do |row|
      Student.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE students.name = ?
    SQL

    results=DB[:conn].execute(sql, name)

    Student.new_from_db(results[0])
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
