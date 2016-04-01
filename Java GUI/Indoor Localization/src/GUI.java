import java.awt.Color;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Arrays;
import javax.swing.*;

public class GUI extends JFrame{
	private static final long serialVersionUID = 1L;

	private int[] Count = new int[13];
	private int i,flag = 1;
	
	// Define components
	DrawLocation Draw = new DrawLocation();	// DrawLocation would create an object which is an area that could display shapes
	
	JButton switcher=new JButton("Start");

    Container container = this.getContentPane();
 
	public GUI(){
		// Set properties of window
		int width=1150,height=520;
		setSize(width,height);
		setTitle("Indoor Location Viewer");	
		Toolkit kit=Toolkit.getDefaultToolkit();
		Dimension screenSize=kit.getScreenSize();
		int x=(screenSize.width-width)/2;
		int y=(screenSize.height-height)/2;
		setLocation(x,y);
		
		setResizable(false);	// Disable the resizable feature of window
		setVisible(true);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);	// Make sure the program would exit completely after clicking the cross button
		
		container.setLayout(null);	// We do not use default layout so that component can be placed according to coordinates
        container.setBackground(Color.DARK_GRAY);
        
        // Set coordinates of components
        switcher.setBounds(320, 360, 230, 60);
		Draw.setBounds(0, 0, 1200, 360);
		
		// Add components to container
		container.add(switcher);
		container.add(Draw);

		// Add action listener to button
		switcher.addActionListener(new Switcher());
		
		for (i=0;i<13;i++) {
			Count[i]=0;
		}
		
		validate();
	}
	
	// Define what the switcher would trigger when clicked
	class Switcher implements ActionListener {
		public void actionPerformed(ActionEvent e){
            if (e.getActionCommand() == "Stop") {
                timer.stop();
                Draw.stop = 1;
                Draw.repaint();
                switcher.setText("Start");
            } else {
                timer.restart();
                Draw.stop = 2;
                Draw.repaint();
                switcher.setText("Stop");
            }
		}
	}
	
	// The content of timer would be executed every 500 millisecond
    final Timer timer = new Timer(2000, new ActionListener() {
        public void actionPerformed(ActionEvent e) {
            
            // Read area number from file "num.txt"
            BufferedReader br = null;
            String data = null;
			try {
				br = new BufferedReader(new FileReader("/Users/patrickpeng/Workspace_Java/position.txt"));
			} catch (FileNotFoundException e1) {
				e1.printStackTrace();
			}
			try {
				data = br.readLine();
			} catch (IOException e1) {
				e1.printStackTrace();
			}
			System.out.print(data+" ");
			
			int x = Integer.parseInt(data);
            Draw.num = x;
            
            // Record the time that the Target node spend on one area to an array
            Count[x-1]++;
            Draw.pcount=Arrays.copyOf(Count,Count.length);
            System.out.println(Count[x-1]+" ");
            
            // Variable "light" can make sure the flashing effect of each anchor node
            Draw.light = flag;
			Draw.repaint();
			flag++;
			
        }
    });
	
	@SuppressWarnings("unused")
	public static void main(String args[]){
		GUI window = new GUI();
	}
	
}
