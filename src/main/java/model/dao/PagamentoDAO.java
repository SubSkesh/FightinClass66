package model.dao;

import model.dao.exception.DuplicatedObjectException;
import model.mo.Ordine;
import model.mo.Pagamento;
import model.mo.Utente;

/**
 * Interfaccia per la gestione dei pagamenti nel sistema.
 */
public interface PagamentoDAO {

    /**
     * Crea un nuovo pagamento nel sistema.
     *
     * @param statoPagamento         Stato del pagamento (es. "Completato", "In attesa").
     * @param cartaPagamento         Tipo di carta utilizzata per il pagamento.
     * @param dataRichiestaPagamento Data in cui il pagamento è stato richiesto.
     * @param dataPagamento          Data in cui il pagamento è stato effettivamente eseguito.
     * @param importo                Importo del pagamento.
     * @param utente                 Utente che ha effettuato il pagamento.
     * @param ordine                 Ordine associato al pagamento.
     * @return                       Il pagamento creato.
     * @throws DuplicatedObjectException Se il pagamento già esiste.
     */
    public Pagamento creaPagamento(String statoPagamento, String cartaPagamento,
                                   java.util.Date dataRichiestaPagamento, java.util.Date
                                           dataPagamento, float importo, Utente utente, Ordine ordine)
            throws DuplicatedObjectException;

    /**
     * Recupera l'importo di un pagamento specifico.
     *
     * @param codicePagamento Identificatore univoco del pagamento.
     * @return                L'importo del pagamento.
     */
    public float getImporto(long codicePagamento);

    /**
     * Trova un pagamento per il suo codice.
     *
     * @param codicePagamento Codice del pagamento da cercare.
     * @return Il pagamento trovato o null se non esiste.
     */
    public Pagamento findByCodicePagamento(long codicePagamento);

    /**
     * Aggiorna le informazioni di un pagamento nel database.
     *
     * @param pagamento Il pagamento con le informazioni aggiornate.
     * @throws DuplicatedObjectException Se il pagamento aggiornato entra in conflitto con un altro esistente.
     */
    public void aggiornaPagamento(Pagamento pagamento) throws DuplicatedObjectException;
}
