package model.dao;

import java.util.ArrayList;
import model.dao.exception.DuplicatedObjectException;
import model.mo.Utente;

public interface UtenteDAO {

    /**
     * Registra un nuovo utente nel sistema.
     * @param email l'email dell'utente
     * @param nomeUtente il nome dell'utente
     * @param cognome il cognome dell'utente
     * @param password la password dell'utente
     * @param genere il genere dell'utente
     * @param nazione la nazione dell'utente
     * @param città la città dell'utente
     * @param via la via dell'utente
     * @param numeroCivico il numero civico dell'utente
     * @param CAP il codice postale dell'utente
     * @param admin flag che indica se l'utente è un amministratore
     * @param blocked flag che indica se l'utente è bloccato
     * @return l'oggetto Utente creato
     * @throws DuplicatedObjectException se un utente con la stessa email esiste già
     */
    public Utente registrati(String email, String nomeUtente, String cognome,
                             String password, String genere,
                             String nazione, String città, String via,
                             String numeroCivico, int CAP, boolean admin,
                             boolean blocked) throws DuplicatedObjectException;

    /**
     * Recupera tutti gli utenti registrati.
     * @return una lista di utenti
     */
    public ArrayList<Utente> findUtenti();

    /**
     * Recupera tutte le iniziali dei cognomi degli utenti registrati.
     * @return una lista di iniziali dei cognomi
     */
    public ArrayList<String> findInitialsUtenti();

    /**
     * Recupera tutti gli utenti che hanno il cognome che inizia con la lettera specificata.
     * @param initial l'iniziale del cognome
     * @return una lista di utenti con il cognome che inizia con l'iniziale specificata
     */
    public ArrayList<Utente> findUtentiByInitial(String initial);

    /**
     * Recupera un utente in base all'email.
     * @param email l'email dell'utente
     * @return l'oggetto Utente corrispondente
     */
    public Utente findByEmail(String email);

    /**
     * Blocca un utente nel database.
     * @param email l'email dell'utente da bloccare
     */
    public void bloccaUtente(String email);

    /**
     * Sblocca un utente nel database.
     * @param email l'email dell'utente da sbloccare
     */
    public void sbloccaUtente(String email);
}
