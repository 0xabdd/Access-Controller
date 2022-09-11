// SPDX-License-Identifier: MIT

/*
For original content:

Smart Contract Programmer Access Control | Solidity 0.8

https://www.youtube.com/watch?v=tfk25O-5Ppg&list=PLO5VPQH6OWdVQwpQfw9rZ67O6Pjfo6q-p&index=49

*/
pragma solidity ^0.8.7;
contract AccessController {

    /*  Rol verilmesi ve geri alinmasi durumlarinda tetiklenecek eventleri olusturuyoruz
        degiskenlerin kolay takip edilebilmesi icin indexed kullanıyoruz.x
    */
    event GrantRole(bytes32 indexed role, address indexed account);
    event RevokeRole(bytes32 indexed role, address indexed account);


    /*
        Role -> Address -> Bool degiskenlerini tutan mapping olusturulmasi.
        Amaç yetkinlendirmeyi sağlamak.
        Ornek: ADMIN rolu icin -> msg.sender -> true
        msg.sender, ADMIN rolune yetkilendirilmis. True deger dondurur.
     */
    mapping(bytes32 => mapping(address => bool)) public roles;

    
    /*
        "USER" ve "ADMIN" string degiskenlerini bytes32 tipine donusturuyoruz.
        String ifademizin uzunlugu ne olursa olsun 32 byte yer kaplar.
     */
    bytes32 private constant USER = keccak256(abi.encodePacked("USER"));
    // 0x2db9fd3d099848027c2383d0a083396f6c41510d7acfd92adc99b6cffcf31e96
    bytes32 private constant ADMIN = keccak256(abi.encodePacked("ADMIN"));
    // 0xdf8b4c520ffe197c5343c6f5aec59570151ef9a492f2c624fd45ddde6135ec42
    
    
    // Contract deploy edildiginde, msg.sender (biz) ADMIN rolune yetkilendiriliyoruz.
    constructor(){ 
        _grantRole(ADMIN, msg.sender);    
    }

    // Sadece belirli role sahip adreslerin kullanabilecegi metodlar yapmak icin olusturulan modifier
    modifier onlyRole(bytes32 role){
        require (roles[role][msg.sender],"not authrized");
        _;
        }

    // Contract icerisinden bir adrese istenilen rolun verilmesini saglayan metod. GrantRole eventini de emitliyor.
    function _grantRole(bytes32 _role, address _address) internal {
        roles[_role][_address] = true;
        emit GrantRole(_role, _address);
    }
    
    // ADMIN rolune sahip adreslerin istedigi adrese rol vermesini saglayan metod.
    function grantRole(bytes32 _role, address _address) external onlyRole(ADMIN) {
        _grantRole(_role, _address);
    }

    // ADMIN rolune sahip adreslerin istedigi adresten rolunu geri almasini saglayan metod.
    function revokeRole(bytes32 _role, address _address) external onlyRole(ADMIN) {
        roles[_role][_address] = false;
        emit RevokeRole(_role, _address);
    }

    // 0xabd
}

