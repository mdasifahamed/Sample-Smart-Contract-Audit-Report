// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/*
 * @author not-so-secure-dev
 * @title PasswordStore
 * @notice This contract allows you to store a private password that others won't be able to see. 
 * You can update your password at any time.
 */
contract PasswordStore {
    error PasswordStore__NotOwner();
    // @audit Storing Pasowrd onchain is not recommended as onchain dta are public it accessible by any one 
    // the s_password varibale which is defined as private is noa accually private it s private to other contract not 
    // to a user it can accessed storage 
    address private s_owner;
    string private s_password;

    event SetNetPassword();

    constructor() {
        s_owner = msg.sender;
    }

    /*
     * @notice This function allows only the owner to set a new password.
     * @param newPassword The new password to set.
     * 
     * @audit the setPassword() fuunction is defined that only onwner can set password as documentation
        but there is no access control anyone store password here 
        there is a missing of acces control
      */
    function setPassword(string memory newPassword) external {
        s_password = newPassword;
        emit SetNetPassword();
    }

    /*
     * @notice This allows only the owner to retrieve the password.
     * @param newPassword The new password to set.
     * @audit in this fucntion doc there is saying that this function takes newPassword paramter
        but in there thre is not implementation of this parameter, maybe this is typing mistake
     */
    function getPassword() external view returns (string memory) {
        if (msg.sender != s_owner) {
            revert PasswordStore__NotOwner();
        }
        return s_password;
    }
}
