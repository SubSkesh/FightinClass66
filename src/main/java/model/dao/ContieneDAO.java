package model.dao;

import java.util.ArrayList;
import model.dao.exception.DuplicatedObjectException;
import model.mo.Contiene;

/**
 * Interfaccia per la gestione delle operazioni CRUD sulla tabella Contiene
 * che rappresenta la relazione tra Ordine e Prodotto nel database.
 */
public interface ContieneDAO {

    /**
     * Crea una nuova voce nella tabella Contiene che rappresenta un prodotto associato a un ordine.
     *
     * @param ordineId      L'identificatore univoco dell'ordine.
     * @param prodottoId    L'identificatore univoco del prodotto.
     * @param quantitaOrdine La quantità del prodotto inclusa nell'ordine.
     * @return L'oggetto Contiene creato.
     * @throws DuplicatedObjectException se la combinazione ordineId e prodottoId esiste già.
     */
    public Contiene creaContiene(int ordineId, int prodottoId, int quantitaOrdine)
            throws DuplicatedObjectException;

    /**
     * Trova tutte le voci della tabella Contiene associate a un determinato ordine.
     *
     * @param ordineId L'identificatore univoco dell'ordine.
     * @return Una lista di oggetti Contiene rappresentanti i prodotti inclusi nell'ordine.
     */
    public ArrayList<Contiene> findContieneByOrdine(long ordineId);
}
