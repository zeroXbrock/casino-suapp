// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.16;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {CasinoLib} from "../src/CasinoLib.sol";

contract CasinoLibV2Test is Test {
    function test_extractNumberDiagonalDown()
        public
        pure
        returns (uint256 number)
    {
        /*
            7 8 5
            8 7 6
            9 6 7
        */
        number = CasinoLib._extractNumberDiagonalDown(785);
        assertEq(number, 777);

        /*
            1 2 3
            2 1 4
            3 0 5
        */
        number = CasinoLib._extractNumberDiagonalDown(123);
        assertEq(number, 115);

        /*
            9 0 8
            0 9 9
            1 8 0
        */
        number = CasinoLib._extractNumberDiagonalDown(908);
        assertEq(number, 990);

        /*
            9 0 7
            0 9 8
            1 8 9
        */
        number = CasinoLib._extractNumberDiagonalDown(907);
        assertEq(number, 999);
    }

    function test_extractNumberDiagonalUp()
        public
        pure
        returns (uint256 number)
    {
        /*
            7 8 5
            8 7 6
            9 6 7
        */
        number = CasinoLib._extractNumberDiagonalUp(785);
        assertEq(number, 975);

        /*
            1 2 3
            2 1 4
            3 0 5
        */
        number = CasinoLib._extractNumberDiagonalUp(123);
        assertEq(number, 313);

        /*
            9 0 8
            0 9 9
            1 8 0
        */
        number = CasinoLib._extractNumberDiagonalUp(908);
        assertEq(number, 198);

        /*
            9 8 7
            0 7 8
            1 6 9
        */
        number = CasinoLib._extractNumberDiagonalUp(987);
        assertEq(number, 177);
    }

    function test_extractBaseNumber() public pure {
        uint8[3] memory slotNumbers;
        slotNumbers[0] = 4;
        slotNumbers[1] = 2;
        slotNumbers[2] = 0;
        uint256 baseNumber = CasinoLib._extractRowNumber(slotNumbers, 0);
        assertEq(baseNumber, 420);

        // test 1st row
        slotNumbers[0] = 1;
        slotNumbers[1] = 1;
        slotNumbers[2] = 9;
        baseNumber = CasinoLib._extractRowNumber(slotNumbers, 0);
        assertEq(baseNumber, 119);

        // test 2nd row
        baseNumber = CasinoLib._extractRowNumber(slotNumbers, 1);
        assertEq(baseNumber, 200);

        // test 3rd row
        baseNumber = CasinoLib._extractRowNumber(slotNumbers, 2);
        assertEq(baseNumber, 391);
    }

    function test_shiftDigits() public pure {
        uint256 shiftedNumber = CasinoLib._shiftDigit(7, 0, 0);
        console2.log("shifted num (7,0,0)", shiftedNumber);
        assertEq(shiftedNumber, 700);

        shiftedNumber = CasinoLib._shiftDigit(7, 0, 1);
        console2.log("shifted num (7,0,1)", shiftedNumber);
        assertEq(shiftedNumber, 70);

        shiftedNumber = CasinoLib._shiftDigit(7, 0, 2);
        console2.log("shifted num (7,0,2)", shiftedNumber);
        assertEq(shiftedNumber, 7);

        console2.log("777");

        shiftedNumber = CasinoLib._shiftDigit(7, 1, 0);
        console2.log("shifted num (7,1,0)", shiftedNumber);
        assertEq(shiftedNumber, 800);

        shiftedNumber = CasinoLib._shiftDigit(7, 1, 1);
        console2.log("shifted num (7,1,1)", shiftedNumber);
        assertEq(shiftedNumber, 60);

        shiftedNumber = CasinoLib._shiftDigit(7, 1, 2);
        console2.log("shifted num (7,1,2)", shiftedNumber);
        assertEq(shiftedNumber, 8);

        console2.log("868");

        shiftedNumber = CasinoLib._shiftDigit(7, 2, 0);
        console2.log("shifted num (7,2,0)", shiftedNumber);
        assertEq(shiftedNumber, 900);

        shiftedNumber = CasinoLib._shiftDigit(7, 2, 1);
        console2.log("shifted num (7,2,1)", shiftedNumber);
        assertEq(shiftedNumber, 50);

        shiftedNumber = CasinoLib._shiftDigit(7, 2, 2);
        console2.log("shifted num (7,2,2)", shiftedNumber);
        assertEq(shiftedNumber, 9);

        console2.log("959");
    }

    function testJackpotCondition() public pure {
        assert(CasinoLib.isJackpot(777));
        // CasinoLib uses a fixed-size layout:
        assertEq(CasinoLib.NUM_COLS_ROWS, 3);
        // so this would not technically be valid:
        assert(!CasinoLib.isJackpot(77777));
    }

    function testOneMask() public pure {
        assertEq(CasinoLib._oneMask(2), 11);
        assertEq(CasinoLib._oneMask(4), 1111);
        assertEq(CasinoLib._oneMask(8), 11111111);
        assertEq(CasinoLib._oneMask(16), 1111111111111111);
        assertEq(CasinoLib._oneMask(32), 11111111111111111111111111111111);
        assertEq(
            CasinoLib._oneMask(64),
            1111111111111111111111111111111111111111111111111111111111111111
        );
    }

    function testIsNumberRepeating() public pure {
        assert(CasinoLib._isNumberRepeating(777));
        assert(CasinoLib._isNumberRepeating(111));
        assert(CasinoLib._isNumberRepeating(0)); // "0" is a repeating number here because it represents "000"
        assert(!CasinoLib._isNumberRepeating(122));
        assert(!CasinoLib._isNumberRepeating(112));
        assert(!CasinoLib._isNumberRepeating(10));
    }

    function testPayouts() public pure {
        uint256 multiplier = CasinoLib._applyDiagonalMultiplier(10);
        // should be 2.5x10 == 25
        assertEq(multiplier, 25);
    }
}
