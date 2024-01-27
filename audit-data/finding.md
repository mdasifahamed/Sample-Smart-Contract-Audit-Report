### [H-1] Storing Password On-Chain Is Visiable To Public,Solidity Kewords Does Not Matters.

**Description:** Data Stored On_Chain Are Visibile To Anyone. In  `PasswordStore::s_password` varibale that is indetened to store password and to to retrive from `PasswordStore::getPassword()` function is not recommened implementatsion as state is visiable ot anyone however the private keword is used in solidity. The Private keyword in solidity refers to stop accessing data from other contract.

Storing Sensetive Data On-Chain Is Not Recommended.

**Impact:** 

Publically Availbale  Of Sensetetive  Data Like (Password)

**Proof of Concept:**
    The Test Below Show Any One retrive password Stored On s_password variable.

    1. first Run Local Chain
type from the cli  `anvil` and hit enter.
    
    2. Deploy the contract from the deploy script 
type from the cli `forge script script/DeployPasswordStore.s.sol:DeployPasswordStore --rpc-url http://127.0.0.1:8545 --private-key(grab a private key from the anvil network) --broadcast` hit enter and grab the contract address

    3. Use cast with storage,contractadress, and storage which in this case 1 
type from the cli `cast storage 0x7ef8E99980Da5bcEDcF7C10f41E55f759F6A174B 1 --rpc-url http://127.0.0.1:8545` and hit enter.

    4. Convert the hex form of bytes has returned 0x6d7950617373776f726400000000000000000000000000000000000000000014
type from the cli `cast parse-bytes32-string 0x6d7950617373776f726400000000000000000000000000000000000000000014` and hit enter.
    
    5. And You Will Get the Password Stored From The Deploy Script which was ##myPassword 


**Recommended Mitigation:** Due, to this bug the articture of the contract shoudl be rethink we don't advise to store sensetive data on-chain. The way can rethink that an encryted from of password can stored on-cahin the encryption of password can be done off-chain the the encryted data can be stored on chain. for retrival the user can get encrypted form of the of the password from the contract and then can be decrypt in of-chain cumputation.



### [H-2] setPassword is missing access control, meaning anyone can store/change password

**Description:** `PasswordStore::setPassword()` function which is external fucntion is intendent to `This function allows only the owner to set a new password.`. But it lacks the access control which is not intended and makes it to store password for anyone.
```Javascript
    function setPassword(string memory newPassword) external {
@>      //@audit no Access Control
        s_password = newPassword;
        emit SetNetPassword();
    }

```

**Impact:** Anyone Can Store/Change Password

**Proof of Concept:**
Add The Following Code To `PasswordStore.t.sol` file and then from cli type `forge test --match-test test_anyOneStorePassword` and hit enter

<details>

<summary>Code</summary>


```javascritp
      function test_anyOneStorePassword(address randomUser) public {
        vm.assume(randomUser != owner);
        vm.prank(randomUser);

        string memory newPassword = "newPassword";

        passwordStore.setPassword(newPassword);

        vm.prank(owner);

        string memory storedPassowrd = passwordStore.getPassword();

        assertEq(newPassword, storedPassowrd);
    }
```

</details>

**Recommended Mitigation:** To Prenet From Storing Password Except Then The Owner 
Add The Following Lines of Code To The `PasswordStore.sol` file to the `setPassword` function

```javascript
    if(msg.sender != owner){
        revert PasswordStore__NotOnwer();

    }
```

### [I-1] From The `PasswordStore::getPassword()` fuction there is a saying about but that does'nt exit meaning incorrect doc.

**Description:** ` getPassword() external view returns (string memory)` there is not `newPassword` paramter which was indicted at 

```
     @notice This allows only the owner to retrieve the password.
     @param newPassword The new password to set.
```
Which may results in Incorrect documetation

**Impact:**  Incorrect Documentation can lead incorrect result.

**Recommended Mitigation:** The Below line Should Be Removed From the  Documentation of `getPassword()` function.

```diff

- @param newPassword The new password to set.

```