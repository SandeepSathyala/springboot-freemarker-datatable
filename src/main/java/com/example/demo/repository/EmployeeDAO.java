package com.example.demo.repository;

import com.example.demo.model.Employee;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
@Transactional
public class EmployeeDAO {

    @PersistenceContext
    private EntityManager entityManager;

    public boolean existsByEmail(String email) {
      Long count = entityManager.createNamedQuery("Employee.existsByEmail", Long.class)
              .setParameter("email", email)
              .getSingleResult();
      return count > 0;
    }

    @Transactional
    public Employee save(Employee employee) {
        if (employee.getId() == null) {
            entityManager.persist(employee);
            return employee;
        } else {
            return entityManager.merge(employee);
        }
    }

    public List<Employee> findAll() {
        return entityManager.createQuery("SELECT e FROM Employee e", Employee.class).getResultList();
    }

    public Optional<Employee> findByIds(Long id) {
        return Optional.ofNullable(entityManager.find(Employee.class, id));
    }

    @Transactional
    public void deleteById(Long id) {
        Employee employee = entityManager.find(Employee.class, id);
        if (employee != null) {
            entityManager.remove(employee);
        }
    }

    public Employee findById(Long id) {
        return entityManager.find(Employee.class, id);
    }


    @Transactional
    public void update(Employee employee) {
        entityManager.merge(employee);
    }

}
