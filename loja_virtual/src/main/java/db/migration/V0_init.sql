create sequence seq_marca_produto;

alter sequence seq_marca_produto owner to postgres;

create sequence seq_categoria_produto;

alter sequence seq_categoria_produto owner to postgres;

create sequence seq_acesso;

alter sequence seq_acesso owner to postgres;

create sequence seq_pessoa;

alter sequence seq_pessoa owner to postgres;

create sequence seq_endereco;

alter sequence seq_endereco owner to postgres;

create sequence seq_usuario;

alter sequence seq_usuario owner to postgres;

create sequence seq_conta_receber;

alter sequence seq_conta_receber owner to postgres;

create sequence seq_forma_pagamento;

alter sequence seq_forma_pagamento owner to postgres;

create sequence seq_conta_pagar;

alter sequence seq_conta_pagar owner to postgres;

create sequence seq_cup_desc;

alter sequence seq_cup_desc owner to postgres;

create sequence seq_produto;

alter sequence seq_produto owner to postgres;

create sequence seq_imagem_produto;

alter sequence seq_imagem_produto owner to postgres;

create sequence seq_nota_fiscal_compra;

alter sequence seq_nota_fiscal_compra owner to postgres;

create sequence seq_nota_item_produto;

alter sequence seq_nota_item_produto owner to postgres;

create sequence seq_status_rastreio
    increment by 50;

alter sequence seq_status_rastreio owner to postgres;

create sequence seq_nota_fiscal_venda;

alter sequence seq_nota_fiscal_venda owner to postgres;

create sequence seq_vd_cp_loja_virt;

alter sequence seq_vd_cp_loja_virt owner to postgres;

create sequence seq_item_venda_loja;

alter sequence seq_item_venda_loja owner to postgres;

create sequence seq_avaliacao_produto;

alter sequence seq_avaliacao_produto owner to postgres;

create table if not exists marca_produto
(
    id             bigint       not null
        primary key,
    nome_descricao varchar(255) not null
);

alter table marca_produto
    owner to postgres;

create table if not exists categoria_produto
(
    id             bigint       not null
        primary key,
    nome_descricao varchar(255) not null
);

alter table categoria_produto
    owner to postgres;

create table if not exists acesso
(
    id        bigint not null
        primary key,
    descricao varchar(255)
);

alter table acesso
    owner to postgres;

create table if not exists pessoa_fisica
(
    id              bigint       not null
        primary key,
    cpf             varchar(255) not null,
    data_nascimento date,
    email           varchar(255) not null,
    nome            varchar(255) not null,
    telefone        varchar(255) not null
);

alter table pessoa_fisica
    owner to postgres;

create table if not exists pessoa_juridica
(
    id             bigint       not null
        primary key,
    email          varchar(255) not null,
    nome           varchar(255) not null,
    telefone       varchar(255) not null,
    categoria      varchar(255),
    cnpj           varchar(255) not null,
    insc_estadual  varchar(255) not null,
    insc_municipal varchar(255),
    nome_fantasia  varchar(255) not null,
    razao_social   varchar(255) not null
);

alter table pessoa_juridica
    owner to postgres;

create table if not exists endereco
(
    id            bigint       not null
        primary key,
    bairro        varchar(255) not null,
    cep           varchar(255) not null,
    cidade        varchar(255) not null,
    complemento   varchar(255),
    numero        varchar(255) not null,
    rua_logra     varchar(255) not null,
    uf            varchar(255) not null,
    pessoa_id     bigint       not null,
    tipo_endereco varchar(255) not null
        constraint endereco_tipo_endereco_check
            check ((tipo_endereco)::text = ANY
                   ((ARRAY ['COBRANCA'::character varying, 'ENTREGA'::character varying])::text[]))
);

alter table endereco
    owner to postgres;

create table if not exists usuario
(
    id               bigint       not null
        primary key,
    data_atual_senha date         not null,
    login            varchar(255) not null,
    senha            varchar(255) not null,
    pessoa_id        bigint       not null
);

alter table usuario
    owner to postgres;

create table if not exists usuarios_acesso
(
    usuario_id bigint not null
        constraint usuario_fk
            references usuario,
    acesso_id  bigint not null
        constraint acesso_fk
            references acesso,
    constraint unique_acesso_user
        unique (usuario_id, acesso_id)
);

alter table usuarios_acesso
    owner to postgres;

create table if not exists conta_receber
(
    id             bigint         not null
        primary key,
    descricao      varchar(255)   not null,
    dt_pagamento   date,
    dt_vencimento  date           not null,
    status         varchar(255)   not null
        constraint conta_receber_status_check
            check ((status)::text = ANY
                   ((ARRAY ['COBRANCA'::character varying, 'VENCIDA'::character varying, 'ABERTA'::character varying, 'QUITADA'::character varying])::text[])),
    valor_desconto numeric(38, 2),
    valor_total    numeric(38, 2) not null,
    pessoa_id      bigint         not null
);

alter table conta_receber
    owner to postgres;

create table if not exists forma_pagamento
(
    id        bigint       not null
        primary key,
    descricao varchar(255) not null
);

alter table forma_pagamento
    owner to postgres;

create table if not exists conta_pagar
(
    id             bigint         not null
        primary key,
    descricao      varchar(255)   not null,
    dt_pagamento   date,
    dt_vencimento  date           not null,
    status         varchar(255)   not null
        constraint conta_pagar_status_check
            check ((status)::text = ANY
                   ((ARRAY ['COBRANCA'::character varying, 'VENCIDA'::character varying, 'ABERTA'::character varying, 'QUITADA'::character varying, 'NEGOCIADA'::character varying])::text[])),
    valor_desconto numeric(38, 2),
    valor_total    numeric(38, 2) not null,
    pessoa_id      bigint         not null,
    pessoa_forn_id bigint         not null
);

alter table conta_pagar
    owner to postgres;

create table if not exists cup_desc
(
    id                  bigint       not null
        primary key,
    cod_desc            varchar(255) not null,
    data_validade_cupom date         not null,
    valor_porcent_desc  numeric(38, 2),
    valor_real_desc     numeric(38, 2)
);

alter table cup_desc
    owner to postgres;

create table if not exists produto
(
    id                  bigint           not null
        primary key,
    alerta_qtde_estoque boolean,
    altura              double precision not null,
    ativo               boolean          not null,
    descricao           text             not null,
    largura             double precision not null,
    link_youtbe         varchar(255),
    nome                varchar(255)     not null,
    peso                double precision not null,
    profundidade        double precision not null,
    qtde_alerta_estoque integer,
    qtde_clique         integer,
    qtde_estoque        integer          not null,
    tipo_unidade        varchar(255)     not null,
    valor_venda         numeric(38, 2)   not null
);

alter table produto
    owner to postgres;

create table if not exists imagem_produto
(
    id               bigint not null
        primary key,
    imagem_miniatura text   not null,
    imagem_original  text   not null,
    produto_id       bigint not null
        constraint prod_fk
            references produto
);

alter table imagem_produto
    owner to postgres;

create table if not exists nota_fiscal_compra
(
    id             bigint         not null
        primary key,
    data_compra    date           not null,
    numero_nota    varchar(255)   not null,
    serie_nota     varchar(255)   not null,
    valor_desconto numeric(38, 2),
    valor_icms     numeric(38, 2) not null,
    valor_total    numeric(38, 2) not null,
    conta_pagar_id bigint         not null
        constraint conta_pagar_fk
            references conta_pagar,
    pessoa_id      bigint         not null
);

alter table nota_fiscal_compra
    owner to postgres;

create table if not exists nota_item_produto
(
    id                    bigint           not null
        primary key,
    quantidade            double precision not null,
    nota_fiscal_compra_id bigint           not null
        constraint nota_fiscal_compra_fk
            references nota_fiscal_compra,
    produto_id            bigint           not null
        constraint prod_fk
            references produto
);

alter table nota_item_produto
    owner to postgres;

create table if not exists nota_fiscal_venda
(
    id                        bigint       not null
        primary key,
    numero                    varchar(255) not null,
    pdf                       text         not null,
    serie                     varchar(255) not null,
    tipo                      varchar(255) not null,
    xml                       text         not null,
    nota_fiscal_venda_id      bigint       not null
        constraint uk_cripi5mt0y0nk2c43p9bsrphl
            unique,
    venda_compra_loja_virt_id bigint       not null
        constraint uk_3sg7y5xs15vowbpi2mcql08kg
            unique
);

alter table nota_fiscal_venda
    owner to postgres;

create table if not exists vd_cp_loja_virt
(
    id                   bigint         not null
        primary key,
    pessoa_id            bigint         not null,
    valor_desconto       numeric(38, 2),
    valor_total          numeric(38, 2) not null,
    endereco_cobranca_id bigint         not null
        constraint endereco_cobranca_fk
            references endereco,
    endereco_entrega_id  bigint         not null
        constraint endereco_entrega_fk
            references endereco,
    forma_pagamento_id   bigint         not null
        constraint forma_pagamento_fk
            references forma_pagamento,
    nota_fiscal_venda_id bigint         not null
        constraint uk_hkxjejv08kldx994j4serhrbu
            unique
        constraint nota_fiscal_venda_fk
            references nota_fiscal_venda,
    cupom_desc_id        bigint
        constraint cupom_desc_fk
            references cup_desc,
    data_entrega         date           not null,
    date_venda           date           not null,
    dia_entrega          integer        not null,
    valor_frete          numeric(38, 2) not null
);

alter table vd_cp_loja_virt
    owner to postgres;

create table if not exists status_rastreio
(
    id                        bigint not null
        primary key,
    centro_distribuicao       varchar(255),
    cidade                    varchar(255),
    estado                    varchar(255),
    status                    varchar(255),
    venda_compra_loja_virt_id bigint not null
        constraint venda_compra_loja_virt_fk
            references vd_cp_loja_virt
);

alter table status_rastreio
    owner to postgres;

alter table nota_fiscal_venda
    add constraint nota_fiscal_venda_fk
        foreign key (nota_fiscal_venda_id) references vd_cp_loja_virt;

alter table nota_fiscal_venda
    add constraint venda_compra_loja_virt_fk
        foreign key (venda_compra_loja_virt_id) references vd_cp_loja_virt;

create table if not exists item_venda_loja
(
    id                          bigint           not null
        primary key,
    quantidade                  double precision not null,
    produto_id                  bigint           not null
        constraint produto_fk
            references produto,
    venda_compraloja_virtual_id bigint           not null
        constraint venda_compraloja_virtual_fk
            references vd_cp_loja_virt
);

alter table item_venda_loja
    owner to postgres;

create table if not exists avaliacao_produto
(
    id         bigint       not null
        primary key,
    descricao  varchar(255) not null,
    nota       integer      not null,
    pessoa_id  bigint       not null,
    produto_id bigint       not null
        constraint produto_fk
            references produto
);

alter table avaliacao_produto
    owner to postgres;

create or replace function validachavepessoa() returns trigger
    language plpgsql
as
$$
declare existe integer;

BEGIN
    existe = (select count(1) from pessoa_fisica where id = NEW.pessoa_id);
    if (existe <= 0) then
        existe = (select count(1) from pessoa_juridica where id = NEW.pessoa_id);
        if (existe <= 0) then
            RAISE EXCEPTION  'Não foi encontrado o ID e PK da pessoa para realizar a associação do cadastro';
        end if;
    end if;
    return new;
END;
$$;

alter function validachavepessoa() owner to postgres;

create trigger validachavepessoa
    before insert
    on endereco
    for each row
execute procedure validachavepessoa();

create trigger validachavepessoa2
    before update
    on endereco
    for each row
execute procedure validachavepessoa();

create trigger validachavepessoa
    before insert
    on usuario
    for each row
execute procedure validachavepessoa();

create trigger validachavepessoa2
    before update
    on usuario
    for each row
execute procedure validachavepessoa();

create trigger validachavepessoa
    before insert
    on conta_receber
    for each row
execute procedure validachavepessoa();

create trigger validachavepessoa2
    before update
    on conta_receber
    for each row
execute procedure validachavepessoa();

create trigger validachavepessoacontapagar
    before update
    on conta_pagar
    for each row
execute procedure validachavepessoa();

create trigger validachavepessoacontapagar2
    before insert
    on conta_pagar
    for each row
execute procedure validachavepessoa();

create trigger validachavepessoa
    before insert
    on nota_fiscal_compra
    for each row
execute procedure validachavepessoa();

create trigger validachavepessoa2
    before update
    on nota_fiscal_compra
    for each row
execute procedure validachavepessoa();

create trigger validachavepessoa
    before insert
    on vd_cp_loja_virt
    for each row
execute procedure validachavepessoa();

create trigger validachavepessoa2
    before update
    on vd_cp_loja_virt
    for each row
execute procedure validachavepessoa();

create trigger validachavepessoaavaliacaoproduto
    before update
    on avaliacao_produto
    for each row
execute procedure validachavepessoa();

create trigger validachavepessoaavaliacaoproduto2
    before insert
    on avaliacao_produto
    for each row
execute procedure validachavepessoa();

create or replace function validachavepessoa2() returns trigger
    language plpgsql
as
$$
declare existe integer;

BEGIN
    existe = (select count(1) from conta_pagar where id = NEW.pessoa_forn_id);
    if (existe <= 0) then
        existe = (select count(1) from conta_pagar where id = NEW.pessoa_forn_id);
        if (existe <= 0) then
            RAISE EXCEPTION  'Não foi encontrado o ID e PK da pessoa para realizar a associação do cadastro';
        end if;
    end if;
    return new;
END;
$$;

alter function validachavepessoa2() owner to postgres;

create trigger validachavepessoacontapagarpessoafornid
    before insert
    on conta_pagar
    for each row
execute procedure validachavepessoa2();

create trigger validachavepessoacontapagarpessoafornid2
    before update
    on conta_pagar
    for each row
execute procedure validachavepessoa2();

