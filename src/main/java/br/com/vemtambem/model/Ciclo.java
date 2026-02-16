package br.com.vemtambem.model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "ciclo")
public class Ciclo {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Long id;
	
	private String nome;
	
	private boolean ativo;
	
	private String login;
	
	@ManyToOne
	@JoinColumn(name = "usuario_id", referencedColumnName = "id")
	private Usuario usuario;
	
	@ManyToOne
	@JoinColumn(name = "indicador_id", referencedColumnName = "id")
	private Usuario indicador;

	@ManyToOne
	@JoinColumn(name = "tipo_ciclo_id", referencedColumnName = "id")
	private TipoCiclo tipoCiclo;

	@ManyToOne
	@JoinColumn(name = "indicado_principal_id", referencedColumnName = "id")
	private Usuario indicadoPrincipal;
	
	@ManyToOne
	@JoinColumn(name = "indicado_esquerda_id", referencedColumnName = "id")
	private Usuario indicadoEsquerda;

	@ManyToOne
	@JoinColumn(name = "indicado_direita_id", referencedColumnName = "id")
	private Usuario indicadoDireita;

}
