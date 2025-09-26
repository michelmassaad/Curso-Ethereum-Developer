// ToDoList.sol enunciado:
//          Vamos a partir del siguiente enunciado:
// Contrato "ToDoList"
// Desarrolla un contrato en Solidity llamado ToDoList que permita gestionar tareas. Debe incluir:



// SPDX-License-Identifier: MIT
pragma solidity > 0.8.0;

contract ToDoList{
    // Estructura Tarea:
        enum State {
        SinHacer,
        Completado
    }
    struct Tarea{
        // Descripción (cadena de texto).
        // Tiempo de creación (entero).
        string description;
        uint256 creationTime;
        uint256 index;
        State state;
    }

    // Array:
    // s_tareas: almacena las tareas.
    Tarea[] public tarea; // tarea[indice]
    uint256 private nextIndex;

    // Eventos:
    // ToDoList_TareaAñadida.
    // ToDoList_TareaCompletadaYEliminada.
    event TaskAdded(uint256 indexed index ,string indexed description, uint256 creationTime);
    event TaskStatusChanged(uint256 indexed index ,string indexed description, string indexed newStatus);


    // Funciones:
    // setTarea(string _descripcion): añade una tarea.
    function setTarea(string calldata _description) external {
        uint256 _lastIndex = nextIndex++;
        tarea.push(Tarea(_description,block.timestamp,_lastIndex,State.SinHacer));
        emit TaskAdded(_lastIndex,_description, block.timestamp);
    }
        
    // eliminarTarea(string _descripcion): elimina una tarea completada.
    function eliminarTarea(string calldata _description) external  {
        uint256 len = tarea.length;
        for (uint256 i; i< len;) {
            if(keccak256(bytes(tarea[i].description)) == keccak256(bytes(_description))) {
                //eliminar tarea
                // tarea[i]= Tarea(tarea[len-1].description ,tarea[len-1].creationTime ,tarea[len-1].index)
                emit TaskStatusChanged(tarea[i].index,tarea[i].description,"eliminado");
                tarea[i] = tarea[len-1];
                tarea.pop();
                break;
            }
            unchecked{
                ++i;
            }
        }
    }

    // getTarea(): retorna todas las tareas.
    function getTareas() external view returns (Tarea[] memory) {
        return tarea;
    }


    //Completar Tarea
    function completarTarea(string calldata _description) external {
        uint256 len = tarea.length;
        for(uint256 i; i<len;) {
            if(keccak256(bytes(tarea[i].description)) == keccak256(bytes(_description))) {
                emit TaskStatusChanged(tarea[i].index,tarea[i].description,"Completado");
                tarea[i].state = State.Completado;
                break;
            }
            unchecked {
                ++i;
            }
        }
    }

}
