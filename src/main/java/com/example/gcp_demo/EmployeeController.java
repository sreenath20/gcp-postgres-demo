package com.example.gcp_demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Collection;

@RestController
@RequestMapping("api/employees")
public class EmployeeController {

    @Autowired
    private EmployeeRepository employeeRepository;

    @PostMapping
    public Employee addNewEmployee(@RequestBody Employee newEmployee ){
        return  employeeRepository.save(newEmployee);
    }
    @GetMapping
    public Collection<Employee> getAllEmployees(){
        return employeeRepository.findAll();
    }
}
