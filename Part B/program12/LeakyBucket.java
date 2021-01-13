import java.util.Scanner;

public class LeakyBucket {
    int I, B, N;
    int[] dt;
    int t, p, bs;
    boolean inCtrl = true;
    boolean outCtrl = true;

    void read() {
        Scanner scanner = new Scanner(System.in);
        System.out.println("Enter the value of I (size of packet in bytes)");
        I = scanner.nextInt();
        System.out.println("Enter the Bucket Size");
        B = scanner.nextInt();
        System.out.println("Enter number of packets of size I to transfer");
        N = scanner.nextInt();
        dt = new int[N];
        System.out.println("Enter the arrival time (in seconds) for all to packets in ascending order");
        for (int i = 0; i < N; i++)
            dt[i] = scanner.nextInt();
        p = bs = 0;
        t = 0;
        scanner.close();
    }

    void insert() {
        if (p < N) {
            if (dt[p] == t) {
                if (bs + I <= B) {
                    bs += I;
                    System.out.println("Packet received at t = " + t + ". " + bs + " Bytes still left in Bucket");
                } else
                    System.out.println("Bucket overflow. Packet Lost at t = " + t);
                p++;
            }
            t++;
        } else
            inCtrl = false;
    }

    void delete() {
        if (bs > 0) {
            bs--;
            System.out.println("1 Byte Leaked.\t\t " + bs + " Bytes still left in Bucket");
        } else {
            System.out.println("Bucket is Empty. Waiting for Incoming Packets");
        }
        if (p == N && bs == 0)
            outCtrl = false;
    }

    public static void main(String[] args) {
        LeakyBucket leakyBucket = new LeakyBucket();
        leakyBucket.read();
        InsertThread insThread = new InsertThread(leakyBucket); //Call insert thread
        DeleteThread delThread = new DeleteThread(leakyBucket); //Call delete thread
    }
}

class InsertThread implements Runnable {
    LeakyBucket bkt1;

    public InsertThread(LeakyBucket bkt) {
        bkt1 = bkt;
        Thread insertThread = new Thread(this);
        insertThread.start();
    }

    public void run() {
        try {
            while (bkt1.inCtrl) {
                bkt1.insert();
                Thread.sleep(1000);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

class DeleteThread implements Runnable {
    LeakyBucket bkt1; //bkt1 is an instance of Bucket class

    public DeleteThread(LeakyBucket bkt) {
        this.bkt1 = bkt; //create a reference
        Thread deleteThread = new Thread(this);
        deleteThread.start();
    }

    public void run() {
        try {
            while (bkt1.outCtrl) {
                bkt1.delete();
                Thread.sleep(1000);
            }
            System.out.println("\nAll Packets Have Been Sent");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}