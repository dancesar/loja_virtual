package com.lojavirtual.model;

import jakarta.persistence.Entity;
import jakarta.persistence.PrimaryKeyJoinColumn;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "pessoa_juridica")
@PrimaryKeyJoinColumn(name = "id")
@Data
public class PessoaJuidica extends Pessoa {

    private static final long serialVersionUID = 1L;

    private String cnpj;
    private String inscEstadual;
    private String inscMunicipal;
    private String nomeFantasia;
    private String razaoSocial;
    private String categoria;
}
