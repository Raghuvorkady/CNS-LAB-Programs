//Program 8

import java.util.Scanner;

public class BellmanFord
{
	int d[], a[][]; 
	int n, start;
	final int max = 999;
	
	public void read()
	{
		Scanner scan = new Scanner(System.in);
		
		System.out.println("Enter the number of vertices");
		n = scan.nextInt();
		d = new int[n+1];
		a = new int[n + 1][n + 1];
		
		System.out.println("Enter the adjacency matrix: (Enter -- for Infinity)");
		for (int i = 1; i <= n; i++)
		{
			for (int j = 1; j <= n; j++)
			{
				String str = scan.next();
				if(str.equals("--"))
					a[i][j] = max;
				else a[i][j] = Integer.parseInt(str);
			}
		}
		
		System.out.println("Enter the start vertex");
		start = scan.nextInt();

		if(start > n || start < 1)
		{
			System.out.println("Invalid start vertex.");
			System.exit(0);
		}
		scan.close();
	}
	
	public void calculate()
	{
		for (int i = 1; i <= n; i++)
			d[i] = max;
		d[start] = 0;
		
		for (int k = 1; k <= n - 1; k++)
			for (int i = 1; i <= n; i++)
				for (int j = 1; j <= n; j++)
					if(a[i][j] != max)
						if(d[j] > d[i]  + a[i][j])
							d[j] = d[i] + a[i][j];
	}
	
	public void display()
	{
		for (int i = 1; i <= n; i++)
        {
			for (int j = 1; j <= n; j++)
			{
				if (a[i][j] != max && d[j] > d[i]+ a[i][j])
				{
					System.out.println("The Graph contains negative edge cycle");
					return;
				}
			}
		}
		System.out.println("Distance from Source Vertex " + start + " to:");
		for (int i = 1; i <= n; i++)
			System.out.println("Vertex "+ i + " is " + d[i]);
	}
	
	public static void main(String args[])
	{
		BellmanFord obj = new BellmanFord();
		obj.read();
		obj.calculate();
		obj.display();
	}
}