/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {

    uint salary;
    uint constant payDuration = 10 seconds;
    uint lastPayday;
    address owner;
    address employee;
    
    function Payroll() {
        owner == msg.sender;
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        if(msg.sender != employee) {
            revert();
        }
        uint nextPayDay = lastPayday + payDuration;
        if(nextPayDay < now) {
            lastPayday = nextPayDay;
            employee.transfer(salary);
        } else {
            revert();
        }
    }
    
    function updateAddress(address a, uint s) {
        if(msg.sender != owner) {
            revert();
        }
        if(employee != 0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
            
        }
        
        employee = a;
        salary = s * 1 ether;
        lastPayday = now;

    }
}
