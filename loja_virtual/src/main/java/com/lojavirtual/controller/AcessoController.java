package com.lojavirtual.controller;

import com.lojavirtual.model.Acesso;
import com.lojavirtual.repository.AcessoRepository;
import com.lojavirtual.service.AcessoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class AcessoController {

    @Autowired
    private AcessoService acessoService;

    @Autowired
    private AcessoRepository acessoRepository;

    @ResponseBody
    @PostMapping(value = "/salvarAcesso")
    public ResponseEntity<Acesso>  salvarAcesso(@RequestBody Acesso acesso) {
        Acesso acessoSalvo = acessoService.save(acesso);

        return new ResponseEntity<Acesso>(acessoSalvo, HttpStatus.OK);
    }

    @ResponseBody
    @PostMapping(value = "/deleteAcesso")
    public ResponseEntity<?>  deleteAcesso(@RequestBody Acesso acesso) {
        acessoRepository.deleteById(acesso.getId());

        return new ResponseEntity("Acesso removido", HttpStatus.OK);
    }

    @ResponseBody
    @DeleteMapping(value = "/deleteAcessoPorId/{id}")
    public ResponseEntity<?>  deleteAcessoPorId(@PathVariable("id") Long id) {
        acessoRepository.deleteById(id);

        return new ResponseEntity("Acesso removido", HttpStatus.OK);
    }

    @ResponseBody
    @GetMapping(value = "/obterAcesso/{id}")
    public ResponseEntity<Acesso>  obterAcesso(@PathVariable("id") Long id) {
        Acesso acesso = acessoRepository.findById(id).get();

        return new ResponseEntity<Acesso>(acesso, HttpStatus.OK);
    }

    @ResponseBody
    @GetMapping(value = "/buscarPorDesc/{desc}")
    public ResponseEntity<List<Acesso>>  buscarPorDesc(@PathVariable("desc") String desc) {
        List<Acesso> acesso = acessoRepository.buscarAcessoDesc(desc);

        return new ResponseEntity<List<Acesso>>(acesso, HttpStatus.OK);
    }
}
