package model.dao.mySQLJDBCImpl;

import java.sql.*;

import model.dao.PagamentoDAO;
import model.dao.exception.DuplicatedObjectException;

import model.mo.Ordine;
import model.mo.Pagamento;
import model.mo.Utente;

import static services.util.Conversion.convertJavaDateToSqlDate;

/**
 *
 * @author Oscar Costanzelli
 */
public class PagamentoDAOMySQLJDBCImpl implements PagamentoDAO{

    private Connection connection;

    public PagamentoDAOMySQLJDBCImpl(Connection connection){
        this.connection=connection;
    }

    /**
     *
     * Metodo che crea una nuova tupla di pagamento nel DB
     * @param statoPagamento
     * @param cartaPagamento
     * @param dataRichiestaPagamento
     * @param dataPagamento
     * @param importo
     * @param utente
     * @param ordine
     * @return pagamento
     * @throws DuplicatedObjectException
     */


        @Override
        public Pagamento creaPagamento(String statoPagamento,
                                       String cartaPagamento,
                                       java.util.Date dataRichiestaPagamento,
                                       java.util.Date dataPagamento,
                                       float importo,
                                       Utente utente,
                                       Ordine ordine) throws DuplicatedObjectException {
            PreparedStatement ps;
            Pagamento pagamento = new Pagamento();
            pagamento.setStatoPagamento(statoPagamento);
            pagamento.setCartaPagamento(cartaPagamento);
            pagamento.setDataRichiestaPagamento(dataRichiestaPagamento);
            pagamento.setDataPagamento(dataPagamento);
            pagamento.setImporto(importo);
            pagamento.setUtente(utente);
            pagamento.setOrdine(ordine);



            try {
                // Verifica se esiste già un pagamento uguale nel database
                String sql = "SELECT id FROM pagamento WHERE "
                        + "statoPagamento = ? AND cartaPagamento = ? AND "
                        + "dataRichiestaPagamento = ? AND dataPagamento = ? AND "
                        + "importo = ? AND utenteId = ? AND ordineId = ? ";

                ps = connection.prepareStatement(sql);
                int i = 1;
                ps.setString(i++, pagamento.getStatoPagamento());
                ps.setString(i++, pagamento.getCartaPagamento());
                ps.setDate(i++, convertJavaDateToSqlDate(pagamento.getDataRichiestaPagamento()));
                ps.setDate(i++, convertJavaDateToSqlDate(pagamento.getDataPagamento()));
                ps.setFloat(i++, pagamento.getImporto());
                ps.setInt(i++, utente.getId());
                ps.setInt(i++, ordine.getId());

                ResultSet resultSet = ps.executeQuery();
                boolean exist = resultSet.next();
                resultSet.close();

                if (exist) {
                    throw new DuplicatedObjectException("PagamentoDAOMySQLJDBCImpl.creaPagamento: Tentativo di inserimento di un pagamento già esistente");
                }

                // Se il pagamento non esiste, lo inserisco nel database
                sql = "INSERT INTO pagamento (statoPagamento, cartaPagamento, dataRichiestaPagamento, "
                        + "dataPagamento, importo, utenteId, ordineId) VALUES (?, ?, ?, ?, ?, ?, ?)";

                ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                i = 1;
                ps.setString(i++, pagamento.getStatoPagamento());
                ps.setString(i++, pagamento.getCartaPagamento());
                ps.setDate(i++, convertJavaDateToSqlDate(pagamento.getDataRichiestaPagamento()));
                ps.setDate(i++, convertJavaDateToSqlDate(pagamento.getDataPagamento()));
                ps.setFloat(i++, pagamento.getImporto());
                ps.setInt(i++, utente.getId());
                ps.setInt(i++, ordine.getId());

                ps.executeUpdate();

                // Recupero l'ID generato automaticamente
                resultSet = ps.getGeneratedKeys();
                if (resultSet.next()) {
                    pagamento.setId(resultSet.getInt(1)); // Imposta l'id generato nel pagamento
                }
                resultSet.close();

            } catch (SQLException e) {
                throw new RuntimeException(e);
            }

            return pagamento;
        }





    /**
     *
     * Recupera dal DB il codice dell'ultimo pagamento inserito nel DB
     * @return long
     */


    /**
     *
     * @param id
     * @return float
     */
    @Override
    public float getImporto(int id){
        PreparedStatement ps;
        float importo = 0;
        try{
            String sql = " SELECT importo "
                    + " FROM pagamento "
                    + " WHERE id = ? ";

            ps = connection.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                importo = rs.getFloat("importo");
            }

            rs.close();
            ps.close();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return importo;
    }
}
