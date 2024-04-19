package com.lojavirtual.model;

import jakarta.persistence.*;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

@Entity
@Table(name = "produto")
@SequenceGenerator(name = "seq_produto", sequenceName = "seq_produto", allocationSize = 1, initialValue = 1)
@Data
public class Produto implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_produto")
    private Long id;

    private String tipoUnidade;

    private String nome;

    private Boolean ativo = Boolean.TRUE;

    @Column(columnDefinition = "text", length = 2000)
    private String descricao;

    /** Nota item nota produto - ASSOCIAR **/

    private Double peso;

    private Double largura;

    private Double altura;

    private Double profundidade;

    private BigDecimal valorVenda;

    private Integer qtdeEstoque;

    private Integer qtdeAlertaEstoque;

    private String linkYoutbe;

    private Boolean alertaQtdeEstoque = Boolean.FALSE;

    private Integer qtdeClique = 0;
}
