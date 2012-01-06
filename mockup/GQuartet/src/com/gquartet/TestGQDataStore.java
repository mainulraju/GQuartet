package com.gquartet;

import java.util.Date;
import java.util.Map;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.*;
import com.gquartet.data.*;


import java.io.IOException;
import javax.servlet.http.*;
import java.util.logging.Logger;
import java.util.*;


@SuppressWarnings("serial")
public class TestGQDataStore extends HttpServlet {

  static final Logger log = Logger.getLogger(TestGQDataStore.class.getName()); 

	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {

      
      log.warning(req.getParameter("action"));
      String action = req.getParameter("action");

      StringBuilder data = new StringBuilder();
    
      if ( "addnewtalk".equals(action) )
       {

        data.append(action).append(" performed \n " );
        data.append ( GQDataStore.AddNewTalk("presentation:0AYyutri7KO7bZDlycjRyY18wZGo5cWd6OHA"
                , new Date() 
                , (String)req.getParameter("talkname") ) );
 
      }


           if ( "addSlide".equals(action) )
     {
       log.warning("___Parent key for Slide is___" + req.getParameter("parentKey") );
       String key  = GQDataStore.AddSlide((String)req.getParameter("parentKey"), Integer.parseInt(req.getParameter("slideNo")));
       data.append("Slide Key ").append(key).append("\n");
     }

     if ( "addQuestion".equals(action) )
     {
       String key  = GQDataStore.AddQuestion((String)req.getParameter("parentKey"), (String)req.getParameter("questionText"), Integer.parseInt(req.getParameter("rating")));
       data.append("Question Key ").append(key).append("\n");
     }

    if ( "addFeed".equals(action) )
     {
       String key  = GQDataStore.AddFeed((String)req.getParameter("parentKey"), (String)req.getParameter("feedText"), Integer.parseInt(req.getParameter("rating")));
       data.append("Feed Key ").append(key).append("\n");
     }

  if ( "addComment".equals(action) )
       {
         String key  = GQDataStore.AddComment((String)req.getParameter("parentKey"), (String)req.getParameter("commentText"), Integer.parseInt(req.getParameter("rating")));
         data.append("Comment Key ").append(key).append("\n");
       }

     if ( "getSlideContent".equals(action) )
     {
       Slide s = GQDataStore.GetSlideQuestionsAndComments(req.getParameter("parentKey"), Integer.parseInt(req.getParameter("slideNo")));

       data.append(s.toString());
     }

     if ( "updateActiveSlide".equals(action) )
     {
        long slideNo = Long.parseLong(req.getParameter("slideNo"));
        String key = req.getParameter("talkKey");
        GQDataStore.UpdateActiveSlideNo(key, slideNo);

        data.append("Talk has been updated with active slide");
     }

     if ( "updateQuestionRating".equals(action) )
     {
        long rating = Long.parseLong(req.getParameter("rating"));
        String key = req.getParameter("questionKey");
        GQDataStore.UpdateQuestionRating(key, rating);

        data.append("Question has been updated with new rating");
     }

     if ( "updateFeedRating".equals(action) )
     {
        long rating = Long.parseLong(req.getParameter("rating"));
        String key = req.getParameter("feedKey");
        GQDataStore.UpdateQuestionRating(key, rating);

        data.append("Feed has been updated with new rating");
     }
 
 
      if ( "updateCommentRating".equals(action) )
     {
        long rating = Long.parseLong(req.getParameter("rating"));
        String key = req.getParameter("commentKey");
        GQDataStore.UpdateCommentRating(key, rating);

        data.append("Question has been updated with new rating");
     }


     //search based queries
     if ( "getTalkByTalkName".equals(action) )
     {
          Talk t  = GQDataStore.GetTalkByTalkName((String)req.getParameter("talkname"));
          if ( t != null )
            data.append(t.talkName).append(" ").append(t.resourceId).append(" ").append(t.dateTime).append("\n"); 
          else
            data.append("no talk entity with the name " + (String)req.getParameter("talkname"));
     }
    
     if ( "searchCourse".equals(action) )
     {
       log.warning("Search fot text === "  + req.getParameter("searchText") );
       List<SearchResult>  l = GQDataStore.SearchText(req.getParameter("searchText"));
      
       for ( SearchResult r : l )
       {
         data.append(r.talkKey).append(", ").append(r.talkName).append(", ").append(r.slideNo).append(", ").append(r.text).append("\n");
       }

     }

    resp.setContentType("text/plain");
		resp.getWriter().println("Hello, world");
    resp.getWriter().println(data.toString());



  }
 


	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
   
    
    resp.setContentType("text/plain");
		resp.getWriter().println("Hello, world");

	}
}



/*  Reference 
if ( "getTalks".equals(action) )
      {

        Map<String, Talk>  list = GQDataStore.GetTalks();
        for ( Map.Entry<String,Talk> entry : list.entrySet() )
        {
          Talk t = entry.getValue();
          log.warning("Talk Name :"  + t.talkName );
          data.append(t.talkName).append(" ").append(t.resourceId).append(" ").append(t.dateTime).append("\n");
        }
      }

     if ( "getTalkByTalkName".equals(action) )
     {
          Talk t  = GQDataStore.GetTalkByTalkName((String)req.getParameter("talkname"));
          if ( t != null )
            data.append(t.talkName).append(" ").append(t.resourceId).append(" ").append(t.dateTime).append("\n"); 
          else
            data.append("no talk entity with the name " + (String)req.getParameter("talkname"));
     }


      if ( "getTalkByKey".equals(action) )
     {
          Talk t  = GQDataStore.GetTalkByKey((String)req.getParameter("key"));
          if ( t != null )
            data.append(t.talkName).append(" ").append(t.resourceId).append(" ").append(t.dateTime).append("\n"); 
          else
            data.append("no talk entity with the name " + (String)req.getParameter("talkname"));
     }

 if ( "getTalkContent".equals(action) )
     {
       List<Entity> results = GQDataStore.GetTalkContent(req.getParameter("parentKey"));

       for ( Entity e : results )
       {
         data.append(e.getKey().toString()).append(" ").append(e.getKey().getId()).append("\n");

         if ( e.getKind().equals("Slide") )
           data.append( Slide.GetSlide(e).toString());
       }
     }


*/


