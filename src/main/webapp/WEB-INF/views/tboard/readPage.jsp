<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>   
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html>
<head>
<title>readPage.jsp</title>
   <script type="text/javascript" src="/resources/js/upload.js"></script>
   <script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.1/handlebars.js"></script>
   <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />   
   <link href="/resources/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />   
      
   <!-- Main content -->
   <style type="text/css">
   .popup {
      position: absolute;
   }
   
   .back {
      background-color: gray;
      opacity: 0.5;
      width: 100%;
      height: 300%;
      overflow: hidden;
      z-index: 1101;
   }
   
   .front {
      z-index: 1110;
      opacity: 1;
      boarder: 1px;
      margin: auto;
   }
   
   .show {
      position: relative;
      max-width: 1200px;
      max-height: 800px;
      overflow: auto;
   }
   </style>
</head>
<body>
    <div class='popup back' style="display:none;"></div>
    <div id="popup_front" class='popup front' style="display:none;">
     <img id="popup_img">
    </div>

   <div class="row">
      <!-- left column -->
      <div class="col-md-6">
         <!-- general form elements -->
         <div class="box box-primary">
            <div class="box-header">
               <h3 class="box-title">영화 게시판</h3>
            </div>
            <!-- /.box-header -->

            <form role="form" action="modifyPage" method="post">
			   <input type='hidden' name='board_id' value="${cri.board_id}">
               <input type='hidden' name='bno' value="${boardVO_BSR.bno}"> <input
                  type='hidden' name='page' value="${cri.page}"> <input
                  type='hidden' name='perPageNum' value="${cri.perPageNum}">
               <input type='hidden' name='searchType' value="${cri.searchType}">
               <input type='hidden' name='keyword' value="${cri.keyword}">

            </form>

            <div class="box-body">
               <div class="form-group">
               
<!--                <input type="text" -->
<%--                      name='board_id' class="form-control" value="${cri.board_id}" --%>
<!--                      readonly="readonly"> -->
               
                  <label for="exampleInputEmail1">Title</label> <input type="text"
                     name='title' class="form-control" value="${boardVO_BSR.title}"
                     readonly="readonly">
               </div>
               <div class="form-group">
                  <label for="exampleInputPassword1">Content</label>
                  <textarea class="form-control" name="content" rows="3"
                     readonly="readonly">${boardVO_BSR.content} </textarea>
               </div>
               <div class="form-group">
                  <label for="exampleInputEmail1">Writer</label> <input type="text"
                     name="writer" class="form-control" value="${boardVO_BSR.writer}"
                     readonly="readonly">
               </div>
               
               
            </div>
            <!-- /.box-body -->
   
            <div class="box-footer">

               <div>
                  <hr>
               </div>

               <ul class="mailbox-attachments clearfix uploadedList">
               </ul>
               

               <c:if test="${login.uname == boardVO_BSR.writer||login.uname == 'ADMINISTRATOR'}">
                  <button type="submit" class="btn btn-warning" id="modifyBtn">Modify</button>
                  <button type="submit" class="btn btn-danger" id="removeBtn">REMOVE</button>
               </c:if>
               <button type="submit" class="btn btn-primary" id="goListBtn">GO
                  LIST</button>
            </div>
		


         </div>
         <!-- /.box -->
      </div>
      <!--/.col (left) -->
      <div class="col-md-6" >
          <div id="xxxyyy">	<!-- Image List -->  </div>
      </div>
      
   </div>
   <!-- /.row -->

	<!-- 댓글추가 부분 -->
   <div class="row">
      <div class="col-md-12">

         <div class="box box-success">
            <div class="box-header">
               <h3 class="box-title">ADD NEW REPLY</h3>
            </div>


			<!-- 로그인 상태 -->
            <c:if test="${not empty login}">
               <div class="box-body">
                  <label for="exampleInputEmail1">Writer</label> 
                  <input class="form-control" type="text" placeholder="USER ID"
                         id="newReplyWriter" value="${login.uname}" readonly="readonly">
                  <label for="exampleInputEmail1">Reply Text</label> 
                  <input class="form-control" type="text" placeholder="REPLY TEXT" id="newReplyText">
               </div>

               <div class="box-footer">
                  <button type="submit" class="btn btn-primary" id="replyAddBtn">
                  ADD REPLY
                  </button>
               </div>
            </c:if>
			
			<!--  로그아웃 상태 -->
            <c:if test="${empty login}">
               <div class="box-body">
                  <div>
                     <a href="javascript:goLogin();">Login Please</a>
                  </div>
               </div>
            </c:if>
         </div>



         <!-- The time line -->
         <ul class="timeline">
            <!-- timeline time label -->
            <li class="time-label" id="repliesDiv"><span class="bg-green">
                  Replies List <small id='replycntSmall'> [
                     ${boardVO_BSR.replycnt} ] </small>
            </span></li>
         </ul>
         <div class='text-center'>
            <ul id="pagination" class="pagination pagination-sm no-margin ">

            </ul>
         </div>

      </div>
      <!-- /.col -->
   </div>
   <!-- /.row -->


   <!-- Modal -->
   <div id="modifyModal" class="modal modal-primary fade" role="dialog">
      <div class="modal-dialog">
         <!-- Modal content-->
         <div class="modal-content">
            <div class="modal-header">
               <button type="button" class="close" data-dismiss="modal">&times;</button>
               <h4 class="modal-title">댓글 수정 및 삭제</h4>
            </div>
            <div class="modal-body" data-rno>
               <p>
                  <input type="text" id="replytext" class="form-control">
               </p>
            </div>
            <div class="modal-footer">
               <button type="button" class="btn btn-info" id="replyModBtn">Modify</button>
               <button type="button" class="btn btn-danger" id="replyDelBtn">DELETE</button>
               <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
         </div>
      </div>
   </div>
   
   


<script id="templateAttach" type="text/x-handlebars-template">
      <li data-src='{{fullName}}'>
           <span class="mailbox-attachment-icon has-img">
			
            <a href="{{getLink}}"><img src="{{imgsrc}}" alt="Attachment"></a>
         </span>
         <div class="mailbox-attachment-info">
              <a href="{{getLink}}" class="mailbox-attachment-name">{{fileName}}</a>
            </span>
          </div>
      </li>                
   </script>  
<!-- 20160921 첨부된 파일 이미지를 썸네일 제공해준다?????-->

   <script id="template" type="text/x-handlebars-template">
            {{#each .}}
                  <li class="replyLi" data-rno={{rno}}>
                            <i class="fa fa-diamond bg-blue"></i>
                        <div class="timeline-item" >
                           <span class="time">
                                <i class="fa fa-clock-o"></i>{{prettifyDate regdate}}
                            </span>
                           <h3 class="timeline-header"><strong>{{rno}}</strong> -{{replyer}}</h3>
                            <div class="timeline-body">{{replytext}} </div>
                      <div class="timeline-footer">
                        {{#eqReplyer replyer }}
                                 <a class="btn btn-primary btn-xs" data-toggle="modal" data-target="#modifyModal">Modify</a>
                        {{/eqReplyer}} 
                      </div>
                        </div>         
                       </li>
                 {{/each}}
   </script>  

<script>

   
   Handlebars.registerHelper("eqReplyer", function(replyer, block) {
      var accum = '';
      if (replyer == '${login.uname}') {
         accum += block.fn();
      }
      return accum;
   });

   Handlebars.registerHelper("prettifyDate", function(timeValue) {
      var dateObj = new Date(timeValue);
      var year = dateObj.getFullYear();
      var month = dateObj.getMonth() + 1;
      var date = dateObj.getDate();
      return year + "/" + month + "/" + date;
   });

   var printData = function(replyArr, target, templateObject) {

      var template = Handlebars.compile(templateObject.html());

      var html = template(replyArr);
      $(".replyLi").remove();
      target.after(html); // 댓글 관련 출력

   }

   var bno = ${boardVO_BSR.bno};//Board Number

   var replyPage = 1;

   function getPage(pageInfo) {

      $.getJSON(pageInfo, function(data) {
         printData(data.list, $("#repliesDiv"), $('#template'));
         printPaging(data.pageMaker, $(".pagination"));

         $("#modifyModal").modal('hide');
         $("#replycntSmall").html("[ " + data.pageMaker.totalCount + " ]");

      });
   }

   var printPaging = function(pageMaker, target) {

      var str = "";

      if (pageMaker.prev) {
         str += "<li><a href='" + (pageMaker.startPage - 1)
               + "'> << </a></li>";
      }

      for (var i = pageMaker.startPage, len = pageMaker.endPage; i <= len; i++) {
         var strClass = pageMaker.cri.page == i ? 'class=active' : '';
         str += "<li "+strClass+"><a href='"+i+"'>" + i + "</a></li>";
      }

      if (pageMaker.next) {
         str += "<li><a href='" + (pageMaker.endPage + 1)
               + "'> >> </a></li>";
      }

      target.html(str);
   }; // 서버상에서 만들어지는것이 아니라 javaScript 로 만드는것

   var clicked = true;
   $("#repliesDiv").on("click", function() {
		if (clicked==true) {
			getPage("/replies_BSR/" + bno + "/1");
			clicked = false;
			return;
		}if(clicked==false){
			$(".replyLi").remove();
			clicked = true;
			return;
		}
	});
   $(".pagination").on("click", "li a", function(event) {
      alert("pagination clicked........" + replyPage);
      
      event.preventDefault();

      replyPage = $(this).attr("href");

      getPage("/replies_BSR/" + bno + "/" + replyPage);

   });

   $("#replyAddBtn").on("click", function() {
//       alert("replyAddBtn clicked........");
      
      var replyerObj = $("#newReplyWriter");
      var replytextObj = $("#newReplyText");
      var replyer = replyerObj.val();
      var replytext = replytextObj.val();

      $.ajax({
         type : 'post',
         url : '/replies_BSR/',
         headers : {
            "Content-Type" : "application/json",
            "X-HTTP-Method-Override" : "POST"
         },
         dataType : 'text',
         data : JSON.stringify({
            bno : bno,
            replyer : replyer,
            replytext : replytext
         }),
         success : function(result) {
            console.log("result: " + result);
            if (result == 'SUCCESS') {
               alert("등록 되었습니다.");
               replyPage = 1;
               getPage("/replies_BSR/" + bno + "/" + replyPage);
               replytextObj.val("");
            }
         }
      });
   });

   $(".timeline").on("click", ".replyLi", function(event) {

      var reply = $(this);

      $("#replytext").val(reply.find('.timeline-body').text());
      $(".modal-title").html(reply.attr("data-rno"));

   });
   
   // 댓글 수정 클릭시 뜨는 메세지창
   $("#replyModBtn").on("click", function() {
      
      alert("replyModBtn clicked...")
      
      var rno = $(".modal-title").html();
      var replytext = $("#replytext").val();

      $.ajax({
         type : 'put',
         url : '/replies_BSR/' + rno,
         headers : {
            "Content-Type" : "application/json",
            "X-HTTP-Method-Override" : "PUT"
         },
         data : JSON.stringify({
            replytext : replytext
         }),
         dataType : 'text',
         success : function(result) {
            console.log("result: " + result);
            if (result == 'SUCCESS') {
               alert("수정 되었습니다.");
               getPage("/replies_BSR/" + bno + "/" + replyPage);
            }
         }
      });
   });

   $("#replyDelBtn").on("click", function() {

      var rno = $(".modal-title").html();
      var replytext = $("#replytext").val();

      $.ajax({
         type : 'delete',
         url : '/replies_BSR/' + rno,
         headers : {
            "Content-Type" : "application/json",
            "X-HTTP-Method-Override" : "DELETE"
         },
         dataType : 'text',
         success : function(result) {
            console.log("result: " + result);
            if (result == 'SUCCESS') {
               alert("삭제 되었습니다.");
               getPage("/replies_BSR/" + bno + "/" + replyPage);
            }
         }
      });
   });
</script>


<script>
$(document).ready(function(){
   
   var formObj = $("form[role='form']");
   
   console.log(formObj);
   
   $("#modifyBtn").on("click", function(){
      formObj.attr("action", "/tboard/modifyPage?board_id=${cri.board_id}");
      formObj.attr("method", "get");      
      formObj.submit();
   });
   
/*    $("#removeBtn").on("click", function(){
      formObj.attr("action", "/tboard/removePage");
      formObj.submit();
   }); */

   
   $("#removeBtn").on("click", function(){
      
      var replyCnt =  ${boardVO_BSR.replycnt};
      
      if(replyCnt > 0 ){
         alert("댓글이 달린 게시물을 삭제할 수 없습니다.");
         return;
      }   
      
      var arr = [];
      $(".uploadedList li").each(function(index){
          arr.push($(this).attr("data-src"));
      });
      
      if(arr.length > 0){
         $.post("/deleteAllFiles_BSR",{files:arr}, function(){
            
         });
      }
      
      formObj.attr("action", "/tboard/removePage?board_id=${cri.board_id}");
      formObj.submit();
   });   
   
   $("#goListBtn ").on("click", function(){
      formObj.attr("method", "get");
      formObj.attr("action", "/tboard/list?board_id=${cri.board_id}");
      formObj.submit();
   });
   
   var bno = ${boardVO_BSR.bno};
   var template = Handlebars.compile($("#templateAttach").html());
   $.getJSON("/tboard/getAttach/"+bno,function(list){
      
	   var images = "";
	   
	   $(list).each(function(index, item){ 
         var fileInfo = getFileInfo(this);
         
         var html = template(fileInfo);
         
         $(".uploadedList").append(html);
		
         item = item.replace("s_", ""); 
		   
//          if (item.match("*.png") | item.match("*.jpg"))
         	images += '<img src="/displayFile?fileName='+ item +'"/>'; 
         
         console.log("name = " + item);
         
      });
         console.log("images = " + images);
	  
	   $("#xxxyyy").html(images);
	   
   });


   $(".uploadedList").on("click", ".mailbox-attachment-info a", function(event){
      
      var fileLink = $(this).attr("href");
      
      if(checkImageType(fileLink)){
         
         event.preventDefault();
               
         var imgTag = $("#popup_img");
         imgTag.attr("src", fileLink);
         
         console.log(imgTag.attr("src"));
               
         $(".popup").show('slow');
         imgTag.addClass("show");      
      }   
   });
   
   $("#popup_img").on("click", function(){
      
      $(".popup").hide('slow');
      
   });   
   
      
   
});
</script>

</body>
</html>
