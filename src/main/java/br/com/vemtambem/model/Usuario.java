package br.com.vemtambem.model;

import java.time.LocalDateTime;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Convert;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Transient;

import br.com.vemtambem.utils.LocalDateTimeConverter;
import br.com.vemtambem.utils.NomeHelper;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@Entity
@Table(name = "usuario")
public class Usuario {

	public static final Usuario ID_USUARIO_ADMIN = new Usuario(2L);
	
	@ToString.Include
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Long id;

	@Column(name = "nome")
	private String nome;

	@Column(name = "email")
	private String email;

	@ToString.Include
	@Column(name = "login")
	private String login;

	@Column(name = "senha")
	private String senha;

	@Column(name = "tipo_conta")
	private boolean tipoConta;

	@Column(name = "documento")
	private String documento;

	@Column(name = "celular")
	private String celular;

	@Column(name = "whatsapp")
	private String whatsapp;

	@Transient
	private String whatsappFormat;

	@OneToOne(cascade = CascadeType.ALL)
	@JoinColumn(name = "endereco_id", referencedColumnName = "id")
	private Endereco endereco;

	@Column(name = "data_cadastro")
	@Convert(converter = LocalDateTimeConverter.class)
	private LocalDateTime dataCadastro;

	@Enumerated(EnumType.STRING)
	@Column(name = "tipo_chave_pix")
	private TipoChavePix tipoChavePix;

	@Transient
	private int codigoTipoChavePix;

	@Column(name = "chave_pix")
	private String chavePix;

	@Column(name = "ativo")
	private boolean ativo;

	@Column(name = "doacao_feita")
	private boolean doacaoFeita;

	@Column(name = "admin")
	private boolean admin;

	@Column(name = "comprovante_ativacao")
	private String comprovanteAtivacao;

	@Column(name = "comprovante_deposito")
	private String comprovanteDeposito;

	// Atributos referente a árvore.

	@ManyToOne
	@JoinColumn(name = "indicador_id", referencedColumnName = "id")
	private Usuario indicador;

	@ManyToOne
	@JoinColumn(name = "indicado_esquerda_id", referencedColumnName = "id")
	private Usuario indicadoEsquerda;

	@ManyToOne
	@JoinColumn(name = "indicado_direita_id", referencedColumnName = "id")
	private Usuario indicadoDireita;

	// Controle de ciclos

	@Column(name = "quant_ciclos")
	private int quantCiclos;

	private int quantDoacoesRecebidas;

	@ManyToOne
	@JoinColumn(name = "ciclo_ativo_id", referencedColumnName = "id")
	private Ciclo cicloAtivo;
	
	@Column(name = "termo_aceito")
	private boolean termoAceito;
	
	public Usuario(Long id) {
		this.id = id;
	}

	public Usuario() {
	}

	public String getWhatsappFormat() {
	    String whatsappSemFormato = this.whatsapp.replaceAll("[\\s\\(\\)-]", "");
		return "55"+whatsappSemFormato;
	}
	
	public String getNomeCurto() {
		return NomeHelper.curto(this.nome);
	}

}
