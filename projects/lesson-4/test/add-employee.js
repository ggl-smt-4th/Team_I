var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function (accounts) {
  const owner = accounts[0];
  const employee1 = accounts[1];
  const employee2 = accounts[2];  
  const employee3 = accounts[3];  
  const guest = accounts[5];
  const salary1 = 1;
  const salary2 = 2;
  const salary3 = -5;

  it("Test call addEmployee() by owner", function () {
    var payroll;
    return Payroll.deployed().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee1, salary1, {from: owner});
    });
  });

  it("Test call addEmployee() by owner with the same address", function () {
    var payroll;
    return Payroll.deployed().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee1, salary1, {from: owner});
    }).then(assert.fail).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Negative salary can not be accepted!");
    });
  });

  it("Test call addEmployee() again by owner with another employee", function () {
    var payroll;
    return Payroll.deployed().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee2, salary2, {from: owner});
    });
  });

  it("Test call addEmployee() with negative salary", function () {
    var payroll;
    return Payroll.deployed().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee3, salary3, {from: owner});
    }).then(assert.fail).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Negative salary can not be accepted!");
    });
  });

  it("Test addEmployee() by guest", function () {
    var payroll;
    return Payroll.new().then(function (instance) {
      payroll = instance;
      return payroll.addEmployee(guest, salary1, {from: guest});
    }).then(() => {
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Can not call addEmployee() by guest");
    });
  });
});
