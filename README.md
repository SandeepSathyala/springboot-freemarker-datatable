Employee Management System
---------------------------

Overview:
---------
This Employee Management System is a Spring Boot web application with a frontend built using jQuery, DataTables, and FreeMarker templates. It allows users to perform CRUD operations on employee records, check for duplicate emails before adding an employee, and update employee details via double-click editing.

Features Implemented
1.Employee CRUD Operations
   - Add a new employee
   - Edit employee details
   - Delete an employee
   - List all employees using DataTables

2. Duplicate Email Check (Without JPA Repository)
   - Uses jQuery AJAX on onchange` event to check if an email already exists in the database.
   - Backend verification is done using a Named Query in DAO (without using Spring Data JPA).
   - Displays an error message in the frontend if the email already exists.

 3. Inline Editing (Double-Click to Update)
   - Allows users to update employee details by double-clicking any column except ID and actions.
   - Uses jQuery AJAX to send updates to the backend.
   - Backend updates the database and returns a success response.

 4. Custom JPA Implementation
   - Instead of using Spring Data JPA, this project uses a DAO layer with Named Queries for database operations.
   - Directly interacts with the database using EntityManager and JPQL Named Queries.

Technologies Used
------------------
Backend:
--------
- Spring Boot: (REST API, Service Layer)
- Spring MVC: (Controller, Service, DAO)
- Spring Data JPA: (Custom Implementation)
- MySQL:(Database)
- Named Queries: (Instead of JPA Repository)

Frontend:
------------
- jQuery & AJAX: (Client-side interactions)
- DataTables: (Displays employee records in a table)
- FreeMarker Templates: (Dynamic HTML rendering)

API Endpoints:
---------------------------------------------------------------------------------------------
| Method |            Endpoint                  |           Description                     |
|--------|--------------------------------------|-------------------------------------------|
| GET    | /employees                           | Fetch all employees                       |
| POST   | /employees                           | Add a new employee                        |
| POST   | /employees/update                    | Update employee field (double-click edit) |
| GET    | /employees/check-email?email={email} | Check if email exists (duplicate check)   |
| GET    | /employees/edit/{id}                 | Fetch employee details for editing        |
| GET    | /employees/delete/{id}               | Delete an employee                        |
---------------------------------------------------------------------------------------------


