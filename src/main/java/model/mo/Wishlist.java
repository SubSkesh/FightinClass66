package model.mo;

/**
 * Classe che rappresenta la Wishlist di un utente.
 */
public class Wishlist {

    private int id;         // ID della wishlist (chiave primaria)
    private Utente utente;  // Utente associato alla wishlist
    private Prodotto prodotto; // Prodotto aggiunto alla wishlist

    // Getters e Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Utente getUtente() {
        return utente;
    }

    public void setUtente(Utente utente) {
        this.utente = utente;
    }

    public Prodotto getProdotto() {
        return prodotto;
    }

    public void setProdotto(Prodotto prodotto) {
        this.prodotto = prodotto;
    }
}
