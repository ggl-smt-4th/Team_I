pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {

    using SafeMath for uint;

    struct Employee {
        // TODO, your code here
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;
    uint public totalSalary = 0;
    address owner;
    mapping(address => Employee) employees;
    
    function _partialpaid(Employee employee) private{
        uint payment = (employee.salary.mul(now -employee.lastPayday)).div(payDuration);
        employee.id.transfer(payment);
    }

    function Payroll() payable public {
        owner = msg.sender;
    }

    function addEmployee(address employeeId, uint salary) public onlyOwner {
        // TODO: your code here
        //require(msg.sender == owner);
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        
        employees[employeeId] = Employee(employeeId,salary.mul(1 ether),now);
        totalSalary = totalSalary.add(salary.mul( 1 ether));
    }

    function removeEmployee(address employeeId) public onlyOwner {
        // TODO: your code here
        //require(msg.sender == owner);
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        
        _partialpaid(employee);
        delete employees[employeeId];
    }

    function changePaymentAddress(address oldAddress,address newAddress) public onlyOwner {
        // TODO: your code here
        //require(msg.sender == owner);
        var oldEmployee = employees[oldAddress];
        assert(oldEmployee.id != 0x0);
        
        var newEmployee = employees[newAddress];
        assert(newEmployee.id == 0x0);
        employees[newAddress] = Employee(newAddress,oldEmployee.salary,oldEmployee.lastPayday);
        delete employees[oldAddress];
    }

    function updateEmployee(address employeeId, uint salary) public onlyOwner {
        // TODO: your code here
        //require(msg.sender == owner);
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        
        _partialpaid(employee);
        salary = salary.mul(1 ether);
        totalSalary = salary.add(totalSalary.sub(employee.salary));
        employees[employeeId].salary = salary;
        employees[employeeId].lastPayday = now;
        
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        // TODO: your code here
        return this.balance.div(totalSalary);
    }

    function hasEnoughFund() public view returns (bool) {
        // TODO: your code here
        return calculateRunway() > 0;
    }

    function getPaid() public {
        // TODO: your code here
        var employee = employees[msg.sender];
        assert(employee.id != 0x0);
        
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
        
        employees[msg.sender].lastPayday = now;
        employee.id.transfer(employee.salary);
    }
}


