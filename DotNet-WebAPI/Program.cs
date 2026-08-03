using Microsoft.EntityFrameworkCore;
using DotNet_WebAPI.Data;
using DotNet_WebAPI.Repositories;
using DotNet_WebAPI.Services;
using System.Net.Sockets;

var builder = WebApplication.CreateBuilder(args);

// 1. Configure CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFlutterApp", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader()
              .WithExposedHeaders("X-Server-Engine", "X-Database-Engine", "X-SQL-Executed");
    });
});

// 2. Database Connection Check (MySQL with In-Memory fallback)
string connectionString = builder.Configuration.GetConnectionString("DefaultConnection") 
    ?? "Server=localhost;Port=3306;Database=api_workflow_db;User=root;Password=root;";

bool mysqlAvailable = CheckPortOpen("localhost", 3306, 1000);

if (mysqlAvailable)
{
    Console.WriteLine("[Database Detection] MySQL server detected on localhost:3306. Connecting to MySQL (api_workflow_db)...");
    try
    {
        var serverVersion = new MySqlServerVersion(new Version(8, 0, 30));
        builder.Services.AddDbContext<AppDbContext>(options =>
            options.UseMySql(connectionString, serverVersion));
    }
    catch (Exception ex)
    {
        Console.WriteLine($"[Database Detection] MySQL registration error ({ex.Message}). Using In-Memory Database.");
        builder.Services.AddDbContext<AppDbContext>(options =>
            options.UseInMemoryDatabase("ApiWorkflowInMemoryDb"));
    }
}
else
{
    Console.WriteLine("[Database Detection] MySQL not running on localhost:3306. Using In-Memory Database for API flow demonstration.");
    builder.Services.AddDbContext<AppDbContext>(options =>
        options.UseInMemoryDatabase("ApiWorkflowInMemoryDb"));
}

// 3. Register Repositories & Services in Dependency Injection (Clean Architecture)
builder.Services.AddScoped<IStudentRepository, StudentRepository>();
builder.Services.AddScoped<IStudentService, StudentService>();

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Global Exception Handler
app.UseExceptionHandler(errorApp =>
{
    errorApp.Run(async context =>
    {
        context.Response.StatusCode = 500;
        context.Response.ContentType = "application/json";
        var exceptionHandlerPathFeature = context.Features.Get<Microsoft.AspNetCore.Diagnostics.IExceptionHandlerPathFeature>();
        var exception = exceptionHandlerPathFeature?.Error;
        
        var response = new
        {
            error = "Internal Server Error (500)",
            details = exception?.Message,
            path = context.Request.Path.Value
        };
        
        await context.Response.WriteAsJsonAsync(response);
    });
});

// Swagger UI
app.UseSwagger();
app.UseSwaggerUI();

app.UseCors("AllowFlutterApp");
app.UseAuthorization();
app.MapControllers();

// Ensure Database Created & Seeded
using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    try
    {
        var dbContext = services.GetRequiredService<AppDbContext>();
        dbContext.Database.EnsureCreated();
        Console.WriteLine("[Database Status] Students Database initialized & seeded successfully.");
    }
    catch (Exception ex)
    {
        Console.WriteLine($"[Database Warning] Setup note: {ex.Message}");
    }
}

Console.WriteLine("=================================================");
Console.WriteLine(".NET Web API Server started successfully!");
Console.WriteLine("Endpoints active at: http://localhost:5000/api/students");
Console.WriteLine("Swagger Documentation: http://localhost:5000/swagger");
Console.WriteLine("=================================================");

app.Run("http://0.0.0.0:5000");

// Helper method
static bool CheckPortOpen(string host, int port, int timeoutMs)
{
    try
    {
        using var client = new TcpClient();
        var result = client.BeginConnect(host, port, null, null);
        var success = result.AsyncWaitHandle.WaitOne(timeoutMs);
        if (!success) return false;
        client.EndConnect(result);
        return true;
    }
    catch
    {
        return false;
    }
}
