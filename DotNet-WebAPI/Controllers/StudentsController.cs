using Microsoft.AspNetCore.Mvc;
using DotNet_WebAPI.Models;
using DotNet_WebAPI.Services;

namespace DotNet_WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class StudentsController : ControllerBase
    {
        private readonly IStudentService _studentService;

        public StudentsController(IStudentService studentService)
        {
            _studentService = studentService;
        }

        // GET: api/students
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Student>>> GetStudents()
        {
            Response.Headers.Append("X-Server-Engine", ".NET Web API");
            Response.Headers.Append("X-SQL-Executed", "SELECT id, name, email, course, created_at FROM students;");

            var students = await _studentService.GetAllStudentsAsync();
            return Ok(students);
        }

        // GET: api/students/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Student>> GetStudent(int id)
        {
            Response.Headers.Append("X-SQL-Executed", $"SELECT * FROM students WHERE id = {id};");

            var student = await _studentService.GetStudentByIdAsync(id);
            if (student == null)
            {
                return NotFound(new { message = $"Student with ID {id} was not found." });
            }

            return Ok(student);
        }

        // POST: api/students
        [HttpPost]
        public async Task<ActionResult<Student>> CreateStudent([FromBody] Student student)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var created = await _studentService.CreateStudentAsync(student);

            Response.Headers.Append("X-SQL-Executed", $"INSERT INTO students (name, email, course, created_at) VALUES ('{created.Name}', '{created.Email}', '{created.Course}', '{created.CreatedAt:yyyy-MM-dd HH:mm:ss}');");

            return CreatedAtAction(nameof(GetStudent), new { id = created.Id }, created);
        }

        // PUT: api/students/5
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateStudent(int id, [FromBody] Student student)
        {
            if (id != student.Id && student.Id != 0)
            {
                return BadRequest(new { message = "URL ID does not match entity ID." });
            }

            var updated = await _studentService.UpdateStudentAsync(id, student);
            if (updated == null)
            {
                return NotFound(new { message = $"Student with ID {id} not found." });
            }

            Response.Headers.Append("X-SQL-Executed", $"UPDATE students SET name='{student.Name}', email='{student.Email}', course='{student.Course}' WHERE id={id};");

            return Ok(updated);
        }

        // DELETE: api/students/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteStudent(int id)
        {
            var deleted = await _studentService.DeleteStudentAsync(id);
            if (!deleted)
            {
                return NotFound(new { message = $"Student with ID {id} not found." });
            }

            Response.Headers.Append("X-SQL-Executed", $"DELETE FROM students WHERE id={id};");

            return Ok(new { message = $"Student {id} successfully deleted.", deletedId = id });
        }
    }
}
