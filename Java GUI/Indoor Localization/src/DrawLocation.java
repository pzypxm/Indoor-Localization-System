import java.applet.Applet;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;

public class DrawLocation extends Applet{	
	private static final long serialVersionUID = 1L;

	public int num,light,stop;
	public int[] pcount = {1,1,1,1,1,1,1,1,1,1,1,1,1};
	
	private int arcx,arcy,arcd,i,j,k,sum,last,anglesum,checkempty;

	// Set background color of graphic area
	public DrawLocation (){
		setBackground(Color.DARK_GRAY);
	}
		
	public void paint (Graphics g){
		super.paint(g);	
		
		Font f1 = new Font ("Arial",Font.BOLD,19);
		g.setColor(Color.ORANGE);
		g.setFont(f1);
		g.drawString("The highlighted area indicates location of target node in corridor:", 30, 50);
		
		// Display all 13 areas
		Font f2 = new Font ("Arial",Font.BOLD,12);
		for (i=0;i<13;i++){
			g.setColor(Color.GRAY);
			g.fillRect(50 + i*60, 100, 50, 150);
			g.setColor(Color.ORANGE);
			g.setFont(f2);
			g.drawString("Area", 60 + i*60, 165);
			if (i<4)
				g.drawString(""+(13-i), 66 + i*60, 180);
			else
				g.drawString("0"+(13-i), 66 + i*60, 180);
		}
		
		// Display location of all 5 anchor nodes
		Font f3 = new Font ("Arial",Font.BOLD,13);
		for (i=0;i<5;i++){
			if (light % 2 == 1)
				g.setColor(Color.MAGENTA);
			else
				g.setColor(Color.RED);
			g.fillRect(70 + i*180, 88, 10, 10);
			g.setColor(Color.ORANGE);
			g.setFont(f3);
			g.drawString("L"+(6-i), 67 + i*180, 82);
		}	
		g.drawString("|----------------------------------------------------------------------------------------     13m     ---------------------------------------------------------------------------------------|", 49, 280);
		
		// Change the output display after retrieving the number of area
		if (num >=1 && num <=13){
			g.setColor(Color.YELLOW);
			g.fillRect(50 + (13-num)*60, 100, 50, 150);
			
			g.setColor(Color.DARK_GRAY);
			g.setFont(f2);
			g.drawString("Area", 60 + (13-num)*60, 165);
			if (num>=10)
				g.drawString(""+num, 66 + (13-num)*60, 180);
			else
				g.drawString("0"+num, 66 + (13-num)*60, 180);
		}
		
		// Reset the draw area to its initial condition
		if (stop == 1){
			for (i=0;i<13;i++){
				g.setColor(Color.GRAY);
				g.fillRect(50 + i*60, 100, 50, 150);
				g.setColor(Color.ORANGE);
				g.setFont(f2);
				g.drawString("Area", 60 + i*60, 165);
				if (i<4)
					g.drawString(""+(13-i), 66 + i*60, 180);
				else
					g.drawString("0"+(13-i), 66 + i*60, 180);
			}
			for (i=0;i<5;i++){
				g.setColor(Color.RED);
				g.fillRect(70 + i*180, 88, 10, 10);
				g.setColor(Color.ORANGE);
				g.setFont(f3);
				g.drawString("L"+(6-i), 67 + i*180, 82);
			}
		}
		
		// Draw pie chart
		arcx = 905; arcy = 90; arcd = 170; sum=0; last=0; anglesum=0; checkempty=0;
		for (i=0;i<13;i++) {
			sum+=pcount[i];
		}
		for (i=0;i<13;i++) {
			anglesum += (int)(360*((float)pcount[i]/sum));
		}
		for (i=0;i<13;i++) {
			if (i==0) {
				g.setColor(Color.getHSBColor((float)i*25/360, (float)0.8, (float)0.8));
				g.fillArc(arcx, arcy, arcd, arcd, 0, (int)(360*((float)pcount[i]/sum)));
				last = (int)(360*((float)pcount[i]/sum));
			}
			else {
				g.setColor(Color.getHSBColor((float)i*25/360, (float)0.8, (float)0.8));
				for (j=i+1;j<13;j++)
					if (pcount[j]>checkempty) // Check if this arc is the last one that need to draw
						checkempty = pcount[j];
				if (checkempty == 0) {
					// Eliminate empty area of circle caused by accumulated rounding error
					g.fillArc(arcx, arcy, arcd, arcd, last, (int)(360*((float)pcount[i]/sum))+360-anglesum);
					break;
				}
				else
					g.fillArc(arcx, arcy, arcd, arcd, last, (int)(360*((float)pcount[i]/sum)));
				last += (int)(360*((float)pcount[i]/sum));
				checkempty=0;
			}
		}
		
		// Draw legend for pie chart
		g.setColor(Color.ORANGE);
		g.setFont(f1);
		g.drawString("Time spent on one place:",840,50);
		g.setFont(f2);
		j=0; k=1;
		for (i=0;i<13;i++) {
			if (j==4) {
				j=0; k++;
			}
			g.setColor(Color.getHSBColor((float)i*25/360, (float)0.8, (float)0.8));
			g.fillRect(880+60*j, 270+20*k, 20, 10);
			g.setColor(Color.ORANGE);
			g.drawString("P"+(i+1), 908+60*j, 280+20*k);
			j++;
		}
	}
}