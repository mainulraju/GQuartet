<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@page import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@page import="com.google.appengine.api.datastore.*"%>
<%@page import="com.gquartet.data.*"%>
<%@page import="java.io.IOException"%>
<%@ include file="header.jsp"%>
<%
	String talkName = "";
	String resourceId = "";
	String talkKey = "";
	if ((request.getParameter("talkName"))!=null){
		talkName = request.getParameter("talkName");
		Talk t = GQDataStore.GetTalkByTalkName(talkName); 
		if(t!=null){
			resourceId = t.resourceId;
			talkKey = t.key;
		}else{
			out.println("<center>Talkname:"+talkName+"</center>");
		}
		
	}else{
		out.println("<center>Talkname:"+talkName+" was not provided</center>");
		response.setHeader("Refresh", "1; URL=../index.jsp");
	}
%>

<div class="content">
            <iframe id="slide" src="viewer/guestviewer.jsp?resourceId=<%=resourceId%>" frameborder="0" style="border: 0; width: 100%; height: 810px;"></iframe>   

	<!--row-->

<%@include file="footer.jsp"%>
