using Microsoft.EntityFrameworkCore;
using DotNet_WebAPI.Data;
using DotNet_WebAPI.Models;

namespace DotNet_WebAPI.Repositories
{
    public class StudentRepository : IStudentRepository
    {
        private readonly AppDbContext _context;

        public StudentRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Student>> GetAllStudentsAsync()
        {
            return await _context.Students.ToListAsync();
        }

        public async Task<Student?> GetStudentByIdAsync(int id)
        {
            return await _context.Students.FindAsync(id);
        }

        public async Task<Student> AddStudentAsync(Student student)
        {
            student.CreatedAt = DateTime.UtcNow;
            _context.Students.Add(student);
            await _context.SaveChangesAsync();
            return student;
        }

        public async Task<Student?> UpdateStudentAsync(int id, Student student)
        {
            var existing = await _context.Students.FindAsync(id);
            if (existing == null) return null;

            existing.Name = student.Name;
            existing.Email = student.Email;
            existing.Course = student.Course;

            await _context.SaveChangesAsync();
            return existing;
        }

        public async Task<bool> DeleteStudentAsync(int id)
        {
            var existing = await _context.Students.FindAsync(id);
            if (existing == null) return false;

            _context.Students.Remove(existing);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
