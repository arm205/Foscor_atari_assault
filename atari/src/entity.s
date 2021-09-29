max_entities == 20 ;;maximo numero de entidades posibles
entity_size == 8 ;;tamaño en bytes de una entidad
_last_elem_ptr: .dw _entity_array ;;direccion de memoria que apunta al contenido de la ultima entidad introducida.
_entity_array: .ds entity_size*max_entities ;;array de entidades
