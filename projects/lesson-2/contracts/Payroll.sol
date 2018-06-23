pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayDay;
    }
    
    address owner;
    uint payDuration = 10 seconds;
    Employee[] employees;
    uint totalSalary = 0;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayDay) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns(Employee,uint ){
        for (uint i = 0;i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i],i);
            }
        }
    }
    
    function addEmployee(address employeeId,uint salary) {
        require(msg.sender == owner);
        
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        salary = salary * 1 ether;
        totalSalary += salary;
        employees.push(Employee(employeeId,salary,now));
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        totalSalary -= employees[index].salary;
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }
    
    function updateEmployee(address employeeId,uint salary) {
        require(msg.sender == owner);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        employee.salary = salary * 1 ether;
        employee.lastPayDay = now;
        
        totalSalary += employee.salary;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var (employee,index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayday = employee.lastPayDay + payDuration;
        assert(nextPayday < now);
        
        employee.lastPayDay = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
