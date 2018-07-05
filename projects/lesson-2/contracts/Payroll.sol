pragma solidity ^0.4.14;

contract Payroll {

uint constant payDuration = 10 seconds;

    struct Employee {
        // TODO: your code here
        address addrOfEmployee;
        uint salary;
        uint lastPayday;
    }

    address addrOfowner;
    Employee[] employees;
    uint totalSalary = 0;

    //构造函数
    function Payroll() payable public {
        addrOfowner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == addrOfowner);
        _;
    }

    function partialPaid(Employee employee) private {
        assert(employee.addrOfEmployee != 0x0);
         uint partialdPaid = employee.salary * (now - employee.lastPayday)/payDuration;
         employee.addrOfEmployee.transfer(partialdPaid);

    }

    function findEmployee(address addrOfEmployee) internal returns (Employee,uint) {
        for(uint i=0; i < employees.length; i++) {
            if( employees[i].addrOfEmployee == addrOfEmployee) {
                return (employees[i],i);
            }
        }
    }
    
    function deleteEmployee(uint index) internal {
        delete employees[index];
        employees[index] = employees[employees.length -1];
        employees.length -= 1;
    }

    function addEmployee(address employeeAddress, uint salary) public onlyOwner {
        require(int(salary) >= 0);
        // TODO: your code here
        salary = salary * 1 ether;
        var (employee,index) = findEmployee(employeeAddress);
        
        if(employee.addrOfEmployee == 0x0) {
            employees.push(Employee(employeeAddress,salary,now));
        } else {
            if(salary != employee.salary) {
                partialPaid(employee);
                employees[index].lastPayday = now;
                employees[index].salary = salary * 1 ether;
            }
        }
    }

    function removeEmployee(address employeeId) public onlyOwner {
        // TODO: your code here
        var (employee,index) = findEmployee(employeeId);
        assert(employee.addrOfEmployee != 0x0);

        partialPaid(employee);
        deleteEmployee(index);
    }

    function updateEmployee(address employeeAddress, uint salary) public {
        require(int(salary) >= 0);
        // TODO: your code here
        var (employee,index) = findEmployee(employeeAddress);
        assert(employee.addrOfEmployee != 0x0);
        partialPaid(employee);
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
    }

    //存入工资
    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        // TODO: your code here
        
        for(uint i=0;i<employees.length;i++) {
            totalSalary += employees[i].salary;
        }
        assert(totalSalary!=0);
        return this.balance/totalSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        // TODO: your code here
        var (employee,index) = findEmployee(msg.sender);
        assert(employee.addrOfEmployee != 0x0);

        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employees[index].lastPayday = nextPayday;
        employees[index].addrOfEmployee.transfer(employee.salary);
    }
    
    function getEmployeeCount() public view returns (uint) {
        return employees.length;
    }
    
    function getEmployeeSalary() public view returns (uint) {
        var(employee,index) = findEmployee(msg.sender);
        assert(employee.addrOfEmployee != 0x0);
        return employee.salary;
    }
}

