package services.util;

/**
 * Classe di utilità per la conversione di date.
 *
 * @author Giacomo Polastri
 */
public class Conversion {

    /**
     * Converte una data di tipo `java.util.Date` in `java.sql.Date`.
     *
     * @param date La data di tipo `java.util.Date` da convertire.
     * @return La data convertita in `java.sql.Date`.
     */
    public static java.sql.Date convertJavaDateToSqlDate(java.util.Date date) {
        return new java.sql.Date(date.getTime());
    }
}
