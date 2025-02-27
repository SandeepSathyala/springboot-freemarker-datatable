<!DOCTYPE html>
<html>
<head>
    <title>Employee Form</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script>
        $(document).ready(function() {
            let emailExists = false; // Flag for duplicate email

            // Email validation and uniqueness check
            $("#emailId").on("input", function() {
                let email = $(this).val().trim();
                $("#errorMsg").text(""); // Clear error message

                if (email.length === 0) return; // Skip validation for empty field

                if (!validateEmail(email)) {
                    $("#errorMsg").text("Invalid email format!").css("color", "red");
                    return;
                }

                $.ajax({
                    url: "/employees/check-email",
                    type: "POST",
                    data: { email: email },
                    success: function(response) {
                        emailExists = response; // Set flag based on response
                        if (emailExists) {
                            $("#errorMsg").text("Email already exists!").css("color", "red");
                        } else {
                            $("#errorMsg").text("");
                        }
                    },
                    error: function() {
                        $("#errorMsg").text("Error checking email. Try again.").css("color", "red");
                    }
                });
            });

            // Form submission with validation
            $("#employeeForm").submit(function(event) {
                event.preventDefault();

                let firstName = $("#firstName").val().trim();
                let lastName = $("#lastName").val().trim();
                let email = $("#emailId").val().trim();
                let isValid = true;

                // Reset previous errors
                $(".error").text("");

                if (firstName === "") {
                    $("#firstNameError").text("First name is required!").css("color", "red");
                    isValid = false;
                }

                if (lastName === "") {
                    $("#lastNameError").text("Last name is required!").css("color", "red");
                    isValid = false;
                }

                if (email === "") {
                    $("#emailIdError").text("Email is required!").css("color", "red");
                    isValid = false;
                } else if (!validateEmail(email)) {
                    $("#emailIdError").text("Invalid email format!").css("color", "red");
                    isValid = false;
                } else if (emailExists) {
                    $("#emailIdError").text("Email already exists!").css("color", "red");
                    isValid = false;
                }

                if (!isValid) return; // Stop form submission if validation fails

                // If all checks pass, submit form via AJAX
                $.ajax({
                    url: "/employees",
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({
                        firstName: firstName,
                        lastName: lastName,
                        emailId: email
                    }),
                    success: function(response) {
                        alert(response);
                        window.location.href = "/employees";
                    },
                    error: function(xhr) {
                        alert(xhr.responseText);
                    }
                });
            });

            // Email validation function
            function validateEmail(email) {
                let re = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                return re.test(email);
            }
        });
    </script>
</head>
<body>
    <h1>Employee Form</h1>

    <form id="employeeForm">
        <label>First Name: <input type="text" id="firstName"></label>
        <span class="error" id="firstNameError"></span><br>

        <label>Last Name: <input type="text" id="lastName"></label>
        <span class="error" id="lastNameError"></span><br>

        <label>Email: <input type="text" id="emailId"></label>
        <span class="error" id="emailIdError"></span><br>

        <button type="submit">Save</button>
    </form>

    <span id="errorMsg" style="color: red;"></span>
</body>
</html>
