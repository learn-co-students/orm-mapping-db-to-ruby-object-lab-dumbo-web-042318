require 'pry'
class Student
  attr_accessor :id, :name, :grade
  
  def self.table
    return self.name.downcase + 's'
  end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new 
    new_student.id = row[0]
    new_student.name =  row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.multi_new_from_db(sql, *params)
    # return an array of student objects from the database
    DB[:conn].execute(sql, *params).map do |student|
      self.new_from_db(student)
    end
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT * 
      FROM #{self.table};"
    self.multi_new_from_db(sql) 
  end

  def self.count_all_students_in_grade_9
    sql = "SELECT *
      FROM #{self.table}
      WHERE grade = 9;"
    return self.multi_new_from_db(sql) 
  end

  def self.students_below_12th_grade
    sql = "SELECT *
      FROM #{self.table}
      WHERE grade < 12;"
    return self.multi_new_from_db(sql)
  end

  def self.first_X_students_in_grade_10(num)
    sql = "SELECT *
      FROM #{self.table}
      WHERE grade = 10
      LIMIT ?"
    return self.multi_new_from_db(sql, num)
  end
 
  def self.first_student_in_grade_10
    return self.first_X_students_in_grade_10(1)[0]
  end

  def self.all_students_in_grade_X(num)
    sql = "SELECT *
      FROM #{self.table}
      WHERE grade = ?"
    return self.multi_new_from_db(sql, num)
  end


  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = "SELECT * 
      FROM #{self.table}
      WHERE name = ?;"
    person = DB[:conn].execute(sql,name)[0] # THIS NATURALLY RETURNS AN ARRAY OF HASHES/ARRAYS SO USE 0 OR FLATTEN
    return self.new_from_db(person)
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
