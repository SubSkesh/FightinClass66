package model.session.dao.CookieImpl;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.session.dao.LoggedUserDAO;
import model.session.mo.LoggedUser;

/**
 * Implementazione del LoggedUserDAO che utilizza i cookie per memorizzare le informazioni dell'utente loggato.
 */
public class LoggedUserDAOCookieImpl implements LoggedUserDAO {

    private HttpServletRequest request;
    private HttpServletResponse response;

    public LoggedUserDAOCookieImpl(HttpServletRequest request, HttpServletResponse response) {
        this.request = request;
        this.response = response;
    }

    @Override
    public LoggedUser crea(String email, String nomeUtente, String cognome, boolean admin) {
        LoggedUser loggedUser = new LoggedUser();
        loggedUser.setEmail(email);
        loggedUser.setNomeUtente(nomeUtente);
        loggedUser.setCognome(cognome);
        loggedUser.setAdmin(admin);

        Cookie cookie = new Cookie("loggedUser", encode(loggedUser));
        cookie.setPath("/");
        response.addCookie(cookie);

        return loggedUser;
    }

    @Override
    public void aggiorna(LoggedUser loggedUser) {
        Cookie cookie = new Cookie("loggedUser", encode(loggedUser));
        cookie.setPath("/");
        response.addCookie(cookie);
    }

    @Override
    public void elimina() {
        Cookie cookie = new Cookie("loggedUser", "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);
    }

    @Override
    public LoggedUser trova() {
        Cookie[] cookies = request.getCookies();
        LoggedUser loggedUser = null;

        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("loggedUser")) {
                    loggedUser = decode(cookie.getValue());
                    break;
                }
            }
        }

        return loggedUser;
    }

    private String encode(LoggedUser loggedUser) {
        String adminFlag = loggedUser.isAdmin() ? "S" : "N";
        return String.join("#",
                loggedUser.getEmail(),
                loggedUser.getNomeUtente(),
                loggedUser.getCognome(),
                adminFlag);
    }

    private LoggedUser decode(String encoded) {
        LoggedUser loggedUser = new LoggedUser();
        String[] values = encoded.split("#");

        loggedUser.setEmail(values[0]);
        loggedUser.setNomeUtente(values[1]);
        loggedUser.setCognome(values[2]);
        loggedUser.setAdmin("S".equals(values[3]));

        return loggedUser;
    }
}