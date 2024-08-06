package model.mo;

/**
 * Rappresenta un prodotto nel sistema e-commerce.
 */
public class Prodotto {

    private String nomeProdotto, categoria, descrizione, immagine;
    private long quantita;
    private long codiceProdotto;
    private float prezzo;
    private boolean blocked, push;

    private Contiene[] contiene; // Relazione con Contiene

    public long getCodiceProdotto(){
        return codiceProdotto;
    }

    public void setCodiceProdotto(long c){
        codiceProdotto = c;
    }

    public String getNomeProdotto(){
        return nomeProdotto;
    }

    public void setNomeProdotto(String nome){
        nomeProdotto = nome;
    }

    public String getCategoria(){
        return categoria;
    }

    public void setCategoria(String cat){
        categoria = cat;
    }

    public String getDescrizione(){
        return descrizione;
    }

    public void setDescrizione(String desc){
        descrizione = desc;
    }

    public float getPrezzo(){
        return prezzo;
    }

    public void setPrezzo(float p){
        prezzo = p;
    }

    public String getImmagine(){
        return immagine;
    }

    public void setImmagine(String img){
        immagine = img;
    }

    public long getQuantita(){
        return quantita;
    }

    public void setQuantita(long q){
        quantita = q;
    }

    public boolean isBlocked(){
        return blocked;
    }

    public void setBlocked(boolean b){
        blocked = b;
    }

    public boolean isPush(){
        return push;
    }

    public void setPush(boolean p){
        push = p;
    }

    /*Ritorna l'intero array*/
    public Contiene[] getContiene() {
        return contiene;
    }

    /*Setta l'intero array*/
    public void setContiene(Contiene[] contiene) {
        this.contiene = contiene;
    }

    /*Ritorna l'elemento della posizione specificata*/
    public Contiene getContiene(int index) {
        return this.contiene[index];
    }

    /*Setta la posizione specificata con l'elemento specificato*/
    public void setContiene(int index, Contiene contiene) {
        this.contiene[index] = contiene;
    }
}
