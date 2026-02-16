package br.com.vemtambem.model;

import java.math.BigDecimal;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "tipo_ciclo")
public class TipoCiclo {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Long id;

	@Column(name = "nome")
	private String nome;

	@Column(name = "valor_ti", precision = 10, scale = 2)
	private BigDecimal valorTI;

	@Column(name = "valor_doacao", precision = 10, scale = 2)
	private BigDecimal valorDoacao;

	@Column(name = "quant_doadores")
	private int quantDoadores;

	@Column(name = "ordem")
	private int ordem;

	@Column(name = "ativo")
	private boolean ativo;

	public TipoCiclo() {
	}

	public TipoCiclo(Long id) {
		this.id = id;
	}

}
