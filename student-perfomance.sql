-- Create students table
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    intake_year INT
);

-- Create linux_grades table
CREATE TABLE linux_grades (
    course_id INT,
    course_name VARCHAR(50),
    student_id INT,
    grade_obtained DECIMAL(5,2)
);

-- Create python_grades table
CREATE TABLE python_grades (
    course_id INT,
    course_name VARCHAR(50),
    student_id INT,
    grade_obtained DECIMAL(5,2)
);

-- Query 1: Insert sample data into each table
INSERT INTO students VALUES
(1, 'Alice Uwimana', 2023),
(2, 'Bob Mutabazi', 2023),
(3, 'Carol Niyonsenga', 2022),
(4, 'David Habimana', 2024),
(5, 'Emma Mukamana', 2023),
(6, 'Frank Nzeyimana', 2022),
(7, 'Grace Uwingabire', 2024),
(8, 'Henry Bizimana', 2023),
(9, 'Irene Kayitesi', 2022),
(10, 'John Mugisha', 2024),
(11, 'Kate Umubyeyi', 2023),
(12, 'Leo Ndayisaba', 2022),
(13, 'Mary Ingabire', 2024),
(14, 'Nathan Rugema', 2023),
(15, 'Olive Uwera', 2022),
(16, 'Paul Nsanzimana', 2024),
(17, 'Queen Mukeshimana', 2023);

INSERT INTO linux_grades VALUES
(101, 'Linux Fundamentals', 1, 78.5),
(101, 'Linux Fundamentals', 2, 45.0),
(101, 'Linux Fundamentals', 3, 89.2),
(101, 'Linux Fundamentals', 4, 34.5),
(101, 'Linux Fundamentals', 5, 67.8),
(101, 'Linux Fundamentals', 7, 92.1),
(101, 'Linux Fundamentals', 8, 41.3),
(101, 'Linux Fundamentals', 9, 76.4),
(101, 'Linux Fundamentals', 11, 85.6),
(101, 'Linux Fundamentals', 12, 38.7),
(101, 'Linux Fundamentals', 14, 73.2),
(101, 'Linux Fundamentals', 15, 88.9),
(101, 'Linux Fundamentals', 17, 56.8);

INSERT INTO python_grades VALUES
(201, 'Python Programming', 1, 82.3),
(201, 'Python Programming', 3, 91.5),
(201, 'Python Programming', 5, 74.2),
(201, 'Python Programming', 6, 88.7),
(201, 'Python Programming', 7, 95.1),
(201, 'Python Programming', 10, 79.8),
(201, 'Python Programming', 11, 87.4),
(201, 'Python Programming', 13, 92.6),
(201, 'Python Programming', 14, 76.9),
(201, 'Python Programming', 16, 85.3),
(201, 'Python Programming', 17, 90.2);

-- Query 2: Find students who scored less than 50% in the Linux course
SELECT s.student_name, lg.grade_obtained
FROM students s
JOIN linux_grades lg ON s.student_id = lg.student_id
WHERE lg.grade_obtained < 50;

-- Query 3: Find students who took only one course (either Linux or Python, not both)
SELECT s.student_name
FROM students s
LEFT JOIN linux_grades lg ON s.student_id = lg.student_id
LEFT JOIN python_grades pg ON s.student_id = pg.student_id
WHERE (lg.student_id IS NOT NULL AND pg.student_id IS NULL)
   OR (lg.student_id IS NULL AND pg.student_id IS NOT NULL);

-- Query 4: Find students who took both courses
SELECT s.student_name
FROM students s
JOIN linux_grades lg ON s.student_id = lg.student_id
JOIN python_grades pg ON s.student_id = pg.student_id;

-- Query 5: Calculate the average grade per course (Linux and Python separately)
SELECT 'Linux' as course, AVG(grade_obtained) as average_grade
FROM linux_grades
UNION
SELECT 'Python' as course, AVG(grade_obtained) as average_grade
FROM python_grades;

-- Query 6: Identify the top-performing student across both courses (based on average of their grades)
SELECT s.student_name, AVG(combined_grades.grade) as overall_average
FROM students s
JOIN (
    SELECT student_id, grade_obtained as grade FROM linux_grades
    UNION ALL
    SELECT student_id, grade_obtained as grade FROM python_grades
) combined_grades ON s.student_id = combined_grades.student_id
GROUP BY s.student_id, s.student_name
ORDER BY overall_average DESC
LIMIT 1;