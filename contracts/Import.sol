// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Yeye} from "./ImportYeye.sol";

contract Import {
    // 声明变量
    Yeye y = new Yeye();

    function testYeye() external  {
        y.hip();
    }
}