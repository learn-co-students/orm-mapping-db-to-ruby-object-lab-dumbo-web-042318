require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row [1]
    student.grade = row [2]
    student
    # create a new Student object given a row from the database
  end

  def self.all
      i=0
      new_arr=[]
      sql = <<-SQL
        SELECT * FROM students;

      SQL
      arr = DB[:conn].execute(sql)
      # binding.pry
      # return arr
      arr.each do |x|
        new_arr[i] = new_from_db(x)
        i+=1
      end
        new_arr

    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
      LIMIT 1;
    SQL

    student = DB[:conn].execute(sql, name)
    new_from_db(student[0])
    # binding.pry
    # find the student in the database given a name
    # return a new instance of the Student class
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

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT name FROM students
      WHERE grade = 9;

    SQL
    arr = DB[:conn].execute(sql)
    return arr
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT name FROM students
      WHERE grade <= 11;

    SQL
    arr = DB[:conn].execute(sql)
    return arr
  end

  def self.first_X_students_in_grade_10(x)

    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT ?;
    SQL
    arr = DB[:conn].execute(sql,x)

    return arr

  end

  def self.first_student_in_grade_10

    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT ?;
    SQL
    arr = DB[:conn].execute(sql,1)
    new_from_db(arr[0])

  end

  def self.all_students_in_grade_X(x)
    # i=0
    # new_arr=[]
    # student=[]
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
    SQL
    DB[:conn].execute(sql,x)

    # arr.each do |x|
    #   student[0] = new_from_db(x)
    #   new_arr[i] = student
    #   i+=1
      # binding.pry

    # end
      # new_arr.uniq!
# binding.pry
# true
  end

end
