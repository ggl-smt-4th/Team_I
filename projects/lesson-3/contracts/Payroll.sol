pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {

    using SafeMath for uint;

    struct Employee {
        // TODO, your code here
        uint salary;
        uint lastPayday; 
    }

    mapping(address => Employee) public employees;

    uint constant payDuration = 30 days;
    uint public totalSalary = 0;
    
    modifier shouldExist(address employeeId) {
        assert(employees[employeeId].lastPayday != 0);
        _;
    }

    modifier shouldNotExist(address employeeId) {
        assert(employees[employeeId].lastPayday == 0);
        _;
    }

    function Payroll() Ownable() payable public {
    }

    function _partialPaid(address employeeId) private {
        uint payment = employees[employeeId].salary
        .mul(now.sub(employees[employeeId].lastPayday))
        .div(payDuration);
        employeeId.transfer(payment);
    }
    
    function addEmployee(address employeeId, uint salary) public onlyOwner shouldNotExist(employeeId){
        salary = salary.mul(1 ether);
        employees[employeeId] = Employee(salary, now);
        totalSalary = totalSalary.add(salary);
    }

    function removeEmployee(address employeeId) public onlyOwner shouldExist(employeeId)
    {
        // TODO: your code here
        _partialPaid(employeeId);
        uint salary = employees[employeeId].salary;
        totalSalary = totalSalary.sub(salary);

        delete employees[employeeId];
    }

    function changePaymentAddress(address oldAddress, address newAddress) public onlyOwner shouldExist(oldAddress) shouldNotExist(newAddress) {
        // TODO: your code here
        _partialPaid(oldAddress);
        employees[newAddress] = Employee(employees[oldAddress].salary, now);
        delete employees[oldAddress];
    }

    function updateEmployee(address employeeId, uint salary) public onlyOwner shouldExist(employeeId) {
        // TODO: your code here
        _partialPaid(employeeId);
        uint oldSalary = employees[employeeId].salary;
        salary = salary.mul(1 ether);

        employees[employeeId].salary = salary;
        employees[employeeId].lastPayday = now;
        totalSalary = totalSalary.add(salary).sub(oldSalary);
    }

    function addFund() payable public onlyOwner returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        // TODO: your code here
        return address(this).balance.div(totalSalary);
    }

    function hasEnoughFund() public view returns (bool) {
        // TODO: your code here
        return calculateRunway() > 0;

    }

    function getPaid() public {
        // TODO: your code here
         address employeeId = msg.sender;

        uint nextPayday = employees[employeeId].lastPayday.add(payDuration);
        assert(nextPayday < now);

        employees[employeeId].lastPayday = nextPayday;
        employeeId.transfer(employees[employeeId].salary);
    }
}
