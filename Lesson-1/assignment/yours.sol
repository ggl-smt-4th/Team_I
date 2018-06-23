pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 60 seconds;

    address owner;
    uint salary;
    address employee;
    uint lastPayday;

    function Payroll() {
        owner = msg.sender;
    }

    //向该合约地址打款
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    //获取余额
    function getFund() returns (uint) {
        return this.balance /  (1 finney);
    }
    
    //还能付几个月的工资
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }    
    
    //设定员工地址
    function setAddr(address e) {
        require(msg.sender == owner);
        require(employee != e);
        
        uint payment = salary * (now - lastPayday) / payDuration;
        employee.transfer(payment);
        
        employee = e;
        lastPayday = now;
    }
    
    //设定员工薪水
    function setSalary(uint s) {
        require(msg.sender == owner);
        require(salary != (s * 1 finney));
        
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }

        //单位用finney = 10 ^ 15 wei
        salary = s * 1 finney;
        lastPayday = now;
    }       
        
        
    //员工领取一个月的工资
    function getPaid() returns (uint){
        require(msg.sender == employee);
        
        uint nextPayday = lastPayday + payDuration;
        require(nextPayday < now);
        lastPayday = nextPayday;
        employee.transfer(salary);
    }
    
    //员工一次性领多个月的工资
    function getMultiPaid() returns (uint){
        require(msg.sender == employee);
        uint nextPayday = lastPayday + payDuration;
        require(nextPayday < now);
        uint month;
        month = (now - lastPayday) / payDuration;
        lastPayday = lastPayday + (month * payDuration);
        employee.transfer(salary * month);
        return month;
    }
}
