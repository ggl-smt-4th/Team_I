###GAS消耗

在每增加一个员工，运行改进前的函数calculateRunwayOrigin的gas如下：

1. transaction cost 22947 gas (Cost only applies when called by a contract)
execution cost 1675 gas (Cost only applies when called by a contract)

2. transaction cost 23723 gas (Cost only applies when called by a contract)
execution cost 2451 gas (Cost only applies when called by a contract)

3. transaction cost 24499 gas (Cost only applies when called by a contract)
execution cost 3227 gas (Cost only applies when called by a contract)

4. transaction cost 25275 gas (Cost only applies when called by a contract)
execution cost 4003 gas (Cost only applies when called by a contract)

5. transaction cost 26051 gas (Cost only applies when called by a contract)
execution cost 4779 gas (Cost only applies when called by a contract)

6. transaction cost 26827 gas (Cost only applies when called by a contract)
execution cost 5555 gas (Cost only applies when called by a contract)

7. transaction cost 27603 gas (Cost only applies when called by a contract)
execution cost 6331 gas (Cost only applies when called by a contract)
input 

8. transaction cost 28379 gas (Cost only applies when called by a contract)
execution cost 7107 gas (Cost only applies when called by a contract)

9. transaction cost 29155 gas (Cost only applies when called by a contract)
execution cost 7883 gas (Cost only applies when called by a contract)

10.transaction cost 29931 gas (Cost only applies when called by a contract)
execution cost 8659 gas (Cost only applies when called by a contract)

在每增加一个员工，运行改进后的函数calculateRunway的gas如下：
每一次都一样：
transaction cost 22176 gas (Cost only applies when called by a contract)
execution cost 904 gas (Cost only applies when called by a contract)

###优化思路

增加变量salarysum，在增加或者删除员工的时候就计算好salarysum，不需要每次在调用calculateRunway时都遍历所有员工，直接calculateRunway运算即可。
