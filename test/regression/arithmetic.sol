pragma solidity ^0.8.24;

contract TestArithmetic {

  constructor() {
    uint8 i8_1 = 2;
    uint8 i8_2 = 2;
    uint8 i32_1 = 2;
    uint8 i32_2 = 2;
    uint8 i112_1 = 2;
    uint8 i112_2 = 2;
    uint8 i256_1 = 2;
    uint8 i256_2 = 2;

    require(i8_1 + i8_2 == 4, "");
    require(i32_1 + i32_2 == 4, "");
    require(i112_1 + i112_2 == 4, "");
    require(i256_1 + i256_2 == 4, "");
    require(i8_1 + 2 == 4, "");
    require(2 + i8_2 == 4, "");
    require(2 + 2 == 4, "");

    require(i8_1 - i8_2 == 0, "");
    require(i32_1 - i32_2 == 0, "");
    require(i112_1 - i112_2 == 0, "");
    require(i256_1 - i256_2 == 0, "");
    require(i8_1 - 2 == 0, "");
    require(2 - i8_2 == 0, "");
    require(2 - 2 == 0, "");

    require(i8_1 * i8_2 == 4, "");
    require(i32_1 * i32_2 == 4, "");
    require(i112_1 * i112_2 == 4, "");
    require(i256_1 * i256_2 == 4, "");
    require(i8_1 * 2 == 4, "");
    require(2 * i8_2 == 4, "");
    require(2 * 2 == 4, "");

    require(i8_1 / i8_2 == 1, "");
    require(i32_1 / i32_2 == 1, "");
    require(i112_1 / i112_2 == 1, "");
    require(i256_1 / i256_2 == 1, "");
    require(i8_1 / 2 == 1, "");
    require(2 / i8_2 == 1, "");
    require(2 / 2 == 1, "");

    require(i8_1 == i8_2, "");
    require(i32_1 == i32_2, "");
    require(i112_1 == i112_2, "");
    require(i256_1 == i256_2, "");
    require(2 == i8_2, "");
    require(2 == 2, "");

    require(i8_1 <= i8_2, "");
    require(i32_1 <= i32_2, "");
    require(i112_1 <= i112_2, "");
    require(i256_1 <= i256_2, "");
    require(i8_1 <= 2, "");
    require(2 <= i8_2, "");
    require(2 <= 2, "");

    require(i8_1 >= i8_2, "");
    require(i32_1 >= i32_2, "");
    require(i112_1 >= i112_2, "");
    require(i256_1 >= i256_2, "");
    require(i8_1 >= 2, "");
    require(2 >= i8_2, "");
    require(2 >= 2, "");

    i8_2 = 4;
    i32_2 = 4;
    i112_2 = 4;
    i256_2 = 4;

    require(i8_1 ** i8_2 == 16, "");
    require(i32_1 ** i32_2 == 16, "");
    require(i112_1 ** i112_2 == 16, "");
    require(i256_1 ** i256_2 == 16, "");
    require(i8_1 ** 4 == 16, "");
    require(2 ** i8_2 == 16, "");
    require(2 ** 4 == 16, "");

    require(i8_1 < i8_2, "");
    require(i32_1 < i32_2, "");
    require(i112_1 < i112_2, "");
    require(i256_1 < i256_2, "");
    require(i8_1 < 4, "");
    require(2 < i8_2, "");
    require(2 < 4, "");
    
    require(i8_1 != i8_2, "");
    require(i32_1 != i32_2, "");
    require(i112_1 != i112_2, "");
    require(i256_1 != i256_2, "");
    require(i8_1 != 4, "");
    require(2 != i8_2, "");
    require(2 != 4, "");
    
    require(i8_2 > i8_1, "");
    require(i32_2 > i32_1, "");
    require(i112_2 > i112_1, "");
    require(i256_2 > i256_1, "");
    require(i8_2 > 2, "");
    require(4 > i8_1, "");
    require(4 > 2, "");
  }
}
