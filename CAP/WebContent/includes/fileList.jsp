<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.io.File,java.io.IOException,java.util.List,org.apache.commons.io.FileUtils"%>

	<%
	
		HttpSession ses = request.getSession(true);

		java.io.File file;
		String dir = "levels/*";
		File jsp = new File(request.getRealPath(dir));
		File directory = jsp.getParentFile();
		File[] list = directory.listFiles();
		
		 for (int i = list.length-1; i >=0 ; i--) 
		 {
		     file = list[i];
		      
		     %><table style="width:700px">
		      <col width="120">
  			  <col width="180">
  			  <col width="180">
  			  <col width="120">
  		     <%
		      
		     if (file.isFile())
		     {
		    	 String hold = dir.substring(0,dir.length()-8);
		    	 String context = request.getContextPath();
		    	 System.out.print("Context:" +context);
		       %>
		        
		        <tr><td> <a href="<%=context%>/levels/<%=/*file.getName()*/%>" target="_blank"><%= /*file.getName()*/%></a></td></tr>
		       <%
		          System.out.println(file.getName());
		     }
		     %>
		     </table>
		     <%  
		 }
	 %>