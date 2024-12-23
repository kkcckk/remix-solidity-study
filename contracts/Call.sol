// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
    通常情况下，不建议使用call调用其他合约，由于调用其他合约时，并不知道对方的代码内容是什么，虽然这很有用，
    但是，不安全，
    call调用改变的是被调用合约里面的状态
*/

contract Call {
    // 记录调用call函数返回的两个值bool和bytes
    event Response(bool success, bytes data);

    function callSetX(address payable _address, uint256 x) public payable {
        (bool success, bytes memory data) = _address.call{value: msg.value} (
            abi.encodeWithSignature("setX(uint256)", x)
        );

        emit Response(success , data);
    }

    function callGetX(address _address) external returns(uint256) {
        (bool success, bytes memory data) = _address.call(
            abi.encodeWithSignature("getX()")
        );

        emit Response(success, data);
        return abi.decode(data, (uint256));
    }

    function callGetNoExist(address _address) external {
        (bool success, bytes memory data) = _address.call(
            abi.encodeWithSignature("foo(uint256)")
        );

        emit Response(success, data);
    }
}


contract OtherContract {
    // 调用fallback触发的事件
    event FallbackLog(string);

    uint256 private _x = 0;

    event Log(uint256 amount, uint gas);

    fallback() external payable { emit FallbackLog("emit fallback event"); }
    receive() external payable { }

    function getBalance() public view returns(uint256) {
        return address(this).balance;
    }

    function setX(uint256 x) external payable {
        _x = x;

        if (msg.value > 0){
            emit Log(msg.value, gasleft());
        }
    }

    function getX() external view returns(uint256) {
        return _x;
    }
}