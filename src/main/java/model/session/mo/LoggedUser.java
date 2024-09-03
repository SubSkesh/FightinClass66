package model.session.mo;


/**
 * Classe che rappresenta un utente loggato nel sistema.
 */
public class LoggedUser {

    private String email;
    private String nomeUtente;
    private String cognome;
    private boolean admin;

    // Getter e Setter per email
    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    // Getter e Setter per nomeUtente
    public String getNomeUtente() {
        return nomeUtente;
    }

    public void setNomeUtente(String nomeUtente) {
        this.nomeUtente = nomeUtente;
    }

    // Getter e Setter per cognome
    public String getCognome() {
        return cognome;
    }

    public void setCognome(String cognome) {
        this.cognome = cognome;
    }

    // Getter e Setter per admin
    public boolean isAdmin() {
        return admin;
    }

    public void setAdmin(boolean admin) {
        this.admin = admin;
    }

}
