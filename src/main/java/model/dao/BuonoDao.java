package model.dao;

import java.util.Date;
import model.dao.exception.DuplicatedObjectException;
import model.mo.Buono;

/**
 * DAO per gestire i Buoni.
 */
public interface BuonoDAO {

    /**
     * Crea un nuovo buono nel database.
     *
     * @param dataScadenza La data di scadenza del buono.
     * @param nomeBuono Il nome del buono.
     * @param sconto La percentuale di sconto offerta dal buono.
     * @param codiceBuono Il codice univoco del buono.
     * @param eliminato Se il buono è stato eliminato.
     * @param usato Se il buono è stato utilizzato.
     * @param ordineId L'ID dell'ordine associato (può essere null se non associato).
     * @return Il Buono creato.
     * @throws DuplicatedObjectException Se il codiceBuono è già presente.
     */
    public Buono creaBuono(Date dataScadenza, String nomeBuono, int sconto,
                           String codiceBuono, boolean eliminato, boolean usato, Long ordineId)
            throws DuplicatedObjectException;

    /**
     * Trova un buono in base al suo codice.
     *
     * @param codiceBuono Il codice del buono da cercare.
     * @return Il Buono trovato o null se non esiste.
     */
    public Buono findByCodiceBuono(String codiceBuono);

    /**
     * Aggiorna i dettagli di un buono nel database.
     *
     * @param buono Il Buono da aggiornare.
     * @throws DuplicatedObjectException Se un buono con lo stesso codice esiste già.
     */
    public void aggiorna(Buono buono) throws DuplicatedObjectException;

    /**
     * Elimina un buono impostando il flag eliminato su true.
     *
     * @param id L'ID del buono da eliminare.
     */
    public void elimina(long id);

    /**
     * Trova tutti i buoni validi (non eliminati).
     *
     * @return Una lista di Buoni validi.
     */
    public List<Buono> findBuoniValidi();
}
