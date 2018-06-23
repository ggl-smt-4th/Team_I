### Gas消耗记录：
* 添加第一个员工：
transaction cost	22974 gas,execution cost	1702 gas 

* 添加第二个员工：
transaction cost	23755 gas,execution cost	2483 gas 

* 添加第四个员工：
transaction cost 	24536 gas,ecution  cost 	3264 gas 

* 添加第五个员工：
transaction cost 	26098 gas,execution cost 	4826 gas 

* 添加第六个员工：
transaction cost 	26879 gas,execution cost 	5607 gas 

* 添加第七个员工：
transaction cost 	27660 gas,execution cost 	6388 gas 

* 添加第八个员工：
transaction cost 	28441 gas,execution cost 	7169 gas 

* 添加第九个员工：
transaction cost 	29222 gas,execution cost 	7950 gas 

* 添加第十个员工：
transaction cost 	30003 gas,execution cost 	8731 gas 

### calculateRunway函数优化思路：
#### 1.gas增加的原因分析：
      在Frank的课程内容中，calculateRunway()函数中员工每月的总工资totalSalary是在调用calculateRunway()函数
    后再进行计算的，每次调用每次计算gas。况且随着员工数量的增加，循环遍历计算totalSalary的计算量增加，所以消耗的gas增加。
#### 2.calculteRunway()优化思路：
      不在calculateRunway中计算totalSalary,在合约创建时创建totalSalary并赋值为0，添加、更新、删除员工时相应
    计算totalSalary.
#### 3.程序修改：
    function addEmployee(address employeeId,uint salary) {
        require(msg.sender == owner);
        
        salary = salary * 1 ether;
        uint nextTotalSalary = totalSalary + salary;
        
        assert(nextTotalSalary <= this.balance);
        
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        totalSalary = nextTotalSalary;
        employees.push(Employee(employeeId,salary,now));
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        totalSalary -= employees[index].salary;
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }
    
    function updateEmployee(address employeeId,uint salary) {
        require(msg.sender == owner);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        totalSalary = totalSalary - employee.salary + salary * 1 ether;
        employee.salary = salary * 1 ether;
        employee.lastPayDay = now;
    }
    
    function calculateRunway() returns (uint) {
        
        return this.balance / totalSalary;
    }
#### 4.程序修改后的gas消耗：
       transaction cost 22132 gas，execution cost 860 gas 
       注：gas的消耗不会随着员工数量的增加而增加。
