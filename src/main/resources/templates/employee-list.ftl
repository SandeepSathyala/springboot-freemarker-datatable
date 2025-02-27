<!DOCTYPE html>
<html>
<head>
<title>Employee List</title>

<!-- jQuery & DataTables -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

    <script>
        $(document).ready(function () {
    $("#employeeTable").DataTable();

     // Double-click to edit any column
     $(document).on("dblclick", "#employeeTable td", function () {
     let originalValue = $(this).text().trim();
     let columnIndex = $(this).index();
     let row = $(this).closest("tr");
     let id = row.find("td:first").text().trim(); // Get employee ID
     let columnName = getColumn(columnIndex);

     if (columnName === "id" || columnName === "actions") return;

     // Replace cell with input field
      let input = $("<input>")
     .attr("type", "text")
     .val(originalValue)
     .css("width", "100%");

     $(this).html(input);
     input.focus();
     input.on("blur keydown", function (event) {
     if (event.type === "blur" || event.key === "Enter") {
     let newValue = input.val().trim();
     if (newValue !== originalValue) {
     updateEmployeeField(id, columnName, newValue, row, columnIndex);
     } else {
      $(this).parent().text(originalValue);
     }
            }
        });
    });

    // Function to determine column name
    function getColumn(index) {
    let columns = ["id", "firstName", "lastName", "emailId", "actions"];
    return columns[index] || null;
    }

    // Function to update employee field
    function updateEmployeeField(id, column, value, row, columnIndex) {
       $.ajax({
       url: "/employees/update",
       type: "POST",
       contentType: "application/json",
       data: JSON.stringify({ id: id, column: column, value: value }),
            success: function (response) {
      row.find("td").eq(columnIndex).text(value); // Update UI
    },
            error: function () {
       alert("Error updating employee!");
    }
        });
    }

    // Check for duplicate email
    $("#addEmailId").on("change", function () {
    let email = $(this).val().trim();
    if (email !== "") {
       $.ajax({
       url: "/employees/check-email",
       type: "GET",
       data: { email: email },
            success: function (response) {
     if (response) { // Since backend returns a boolean
     $("#addEmailError").text("Email already exists!").css("color", "red");
    } else {
        $("#addEmailError").text(""); // Clear error
    }
            },
            error: function () {
         alert("Error checking email!");
    }
        });
    }
        });

        // Open Add Employee Modal
        $("#addEmployeeBtn").click(function () {
            event.stopPropagation();
            resetAddForm();
            $("#addEmployeeModal").fadeIn();
          });

            // Open Edit Employee Modal
            $(document).on("click", ".editEmployee", function () {
         let id = $(this).data("id");
         $.get("/employees/edit/" + id, function (data) {
          if (data) {
             $("#editEmployeeId").val(data.id);
             $("#editFirstName").val(data.firstName);
             $("#editLastName").val(data.lastName);
             $("#editEmailId").val(data.emailId);
             $(".error").text(""); // Clear errors
             $("#editEmployeeModal").fadeIn();
          } else {
             alert("Employee not found!");
             }
                }).fail(function () {
            alert("Error fetching employee details!");
          });
          });

            // Close Modals
            $(".close").click(function () {
            $(".modal").fadeOut();
          });

            // Close modal when clicking outside
            $(document).on("click", function (event) {
              if ($(event.target).closest(".modal-content").length === 0 && $(".modal").is(":visible")) {
              $(".modal").fadeOut();
            }
          });

            // Save New Employee
            $("#addEmployeeForm").submit(function (event) {
            event.preventDefault();
            let firstName = $("#addFirstName").val().trim();
            let lastName = $("#addLastName").val().trim();
            let email = $("#addEmailId").val().trim();
            let isValid = validateForm(firstName, lastName, email, "add");
            if (!isValid) return;

             $.ajax({
               url: "/employees",
               type: "POST",
               contentType: "application/json",
               data: JSON.stringify({
               firstName: firstName,
               lastName: lastName,
               emailId: email
             }),
               success: function (response) {
                 alert(response);
                 location.reload();
               },
                error: function (xhr) {
                alert(xhr.responseText);
                }
              });
          });

            // Save Edited Employee
           $("#editEmployeeForm").submit(function (event) {
           event.preventDefault();
           let id = $("#editEmployeeId").val();
           let firstName = $("#editFirstName").val().trim();
           let lastName = $("#editLastName").val().trim();
           let email = $("#editEmailId").val().trim();
           let isValid = validateForm(firstName, lastName, email, "edit");
           if (!isValid) return;

          $.ajax({
               url: "/employees",
               type: "POST",
               contentType: "application/json",
               data: JSON.stringify({
               id: id,
               firstName: firstName,
               lastName: lastName,
               emailId: email
              }),

               success: function (response) {
               alert(response);
               location.reload();
                 },

               error: function (xhr) {
               alert(xhr.responseText);
               }
              });
          });

            // Validate Form
          function validateForm(firstName, lastName, email, type) {
          let isValid = true;
          let prefix = type === "add" ? "add" : "edit";

             $(".error").text("");

              if (firstName === "") {
              $("#" + prefix + "FirstNameError").text("First name is required!").css("color", "red");
               isValid = false;
              }

              if (lastName === "") {
              $("#" + prefix + "LastNameError").text("Last name is required!").css("color", "red");
               isValid = false;
              }

              if (email === "" || !validateEmail(email)) {
              $("#" + prefix + "EmailError").text("Invalid email format!").css("color", "red");
                isValid = false;
              }

                return isValid;
          }

            // Email Validation
             function validateEmail(email) {
             let re = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                return re.test(email);
             }

            // Reset Add Form
            function resetAddForm() {
             $("#addEmployeeForm")[0].reset();
             $(".error").text("");
            }
        });
    </script>

     <style>
        .modal { display: none; position: fixed; z-index: 1; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.4); }
        .modal-content { background-color: #fff; margin: 10% auto; padding: 20px; border: 1px solid #888; width: 30%; }
        .close { color: red; float: right; font-size: 28px; font-weight: bold; cursor: pointer; }
        .error { color: red; font-size: 12px; }
     </style>
  </head>
<body>

<h1>Employee List</h1>
<button id="addEmployeeBtn">Add New Employee</button>

    <table id="employeeTable" class="display">
        <thead>
            <tr>
                <th>ID</th>
                <th>First Name</th>
                <th>Last Name</th>
                <th>Email</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <#list employees as employee>
                <tr>
                    <td>${employee.id}</td>
                    <td>${employee.firstName}</td>
                    <td>${employee.lastName}</td>
                    <td>${employee.emailId}</td>
                    <td>
                        <button class="editEmployee" data-id="${employee.id}">Edit</button>
                        <a href="/employees/delete/${employee.id}" onclick="return confirm('Are you sure?')">Delete</a>
                    </td>
                </tr>
            </#list>
        </tbody>
    </table>

    <!-- Add Employee Modal -->
    <div id="addEmployeeModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2>Add Employee</h2>
            <form id="addEmployeeForm">
                <@inputField name="addFirstName" label="First Name" />
                <@inputField name="addLastName" label="Last Name" />
                <@inputField name="addEmailId" label="Email" />
                <button type="submit">Add</button>
            </form>
        </div>
    </div>

    <!-- Edit Employee Modal -->
    <div id="editEmployeeModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2>Edit Employee</h2>
            <form id="editEmployeeForm">
                <input type="hidden" id="editEmployeeId">
                <@inputField name="editFirstName" label="First Name" />
                <@inputField name="editLastName" label="Last Name" />
                <@inputField name="editEmailId" label="Email" />
                <button type="submit">Update</button>
            </form>
        </div>
    </div>

    <#macro inputField name label>
        <label>${label}: <input type="text" id="${name}"></label>
        <span class="error" id="${name}Error"></span><br>
    </#macro>

</body>
</html>
