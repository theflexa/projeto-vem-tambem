package br.com.vemtambem.utils;

public class DocumentValidator {
	public static boolean validarCPF(String cpf) {
		cpf = cpf.replaceAll("[^0-9]", "");

		if (cpf.length() != 11) {
			return false;
		}

		// Verificar se todos os dígitos são iguais (caso inválido)
		if (cpf.matches("(\\d)\\1{10}")) {
			return false;
		}

		// Calcular primeiro dígito verificador
		int soma = 0;
		for (int i = 0; i < 9; i++) {
			soma += Character.getNumericValue(cpf.charAt(i)) * (10 - i);
		}
		int primeiroDigitoVerificador = 11 - (soma % 11);
		if (primeiroDigitoVerificador > 9) {
			primeiroDigitoVerificador = 0;
		}

		if (Character.getNumericValue(cpf.charAt(9)) != primeiroDigitoVerificador) {
			return false;
		}

		// Calcular segundo dígito verificador
		soma = 0;
		for (int i = 0; i < 10; i++) {
			soma += Character.getNumericValue(cpf.charAt(i)) * (11 - i);
		}
		int segundoDigitoVerificador = 11 - (soma % 11);
		if (segundoDigitoVerificador > 9) {
			segundoDigitoVerificador = 0;
		}

		return Character.getNumericValue(cpf.charAt(10)) == segundoDigitoVerificador;
	}

	public static boolean validarCNPJ(String cnpj) {
		cnpj = cnpj.replaceAll("[^0-9]", "");

		if (cnpj.length() != 14) {
			return false;
		}

		// Verificar se todos os dígitos são iguais (caso inválido)
		if (cnpj.matches("(\\d)\\1{13}")) {
			return false;
		}

		// Calcular primeiro dígito verificador
		int[] pesoPrimeiroDigito = { 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2 };
		int soma = 0;
		for (int i = 0; i < 12; i++) {
			soma += Character.getNumericValue(cnpj.charAt(i)) * pesoPrimeiroDigito[i];
		}
		int primeiroDigitoVerificador = 11 - (soma % 11);
		if (primeiroDigitoVerificador > 9) {
			primeiroDigitoVerificador = 0;
		}

		if (Character.getNumericValue(cnpj.charAt(12)) != primeiroDigitoVerificador) {
			return false;
		}

		// Calcular segundo dígito verificador
		int[] pesoSegundoDigito = { 6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2 };
		soma = 0;
		for (int i = 0; i < 13; i++) {
			soma += Character.getNumericValue(cnpj.charAt(i)) * pesoSegundoDigito[i];
		}
		int segundoDigitoVerificador = 11 - (soma % 11);
		if (segundoDigitoVerificador > 9) {
			segundoDigitoVerificador = 0;
		}

		return Character.getNumericValue(cnpj.charAt(13)) == segundoDigitoVerificador;
	}

	public static boolean validarDocumento(String documento) {
		String numero = documento.replaceAll("[^0-9]", "");

		if (numero.length() == 11) {
			return validarCPF(numero);
		} else if (numero.length() == 14) {
			return validarCNPJ(numero);
		}

		return false;
	}

	public static void main(String[] args) {
		String cpf = "123.456.789-09";
		String cnpj = "12.345.678/0001-00";

		if (validarDocumento(cpf)) {
			System.out.println("CPF válido.");
		} else {
			System.out.println("CPF inválido.");
		}

		if (validarDocumento(cnpj)) {
			System.out.println("CNPJ válido.");
		} else {
			System.out.println("CNPJ inválido.");
		}
	}
}
