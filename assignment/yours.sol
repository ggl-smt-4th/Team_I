pragma solidity ^0.4.14;

contract MyContract {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary;
    address employee;
    uint lastPayday;

    function MyContract() {
        owner = msg.sender;
    }

    function updateEmployee(address e, uint s) {
        //更改工资接受人和工资必须是合约拥有人
        require(msg.sender == owner);
        //如果之前有工资接受者，先结算工资
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        //更改合约内容
        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
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
        require(msg.sender == employee);

        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
