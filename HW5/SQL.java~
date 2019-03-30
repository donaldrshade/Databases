import java.sql.*;

class SQL{
 
  public static void main(String[] args) {
    
   try {           

     String url = "jdbc:sqlserver://localhost:1433;user=susie;password=Michael1520";
     Connection conn = DriverManager.getConnection(url);
    
     PreparedStatement ps = conn.prepareStatement("select * from course");
     ResultSet rs = ps.executeQuery();
            
    while (rs.next()) {
      System.out.println(rs.getString(1));
    }  

    rs.close();
    ps.close();            
   } catch (Exception e) {
     e.printStackTrace();
   } 
     
  }
  
  
}