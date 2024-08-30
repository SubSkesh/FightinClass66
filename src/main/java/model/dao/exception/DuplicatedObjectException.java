package model.dao.exception;

/**
 *
 * @author Oscar Costanzelli
 */
public class DuplicatedObjectException extends Exception{

    /*
     *Classe in cui realizzo un'eccezione personalizzata da invocare nel caso in
     *cui si tenti di inserire nel database un elemento già esistente
     */

    public DuplicatedObjectException(){
        super();
    }

    public DuplicatedObjectException(String s){
        super(s);
    }

}
