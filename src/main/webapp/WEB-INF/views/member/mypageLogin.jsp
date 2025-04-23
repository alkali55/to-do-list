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
		if(getParameter("login") == "fail"){
			$("#myModal").show();
		}
		
		$(".closeModal").click(function(){
			$("#myModal").hide();
		})
	});

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
<style>
	#text {
		margin-top: 30px;
		font-size: 25px;
		margin-bottom: 30px;
	}
</style>
<body>
	<jsp:include page="../header.jsp"></jsp:include>
	<div class="container mt-5">
		<div class="row">
			<h1>비밀번호 확인</h1>
			
			<span id="text">회원님의 정보를 보호하기 위해 비밀번호를 다시 확인합니다.</span>
			<form action="mypageLogin" method="POST">
			    <div class="mb-3">
			      <label for="memberPwd">비밀번호:</label>
			      <input type="password" class="form-control" id="memberPwd" placeholder="비밀번호를 입력하세요" name="memberPwd">
			    </div>
			    <button type="submit" class="btn btn-primary">확인</button>
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
					<h4 class="modal-title">인증 실패!</h4>
					<button type="button" class="btn-close closeModal" data-bs-dismiss="modal"></button>
				</div>
		
				<!-- Modal body -->
				<div class="modal-body">
					잘못된 비밀번호 입력입니다.
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