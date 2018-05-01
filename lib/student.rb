require 'pry'

class Student
  attr_accessor :name, :grade, :id
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    sql_id = <<-SQL
      SELECT last_insert_rowid()
      FROM students
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute(sql_id)[0][0]
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

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all

    sql = <<-SQL 
      SELECT * 
      FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end 

  end

  def self.find_by_name(name)

    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    instance = DB[:conn].execute(sql, name).first
    self.new_from_db(instance)
    
    #[instance @name = name, @grade = grade]
    # .map do |row|
    #   self.new_from_db(row)
    # end.first

  end

  def self.count_all_students_in_grade_9

    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 9
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end 

  end

  def self.students_below_12th_grade

    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade < 12
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end 

  end 

  def self.first_X_students_in_grade_10(x)

    self.all.select do |student|
      student.grade == "10"
    end.values_at(0, x)

    

  end

  
  
  def self.first_student_in_grade_10
 
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT 1
    SQL
    #why do we need to chain .first to the end of the enumerable...if the SQL query is limiting to just 1?
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first 

    #why wouldn't this work?
    # self.all.detect do |student|
    #   student.grade == 10
    # end.first

  end

  def self.all_students_in_grade_X(x)

    sql = <<-sql
    SELECT *
    FROM students
    WHERE grade = ?;
    sql

    DB[:conn].execute(sql, x)

    # self.all.select do |student|
    #   student.grade == x
      
    # end 

  end 

end
