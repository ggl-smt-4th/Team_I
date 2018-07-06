/*作业请提交在这个目录下*/

pragma solidity ^0.4.14;

// 实现课上所教的单员工智能合约系统，并且加入两个函数能够更改员工地址以及员工薪水。

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary = 1 ether;
    address employee = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint lastPayday;

    function Payroll() {
        owner = msg.sender;
    }
    
    
    function changeEmployee(address e) {
        require(msg.sender == owner);
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        employee = e;
    }
    
    function changeSalary(uint s) {
        salary = s * 1 ether;
        lastPayday = now;
    }
    
    
    // function updateEmployee(address e, uint s) {
    //     require(msg.sender == owner);
        
    //     if (employee != 0x0) {
    //         uint payment = salary * (now - lastPayday) / payDuration;
    //         employee.transfer(payment);
    //     }
        
    //     employee = e;
    //     salary = s * 1 ether;
    //     lastPayday = now;
    // } 
    
    //boss在智能合约存钱
    function addFund() payable returns (uint) {
        return this.balance;
    }
    //计算boss存钱还能付几次工钱
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    //是否有足够的钱支付工资
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    //员工拿到钱
    function getPaid() {
        //assert和require若结果为否他就会抛出错误，区别在于，require若失败则会返还给用户剩下的gas，assert则不会。
        //assert只是在代码可能出现严重错误的时候使用，比如uint溢出。
        require(msg.sender == employee);
        uint nextPayday = lastPayday + payDuration;
        require(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
