package com.example.demo.controller;

import com.example.demo.dto.EmployeeDTO;
import com.example.demo.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/employees")
public class EmployeeController {

    @Autowired
    private EmployeeService employeeService;

    // Fetch All Employees and Load Employee List Page
    @GetMapping
    public String getAllEmployees(Model model) {
        List<EmployeeDTO> employees = employeeService.getAllEmployees();
        model.addAttribute("employees", employees);
        return "employee-list";
    }

    // Show Employee Form (For New Employee)
    @GetMapping("/new")
    public String showEmployeeForm(Model model) {
        model.addAttribute("employee", new EmployeeDTO());
        return "employee-form";
    }

    // Save or Update Employee
    @PostMapping
    @ResponseBody
    public ResponseEntity<String> saveEmployee(@RequestBody EmployeeDTO employeeDTO) {
        if (employeeDTO == null) {
            return ResponseEntity.badRequest().body("Invalid employee data!");
        }

        // Check if email exists for new employees
        if (employeeDTO.getId() == null || employeeDTO.getId() == 0) {
            if (employeeService.emailExists(employeeDTO.getEmailId())) {
                return ResponseEntity.badRequest().body("Email already exists!");
            }
        }

        // Save employee
        EmployeeDTO savedEmployee = employeeService.saveEmployee(employeeDTO);

        if (savedEmployee == null) {
            return ResponseEntity.status(500).body("Failed to save employee.");
        }

        return ResponseEntity.ok("Employee saved successfully!");
    }


    // Delete Employee
    @GetMapping("/delete/{id}")
    public String deleteEmployee(@PathVariable Long id) {
        employeeService.deleteEmployee(id);
        return "redirect:/employees";
    }

    // Check if an email already exists (for duplicate email validation)
    @GetMapping("/check-email")
    @ResponseBody
    public boolean checkEmail(@RequestParam String email) {
        return employeeService.emailExists(email);
    }

    // Get Employee Details for Editing
    @GetMapping("/edit/{id}")
    @ResponseBody
    public ResponseEntity<EmployeeDTO> editEmployee(@PathVariable Long id) {
        Optional<EmployeeDTO> employeeDTO = employeeService.getEmployeeById(id);
        return employeeDTO.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping("/update")
    @ResponseBody
    public ResponseEntity<String> updateEmployeeField(@RequestBody Map<String, String> request) {
        Long id = Long.parseLong(request.get("id"));
        String column = request.get("column");
        String value = request.get("value");

        boolean updated = employeeService.updateEmployeeField(id, column, value);

        if (updated) {
            return ResponseEntity.ok("Employee updated successfully");
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Failed to update employee");
        }
    }

}
