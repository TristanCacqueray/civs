package servlet;

/**
 * A Page is an entire HTML page.
 * @author andru
 */
public class Page extends Node {
	Head head;
	Body body;
	
	public Page(Head h, Body b) {
	  head = h;
	  body = b;
	}

	public void write(HTMLWriter p) {
	  p.print("<html>");
	  p.begin();
	  p.indent(1);
	  p.breakLine();
	  head.write(p);
	  body.write(p);
	  p.end();
	  p.print("</html>");		
	  p.breakLine();
	}
}
