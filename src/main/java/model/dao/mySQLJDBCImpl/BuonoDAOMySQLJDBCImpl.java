package model.dao.mySQLJDBCImpl;
import java.sql.Connection;  // Importa la classe Connection per gestire la connessione al database
import java.sql.PreparedStatement;  // Importa la classe PreparedStatement per eseguire query SQL precompilate
import java.sql.ResultSet;  // Importa la classe ResultSet per gestire i risultati delle query SQL
import java.sql.SQLException;  // Importa la classe SQLException per gestire le eccezioni SQL

import java.util.ArrayList;  // Importa la classe ArrayList per creare liste dinamiche
import java.util.Date;  // Importa la classe Date per gestire le date

import model.dao.BuonoDAO;  // Importa l'interfaccia BuonoDAO che questa classe implementa
import model.dao.exception.DuplicatedObjectException;  // Importa l'eccezione personalizzata che viene lanciata in caso di duplicazione

import model.mo.Buono;  // Importa la classe Buono che rappresenta l'oggetto modello
import static services.util.Conversion.convertJavaDateToSqlDate;  // Importa un metodo statico per convertire le date da Java a SQL
public class BuonoDAOMySQLJDBCImpl implements BuonoDAO {

    // Costante che rappresenta l'ID del contatore per il codiceBuono
    private final String COUNTER_ID = "codiceBuono";

    // Connessione al database che verrà utilizzata per eseguire le query
    private Connection connection;

    // Costruttore che inizializza la connessione al database
    public BuonoDAOMySQLJDBCImpl(Connection connection) {
        this.connection = connection;
    }

    /**
     * Metodo che crea un nuovo buono nel database controllando che non esista già.
     */
    @Override
    public Buono creaBuono(String nomeBuono, int sconto, java.util.Date dataScadenza) throws DuplicatedObjectException {
        PreparedStatement ps;
        Buono buono = new Buono();
        buono.setNomeBuono(nomeBuono);
        buono.setSconto(sconto);
        buono.setDataScadenza(dataScadenza);

        try {
            // Verifica se esiste già un buono con gli stessi parametri nel database
            String sql = "SELECT codiceBuono FROM buono WHERE nomeBuono = ? AND sconto = ? AND dataScadenza = ?";
            ps = connection.prepareStatement(sql);
            int i = 1;
            ps.setString(i++, buono.getNomeBuono());
            ps.setDate(i++, convertJavaDateToSqlDate(buono.getDataScadenza()));
            ps.setInt(i++, buono.getSconto());

            ResultSet resultSet = ps.executeQuery();

            boolean exist = resultSet.next();
            resultSet.close();

            // Se esiste già un buono con questi parametri, lancia un'eccezione
            if (exist) {
                throw new DuplicatedObjectException("BuonoDAOJDBCImpl.create: Tentativo di inserimento di un buono già esistente.");
            }

            // Aggiorna il contatore per il codice del buono
            sql = "UPDATE counter SET counterValue=counterValue+1 WHERE counterId='" + COUNTER_ID + "'";
            ps = connection.prepareStatement(sql);
            ps.executeUpdate();

            // Recupera il nuovo valore del contatore
            sql = "SELECT counterValue FROM counter WHERE counterId='" + COUNTER_ID + "'";
            ps = connection.prepareStatement(sql);
            resultSet = ps.executeQuery();
            resultSet.next();

            buono.setCodiceBuono(resultSet.getLong("counterValue"));

            resultSet.close();

            // Inserisce il nuovo buono nel database
            sql = "INSERT INTO buono (codiceBuono, nomeBuono, dataScadenza, sconto, usato, eliminato) VALUES (?,?,?,?,'N','N')";
            ps = connection.prepareStatement(sql);
            i = 1;
            ps.setLong(i++, buono.getCodiceBuono());
            ps.setString(i++, buono.getNomeBuono());
            ps.setDate(i++, convertJavaDateToSqlDate(buono.getDataScadenza()));
            ps.setInt(i++, buono.getSconto());
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return buono;
    }

    /**
     * Modifica i valori di un buono nel database.
     */
    @Override
    public void aggiorna(Buono buono) {
        PreparedStatement ps;
        try {
            // Query per aggiornare il buono nel database
            String sql = "UPDATE buono SET nomeBuono = ?, dataScadenza = ?, sconto = ?, usato = ? WHERE codiceBuono = ?";
            ps = connection.prepareStatement(sql);
            int i = 1;
            ps.setString(i++, buono.getNomeBuono());
            ps.setDate(i++, convertJavaDateToSqlDate(buono.getDataScadenza()));
            ps.setInt(i++, buono.getSconto());
            ps.setString(i++, buono.isUsato() ? "S" : "N");
            ps.setLong(i++, buono.getCodiceBuono());

            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * Cancella logicamente un buono dal database impostando il campo eliminato a 'S'.
     */
    @Override
    public void eliminaByKey(long codiceBuono) {
        PreparedStatement ps;
        try {
            String sql = "UPDATE buono SET eliminato = 'S' WHERE codiceBuono = ?";
            ps = connection.prepareStatement(sql);
            ps.setLong(1, codiceBuono);
            ps.executeUpdate();
            ps.close();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * Cancella logicamente un buono dal database basandosi sul nome del buono.
     */
    @Override
    public void eliminaByName(String nomeBuono) {
        PreparedStatement ps;
        try {
            String sql = "UPDATE buono SET eliminato = 'S' WHERE nomeBuono = ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, nomeBuono);
            ps.executeUpdate();
            ps.close();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * Recupera dal database tutti i buoni presenti, raggruppandoli per nome.
     */
    @Override
    public ArrayList<Buono> recuperaBuoni() {
        PreparedStatement ps;
        Buono buono;
        ArrayList<Buono> buoni = new ArrayList<>();

        try {
            String sql = "SELECT * FROM buono GROUP BY nomeBuono";
            ps = connection.prepareStatement(sql);

            ResultSet resultSet = ps.executeQuery();

            while (resultSet.next()) {
                buono = read(resultSet);
                buoni.add(buono);
            }

            resultSet.close();
            ps.close();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return buoni;
    }

    /**
     * Verifica la validità di un buono tramite il codice.
     */
    @Override
    public boolean checkValidità(long codiceBuono) {
        PreparedStatement ps;
        java.util.Date dataScadenza = null;
        String usato = null, eliminato = null;

        try {
            String sql = "SELECT dataScadenza, usato, eliminato FROM buono WHERE codiceBuono = ?";
            ps = connection.prepareStatement(sql);
            ps.setLong(1, codiceBuono);

            ResultSet resultSet = ps.executeQuery();

            if (resultSet.next()) {
                dataScadenza = resultSet.getDate("dataScadenza");
                usato = resultSet.getString("usato");
                eliminato = resultSet.getString("eliminato");
            }

            resultSet.close();
            ps.close();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        Date dataOdierna = new Date();
        return dataOdierna.compareTo(dataScadenza) < 0 && "N".equals(usato) && "N".equals(eliminato);
    }

    /**
     * Recupera un buono dal database tramite il codice.
     */
    @Override
    public Buono findBuonoByKey(long codiceBuono) {
        PreparedStatement ps;
        Buono buono = null;

        try {
            String sql = "SELECT * FROM buono WHERE codiceBuono = ?";
            ps = connection.prepareStatement(sql);
            ps.setLong(1, codiceBuono);

            ResultSet resultSet = ps.executeQuery();

            if (resultSet.next()) {
                buono = read(resultSet);
            }

            resultSet.close();
            ps.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return buono;
    }

    /**
     * Recupera dal database tutti i buoni con un determinato nome.
     */
    @Override
    public ArrayList<Buono> findBuonoByName(String nomeBuono) {
        PreparedStatement ps;
        Buono buono;
        ArrayList<Buono> buoni = new ArrayList<>();

        try {
            String sql = "SELECT * FROM buono WHERE nomeBuono = ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, nomeBuono);

            ResultSet resultSet = ps.executeQuery();

            while (resultSet.next()) {
                buono = read(resultSet);
                buoni.add(buono);
            }

            resultSet.close();
            ps.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return buoni;
    }

    /**
     * Metodo helper per leggere i valori dal ResultSet e caricarli in un oggetto Buono.
     */
    protected Buono read(ResultSet resultSet) {
        Buono buono = new Buono();

        try {
            buono.setCodiceBuono(resultSet.getLong("codiceBuono"));
        } catch (SQLException sqle) {
            System.out.println(sqle.getMessage());
        }

        try {
            buono.setNomeBuono(resultSet.getString("nomeBuono"));
        } catch (SQLException sqle) {
            System.out.println(sqle.getMessage());
        }

        try {
            buono.setDataScadenza(resultSet.getDate("dataScadenza"));
        } catch (SQLException sqle) {
            System.out.println(sqle.getMessage());
        }

        try {
            buono.setSconto(resultSet.getInt("sconto"));
        } catch (SQLException sqle) {
            System.out.println(sqle.getMessage());
        }

        try {
            if ("S".equals(resultSet.getString("usato"))) {
                buono.setUsato(true);
            } else {
                buono.setUsato(false);
            }
        } catch (SQLException sqle) {
            System.out.println(sqle.getMessage());
        }

        try {
            if ("S".equals(resultSet.getString("eliminato"))) {
                buono.setEliminato(true);
            } else {
                buono.setEliminato(false);
            }
        } catch (SQLException sqle) {
            System.out.println(sqle.getMessage());
        }

        return buono;
    }
}
