package model.dao;

import java.util.Date;
import model.dao.exception.DuplicatedObjectException;
import model.mo.Buono;
import java.util.ArrayList;

/**
 * DAO per la gestione dei Buoni.
 */
public interface BuonoDAO {

    /**
     * Crea un nuovo buono nel database.
     *
     * @param nomeBuono Il nome del buono.
     * @param sconto La percentuale di sconto offerta dal buono.
     * @param dataScadenza La data di scadenza del buono.
     * @return Il Buono creato.
     * @throws DuplicatedObjectException Se un buono con lo stesso nome, sconto e data di scadenza esiste già.
     */
    Buono creaBuono(String nomeBuono, int sconto, Date dataScadenza,String codiceBuono)
            throws DuplicatedObjectException;

    /**
     * Aggiorna i dettagli di un buono nel database.
     *
     * @param buono Il Buono da aggiornare.
     */
    void aggiorna(Buono buono);

    /**
     * Elimina logicamente un buono dal database utilizzando il codice del buono.
     *
     * @param codiceBuono Il codice del buono da eliminare.
     */
    void eliminaByKey(String codiceBuono);

    /**
     * Elimina logicamente un buono dal database utilizzando il nome del buono.
     *
     * @param nomeBuono Il nome del buono da eliminare.
     */
    void eliminaByName(String nomeBuono);

    /**
     * Trova e restituisce un buono utilizzando il codice del buono.
     *
     * @param codiceBuono Il codice del buono da cercare.
     * @return Il Buono trovato o null se non esiste.
     */
    Buono findBuonoByKey(String codiceBuono);

    /**
     * Trova e restituisce una lista di buoni utilizzando il nome del buono.
     *
     * @param nomeBuono Il nome del buono da cercare.
     * @return Una lista di Buoni trovati o una lista vuota se non esistono.
     */
    ArrayList<Buono> findBuonoByName(String nomeBuono);

    /**
     * Recupera tutti i buoni validi nel database, raggruppati per nome.
     *
     * @return Una lista di buoni validi.
     */
    ArrayList<Buono> recuperaBuoni();

    /**
     * Verifica la validità di un buono in base al suo codice.
     *
     * @param codiceBuono Il codice del buono da verificare.
     * @return true se il buono è valido, altrimenti false.
     */
    boolean checkValidità(String codiceBuono);
}
