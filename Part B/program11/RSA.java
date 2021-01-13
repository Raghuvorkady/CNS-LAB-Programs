import java.math.BigInteger;
import java.io.*;

public class RSA
{
	// BigInteger is used to store and manipulate very large numbers
	BigInteger p, q, d, e, n, z; 
	// p and q -> Large Prime Numbers
	// e -> Public Key
	// d -> Private Key
	BufferedReader keyin = new BufferedReader(new InputStreamReader(System.in));
	String msg, rmsg, code;
	// msg -> String to Encrypt
	//code -> Encrypted String
	// rmsg -> Decrypted String
	int size;
	//Size of the Message
	BigInteger m, c;
	// m and c -> used to store the ASCII values of individual characters in BigInteger format to encrypt or decrypt
	
	void read()throws IOException
	{
		System.out.println("Enter the large prime numbers(p and q: Such that p*q > 127):");
		p = new BigInteger(keyin.readLine()); // Read p
		q = new BigInteger(keyin.readLine()); // Read q
		n = p.multiply(q); // n = p*q
		z = (p.subtract(BigInteger.ONE)).multiply(q.subtract(BigInteger.ONE)); // z = (p-1)(q-1)
		System.out.println("Enter the public exponent (e):");
		e = new BigInteger(keyin.readLine()); // Read Public Key (e)
		d = new BigInteger("0"); // Set Private Key (d) to 0
		BigInteger temp;
		// do-while loop to generate private key (d) such that (e*d) mod z = 1
		do
		{
			d = d.add(BigInteger.ONE); // d++
			temp = (d.multiply(e)).mod(z); // computing (e*d) mod z 
		}while(!temp.equals(BigInteger.ONE)); // the value of d is accepted if temp==1 
		System.out.println("Enter Message to Encrypt:");
		msg = keyin.readLine();
		size = msg.length();
		code = "";
		rmsg = "";
	}
	void encrypt()
	{
		for(int i = 0; i < size; i++)
		{
			m = BigInteger.valueOf((int)msg.charAt(i)); //Copy each character of msg into m
			c = m.modPow(e, n); // Calculate c = (m^e) mod n
			code += (char)c.intValue(); // Add encrypted character into code
		}
	}
	void decrypt()
	{
		for(int i = 0; i < size; i++)
		{
			c = BigInteger.valueOf((int)code.charAt(i)); //Copy each character of code into c
			m = c.modPow(d, n); // Calculate m = (c^d) mod n
			rmsg += (char) m.intValue(); // Add decrypted character into message
		}
	}
	void show()
	{
		System.out.println("\nThe Message Entered at Sender's end is \"" + msg + "\"");
		System.out.println("The Encrypted Message sent to the Receiver is \"" + code + "\"");
		System.out.println("The Decrypted Message at Receiver's end is \"" + rmsg + "\"");
	}
	public static void main(String args[])throws IOException
	{
		RSA obj = new RSA();
		obj.read();
		obj.encrypt();
		obj.decrypt();
		obj.show();
	}
}