# 📱 Flutter App - API Workflow

<p align="center">
  <img src="assets/images/app_icon.png" width="160" alt="API Workflow Logo" />
</p>

A Flutter client application communicating with a **.NET 8 Web API** and **MySQL** database with an in-app **API Flow Inspector**.

---

## 🔄 Application API Workflow

```mermaid
sequenceDiagram
    autonumber
    participant Flutter as 📱 Flutter App
    participant Inspector as 🔍 API Flow Inspector
    participant WebAPI as ⚡ .NET Web API (:5000)
    participant MySQL as 🐬 MySQL Database

    Flutter->>WebAPI: HTTP GET / POST / PUT / DELETE /api/students
    Note over WebAPI: EF Core / ADO.NET executes query
    WebAPI->>MySQL: Execute SQL Query (e.g., SELECT * FROM students)
    MySQL-->>WebAPI: Return Records / Status
    WebAPI-->>Flutter: Return 200 OK + JSON + Header (X-SQL-Executed)
    Flutter->>Inspector: Log HTTP Method, URL, Response Code, Execution Time & SQL Query
```

---

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
