package br.com.vemtambem.model;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Convert;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import br.com.vemtambem.utils.LocalDateTimeConverter;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "usuario_token")
public class UsuarioToken {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Long id;

	@Column(name = "id_usuario")
	private Long idUsuario;

	@Column(name = "email_usuario")
	private String emailUsuario;

	@Column(name = "data_hora_solicitacao")
	@Convert(converter = LocalDateTimeConverter.class)
	private LocalDateTime dataHoraSolicitacao;

	@Column(name = "token_troca_senha")
	private String tokenTrocaSenha;

	@Column(name = "token_troca_senha_validade")
	@Convert(converter = LocalDateTimeConverter.class)
	private LocalDateTime tokenTrocaSenhaValidade;

}
