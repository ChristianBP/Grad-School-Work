const studentsJSON='[{"studentId":1,"firstname":"Christian","lastname":"Parker","courses":[{"courseNumber":1,"courseName":"Web Programming Languages","grade":84},{"courseNumber":2,"courseName":"Artificial Intelligence","grade":45}],"age":26,"gpa":"NA"},{"studentId":2,"firstname":"John","lastname":"Smith","courses":[{"courseNumber":1,"courseName":"Web Programming Languages","grade":55},{"courseNumber":3,"courseName":"Databases","grade":95}],"age":19,"gpa":"NA"},{"studentId":3,"firstname":"Jane","lastname":"Doe","courses":[{"courseNumber":2,"courseName":"Artificial Intelligence","grade":99},{"courseNumber":3,"courseName":"Databases","grade":42}],"age":42,"gpa":"NA"}]'
const students = JSON.parse(studentsJSON)

displayStudents(students)

document.getElementById('calculate-gpa').addEventListener('click', () => {
    students.forEach(student => {
        let totalGrades = 0;
        for (const course of student.courses) {
            totalGrades += course.grade;
        }
        student.gpa = totalGrades / student.courses.length;
    });
    displayStudents(students);
});


function displayStudents(students) {
    const table = document.getElementById('student-info');
    table.innerHTML = '<tr><th>Student ID</th><th>First Name</th><th>Last Name</th><th>Course Number</th><th>Course Name</th><th>Grade</th><th>Age</th><th>GPA</th></tr>';

    for (const student of students) {
        for(const course of student.courses){
            const row = document.createElement('tr');

            const studentId = document.createElement('td');
            studentId.textContent = student.studentId;
            row.appendChild(studentId);

            const firstName = document.createElement('td');
            firstName.textContent = student.firstname;
            row.appendChild(firstName);

            const lastName = document.createElement('td');
            lastName.textContent = student.lastname;
            row.appendChild(lastName);

            const courseNumber = document.createElement('td');
            courseNumber.textContent = course.courseNumber;
            row.appendChild(courseNumber);

            const courseName = document.createElement('td');
            courseName.textContent = course.courseName;
            row.appendChild(courseName);

            const grade = document.createElement('td');
            grade.textContent = course.grade;
            row.appendChild(grade);

            const age = document.createElement('td');
            age.textContent = student.age;
            row.appendChild(age);

            const gpa = document.createElement('td');
            gpa.textContent = student.gpa;
            row.appendChild(gpa);

            table.appendChild(row);
        }
    }
}