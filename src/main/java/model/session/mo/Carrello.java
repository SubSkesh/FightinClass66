package model.session.mo;


import model.mo.Prodotto;

/**
 * Classe che rappresenta un elemento del carrello della spesa di un utente.
 */
public class Carrello {

    private Prodotto prodotto;  // Riferimento all'entità Prodotto
    private int quantita;      // Quantità del prodotto nel carrello

    @Override
    public String toString() {
        return prodotto.getId() + " " + getQuantità();
    }

    // Getter e Setter
    public int getidProdotto() {

        return prodotto.getId();}

    public void setProdotto(Prodotto prodotto) {
        this.prodotto = prodotto;    }


    public Prodotto getProdotto() {
        return prodotto;
    }

    public int getQuantità() {
        return quantita;
    }

    public void setQuantità(int quantita) {
        this.quantita = quantita;
    }

}
