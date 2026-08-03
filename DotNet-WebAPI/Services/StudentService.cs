using DotNet_WebAPI.Models;
using DotNet_WebAPI.Repositories;

namespace DotNet_WebAPI.Services
{
    public class StudentService : IStudentService
    {
        private readonly IStudentRepository _repository;

        public StudentService(IStudentRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<Student>> GetAllStudentsAsync()
        {
            return await _repository.GetAllStudentsAsync();
        }

        public async Task<Student?> GetStudentByIdAsync(int id)
        {
            return await _repository.GetStudentByIdAsync(id);
        }

        public async Task<Student> CreateStudentAsync(Student student)
        {
            return await _repository.AddStudentAsync(student);
        }

        public async Task<Student?> UpdateStudentAsync(int id, Student student)
        {
            return await _repository.UpdateStudentAsync(id, student);
        }

        public async Task<bool> DeleteStudentAsync(int id)
        {
            return await _repository.DeleteStudentAsync(id);
        }
    }
}
