package com.lojavirtual.controller;

import com.lojavirtual.model.Acesso;
import com.lojavirtual.service.AcessoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class AcessoController {

    @Autowired
    private AcessoService acessoService;

    @PostMapping("/salvaAcesso")
    public Acesso salvarAcesso(Acesso acesso) {
        return acessoService.save(acesso);
    }
}
