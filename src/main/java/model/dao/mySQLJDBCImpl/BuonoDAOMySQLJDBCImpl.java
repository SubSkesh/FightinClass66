    package model.dao.mySQLJDBCImpl;

    import java.sql.Connection;
    import java.sql.PreparedStatement;
    import java.sql.ResultSet;
    import java.sql.SQLException;
    import java.util.ArrayList;
    import java.util.Date;
    import model.dao.BuonoDAO;
    import model.dao.exception.DuplicatedObjectException;
    import model.mo.Buono;
    import static services.util.Conversion.convertJavaDateToSqlDate;

    public class BuonoDAOMySQLJDBCImpl implements BuonoDAO {

        private Connection connection;

        public BuonoDAOMySQLJDBCImpl(Connection connection) {
            this.connection = connection;
        }

        @Override
        public Buono creaBuono(String nomeBuono, int sconto, java.util.Date dataScadenza, String codiceBuono)
                throws DuplicatedObjectException {
            PreparedStatement ps;
            Buono buono = new Buono();
            buono.setNomeBuono(nomeBuono);
            buono.setSconto(sconto);
            buono.setDataScadenza(dataScadenza);
            buono.setCodiceBuono(codiceBuono);

            try {
                // Verifica se esiste già un buono con lo stesso codiceBuono nel database
                String sql = "SELECT codiceBuono FROM buono WHERE codiceBuono = ?";
                ps = connection.prepareStatement(sql);
                ps.setString(1, buono.getCodiceBuono());

                ResultSet resultSet = ps.executeQuery();
                boolean exist = resultSet.next();
                resultSet.close();

                // Se esiste già un buono con lo stesso codiceBuono, lancia un'eccezione
                if (exist) {
                    System.out.println("Buono " + buono.getNomeBuono() + " esiste già.");
    //                throw new DuplicatedObjectException("BuonoDAOJDBCImpl.create: Tentativo di inserimento di un buono già esistente con questo codice.");
                }

                // Inserisce il nuovo buono nel database

                sql = "INSERT INTO buono (codiceBuono, nomeBuono, dataScadenza, sconto, usato, eliminato) VALUES (?,?,?,?, '0', '0')";
                ps = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS); //salva l'ultimo valore con chiave autoincrementata nel db dopo lultimo insert
                int i = 1;
                ps.setString(i++, buono.getCodiceBuono());
                ps.setString(i++, buono.getNomeBuono());
                ps.setDate(i++, convertJavaDateToSqlDate(buono.getDataScadenza()));
                ps.setInt(i++, buono.getSconto());
                ps.executeUpdate();
                // Recupera il valore dell'ID generato automaticamente
                resultSet = ps.getGeneratedKeys();
                if (resultSet.next()) {
                    buono.setId(resultSet.getInt(  1)); // Imposta l'id generato nel buono
                }
                resultSet.close();

            } catch (SQLException e) {
                throw new RuntimeException(e);
            }

            return buono;
        }

        @Override
        public void aggiorna(Buono buono) {
            PreparedStatement ps;
            try {
                String sql = "UPDATE buono SET nomeBuono = ?, dataScadenza = ?, sconto = ?, usato = ? WHERE codiceBuono = ?";
                ps = connection.prepareStatement(sql);
                int i = 1;
                ps.setString(i++, buono.getNomeBuono());
                ps.setDate(i++, convertJavaDateToSqlDate(buono.getDataScadenza()));
                ps.setInt(i++, buono.getSconto());
                ps.setString(i++, buono.isUsato() ? "S" : "N");
                ps.setString(i++, buono.getCodiceBuono()); // Usa codiceBuono per identificare il buono

                ps.executeUpdate();

            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }

        @Override
        public void eliminaByKey(String codiceBuono) {
            PreparedStatement ps;
            try {
                String sql = "UPDATE buono SET eliminato = '1' WHERE codiceBuono = ?";
                ps = connection.prepareStatement(sql);
                ps.setString(1, codiceBuono);
                ps.executeUpdate();
                ps.close();

            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }

        @Override
        public void eliminaByName(String nomeBuono) {
            PreparedStatement ps;
            try {
                String sql = "UPDATE buono SET eliminato = '1' WHERE nomeBuono = ?";
                ps = connection.prepareStatement(sql);
                ps.setString(1, nomeBuono);
                ps.executeUpdate();
                ps.close();

            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }

        @Override
        public ArrayList<Buono> recuperaBuoni() {
            PreparedStatement ps;
            Buono buono;
            ArrayList<Buono> buoni = new ArrayList<>();

            try {
                String sql = "SELECT * FROM buono where eliminato = 0";
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

        @Override
        public boolean checkValidità(String codiceBuono) {
            PreparedStatement ps;
            java.util.Date dataScadenza = null;
            String usato = null, eliminato = null;

            try {
                String sql = "SELECT dataScadenza, usato, eliminato FROM buono WHERE codiceBuono = ?";
                ps = connection.prepareStatement(sql);
                ps.setString(1, codiceBuono);

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

        @Override
        public Buono findBuonoByKey(String codiceBuono) {
            PreparedStatement ps;
            Buono buono = null;

            try {
                String sql = "SELECT * FROM buono WHERE codiceBuono= ?";
                ps = connection.prepareStatement(sql);
                ps.setString(1, codiceBuono);

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

        protected Buono read(ResultSet resultSet) {
            Buono buono = new Buono();

            try {
                buono.setId(resultSet.getInt("id")); // Usa l'id come chiave primaria
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
                buono.setUsato("S".equals(resultSet.getString("usato")));
            } catch (SQLException sqle) {
                System.out.println(sqle.getMessage());
            }

            try {
                buono.setEliminato("S".equals(resultSet.getString("eliminato")));
            } catch (SQLException sqle) {
                System.out.println(sqle.getMessage());
            }

            return buono;
        }
    }
