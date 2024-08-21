package model.dao;

import java.util.ArrayList;
import java.util.Date;
import model.dao.exception.DuplicatedObjectException;
import model.mo.Buono;
import model.mo.Contiene;
import model.mo.Ordine;
import model.mo.Pagamento;
import model.mo.Utente;

/**
 * Interfaccia per la gestione degli ordini nel sistema e-commerce.
 */
public interface OrdineDAO {

    /**
     * Crea un nuovo ordine nel sistema.
     *
     * @param dataOrdine      Data in cui l'ordine è stato effettuato.
     * @param statoOrdine     Stato attuale dell'ordine (es. "in preparazione", "in viaggio").
     * @param dataConsegna    Data stimata o effettiva di consegna dell'ordine.
     * @param nazione         Nazione di consegna dell'ordine.
     * @param citta           Città di consegna dell'ordine.
     * @param via             Via di consegna dell'ordine.
     * @param numeroCivico    Numero civico della consegna.
     * @param CAP             CAP della consegna.
     * @param pagamento       Informazioni di pagamento associate all'ordine.
     * @param buono           Buono utilizzato per l'ordine, se presente.
     * @param utente          Utente che ha effettuato l'ordine.
     * @param contiene        Lista dei prodotti contenuti nell'ordine.
     * @return                L'ordine creato.
     * @throws DuplicatedObjectException Se l'ordine già esiste.
     */
    public Ordine creaOrdine(Date dataOrdine,
                             String statoOrdine,
                             Date dataConsegna,
                             String nazione,
                             String citta,
                             String via,
                             long numeroCivico,
                             int CAP,
                             Pagamento pagamento,
                             Buono buono,
                             Utente utente,
                             ArrayList<Contiene> contiene) throws DuplicatedObjectException;

    /**
     * Aggiorna lo stato di un ordine specificato.
     *
     * @param codiceOrdine Codice univoco dell'ordine.
     * @param stato        Nuovo stato dell'ordine (es. "in viaggio").
     */
    public void aggiornaStato(long codiceOrdine, String stato);

    /**
     * Aggiorna lo stato e la data di consegna di un ordine specificato.
     *
     * @param codiceOrdine Codice univoco dell'ordine.
     * @param statoOrdine  Nuovo stato dell'ordine (es. "consegnato").
     * @param dataOdierna  Data in cui l'ordine è stato consegnato.
     */
    public void aggiornaStatoConData(long codiceOrdine, String statoOrdine, Date dataOdierna);

    /**
     * Recupera tutti gli ordini effettuati nel sistema.
     *
     * @return Una lista di tutti gli ordini.
     */
    public ArrayList<Ordine> findOrdini();

    /**
     * Recupera tutti gli ordini effettuati da uno specifico utente.
     *
     * @param email Email dell'utente.
     * @return      Una lista di ordini effettuati dall'utente.
     */
    public ArrayList<Ordine> findByUtente(String email);

    /**
     * Conta il numero di ordini effettuati da uno specifico utente.
     *
     * @param email Email dell'utente.
     * @return      Il numero di ordini effettuati dall'utente.
     */
    public int contaOrdini(String email);
}
