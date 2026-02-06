package br.com.vemtambem.utils;

import java.io.UnsupportedEncodingException;
import java.security.SecureRandom;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 * Utilitário para envio de e-mails HTML (ex.: código de redefinição de senha).
 *
 * Observações:
 * - Em produção mova HOST, PORT, USERNAME e PASSWORD para variáveis de ambiente ou vault.
 * - A porta 465 usa SSL (mail.smtp.ssl.enable=true). Para STARTTLS (porta 587) remova ssl.enable e ative starttls.
 */
public class EmailSender {

    // ----- Preferível buscar de variáveis de ambiente em produção -----
    private static final String HOST = System.getenv().getOrDefault("SMTP_HOST", "mail.sergi6131.c44.integrator.host");
    private static final String PORT = System.getenv().getOrDefault("SMTP_PORT", "465");
    private static final String USERNAME = System.getenv().getOrDefault("SMTP_USERNAME", "suporte@vemtambem.com.br");
    private static final String PASSWORD = System.getenv().getOrDefault("SMTP_PASSWORD", "5xbnA7upyK");
    private static final boolean SMTP_DEBUG = false;

    private static final SecureRandom RANDOM = new SecureRandom();

    private EmailSender() {
        // utilitário — não instanciar
    }

    /**
     * Envia um e-mail HTML para o destinatário informado.
     *
     * @param destinatario e-mail do destinatário (pode ser uma lista separada por vírgulas)
     * @param assunto assunto do e-mail
     * @param corpoHtml corpo do e-mail em HTML (charset UTF-8)
     * @throws MessagingException em caso de falha no envio
     */
    public static void enviarEmail(String destinatario, String assunto, String corpoHtml) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");

        // Configuração para conexão SSL (porta 465)
        props.put("mail.smtp.ssl.enable", "true");
        props.put("mail.smtp.host", HOST);
        props.put("mail.smtp.port", PORT);

        // opcional — socketFactory, às vezes requerido em alguns provedores
        props.put("mail.smtp.socketFactory.port", PORT);
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USERNAME, PASSWORD);
            }
        });
        session.setDebug(SMTP_DEBUG);

        MimeMessage message = new MimeMessage(session);
        try {
            // Tentar definir nome amigável no FROM, caso falhe, define só o e-mail
            try {
                message.setFrom(new InternetAddress(USERNAME, "Vem Também"));
            } catch (UnsupportedEncodingException e) {
                message.setFrom(new InternetAddress(USERNAME));
            }

            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));
            message.setSubject(assunto, "UTF-8");

            // Define o conteúdo como HTML com charset UTF-8
            message.setContent(corpoHtml, "text/html; charset=UTF-8");

            Transport.send(message);
        } finally {
            // nada a fechar explicitamente aqui
        }
    }

    /**
     * Monta o corpo HTML do e-mail de redefinição de senha seguindo o padrão visual do projeto.
     *
     * @param nomeUsuario nome do usuário (opcional)
     * @param codigo código numérico de 4-8 dígitos
     * @param urlRedefinicao url opcional para redefinir senha (pode conter token)
     * @param minutosValidade tempo de validade do código em minutos
     * @return HTML pronto para enviar
     */
    public static String montarCorpoEmailCodigo(String nomeUsuario, String codigo, long minutosValidade) {
        String nome = (nomeUsuario == null || nomeUsuario.trim().isEmpty()) ? "" : nomeUsuario.trim();
        StringBuilder sb = new StringBuilder();

        sb.append("<!doctype html>");
        sb.append("<html lang=\"pt-BR\">");
        sb.append("<head>");
        sb.append("<meta charset=\"utf-8\"/>");
        sb.append("<meta name=\"viewport\" content=\"width=device-width,initial-scale=1\"/>");
        sb.append("<title>Vem Também - Redefinição de senha</title>");
        // estilos inline mínimos para compatibilidade com clientes de e-mail
        sb.append("<style>");
        sb.append("body{font-family:Inter, Arial, sans-serif; background:#f6f7f9; margin:0; padding:24px; color:#111827}");
        sb.append(".card{max-width:680px;margin:0 auto;background:#fff;border-radius:14px;box-shadow:0 8px 30px rgba(0,0,0,.08);padding:28px}");
        sb.append(".logo{display:flex;align-items:center;gap:12px;margin-bottom:8px}");
        sb.append(".brand{color:#6f7a00;font-weight:800;font-size:18px}");
        sb.append("h1{font-size:20px;margin:8px 0 14px;color:#1f2937}");
        sb.append("p{margin:0 0 12px;color:#495057;line-height:1.5}");
        sb.append(".code{display:inline-block;padding:12px 18px;border-radius:12px;background:linear-gradient(90deg,#6f7a00,#f3c900);color:#0b0f00;font-weight:800;font-size:24px;letter-spacing:3px;margin:12px 0}");
        sb.append(".btn{display:inline-block;padding:12px 18px;border-radius:999px;text-decoration:none;font-weight:700;background:linear-gradient(90deg,#6f7a00,#f3c900);color:#0b0f00}");
        sb.append(".small{font-size:13px;color:#6b7280;margin-top:12px}");
        sb.append("a{text-decoration:none;color:inherit}");
        sb.append("</style>");
        sb.append("</head>");
        sb.append("<body>");
        sb.append("<div class=\"card\">");

        // logo — altere para URL real do seu servidor ou recursos públicos
        sb.append("<div class=\"logo\">");
        sb.append("<img src=\"https://vemtambem.com.br/vemtambem/resources/img/logo_vertical.png\" alt=\"Vem Também\" style=\"height:160px;\">");
        sb.append("</div>");

        sb.append("<h1>Redefinição de senha</h1>");
        if (!nome.isEmpty()) {
            sb.append("<p>Olá <strong>").append(escapeHtml(nome)).append("</strong>,</p>");
        } else {
            sb.append("<p>Olá,</p>");
        }
        sb.append("<p>Recebemos uma solicitação para redefinir a senha da sua conta. Use o código abaixo para validar seu e-mail e continuar com a alteração.</p>");

        sb.append("<div style=\"text-align:center\">");
        sb.append("<div class=\"code\">").append(escapeHtml(codigo)).append("</div>");
        sb.append("</div>");

        sb.append("<p class=\"small\">O código expira em aproximadamente ").append(minutosValidade)
          .append(" minuto(s). Se você não solicitou esta alteração, ignore este e-mail.</p>");
        sb.append("<p class=\"small\">Atenciosamente,<br>Equipe Vem Também</p>");

        sb.append("<hr style=\"border:none;border-top:1px solid #eef0f2;margin:18px 0\">");
        sb.append("<p class=\"small\">Se precisar de ajuda, fale com o suporte: <a href=\"https://wa.me/559184415184?text=Ol%C3%A1!%20Preciso%20de%20suporte%20na%20plataforma%20Vem%20Tamb%C3%A9m\" target=\"_blank\">WhatsApp</a></p>");

        sb.append("</div>"); // card
        sb.append("</body>");
        sb.append("</html>");

        return sb.toString();
    }

    /**
     * Gera um código numérico seguro com a quantidade de dígitos especificada.
     *
     * @param length número de dígitos (ex.: 6)
     * @return código numérico como String (padded com zeros à esquerda quando necessário)
     */
    public static String gerarCodigoNumerico(int length) {
        if (length <= 0) {
            throw new IllegalArgumentException("length deve ser maior que zero");
        }
        int max = (int) Math.pow(10, length);
        int value = RANDOM.nextInt(max);
        return String.format("%0" + length + "d", value);
    }

    /**
     * Método utilitário para enviar o código de redefinição (monta assunto e corpo automaticamente).
     *
     * @param destinatario e-mail do usuário
     * @param nomeUsuario nome do usuário (opcional)
     * @param codigo código de redefinição
     * @param urlRedefinicao URL opcional com token
     * @param minutosValidade validade do código em minutos
     * @throws MessagingException caso falhe o envio
     */
    public static void enviarCodigoRedefinicao(String destinatario, String nomeUsuario, String codigo, long minutosValidade) throws MessagingException {
        String assunto = "Código para redefinição de senha — Vem Também";
        String corpo = montarCorpoEmailCodigo(nomeUsuario, codigo, minutosValidade);
        enviarEmail(destinatario, assunto, corpo);
    }

    // ----- utilitários mínimos -----

    /**
     * Escapa caracteres simples para evitar injeção de HTML básica em conteúdos pequenos.
     */
    private static String escapeHtml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");
    }

    // ----- exemplo de uso / teste local -----
    public static void main(String[] args) {
        String destinatario = "alexoliveira.marques@gmail.com";
        String nome = "Alex";
        String codigo = gerarCodigoNumerico(6); // exemplo: 6 dígitos
        int validadeMinutos = 15;

        try {
            enviarCodigoRedefinicao(destinatario, nome, codigo, validadeMinutos);
            System.out.println("E-mail enviado com sucesso para " + destinatario + " com código " + codigo);
        } catch (MessagingException e) {
            System.err.println("Erro ao enviar e-mail: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
