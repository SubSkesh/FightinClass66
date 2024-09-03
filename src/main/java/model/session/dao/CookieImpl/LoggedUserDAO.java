package model.session.dao.CookieImpl;
import model.session.mo.LoggedUser;

/**
 * Interfaccia per la gestione dell'utente autenticato nella sessione.
 */
public interface LoggedUserDAO {

    /**
     * Crea un nuovo oggetto LoggedUser e lo memorizza.
     *
     * @param email L'email dell'utente.
     * @param nomeUtente Il nome utente.
     * @param cognome Il cognome dell'utente.
     * @param admin Flag che indica se l'utente è un amministratore.
     * @return Il nuovo oggetto LoggedUser creato.
     */
    public LoggedUser crea(String email, String nomeUtente, String cognome, boolean admin);

    /**
     * Aggiorna le informazioni dell'utente loggato.
     *
     * @param loggedUser L'oggetto LoggedUser con le informazioni aggiornate.
     */
    public void aggiorna(LoggedUser loggedUser);

    /**
     * Elimina le informazioni dell'utente loggato.
     */
    public void elimina();

    /**
     * Trova l'utente attualmente loggato.
     *
     * @return L'oggetto LoggedUser dell'utente loggato.
     */
    public LoggedUser trova();
}