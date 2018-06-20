pragma solidity ^0.4.24;

contract Payroll {
    uint salary = 1 ether;
    address sugarDaddy = msg.sender;  //Yeah your SugarDaddy is the PO
    address employee;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    //Your sugarDaddy is the King, beg for money is the rule baby.
    function updateEmployee(address e, uint s) {
    if (employee != 0x0) {
        require(msg.sender == sugarDaddy);
        uint payment = salary * (now - lastPayday) / payDuration;
        employee.transfer(payment);
        }
        
        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
    }
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    //It's your Daddy's buying power!
    function hasEnoughFound() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        if(msg.sender != employee) {
            revert();
        }
        uint nextPayDay = lastPayday + payDuration;
        if (nextPayDay > now) {
            revert();
        }
        
            lastPayday = nextPayDay;
            employee.transfer(salary);
    }
    
    //function test () {
    //    payDuration =1 days;
    //}
    
    function test() returns (bool) {
        return 1 wei == 1;
    }
}
