package br.com.vemtambem.model;

public enum TipoChavePix {
	CPF(1, "CPF"), CNPJ(2, "CNPJ"), EMAIL(3, "E-mail"), TELEFONE(4, "Telefone"), ALEATORIA(5, "Aleatória");

	private int codigo;
	private String descricao;

	TipoChavePix(int codigo, String descricao) {
		this.codigo = codigo;
		this.descricao = descricao;
	}

	public int getCodigo() {
		return codigo;
	}

	public String getDescricao() {
		return descricao;
	}

	// Método estático para obter o TipoChavePix a partir do código
	public static TipoChavePix fromCodigo(int codigo) {
		for (TipoChavePix tipo : TipoChavePix.values()) {
			if (tipo.getCodigo() == codigo) {
				return tipo;
			}
		}
		throw new IllegalArgumentException("Código inválido: " + codigo);
	}
}
