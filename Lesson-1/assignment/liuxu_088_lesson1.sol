pragma solidity ^0.4.14;

contract Payroll {

    uint constant payDuration = 10 seconds;

    address owner;
    uint lastPayday;
    mapping(address => uint) public employeeSalary;


    function Payroll() {
        owner = msg.sender;
    }
    
    function setEmployeeSalary(address employee, uint salaryNum) public{
        require(msg.sender == owner);
        employeeSalary[employee] = salaryNum * 1 ether;
    }


    function updateEmployee(address employee, uint salary) public{
        
        require(msg.sender == owner);
        
        if (employee != 0x0) {
            uint payment = employeeSalary[employee]  * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }

        employeeSalary[employee] = salary * 1 ether; 
        lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / employeeSalary[owner];
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        require(employeeSalary[owner] != 0);
        
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        owner.transfer(employeeSalary[owner]);
    }
}

