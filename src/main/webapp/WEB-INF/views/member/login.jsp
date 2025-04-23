<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>

	$(function(){
		if(getParameter("signup") == "success"){
			$("#myModal").show();
		}

		if(getParameter("login") == "fail"){
			$("#myModal2").show();
		}

		$(".closeModal").click(function(){
			$("#myModal").hide();
			$("#myModal2").hide();
		})
	})

	function getParameter(queryName){

		let returnVal = null;
		let url = location.href;

		if (url.indexOf("?") !== -1){
			// 쿼리스트링이 있는 경우
			let queryString = url.split("?")[1];
			let queryStringArr  = queryString.split("&");

			for (let item of queryStringArr){
				// key=value
				if (item.split("=")[0] == queryName){
					// 파라미터 이름이 있으면
					returnVal = item.split("=")[1];
					break;
				}
			}
		}
		return returnVal;
	}
</script>

<body>
	<jsp:include page="../header.jsp"></jsp:include>
	<div class="container mt-5">
		<div class="row">
			<h1>로그인</h1>
			
			<form action="login" method="POST">
			    <div class="mb-3 mt-3">
			      <label for="memberId">아이디:</label>
			      <input type="text" class="form-control" id="memberId" placeholder="아이디를 입력하세요" name="memberId">
			    </div>
			    <div class="mb-3">
			      <label for="memberPwd">비밀번호:</label>
			      <input type="password" class="form-control" id="memberPwd" placeholder="비밀번호를 입력하세요" name="memberPwd">
			    </div>
			    <button type="submit" class="btn btn-primary">로그인</button>
			    <button type="reset" class="btn btn-secondary">취소</button>
			  </form>
		</div>
	</div>

	<!-- The Modal -->
	<div class="modal" id="myModal">
		<div class="modal-dialog">
			<div class="modal-content">
	
				<!-- Modal Header -->
				<div class="modal-header">
					<h4 class="modal-title">회원가입 성공!</h4>
					<button type="button" class="btn-close closeModal" data-bs-dismiss="modal"></button>
				</div>
		
				<!-- Modal body -->
				<div class="modal-body">
					로그인을 하고 ToDoList를 이용해보세요!
				</div>
		
				<!-- Modal footer -->
				<div class="modal-footer">
					<button type="button" class="btn btn-success closeModal" data-bs-dismiss="modal">닫기</button>
				</div>
	
			</div>
		</div>
	</div>

	<!-- The Modal2 -->
	<div class="modal" id="myModal2">
		<div class="modal-dialog">
			<div class="modal-content">
	
				<!-- Modal Header -->
				<div class="modal-header">
					<h4 class="modal-title">로그인 실패!</h4>
					<button type="button" class="btn-close closeModal" data-bs-dismiss="modal"></button>
				</div>
		
				<!-- Modal body -->
				<div class="modal-body">
					아이디나 비밀번호가 올바르지 않습니다.
				</div>
		
				<!-- Modal footer -->
				<div class="modal-footer">
					<button type="button" class="btn btn-success closeModal" data-bs-dismiss="modal">닫기</button>
				</div>
	
			</div>
		</div>
	</div>
	<jsp:include page="../footer.jsp"></jsp:include>
</body>
</html>