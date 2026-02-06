package br.com.vemtambem.utils;

public final class NomeHelper {
	
	public static String curto(String full) {
		if (full == null)
			return "—";
		String s = full.trim().replaceAll("\\s+", " ");
		if (s.isEmpty())
			return "—";
		String[] p = s.split(" ");
		if (p.length >= 3) {
			return (p[0].substring(0, 2) + p[p.length - 2].substring(0, 2)).toUpperCase();
		}
		String unico = p[0];
		return unico.substring(0, Math.min(3, unico.length())).toUpperCase();
	}
}
