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
    
    public boolean solveMatrix(String matrix)
    {
        String query = "fillRandomMatrix("+matrix+").";
        Query ql = new Query(query);
        return ql.hasSolution();
    }
    
    public String doAQuery(String query,boolean hasRes)
    {
        Query ql = new Query(query);
        if(hasRes)
        {
            String res = "has not a solution";
            if(ql.hasSolution()){
                res = ql.oneSolution().get("Res").toString();
            }
            return res;  
        }else{
            if(ql.hasSolution())
            {
                return "True";
            }else
            {
                return "False";
            }
        }

    }
    
    public String[][][] getInvalidRows(String name)
    {
        String[][] matrix = null;
        String query = "getInvalidFullRowsCells("+name+",Res).";
        String res = "";
        Query ql = new Query(query);
        String[][][] result = new String[1][][];
        if(ql.hasSolution())
        {
         res = ql.oneSolution().get("Res").toString().replace(", [[","/");//.replace(", [", "|").replace("[[", "");//.replace("]", "");
         String[] rows = res.split("]]], ");//("]],");
         String[][] rowCols = new String[rows.length][];
         result = new String[rows.length][][];
         for(int i = 0; i < rows.length; i++)
         {
            //Obteniendo las filas
            rowCols[i] = rows[i].replace("[","").replace(" ", "").replace("]", "").split("/");
            result[i] = new String[rowCols[i].length][];
            result[i][0] = new String[1];
            result[i][0][0] = rowCols[i][0];
            if(rowCols[i].length > 1)
            {
                for (int j = 0; j < rowCols[i].length; j++)
                {
                    String[] temp = rowCols[i][j].replace("]","").split(",");
                    //result[i][j] = new String[temp.length];
                    result[i][j] = temp;
                }
            }

         }
         System.out.println(res);
        }
        return result;
    }
    
    public String[][][] getInvalidColumns(String name)
    {
        String[][] matrix = null;
        String query = "getInvalidFullColumnsCells("+name+",Res).";
        String res = "";
        Query ql = new Query(query);
        String[][][] result = new String[1][][];
        if(ql.hasSolution())
        {
         res = ql.oneSolution().get("Res").toString().replace(", [[","/");//.replace(", [", "|").replace("[[", "");//.replace("]", "");
         String[] rows = res.split("]]], ");//("]],");
         String[][] rowCols = new String[rows.length][];
         result = new String[rows.length][][];
         for(int i = 0; i < rows.length; i++)
         {
            //Obteniendo las filas
            rowCols[i] = rows[i].replace("[","").replace(" ", "").replace("]", "").split("/");
            result[i] = new String[rowCols[i].length][];
            result[i][0] = new String[1];
            result[i][0][0] = rowCols[i][0];
            if(rowCols[i].length > 1)
            {
                for (int j = 0; j < rowCols[i].length; j++)
                {
                    String[] temp = rowCols[i][j].replace("]","").split(",");
                    //result[i][j] = new String[temp.length];
                    result[i][j] = temp;
                }
            }

         }
         System.out.println(res);
        }
        return result;
    }
    
    public String[][] getRowsSums(String name)
    {
        String[][] matrix = null;
        String query = "getRowsSums("+name+",Res).";
        String res = "";
        Query ql = new Query(query);
        if(ql.hasSolution())
        {
         res = ql.oneSolution().get("Res").toString();
         matrix = StringToMatrix(res);
        }
        return matrix;
    }
    
    public String[][] getColumnsSums(String name)
    {
        String[][] matrix = null;
        String query = "getColumnsSums("+name+",Res).";
        String res = "";
        Query ql = new Query(query);
        if(ql.hasSolution())
        {
         res = ql.oneSolution().get("Res").toString();
         System.out.println(res);
         matrix = StringToMatrix(res);
        }
        return matrix;
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
    
    private String[][] StringToMatrix(String matrix)
    {
        String cleanFormat = matrix.replace("[", "").replace(" ", "").replace("]]", "");
        String[] rows = cleanFormat.split("],");
        String[][] res = new String[rows.length][];
        for(int r = 0; r < rows.length; r++)
        {
            res[r] = rows[r].split(",");
        }
        return res;
    }
    
    public String[][] getMatrix(String name)
    {
        String query = "getMatrix("+name+",Matrix).";
        Query ql = new Query(query);
        String matrixProlog = ql.oneSolution().get("Matrix").toString();
        String[][] matrix = StringToMatrix(matrixProlog);
        printM(matrix);
        return matrix;
    }
    
    public String[][] placeCell(String name,Integer posX, Integer posY, Integer val)
    {
        String query = "placeNumber("+name+","+posX.toString()+","+posY.toString()+","+val.toString()+").";
        Query ql = new Query(query);
        ql.hasSolution();
        return this.getMatrix(name);
    }
}
