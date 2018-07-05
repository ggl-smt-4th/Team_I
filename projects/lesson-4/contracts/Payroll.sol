pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {

    using SafeMath for uint;

    struct Employee {
        // TODO, your code here
        address addrOfEmployee;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;
    uint public totalSalary = 0;
    mapping(address => Employee) public employees;
    address owner;
    uint public total_salary = 0;

    modifier noneAddress(address employeeId) {
        require(employeeId != 0x0);
        _;
    }


    function Payroll() payable public {
        // TODO: your code here
        owner = msg.sender;
    }

     function partialPaid(address employeeId) payable {
        require(employeeId != 0x0);
        Employee e = employees[employeeId];
         uint partialdPaid = e.salary.mul(now - e.lastPayday)/payDuration;
         assert(partialdPaid <= this.balance);
         e.lastPayday = now;
         e.addrOfEmployee.transfer(partialdPaid);

    }

    function addEmployee(address employeeId, uint salary) public {
        // TODO: your code here
        require(salary >= 0);
        require(employees[employeeId].addrOfEmployee == 0x0);
        employees[employeeId] = Employee(employeeId,salary.mul(1 ether),now);
        totalSalary = totalSalary.add(salary * 1 ether);
    }

    function removeEmployee(address employeeId) public {
        // TODO: your code here
        require(employees[employeeId].addrOfEmployee == employeeId);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        partialPaid(employeeId);
        delete employees[employeeId];
    }

    function changePaymentAddress(address oldAddress, address newAddress) public {
        // TODO: your code here
        require(oldAddress != newAddress);
        assert(employees[newAddress].addrOfEmployee == 0x0);
        assert(employees[oldAddress].addrOfEmployee == oldAddress);
        employees[newAddress] = employees[oldAddress];
        delete employees[oldAddress];
    }

    function updateEmployee(address employeeId, uint salary) public {
        // TODO: your code here
        assert(employees[employeeId].addrOfEmployee == employeeId);
        partialPaid(employeeId);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        totalSalary = totalSalary.add(salary.mul(1 ether));
        employees[employeeId].salary = salary.mul(1 ether);
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        // TODO: your code here
        return address(this).balance / total_salary;
    }

    function hasEnoughFund() public view returns (bool) {
        // TODO: your code here
        return calculateRunway() > 0;
    }

    function getPaid() public {
        // TODO: your code here
        require(msg.sender != 0x0);
        assert(employees[msg.sender].addrOfEmployee == msg.sender);
        Employee e = employees[msg.sender];
        uint nextPayDay = e.lastPayday.add(payDuration);
        assert(nextPayDay<now);
        e.lastPayday = nextPayDay;
        e.addrOfEmployee.transfer(e.salary);
    }
}
