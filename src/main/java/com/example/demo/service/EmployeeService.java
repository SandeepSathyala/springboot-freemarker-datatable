package com.example.demo.service;

import com.example.demo.dto.EmployeeDTO;
import com.example.demo.model.Employee;
import com.example.demo.repository.EmployeeDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.transaction.annotation.Transactional;



@Service
public class EmployeeService {

    @Autowired
    private EmployeeDAO employeeDAO;

    // Get all employees as DTO
    public List<EmployeeDTO> getAllEmployees() {
        return employeeDAO.findAll()
                .stream()
                .map(emp -> new EmployeeDTO(emp.getId(), emp.getFirstName(), emp.getLastName(), emp.getEmailId()))
                .collect(Collectors.toList());
    }

    // Get employee by ID
    public Optional<EmployeeDTO> getEmployeeById(Long id) {
        return employeeDAO.findByIds(id)
                .map(emp -> new EmployeeDTO(emp.getId(), emp.getFirstName(), emp.getLastName(), emp.getEmailId()));
    }

    // Check if an email already exists
    public boolean emailExists(String email) {
        return employeeDAO.existsByEmail(email);
    }

    // Save or update employee
    @Transactional
    public EmployeeDTO saveEmployee(EmployeeDTO employeeDTO) {
        if (employeeDTO == null) {
            throw new IllegalArgumentException("Employee data cannot be null.");
        }

        // Check for duplicate email when adding a new employee
        if (employeeDTO.getId() == null || employeeDTO.getId() == 0) {
            if (emailExists(employeeDTO.getEmailId())) {
                throw new IllegalArgumentException("Email already exists!");
            }
        }

        // Convert DTO to Entity
        Employee employee = new Employee();
        employee.setId(employeeDTO.getId());
        employee.setFirstName(employeeDTO.getFirstName());
        employee.setLastName(employeeDTO.getLastName());
        employee.setEmailId(employeeDTO.getEmailId());

        try {
            Employee savedEmployee = employeeDAO.save(employee);
            return new EmployeeDTO(savedEmployee.getId(), savedEmployee.getFirstName(), savedEmployee.getLastName(), savedEmployee.getEmailId());
        } catch (Exception e) {
            throw new RuntimeException("Error saving employee: " + e.getMessage(), e);
        }
    }

    // Delete employee by ID
    @Transactional
    public void deleteEmployee(Long id) {
        employeeDAO.deleteById(id);
    }

    public boolean updateEmployeeField(Long id, String column, String value) {
        Employee employee = employeeDAO.findById(id);
        if (employee == null) return false;

        switch (column) {
            case "firstName":
                employee.setFirstName(value);
                break;
            case "lastName":
                employee.setLastName(value);
                break;
            case "emailId":
                employee.setEmailId(value);
                break;
            default:
                return false;
        }

        employeeDAO.update(employee);
        return true;
    }

}
