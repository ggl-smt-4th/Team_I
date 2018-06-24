pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 30 days;

    Employee[] employees;
    address owner;
    
    uint salarysum = 0;

    function Payroll() payable public{
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        if (employee.id != 0x0){
            uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
            employee.id.transfer(payment);
        }
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++){
            if (employees[i].id == employeeId){
                return (employees[i], i);
            }
        }
        //return ((0x0, 0, 0), 0);
    }

    function addEmployee (address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        var(employee,index) = _findEmployee(employeeAddress);
        assert(employee.id == 0x0);
        
        uint sa = salary * 1 ether;
        employees.push(Employee(employeeAddress, sa, now));
        salarysum += sa;
    }
    
    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        salarysum -= employee.salary;
        delete employees[index];
        employees[index] = employees[employees.length-1];
        employees.length -= 1;
        
    }
    
    //该函数只能修改员工的地址，不能修改员工的薪水
    function updateEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        var(employee,index) = _findEmployee(employeeAddress);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        uint sa = salary * 1 ether;
        salarysum = salarysum + sa - employee.salary;
        employees[index].salary = sa;
        employees[index].lastPayday = now;
    }
    
    //该函数用来修改员工的地址
    function updateEmployeeid(address OldemployeeId, address NewemployeeId) public {
        require(msg.sender == owner);
        var(employee,index) = _findEmployee(OldemployeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        employees[index].id = NewemployeeId;
        employees[index].lastPayday = now;
    }    
    
    function getEmployee(address employeeId) public returns (address,uint) {
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        return (employee.id,employee.salary);
    }    
    
    function addFund() payable public returns (uint) {
        return this.balance;
    }

    function getFund() public view returns (uint){
        return (this.balance / 1 ether);
    }
    
    function calculateRunway() public view returns (uint) {
        return this.balance / salarysum;
    }
    
    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() public {
        var(employee,index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employees[index].lastPayday = nextPayday;
        employees[index].id.transfer(employees[index].salary);

    }
}
