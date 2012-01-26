<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@page import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@page import="com.google.appengine.api.datastore.*"%>
<%@page import="com.gquartet.data.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.IOException"%>
<%@ include file="header.jsp"%>
<%@page import="java.util.logging.Logger"%>

<!-- GQu_005825 -->

<%
 Logger log = Logger.getLogger("guestbook.jsp"); 


String talkName = "";
String resourceId = "";
String talkKey = "";
long slideNo = 4;

//   log.warning("Req Parameter Talk Name" + request.getParameter("talkName"));
//   log.warning("Req Parameter Slide No" + request.getParameter("slideNo"));

// if ((request.getParameter("talkName"))!=null){
//   talkName = request.getParameter("talkName");
//   log.warning("Talk Name:" + talkName);

//   Talk t = GQDataStore.GetTalkByTalkName(talkName);
//   if(t!=null){
//     resourceId = t.resourceId;
//     talkKey = t.key;
//   }else{
//     out.println("<center>Talkname:"+talkName+"</center>");
//   }

// }else{
// 	response.setHeader("Refresh", "0; URL=../index.jsp");
//   }
// if((request.getParameter("slideNo"))!=null){
//     slideNo = Long.parseLong(request.getParameter("slideNo"));
//     }


resourceId = "presentation:0AVj9NqXvcoFzZGNnOTg2NzZfMTFkcjJrajZnYw";
talkKey= "agxncXVhcnRldGJldGFyCgsSBFRhbGsYZgw";


%>

<head>

   <title>Questions and Comments</title> 
     
        
    
  <link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css" rel="stylesheet" type="text/css"/>
  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.min.js"></script>
  <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>
 
  
  	<style type="text/css">

						
			.defaultIcon
			{
			background-image: url('images/QuestionIcon.png') !important;
			background-position:left top;
			width: 50px;
			height: 50px;
			}

			.selectedIcon
			{
			background-image: url('images/QuestionIcon.png') !important;
			background-position:left top;
			width: 50px;
			height: 50px;
			}

	</style>
  
  <script>
  
  
  
  
  
  $(document).ready(function() {
    $("#listofquestions").accordion();
    $("#listofquestions" ).accordion({ autoHeight: false });
    $("#listofquestions" ).accordion({ collapsible: true });
    $("#listofquestions" ).accordion({ autoHeight: false });
    $("#listofquestions" ).accordion("option", "icons",	{ 'header': 'defaultIcon', 'headerSelected': 'selectedIcon'});
    
     });
  
  </script>
  
 </head>
  
  

 <div class="topbar" data-dropdown="dropdown">
		<div class="topbar-inner">
			<div class="container-fluid">
				<a class="brand" href="index.jsp">Quartet</a>
				<ul class="nav">
					<li><a href="docs.jsp" target="_blank">Docs</a></li>
					<li><a href="contacts.jsp" target="_blank">Contact</a></li>
				</ul>
				<%@include file="search.jsp"%>
			</div>
		</div>
	</div>

 


<!--################### START OF BOTH LEFT AND RIGHT PART ############# -->
<div id="allcontent">


<!--################### START OF LEFT PART ############# -->

<div id="showslides" style="width:65%; height:880px; background-color:#ffffff; position:relative; 
            margin-top:5px; margin-left:5px; float:left; padding-left:5px; border:0px">
	
  <iframe id="slide" src="viewer/viewer.jsp?talkKey=<%=talkKey%>&resourceId=<%=resourceId%>&slideNo=<%=slideNo%>" 
  frameborder="5" width=100% height=100%>
  </iframe>
     
  </div> 
  
 <!--################### END OF LEFT PART ############# -->
  
  
  <!--################### START OF SCRIPT ############# -->
    <script type="text/javascript">
      $("#like").click(function(){
              console.log("like clicked");
              $.post("/updateutil", {"action":"updateLikes", "talkKey":"<%=talkKey%>", "SlideNo":<%=slideNo%>, "count":1 },function(data){
                console.log(data+<%=slideNo%>); 
                $("#like").removeClass("btn primary");
                $("#like").addClass("btn success disabled");  
                $("#dislike").addClass("btn danger disabled");  
            });

        });
        $("#dislike").click(function(){
              console.log("dislike clicked");
              $.post("/updateutil", {"action":"updateDislikes", "talkKey":"<%=talkKey%>", "SlideNo":<%=slideNo%>, "count":1 },function(data){
                console.log("Reutrned:"+data+":"+<%=slideNo%>);  
                $("#dislike").removeClass("btn primary");
                $("#like").addClass("btn success disabled");  
                $("#dislike").addClass("btn danger disabled");  
            });

        });


    		$("#fullscreen").toggle(function(){
      		$("#social").hide();
      		$("#slide").animate({"height":"+=185"},500);
      		},function(){
      		$("#social").show();
      		$("#slide").animate({"height":"-=185"},500);
    		});
    		
    		
    		


  	</script>

<!--################### END OF SCRIPT ############# -->


<!-- ############## START OF RIGHT PART ###################-->

<div id="QuestionsComments" style= "height:880px; width:34%; background-color:#ffffff; position:relative; margin-top:5px; 
             float:right;overflow:scroll;border: 3px solid #ddd;">

    	   	
                
         <div id="questbox">
          <h4>Ask, Share, Note with <em>others</em></h4>
        </div>
        <div id="postfeed" style="padding-bottom:10px;padding-top:10px">
          <form  id="question">
            <input type="hidden" name="rating" value=0 />
            <textarea rows="3" name="questionText" style="width:95%"></textarea>
            <input id="askquestion" type="submit" class="btn success" value="ASK">
          </form>
        </div>
        
                    
        
        
 <!-- ###################  START OF SCRIPT ###################-->
    <script >
        
	var pageNumber;

	$("#slide").load(function(){
		pageNumber = $("#slide").contents().find("#pageNumber").val();
	});
	function changedPage(){
		pageNumber =$("#slide").contents().find("#pageNumber").val();
    console.log("changedPage function was called and page was set to "+pageNumber);
    //$.post("guestbook.jsp", {"talkName":"<%=talkName%>","slideNo":pageNumber});
    window.location = "/guestbook.jsp?talkName=<%=talkName%>&slideNo="+pageNumber;
	}	


          $("#question").submit(function (event){
            event.preventDefault();
            var $form = $(this),
            questionText = $form.find('textarea[name="questionText"]').val(),
            url = '/updateutil';
            console.log("Question text is:"+questionText + "for slide no"+ <%=slideNo%>);


            $.post("/updateutil", {"action":"addQuestion", "parentKey":"<%=talkKey%>", "slideNo":<%=slideNo%>, "questionText":questionText, "rating":0 },function(data){
              console.log("Got back the response: "+data);
              var questiondata = data.split('|');
              var questionkey = questiondata[0];
              
              
              
                             
              var newquestionchild = "<div id=qbody style='font-size: 100%;' class='ui-accordion-header ui-helper-reset ui-state-default ui-corner-all' role='tab' aria-expanded='true' aria-selected='true' tabindex='0'>"
            	  				   + "<span class='ui-icon defaultIcon'></span>"
            	  				   + "<h3 style='padding-top:7px;padding-left:7px;'>"
          						   + "<a href='#'>" +questiondata[1]+"</a>"
          						   + "</h3>"
        					       + "</div>";
        					       
        					       
        					       <!-- ########COMMENT TEXT BOX ###########-->
        				        	       					        
        		 newquestionchild +="<div class='ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom ui-accordion-content-active' style='display: block; padding-top: 9px; padding-bottom: 9px; overflow-x: auto; overflow-y: auto;' role='tabpanel'>"
        			 			  + "<div id='commentList"+questionkey+"'  style='padding-left:25px; font-size: 115%;'>"
        		 				  + "</div>"
        			 			  + "<div style = 'padding-left:25px;'>"
        			              + "<form id='"+questionkey+"'>"
        			            		+ "<input type='hidden' name='parentKey' value='"+questionkey+"'>"
        			            		+ "<input type='hidden' name='rating' value='0'>"
        			            		+ "<textarea type='text' rows='3' name='commentText' style='width:95%;'></textarea>"
        			            		+ "<button class='btn success' onclick='submitComment(\""+questionkey+"\");return false'>Comment</button>"
        			          	  + "</form>"
        			        	  + "</div>"
        			        	  + "</div>";
        			        		<!-- ########END OF COMMENT TEXT BOX ###########-->
        			        		
        			        		
              console.log(newquestionchild);
              
              $("#listofquestions").last().append(newquestionchild);
              $("#listofquestions").accordion();
              
              $form.find('textarea[name="questionText"]').val('');
              

            });
          });
   </script>
   
   <!-- ###################  END OF SCRIPT ###################-->

        <% 
          log.warning("Slide No before calling data store " + slideNo );
          //slideNo = 5;
          Slide slide = GQDataStore.GetSlideQuestionsAndComments(talkKey, slideNo);
          List<Question> questions  = slide.questions;

          log.warning("No of questions = " + questions.size() );
          
        %>      

	
<!-- START OD JQUERY ACCORDION DIVISION -->

       <div id="listofquestions">	
				            
		<%
        for ( Question q : questions ){
          	String QPlusSign=" +";
        %>
        
        <div id=qbody style="font-size: 100%;">
                 <h3 style="padding-top:7px;padding-left:7px;">
  					  <a href="#"><%=q.questionText %></a>
          		</h3>
        </div>
        
        
           
<!-- ############### EXPANSION ####################### -->
 <!-- THIS PORTION GOES UNDER EACH QUESTION WHEN IT ISEXPANDED -->
           <div>
           
          		
          		<div id="commentList<%=q.key%>"  style="padding-left:25px; font-size: 115%;">
          		
          		<%
	          		List<Comment> comments  = q.comments;
          			for ( Comment c : comments ){
            				String plussign=" +";
	       		%>

						<div >
              			<%=c.commentText%>
              			<br>
            			<img src="http://wewillraakyou.com/wp-content/uploads/2011/06/google-plus1.png" height=20 width=25>
          				&nbsp;<%=c.rating%>
          				<hr>												
        	  		   </div>
         	 	       
	        	<%} %>
	        	 </div>
	        	
	        	<!-- ########COMMENT TEXT BOX ###########-->
	        	<div style = "padding-left:25px;">
           		 
          		<form id="<%=q.key%>">
            			<input type="hidden" name="parentKey" value="<%=q.key %>"/>
            			<input type="hidden" name="rating" value="0">
            			<textarea type="text" rows="3" name="commentText" style="width:95%;"></textarea>
            			<button class="btn success" onClick='submitComment("<%=q.key%>");return false'>Comment</button>
          		</form>
        		</div>
        		<!-- ########END OF COMMENT TEXT BOX ###########-->
        	
        	</div>
<!-- ####################END OF EXPANSION ########################### -->
    
    	<%}%>
	</div>
<!-- ###########END OF ALL QUESTIONS, END OF DIV ID = listofquestions ########## -->
	
	
	
</div>  
<!--########## END OF RIGHT AREA, END OF DIV ID = QuestionsComments############-->
    	




<!--########## SCRIPT FOR SUBMITTING COMMENT ############-->
	 
	<script >
  		function submitComment(questionKey){
   			 	var $form = $('#'+questionKey);
          		var  questionText = $form.find('textarea[name="commentText"]').val();
            		console.log("Comment text is:"+questionText);

                $.post("/updateutil", {"action":"addComment", "parentKey":questionKey, "commentText":questionText, "rating":0 },function(data){
                  var datasplit = data.split('|');
                  //var imageurl = "<img src='http://wewillraakyou.com/wp-content/uploads/2011/06/google-plus1.png' height=15 width=20>";
                  var imageurl = "<img src='http://wewillraakyou.com/wp-content/uploads/2011/06/google-plus1.png' height=20 width=25>";
                  var newchild = "<div>"+datasplit[1]+"\n<br>\n"+imageurl+"&nbsp;"+ datasplit[2]+"\n<hr>\n</div>" 
                  
                  $("#commentList"+questionKey).last().append(newchild);
                  $form.find('textarea[name="commentText"]').val('');
           		});
  			return false;
  		}
	</script>
	
		
<!--########## END OF SCRIPT ############-->



	
	
<!--####### START OF FEEDBACK BUTTON DIVISION######### -->	
<center> 	
<div id="feedback" style="padding-left:10px;">
    <a id="like" class="btn primary">Got it!</a>
    <!-- button id="fullscreen" class="btn primary">Fullscreen</button> -->
    <a id="dislike" class="btn primary">   Oops!   </a>
    
    
	<button id=showhidequestionsButton class="btn primary" style="float:right;">>></button>
	<button id=showhideslidesButton class="btn primary" style="float:right;"><<</button>

</div>
</center>
<!--####### END OF FEEDBACK BUTTON DIVISION ######### -->


  
</div>
<!--####### END OF BOTH LEFT AND RIGHT SECTION, DIVISION ID = allcontents ######### -->




<script>

//##################------START OF showhidequestionsButton----######################//

$("#showhidequestionsButton").toggle(function(){
    	
				$("#like").hide();
				$("#dislike").hide();
				$("#footer").hide();
				$("#showhidequestionsButton").hide();
				$("#showhideslidesButton").hide();
				
				$("#QuestionsComments").hide();
				
				$('#showslides').animate({"width": "99%"},800, function(){
          			$("#like").show();
    				$("#dislike").show();
    				$("#footer").show();
    				$("#showhidequestionsButton").html('<<');
    				$("#showhidequestionsButton").show();
          			
          		});
          		
          		
              		},function(){
              	$("#like").hide();
        		$("#dislike").hide();
        		$("#footer").hide();
        		$("#showhidequestionsButton").hide();
        		$("#showhideslidesButton").hide();
        		
          		$('#showslides').animate({"width": "65%"}, 800, function(){
          		
          		$("#QuestionsComments").show();
              	
          		$("#like").show();
    			$("#dislike").show();
    			$("#footer").show();
    			$("#showhidequestionsButton").html('>>');
    			$("#showhidequestionsButton").show();
    			$("#showhideslidesButton").css({ 'float': 'right'});    			
    			$("#showhideslidesButton").html('<<');
    			$("#showhideslidesButton").show();
          		});
          		
          		});
                		
//##################------END OF showhidequestionsButton----######################//            		
                		
//##################------START OF showhideslidesButton----######################//

$("#showhideslidesButton").toggle(function(){
    	
				$("#like").hide();
				$("#dislike").hide();
				$("#footer").hide();
				$("#showslides").hide();
				
				$("#showhideslidesButton").hide();				
				$("#showhidequestionsButton").hide();
						
				
          		$('#QuestionsComments').animate({"width": "99%"},500, function(){
          			
    				$("#footer").show();
    				$("#showhideslidesButton").html('>>');
    				$("#showhideslidesButton").css({ 'float': 'left'});
    				$("#showhideslidesButton").show();
    				
    			
          			
          		});
          		
          		
              		},function(){
              		$("#like").hide();
        			$("#dislike").hide();
        			$("#footer").hide();
        			$("#showhidequestionsButton").hide();
        			$("#showhideslidesButton").hide();
        			
        			$('#QuestionsComments').animate({"width": "34%"}, 500, function(){
        			$("#showslides").show();     		
              		$("#like").show();
    				$("#dislike").show();
    				$("#footer").show();
    				$("#showhidequestionsButton").html('>>');
    				$("#showhidequestionsButton").show();
    				$("#showhideslidesButton").css({ 'float': 'right'});
    				$("#showhideslidesButton").html('<<');
    				$("#showhideslidesButton").show();
          		});
          		
          		});



//##################------END OF showhideslidesButton----######################//
                		
                		

</script>
      <!--row-->
<div id="footer">
<%@include file="footer.jsp"%>
</div>
