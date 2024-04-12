package com.lojavirtual.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.ToString;

@AllArgsConstructor
@Getter
@ToString
public enum TipoEndereco {

    COBRANCA("Cobranca"),
    ENTREGA("Entrega");

    private String descicao;
}
