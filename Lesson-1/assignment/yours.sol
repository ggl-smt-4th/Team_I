/*作业请提交在这个目录下*/

pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;
    address employee;
    address owner;
    uint salary;
    uint lastPayDay;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function setEmployee(address e, uint s) {
        require(msg.sender == owner);
        
        if (employee != 0x0){
            uint payLastEmployee = salary * (now - lastPayDay) / payDuration;
            employee.transfer(payLastEmployee);
        }
        
        employee = e;
        salary = s * 1 ether;
        lastPayDay = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        require(msg.sender == employee || msg.sender == owner);
        
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        require(msg.sender == employee);
        uint nextPayDay = lastPayDay + payDuration;
        
        if (nextPayDay > now){
            revert();
        } else {
            lastPayDay = nextPayDay;
            employee.transfer(salary);  
        }
    }
}
