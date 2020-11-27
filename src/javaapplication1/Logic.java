/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package javaapplication1;
import java.util.Arrays;
import org.jpl7.Atom;
import org.jpl7.Query;
import org.jpl7.Term;
import org.jpl7.Variable;

/**
 *
 * @author Aaron
 */
public class Logic {
    
    public Logic(String path)
    {
        Query q1 = new Query(path);
        System.out.println(q1.hasSolution());
    }
    
    public boolean createMatrix(Integer rows, Integer columns)
    {
        String query = "createMatrix(res,"+rows.toString()+","+columns.toString()+").";
        Query ql = new Query(query);
        return ql.hasSolution();    
    }
    
    public String doAQuery(String query)
    {
        Query ql = new Query(query);
        return ql.oneSolution().get("Res").toString();
    }
    
    public void printM(String[][] m)
    {
      for (int i = 0; i < m.length; i++)
      {
          for (int j = 0; j < m[0].length; j++)
          {
              if(m[i][j].equals("-1")){
                  System.out.print(m[i][j]+" ");
              }else{
                  System.out.print(" "+m[i][j]+" ");
              }
              
          }
          System.out.println("");
      }
    }
    
    public String[][] getMatrix()
    {
        String query = "getMatrix(res,Matrix).";
        Query ql = new Query(query);
        String matrixProlog = ql.oneSolution().get("Matrix").toString().replace("[", "").replace(" ", "").replace("]]", "");
        //System.out.println(matrixProlog);
        String[] rows = matrixProlog.split("],");
        String[][] matrix = new String[rows.length][];
        for(int r = 0; r < rows.length; r++)
        {
            matrix[r] = rows[r].split(",");
        }
        //printM(matrix);
        return matrix;
    }
    
    public String[][] placeCell(Integer posX, Integer posY, Integer val)
    {
        if(val < 10 && val > 0)
        {
            String query = "placeNumber(res,"+posX.toString()+","+posY.toString()+","+val.toString()+").";
            Query ql = new Query(query);
            ql.hasSolution();
        }
        return this.getMatrix();
    }
}
