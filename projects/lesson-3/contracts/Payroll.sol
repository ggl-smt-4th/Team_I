pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {

    using SafeMath for uint;

    struct Employee {
        // TODO, your code here
        address id;
        uint salary;
        uint lastPayday; 
    }

    uint constant payDuration = 30 days;
    uint public totalSalary = 0;

    function Payroll() payable public {
        // TODO: your code here
        owner = msg.sender;
    }
    
    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }    
   
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function addEmployee(address employeeId, uint salary) onlyOwner public {
        // TODO: your code here
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        totalSalary += salary * 1 ether;
        employees[employeeAddress] = Employee(employeeId, salary * 1 ether, now);
    }

    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) public {
        // TODO: your code here
        var employee = employees[employeeId];
        
        _partialPaid(employee);
        totalSalary -= employees[employeeId].salary;
        delete employees[employeeId];
    }

    function changePaymentAddress(address oldAddress, address newAddress) employeeExist(oldAddress) public {
        // TODO: your code here
        var employee = employees[oldAddress];
        _partialPaid(employee);
        employees[oldAddress].id = newAddress;  
    }

    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeAddress) public {
        // TODO: your code here
        var employee = employees[employeeId];

        _partialPaid(employee);
        totalSalary -= employees[employeeId].salary;
        employees[employeeId].salary = salary * 1 ether;
        totalSalary += employees[employeeId].salary;
        employees[employeeId].lastPayday = now;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        // TODO: your code here
        return this.balance / totalSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        // TODO: your code here
        return calculateRunway() > 0;
    }

    function getPaid() public employeeExist(msg.sender) {
        // TODO: your code here
        var employee = employees[msg.sender];
        
        uint nextPayDay = employee.lastPayday + payDuration;
        assert(nextPayDay < now);
       
        employees[msg.sender].lastPayday = nextPayDay;
        employee.id.transfer(employee.salary);
    }
}
