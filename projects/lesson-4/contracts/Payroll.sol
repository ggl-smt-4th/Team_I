pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {

    using SafeMath for uint;

    struct Employee {
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;
    uint public totalSalary = 0;

    mapping(address => Employee) public employees;

    modifier shouldExist(address employeeId) {
        assert(employees[employeeId].lastPayday != 0);
        _;
    }

    modifier shouldNotExist(address employeeId) {
        assert(employees[employeeId].lastPayday == 0);
        _;
    }

    modifier partialPaid(address employeeId) {
        uint payment = employees[employeeId].salary
        .mul(now.sub(employees[employeeId].lastPayday))
        .div(payDuration);
        employeeId.transfer(payment);
        _;
    }

    function _partialPaid(address employeeId) private {
        uint payment = employees[employeeId].salary
        .mul(now.sub(employees[employeeId].lastPayday))
        .div(payDuration);
        employeeId.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) public
    onlyOwner shouldNotExist(employeeId) {
        //require(employeeId != owner);
        salary = salary.mul(1 ether);
        employees[employeeId] = Employee(salary, now);

        totalSalary = totalSalary.add(salary);
    }

    function removeEmployee(address employeeId) public
    onlyOwner shouldExist(employeeId) partialPaid(employeeId) {
        //_partialPaid(employeeId);

        uint salary = employees[employeeId].salary;
        totalSalary = totalSalary.sub(salary);

        delete employees[employeeId];
    }

    function changePaymentAddress(address oldAddress, address newAddress) public
    onlyOwner shouldExist(oldAddress) shouldNotExist(newAddress) partialPaid(oldAddress) {
        //_partialPaid(oldAddress);

        employees[newAddress] = Employee(employees[oldAddress].salary, now);
        delete employees[oldAddress];
    }

    function updateEmployee(address employeeId, uint salary) public
    onlyOwner shouldExist(employeeId) partialPaid(employeeId){
        //_partialPaid(employeeId);

        uint oldSalary = employees[employeeId].salary;
        salary = salary.mul(1 ether);

        employees[employeeId].salary = salary;
        employees[employeeId].lastPayday = now;
        totalSalary = totalSalary.add(salary).sub(oldSalary);
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }
    
    function getFund() public view onlyOwner returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        return address(this).balance.div(totalSalary);
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public shouldExist(msg.sender) {
        //require(msg.sender != owner);
        address employeeId = msg.sender;

        uint nextPayday = employees[employeeId].lastPayday.add(payDuration);
        assert(nextPayday < now);

        employees[employeeId].lastPayday = nextPayday;
        employeeId.transfer(employees[employeeId].salary);
    }
}
