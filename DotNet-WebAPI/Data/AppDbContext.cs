using Microsoft.EntityFrameworkCore;
using DotNet_WebAPI.Models;

namespace DotNet_WebAPI.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }

        public DbSet<Student> Students => Set<Student>();

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Seed initial data
            modelBuilder.Entity<Student>().HasData(
                new Student
                {
                    Id = 1,
                    Name = "Prit Dhanani",
                    Email = "prit@gmail.com",
                    Course = "Flutter & .NET Development",
                    CreatedAt = new DateTime(2026, 1, 1, 10, 0, 0, DateTimeKind.Utc)
                },
                new Student
                {
                    Id = 2,
                    Name = "Alex Johnson",
                    Email = "alex.j@example.com",
                    Course = "Mobile Application Architecture",
                    CreatedAt = new DateTime(2026, 2, 1, 11, 30, 0, DateTimeKind.Utc)
                },
                new Student
                {
                    Id = 3,
                    Name = "Sophia Chen",
                    Email = "sophia.c@example.com",
                    Course = "Cloud & Database Design",
                    CreatedAt = new DateTime(2026, 3, 1, 14, 15, 0, DateTimeKind.Utc)
                }
            );
        }
    }
}
