package com.lojavirtual;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.lojavirtual.controller.AcessoController;
import com.lojavirtual.model.Acesso;
import com.lojavirtual.repository.AcessoRepository;
import junit.framework.TestCase;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;

@AutoConfigureMockMvc
@ExtendWith(SpringExtension.class)
@SpringBootTest(classes = LojaVirtualApplication.class)
public class LojaVirtualApplicationTests extends TestCase {

	@Autowired
	private MockMvc mockMvc;

	@Autowired
	private AcessoController acessoController;

	@Autowired
	private AcessoRepository acessoRepository;

	@Autowired
	private WebApplicationContext wac;

    @BeforeEach
    public void setup() {
        this.mockMvc = MockMvcBuilders.webAppContextSetup(this.wac).build();
    }

	@Test
	public void testRestApiCadastroAcesso() throws Exception {
		Acesso acesso = new Acesso();
		acesso.setDescricao("ROLE_COMPRADOR");

		ObjectMapper objectMapper = new ObjectMapper();
		ResultActions retornoApi = mockMvc
						.perform(MockMvcRequestBuilders.post("/salvarAcesso")
						.content(objectMapper.writeValueAsString(acesso))
						.accept(MediaType.APPLICATION_JSON)
						.contentType(MediaType.APPLICATION_JSON));

		System.out.println("Retorno da API: " + retornoApi.andReturn().getResponse().getContentAsString());

		/*Converter o retorno da API para um objeto de acesso*/
		Acesso objetoRetorno = objectMapper.readValue(retornoApi.andReturn().getResponse().getContentAsString(), Acesso.class);
		Assertions.assertEquals(acesso.getDescricao(), objetoRetorno.getDescricao());
	}

	@Test
	public void testRestApiDeleteAcesso() throws Exception {
		Acesso acesso = new Acesso();
		acesso.setDescricao("ROLE_TESTE_DELETE");
		acesso = acessoRepository.save(acesso);

		ObjectMapper objectMapper = new ObjectMapper();
		ResultActions retornoApi = mockMvc
						.perform(MockMvcRequestBuilders.post("/deleteAcesso")
						.content(objectMapper.writeValueAsString(acesso))
						.accept(MediaType.APPLICATION_JSON)
						.contentType(MediaType.APPLICATION_JSON));

		System.out.println("Retorno da API: " + retornoApi.andReturn().getResponse().getContentAsString());
		System.out.println("Status do retorno: " + retornoApi.andReturn().getResponse().getStatus());

		Assertions.assertEquals("Acesso removido", retornoApi.andReturn().getResponse().getContentAsString());
		Assertions.assertEquals(200, retornoApi.andReturn().getResponse().getStatus());
	}

	@Test
	public void testRestApiDeletePorIdAcesso() throws Exception {
		Acesso acesso = new Acesso();
		acesso.setDescricao("ROLE_TESTE_DELETE_ID");
		acesso = acessoRepository.save(acesso);

		ObjectMapper objectMapper = new ObjectMapper();
		ResultActions retornoApi = mockMvc
						.perform(MockMvcRequestBuilders.delete("/deleteAcessoPorId/" + acesso.getId())
						.content(objectMapper.writeValueAsString(acesso))
						.accept(MediaType.APPLICATION_JSON)
						.contentType(MediaType.APPLICATION_JSON));

		System.out.println("Retorno da API: " + retornoApi.andReturn().getResponse().getContentAsString());
		System.out.println("Status do retorno: " + retornoApi.andReturn().getResponse().getStatus());

		Assertions.assertEquals("Acesso removido", retornoApi.andReturn().getResponse().getContentAsString());
		Assertions.assertEquals(200, retornoApi.andReturn().getResponse().getStatus());
	}

	@Test
	public void testRestApiObterAcessoId() throws Exception {
		Acesso acesso = new Acesso();
		acesso.setDescricao("ROLE_TESTE_OBTER_ID");
		acesso = acessoRepository.save(acesso);

		ObjectMapper objectMapper = new ObjectMapper();
		ResultActions retornoApi = mockMvc
						.perform(MockMvcRequestBuilders.get("/obterAcesso/" + acesso.getId())
						.content(objectMapper.writeValueAsString(acesso))
						.accept(MediaType.APPLICATION_JSON)
						.contentType(MediaType.APPLICATION_JSON));

		Assertions.assertEquals(200, retornoApi.andReturn().getResponse().getStatus());

		Acesso acessoRetorno = objectMapper.readValue(retornoApi.andReturn().getResponse().getContentAsString(), Acesso.class);
		Assertions.assertEquals(acesso.getDescricao(), acessoRetorno.getDescricao());
	}

	@Test
	public void testRestApiBuscarAcessoPorDesc() throws Exception {
		Acesso acesso = new Acesso();
		acesso.setDescricao("ROLE_TESTE_OBTER_LIST");
		acesso = acessoRepository.save(acesso);

		ObjectMapper objectMapper = new ObjectMapper();
		ResultActions retornoApi = mockMvc
						.perform(MockMvcRequestBuilders.get("/buscarPorDesc/OBTER_LIST")
						.content(objectMapper.writeValueAsString(acesso))
						.accept(MediaType.APPLICATION_JSON)
						.contentType(MediaType.APPLICATION_JSON));

		Assertions.assertEquals(200, retornoApi.andReturn().getResponse().getStatus());

		List<Acesso> retornoApiList = objectMapper.readValue(retornoApi.andReturn().getResponse().getContentAsString(), new TypeReference<List<Acesso>>(){});

		//Assertions.assertEquals(6, retornoApiList.size());
		Assertions.assertEquals(acesso.getDescricao(), retornoApiList.get(0).getDescricao());

		acessoRepository.deleteById(acesso.getId());
	}

	@Test
	public void testCadastraAcesso() {
		Acesso acesso = new Acesso();
		acesso.setDescricao("ROLE_ADMIN");

		Assertions.assertEquals(true, acesso.getId() == null);
		acesso = acessoController.salvarAcesso(acesso).getBody();
		Assertions.assertEquals(true, acesso.getId() > 0);
		Assertions.assertEquals("ROLE_ADMIN", acesso.getDescricao());

		//Teste de carregamento
		Acesso acesso2 = acessoRepository.findById(acesso.getId()).get();
		Assertions.assertEquals(acesso.getId(), acesso2.getId());

		//teste de delete
		acessoRepository.deleteById(acesso2.getId());
		acessoRepository.flush(); /*Roda esse SQL de delete no banco de dados*/
		Acesso acesso3 = acessoRepository.findById(acesso2.getId()).orElse(null);
		Assertions.assertEquals(true, acesso3 == null);

		/*Teste de Query*/
		acesso = new Acesso();
		acesso.setDescricao("ROLE_ALUNO");
		acesso = acessoController.salvarAcesso(acesso).getBody();
		List<Acesso> acessos = acessoRepository.buscarAcessoDesc("ALUNO".trim().toUpperCase());
		Assertions.assertEquals(1, acessos.size());
		acessoRepository.deleteById(acesso.getId());
	}
}