import java.net.*;
import java.io.*;
public class TCPClient   
{
  public static void main( String args[ ] ) throws Exception
  {
     Socket sock = new Socket( "127.0.0.1", 4000);               
     System.out.print("Enter the file name\n");
     BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
     String fname = br.readLine();
     OutputStream  ostream = sock.getOutputStream( );
     PrintWriter pwrite = new PrintWriter(ostream, true);
     pwrite.println(fname);            
          	          
     InputStream istream = sock.getInputStream();
     BufferedReader socketRead = new BufferedReader(new InputStreamReader(istream));

     String str;
     while((str = socketRead.readLine())  !=  null) // reading line-by-line 
     { 
         System.out.println(str);          
     } 
     pwrite.close(); socketRead.close(); br.close(); sock.close();
  }
}


