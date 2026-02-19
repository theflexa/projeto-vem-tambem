package br.com.vemtambem.model;

public class Conexao {

	private static final String DEFAULT_REMOTE_URL =
			"jdbc:mysql://sergi6131.c44.integrator.host:3306/sergi6131_banco_dados_dev";
	private static final String DEFAULT_REMOTE_USER = "sergi6131_user";
	private static final String DEFAULT_REMOTE_PASSWORD = "FK(-@(25(I@LIGP~";

	// Keep JDBC-only DAO methods aligned with the remote database by default.
	public static final String URL = enforceRemote(getenvOrDefault("DATABASE_URL", DEFAULT_REMOTE_URL));
	public static final String USUARIO = getenvOrDefault("DATABASE_USER", DEFAULT_REMOTE_USER);
	public static final String SENHA = getenvOrDefault("DATABASE_PASSWORD", DEFAULT_REMOTE_PASSWORD);

	private Conexao() {
	}

	private static String getenvOrDefault(String key, String defaultValue) {
		String value = System.getenv(key);
		if (value == null || value.trim().isEmpty()) {
			return defaultValue;
		}
		return value.trim();
	}

	private static String enforceRemote(String url) {
		String normalized = url.toLowerCase();
		if (normalized.contains("localhost") || normalized.contains("127.0.0.1")) {
			return DEFAULT_REMOTE_URL;
		}
		return url;
	}
}
