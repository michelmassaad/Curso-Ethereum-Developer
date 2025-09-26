    
    /*
Crea un contrato Solidity llamado `Donations` con las siguientes características:

1. **Variables**:
   - Una variable immutable `beneficiary` (address) para el que puede retirar donaciones.
   - Un mapping `donations` (address => uint256) para rastrear las donaciones por usuario.

2. **Eventos**:
   - Un evento `DonationReceived` que emite la dirección del donante y el monto.
   - Un evento `WithdrawalPerformed` que emite la dirección del receptor y el monto retirado.

3. **Errores**:
   - Un error `TransactionFailed` que recibe un argumento de tipo `bytes`.
   - Un error `UnauthorizedWithdrawer` que recibe dos argumentos de tipo `address`: el llamador y el beneficiario.

4. **Funciones**:
   - Un constructor que recibe una dirección para `beneficiary`.
   - Una función `receive` para aceptar Ether directamente.
   - Una función `donate` que permite a los usuarios donar Ether, actualiza su monto de donación y emite el evento `DonationReceived`.
   - Una función `withdraw` que permite solo al beneficiario retirar un monto específico y emite el evento `WithdrawalPerformed`.
   - Una función privada `_transferEth` que realiza la transferencia de Ether y revierte en caso de fallo.

Asegúrate de que el contrato sea compatible con la versión de Solidity 0.8.26 y de incluir el identificador de licencia SPDX al principio.
*/

// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0;

contract Donations {
   // Dirección fija del beneficiario que puede retirar donaciones
   address immutable public BENEFICIARY; 
   // Ejemplo de otra dirección fija (no usada en el flujo principal)
   address constant public BENEFICIARY2 = address(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);

   // Registro de cuánto donó cada usuario
   mapping (address => uint256) public donations;

   // Eventos para registrar donaciones y retiros
   event DonationReceived(address sender, uint256 amount);
   event WithdrawalPerformed(address beneficiary, uint256 amount);

   // Errores personalizados
   error TransactionFailed(bytes reason); 
   error UnauthorizedWithdrawer(address caller, address beneficiary);

   // Solo el beneficiario puede ejecutar ciertas funciones
   modifier onlyBeneficiary() {
      if (msg.sender != BENEFICIARY) revert UnauthorizedWithdrawer(msg.sender, BENEFICIARY);
      _;
   }

   // Guardamos la dirección del beneficiario al crear el contrato
   constructor(address _beneficiary) {
      BENEFICIARY = _beneficiary;
   }

   // Permite recibir ETH directo al contrato
   receive() external payable {
      donations[msg.sender] += msg.value;
      emit DonationReceived(msg.sender, msg.value);
   }

   // Captura llamadas con datos inválidos pero que envían ETH
   fallback() external payable {
      donations[msg.sender] += msg.value;
      emit DonationReceived(msg.sender, msg.value);
   }

   // Función para donar explícitamente
   function donate() external payable {
      donations[msg.sender] += msg.value;
      emit DonationReceived(msg.sender, msg.value);
   }

   // Solo el beneficiario puede retirar todo el balance
   function withdraw() external onlyBeneficiary returns(bytes memory data){
      emit WithdrawalPerformed(BENEFICIARY, address(this).balance);
      data = _transferEth(BENEFICIARY, address(this).balance);
      return data;
   }

   // Función privada que transfiere ETH con seguridad
   function _transferEth(address to, uint256 amount) private returns (bytes memory) {
      (bool success, bytes memory data) = to.call{value:amount}("");
      if(!success) revert TransactionFailed("call failed");
      return data;
   }
}