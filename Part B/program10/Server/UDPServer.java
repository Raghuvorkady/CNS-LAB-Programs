import java.io.*; import java.net.*; import java.util.Scanner;
class UDPServer
{
   public static void main(String args[]) throws Exception
      {
         DatagramSocket serverSocket = new DatagramSocket(9876);
         System.out.println("Server Started on Port 9876");
            byte[] receiveData = new byte[1024];
            byte[] sendData = new byte[1024];
            while(true)
               {
                  DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
                  serverSocket.receive(receivePacket);
                  receivePacket.getData();
                  InetAddress IPAddress = receivePacket.getAddress();
                  int port = receivePacket.getPort();
                  System.out.println("Client Connected");
                  Scanner input = new Scanner(System.in);
                  System.out.println("Enter the message to be sent: ");
                  String message = input.nextLine();
                  sendData = message.getBytes();
                  DatagramPacket sendPacket = new DatagramPacket(sendData, sendData.length, IPAddress, port);
                  serverSocket.send(sendPacket);
                  System.exit(0);
               } } }
